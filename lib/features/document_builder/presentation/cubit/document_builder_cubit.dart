import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:printing/printing.dart';
import 'package:waraqty/features/document_builder/data/services/egyptian_pdf_generator.dart';
import 'package:waraqty/features/document_builder/data/services/pdf_storage_service.dart';
import 'package:waraqty/features/document_builder/domain/entities/document_data_entity.dart';
import 'package:waraqty/features/document_builder/domain/entities/generated_pdf_file_entity.dart';
import 'package:waraqty/features/document_builder/domain/entities/saved_pdf_file_entity.dart';

part 'document_builder_state.dart';

class DocumentBuilderCubit extends Cubit<DocumentBuilderState> {
  DocumentBuilderCubit({
    required this.documentData,
    required this.pdfGenerator,
    required this.storageService,
  }) : super(DocumentBuilderState(documentData: documentData));

  final DocumentDataEntity documentData;
  final EgyptianPdfGenerator pdfGenerator;
  final PdfStorageService storageService;

  Future<void> generate() async {
    emit(
      state.copyWith(
        status: DocumentBuilderStatus.generating,
        errorMessage: '',
        generatedFiles: const [],
        savedFiles: const [],
        selectedFileIndex: 0,
      ),
    );

    try {
      final files = await pdfGenerator.generate(documentData);
      emit(
        state.copyWith(
          status: DocumentBuilderStatus.ready,
          generatedFiles: List.unmodifiable(files),
          selectedFileIndex: 0,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: DocumentBuilderStatus.error,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  void selectFile(int index) {
    if (index < 0 || index >= state.generatedFiles.length) return;
    if (index == state.selectedFileIndex) return;
    emit(state.copyWith(selectedFileIndex: index));
  }

  Future<void> saveAll() async {
    if (state.generatedFiles.isEmpty || state.isSaving) return;

    emit(
      state.copyWith(
        status: DocumentBuilderStatus.saving,
        errorMessage: '',
        savedFiles: const [],
      ),
    );

    try {
      final savedFiles = <SavedPdfFileEntity>[];
      for (final file in state.generatedFiles) {
        savedFiles.add(
          await storageService.save(file: file, documentData: documentData),
        );
      }
      emit(
        state.copyWith(
          status: DocumentBuilderStatus.saved,
          savedFiles: List.unmodifiable(savedFiles),
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: DocumentBuilderStatus.ready,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  Future<bool> shareFile(GeneratedPdfFileEntity file) {
    return Printing.sharePdf(bytes: file.bytes, filename: file.fileName);
  }
}
