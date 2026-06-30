import 'dart:typed_data';

import 'package:equatable/equatable.dart';

enum GeneratedPdfFileKind { booklet, exam, answerKey }

class GeneratedPdfFileEntity extends Equatable {
  final GeneratedPdfFileKind kind;
  final String title;
  final String fileName;
  final Uint8List bytes;

  const GeneratedPdfFileEntity({
    required this.kind,
    required this.title,
    required this.fileName,
    required this.bytes,
  });

  @override
  List<Object?> get props => [kind, title, fileName, bytes];
}
