import 'package:equatable/equatable.dart';
import 'package:waraqty/features/document_builder/domain/entities/generated_pdf_file_entity.dart';

class SavedPdfFileEntity extends Equatable {
  final GeneratedPdfFileEntity file;
  final String displayPath;
  final String? uri;

  const SavedPdfFileEntity({
    required this.file,
    required this.displayPath,
    this.uri,
  });

  @override
  List<Object?> get props => [file, displayPath, uri];
}
