part of 'document_builder_cubit.dart';

enum DocumentBuilderStatus { initial, generating, ready, saving, saved, error }

class DocumentBuilderState extends Equatable {
  final DocumentDataEntity documentData;
  final DocumentBuilderStatus status;
  final List<GeneratedPdfFileEntity> generatedFiles;
  final List<SavedPdfFileEntity> savedFiles;
  final int selectedFileIndex;
  final String errorMessage;

  const DocumentBuilderState({
    required this.documentData,
    this.status = DocumentBuilderStatus.initial,
    this.generatedFiles = const [],
    this.savedFiles = const [],
    this.selectedFileIndex = 0,
    this.errorMessage = '',
  });

  bool get isGenerating => status == DocumentBuilderStatus.generating;
  bool get isSaving => status == DocumentBuilderStatus.saving;
  bool get isSaved => status == DocumentBuilderStatus.saved;
  bool get hasGenerationError {
    return status == DocumentBuilderStatus.error && generatedFiles.isEmpty;
  }

  bool get canSave => generatedFiles.isNotEmpty && !isSaving;

  GeneratedPdfFileEntity? get selectedFile {
    if (generatedFiles.isEmpty) return null;
    if (selectedFileIndex < 0 || selectedFileIndex >= generatedFiles.length) {
      return generatedFiles.first;
    }
    return generatedFiles[selectedFileIndex];
  }

  DocumentBuilderState copyWith({
    DocumentDataEntity? documentData,
    DocumentBuilderStatus? status,
    List<GeneratedPdfFileEntity>? generatedFiles,
    List<SavedPdfFileEntity>? savedFiles,
    int? selectedFileIndex,
    String? errorMessage,
  }) {
    return DocumentBuilderState(
      documentData: documentData ?? this.documentData,
      status: status ?? this.status,
      generatedFiles: generatedFiles ?? this.generatedFiles,
      savedFiles: savedFiles ?? this.savedFiles,
      selectedFileIndex: selectedFileIndex ?? this.selectedFileIndex,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    documentData,
    status,
    generatedFiles,
    savedFiles,
    selectedFileIndex,
    errorMessage,
  ];
}
