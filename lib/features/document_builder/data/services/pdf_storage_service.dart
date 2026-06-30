import 'package:flutter/services.dart';
import 'package:waraqty/features/document_builder/domain/entities/document_data_entity.dart';
import 'package:waraqty/features/document_builder/domain/entities/generated_pdf_file_entity.dart';
import 'package:waraqty/features/document_builder/domain/entities/saved_pdf_file_entity.dart';

class PdfStorageService {
  static const MethodChannel _channel = MethodChannel(
    'com.marwan.waraqty/pdf_storage',
  );

  Future<SavedPdfFileEntity> save({
    required GeneratedPdfFileEntity file,
    required DocumentDataEntity documentData,
  }) async {
    final gradeFolder = _safeFolderName(documentData.gradeTitle);
    final typeFolder = documentData.isBooklet ? 'الملازم' : 'الامتحانات';
    final relativePath = 'ورقتي/$gradeFolder/$typeFolder';

    final result = await _channel.invokeMapMethod<String, dynamic>('savePdf', {
      'bytes': file.bytes,
      'fileName': file.fileName,
      'relativePath': relativePath,
    });

    final displayPath = result?['displayPath'] as String?;
    if (displayPath == null || displayPath.isEmpty) {
      throw PlatformException(
        code: 'invalid_save_result',
        message: 'The platform did not return the saved file path.',
      );
    }

    return SavedPdfFileEntity(
      file: file,
      displayPath: displayPath,
      uri: result?['uri'] as String?,
    );
  }

  String _safeFolderName(String value) {
    return value
        .trim()
        .replaceAll(RegExp(r'[\\/:*?"<>|]'), '_')
        .replaceAll(RegExp(r'\s+'), ' ');
  }
}
