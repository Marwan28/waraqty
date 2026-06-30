import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:waraqty/core/constants/app_strings.dart';
import 'package:waraqty/core/enums/question_category_type.dart';
import 'package:waraqty/features/document_builder/domain/entities/document_data_entity.dart';
import 'package:waraqty/features/document_builder/domain/entities/document_section_entity.dart';
import 'package:waraqty/features/document_builder/domain/entities/document_template.dart';
import 'package:waraqty/features/document_builder/domain/entities/generated_pdf_file_entity.dart';
import 'package:waraqty/features/question_bank/domain/entities/question_entity.dart';

class EgyptianPdfGenerator {
  static const _regularFontPath =
      'assets/fonts/ibm_plex_sans_arabic/IBMPlexSansArabic-Regular.ttf';
  static const _boldFontPath =
      'assets/fonts/ibm_plex_sans_arabic/IBMPlexSansArabic-Bold.ttf';

  static const _primary = PdfColor.fromInt(0xFF0F5B5B);
  static const _primarySoft = PdfColor.fromInt(0xFFE4F5F2);
  static const _ink = PdfColor.fromInt(0xFF111111);
  static const _muted = PdfColor.fromInt(0xFF555555);
  static const _line = PdfColor.fromInt(0xFFB8B8B8);
  static const _paperSoft = PdfColor.fromInt(0xFFF4F4F4);

  Future<List<GeneratedPdfFileEntity>> generate(DocumentDataEntity data) async {
    final fonts = await _loadFonts();
    if (data.isBooklet) {
      final bytes = await _buildBooklet(data, fonts);
      return [
        GeneratedPdfFileEntity(
          kind: GeneratedPdfFileKind.booklet,
          title: PdfPreviewStrings.booklet,
          fileName: _fileName(
            data.bookletTitle.isEmpty
                ? PdfDocumentStrings.bookletDefaultTitle
                : data.bookletTitle,
            data,
          ),
          bytes: bytes,
        ),
      ];
    }

    final examBytes = await _buildExam(data, fonts);
    final answerKeyBytes = await _buildAnswerKey(data, fonts);
    final examTitle = data.examTitle.isEmpty
        ? PdfDocumentStrings.examDefaultTitle
        : data.examTitle;

    return [
      GeneratedPdfFileEntity(
        kind: GeneratedPdfFileKind.exam,
        title: PdfPreviewStrings.exam,
        fileName: _fileName(examTitle, data),
        bytes: examBytes,
      ),
      GeneratedPdfFileEntity(
        kind: GeneratedPdfFileKind.answerKey,
        title: PdfPreviewStrings.answerKey,
        fileName: _fileName('${PdfDocumentStrings.answerKey}_$examTitle', data),
        bytes: answerKeyBytes,
      ),
    ];
  }

  Future<_PdfFonts> _loadFonts() async {
    final regularData = await rootBundle.load(_regularFontPath);
    final boldData = await rootBundle.load(_boldFontPath);
    return _PdfFonts(
      regular: pw.Font.ttf(regularData),
      bold: pw.Font.ttf(boldData),
    );
  }

  Future<Uint8List> _buildBooklet(
    DocumentDataEntity data,
    _PdfFonts fonts,
  ) async {
    final title = data.bookletTitle.isEmpty
        ? PdfDocumentStrings.bookletDefaultTitle
        : data.bookletTitle;
    final document = pw.Document(
      title: title,
      author: data.teacherName,
      creator: AppStrings.appName,
      subject: data.subjectTitle,
    );
    final theme = _theme(fonts);

    document.addPage(
      pw.Page(
        pageTheme: _pageThemeFor(data, theme),
        build: (context) => _bookletCover(data, title),
      ),
    );
    document.addPage(
      pw.MultiPage(
        pageTheme: _pageThemeFor(data, theme),
        maxPages: 200,
        header: (context) => _bookletHeader(data, title),
        footer: _pageFooter,
        build: (context) => _questionWidgets(
          data: data,
          includeAnswers: data.includeBookletAnswers,
          includeAnswerSpaces: !data.includeBookletAnswers,
        ),
      ),
    );

    return document.save();
  }

  Future<Uint8List> _buildExam(DocumentDataEntity data, _PdfFonts fonts) async {
    final title = data.examTitle.isEmpty
        ? PdfDocumentStrings.examDefaultTitle
        : data.examTitle;
    final document = pw.Document(
      title: title,
      author: data.teacherName,
      creator: AppStrings.appName,
      subject: data.subjectTitle,
    );
    final theme = _theme(fonts);

    document.addPage(
      pw.MultiPage(
        pageTheme: _pageThemeFor(data, theme),
        maxPages: 200,
        header: (context) => _examHeader(data, title, isAnswerKey: false),
        footer: _pageFooter,
        build: (context) => [
          ..._questionWidgets(
            data: data,
            includeAnswers: false,
            includeAnswerSpaces: data.includeAnswerSpaces,
          ),
          pw.SizedBox(height: 18),
          pw.Center(
            child: pw.Text(
              PdfDocumentStrings.ending,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11),
            ),
          ),
        ],
      ),
    );

    return document.save();
  }

  Future<Uint8List> _buildAnswerKey(
    DocumentDataEntity data,
    _PdfFonts fonts,
  ) async {
    final title = data.examTitle.isEmpty
        ? PdfDocumentStrings.examDefaultTitle
        : data.examTitle;
    final document = pw.Document(
      title: '${PdfDocumentStrings.answerKey} - $title',
      author: data.teacherName,
      creator: AppStrings.appName,
      subject: data.subjectTitle,
    );
    final theme = _theme(fonts);

    document.addPage(
      pw.MultiPage(
        pageTheme: _pageThemeFor(data, theme),
        maxPages: 100,
        header: (context) => _examHeader(data, title, isAnswerKey: true),
        footer: _pageFooter,
        build: (context) => _answerKeyWidgets(data),
      ),
    );

    return document.save();
  }

  pw.ThemeData _theme(_PdfFonts fonts) {
    return pw.ThemeData.withFont(
      base: fonts.regular,
      bold: fonts.bold,
    ).copyWith(
      defaultTextStyle: pw.TextStyle(
        font: fonts.regular,
        fontSize: 12,
        color: _ink,
        lineSpacing: 2,
      ),
    );
  }

  pw.PageTheme _pageThemeFor(DocumentDataEntity data, pw.ThemeData theme) {
    final margin = !data.isBooklet && data.examTemplate == ExamTemplate.compact
        ? const pw.EdgeInsets.fromLTRB(24, 20, 24, 24)
        : const pw.EdgeInsets.fromLTRB(30, 28, 30, 30);

    return pw.PageTheme(
      pageFormat: PdfPageFormat.a4,
      margin: margin,
      textDirection: pw.TextDirection.rtl,
      theme: theme,
    );
  }

  pw.Widget _bookletCover(DocumentDataEntity data, String title) {
    return switch (data.bookletTemplate) {
      BookletTemplate.classic => _classicBookletCover(data, title),
      BookletTemplate.organized => _organizedBookletCover(data, title),
      BookletTemplate.revision => _revisionBookletCover(data, title),
    };
  }

  pw.Widget _classicBookletCover(DocumentDataEntity data, String title) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: _primary, width: 2),
      ),
      padding: const pw.EdgeInsets.all(26),
      child: pw.Column(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                AppStrings.appName,
                style: pw.TextStyle(
                  color: _primary,
                  fontSize: 15,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                PdfDocumentStrings.booklet,
                style: const pw.TextStyle(color: _muted, fontSize: 12),
              ),
            ],
          ),
          pw.Column(
            children: [
              pw.Container(
                width: 84,
                height: 84,
                alignment: pw.Alignment.center,
                decoration: pw.BoxDecoration(
                  color: _primarySoft,
                  borderRadius: const pw.BorderRadius.all(
                    pw.Radius.circular(12),
                  ),
                  border: pw.Border.all(color: _primary),
                ),
                child: pw.Text(
                  'و',
                  style: pw.TextStyle(
                    color: _primary,
                    fontSize: 40,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SizedBox(height: 30),
              pw.Text(
                title,
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(
                  fontSize: 28,
                  fontWeight: pw.FontWeight.bold,
                  color: _primary,
                ),
              ),
              pw.SizedBox(height: 12),
              pw.Text(
                data.subjectTitle,
                style: pw.TextStyle(
                  fontSize: 19,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Text(
                data.gradeTitle,
                style: const pw.TextStyle(fontSize: 16, color: _muted),
              ),
              pw.SizedBox(height: 28),
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: pw.BoxDecoration(
                  color: _paperSoft,
                  border: pw.Border.all(color: _line),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _coverValue(
                      PdfDocumentStrings.studentName,
                      PdfDocumentStrings.unknown,
                    ),
                    pw.SizedBox(height: 10),
                    _coverValue(
                      PdfDocumentStrings.classroom,
                      PdfDocumentStrings.unknown,
                    ),
                  ],
                ),
              ),
            ],
          ),
          pw.Column(
            children: [
              if (data.teacherName.isNotEmpty)
                pw.Text(
                  '${PdfDocumentStrings.teacher}: ${data.teacherName}',
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              if (data.teacherPhoneNumber.isNotEmpty) ...[
                pw.SizedBox(height: 6),
                pw.Text(
                  '${PdfDocumentStrings.phone}: ${data.teacherPhoneNumber}',
                  style: const pw.TextStyle(fontSize: 12, color: _muted),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _organizedBookletCover(DocumentDataEntity data, String title) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: _ink, width: 1.2),
      ),
      child: pw.Column(
        children: [
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 14,
            ),
            color: _primary,
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  AppStrings.appName,
                  style: pw.TextStyle(
                    color: PdfColors.white,
                    fontSize: 13,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Text(
                  PdfDocumentStrings.booklet,
                  style: const pw.TextStyle(
                    color: PdfColors.white,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          pw.Expanded(
            child: pw.Padding(
              padding: const pw.EdgeInsets.all(30),
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Container(
                    padding: const pw.EdgeInsets.symmetric(
                      horizontal: 22,
                      vertical: 12,
                    ),
                    decoration: pw.BoxDecoration(
                      color: _primarySoft,
                      border: pw.Border.all(color: _primary, width: 1),
                    ),
                    child: pw.Text(
                      data.subjectTitle,
                      style: pw.TextStyle(
                        color: _primary,
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                  pw.SizedBox(height: 24),
                  pw.Text(
                    title,
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(
                      fontSize: 30,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 12),
                  pw.Container(width: 120, height: 2, color: _primary),
                  pw.SizedBox(height: 12),
                  pw.Text(
                    data.gradeTitle,
                    style: const pw.TextStyle(fontSize: 17, color: _muted),
                  ),
                  pw.SizedBox(height: 36),
                  pw.Table(
                    border: pw.TableBorder.all(color: _line, width: 0.7),
                    columnWidths: const {
                      0: pw.FlexColumnWidth(),
                      1: pw.FlexColumnWidth(),
                    },
                    children: [
                      pw.TableRow(
                        children: [
                          _coverTableCell(
                            PdfDocumentStrings.studentName,
                            PdfDocumentStrings.unknown,
                          ),
                          _coverTableCell(
                            PdfDocumentStrings.classroom,
                            PdfDocumentStrings.unknown,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          _bookletTeacherFooter(data, filled: true),
        ],
      ),
    );
  }

  pw.Widget _revisionBookletCover(DocumentDataEntity data, String title) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: _primary, width: 3),
      ),
      child: pw.Container(
        padding: const pw.EdgeInsets.all(24),
        decoration: pw.BoxDecoration(
          border: pw.Border.all(color: _line, width: 0.8),
        ),
        child: pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Column(
              children: [
                pw.Container(
                  width: double.infinity,
                  padding: const pw.EdgeInsets.symmetric(vertical: 12),
                  color: _primary,
                  child: pw.Text(
                    PdfDocumentStrings.booklet,
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(
                      color: PdfColors.white,
                      fontSize: 17,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Text(
                  '${data.subjectTitle} - ${data.gradeTitle}',
                  style: const pw.TextStyle(fontSize: 13, color: _muted),
                ),
              ],
            ),
            pw.Column(
              children: [
                pw.Text(
                  title,
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                    color: _primary,
                    fontSize: 34,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 18),
                pw.Container(
                  width: double.infinity,
                  padding: const pw.EdgeInsets.all(18),
                  decoration: pw.BoxDecoration(
                    color: _paperSoft,
                    border: pw.Border.all(color: _ink, width: 1),
                  ),
                  child: pw.Column(
                    children: [
                      _coverValue(
                        PdfDocumentStrings.studentName,
                        PdfDocumentStrings.unknown,
                      ),
                      pw.SizedBox(height: 12),
                      _coverValue(
                        PdfDocumentStrings.classroom,
                        PdfDocumentStrings.unknown,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            _bookletTeacherFooter(data),
          ],
        ),
      ),
    );
  }

  pw.Widget _bookletHeader(DocumentDataEntity data, String title) {
    return switch (data.bookletTemplate) {
      BookletTemplate.classic => _classicBookletHeader(data, title),
      BookletTemplate.organized => _organizedBookletHeader(data, title),
      BookletTemplate.revision => _revisionBookletHeader(data, title),
    };
  }

  pw.Widget _classicBookletHeader(DocumentDataEntity data, String title) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 14),
      padding: const pw.EdgeInsets.only(bottom: 8),
      decoration: const pw.BoxDecoration(
        border: pw.Border(bottom: pw.BorderSide(color: _primary, width: 1.4)),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Expanded(
            child: pw.Text(
              title,
              style: pw.TextStyle(
                fontSize: 12,
                fontWeight: pw.FontWeight.bold,
                color: _primary,
              ),
            ),
          ),
          pw.SizedBox(width: 12),
          pw.Text(
            '${data.subjectTitle} - ${data.gradeTitle}',
            style: const pw.TextStyle(fontSize: 10, color: _muted),
          ),
        ],
      ),
    );
  }

  pw.Widget _organizedBookletHeader(DocumentDataEntity data, String title) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 14),
      padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: pw.BoxDecoration(
        color: _primarySoft,
        border: pw.Border.all(color: _primary, width: 0.8),
      ),
      child: pw.Row(
        children: [
          pw.Container(
            width: 28,
            height: 28,
            alignment: pw.Alignment.center,
            color: _primary,
            child: pw.Text(
              'و',
              style: pw.TextStyle(
                color: PdfColors.white,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
          pw.SizedBox(width: 10),
          pw.Expanded(
            child: pw.Text(
              title,
              style: pw.TextStyle(
                color: _primary,
                fontSize: 12,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
          pw.Text(
            '${data.subjectTitle} | ${data.gradeTitle}',
            style: const pw.TextStyle(fontSize: 9, color: _muted),
          ),
        ],
      ),
    );
  }

  pw.Widget _revisionBookletHeader(DocumentDataEntity data, String title) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 14),
      child: pw.Column(
        children: [
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            color: _primary,
            child: pw.Text(
              title,
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(
                color: PdfColors.white,
                fontSize: 12,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
          pw.SizedBox(height: 4),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                data.subjectTitle,
                style: pw.TextStyle(
                  fontSize: 9,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                data.gradeTitle,
                style: const pw.TextStyle(fontSize: 9, color: _muted),
              ),
            ],
          ),
          pw.Container(height: 0.8, color: _line),
        ],
      ),
    );
  }

  pw.Widget _examHeader(
    DocumentDataEntity data,
    String title, {
    required bool isAnswerKey,
  }) {
    return switch (data.examTemplate) {
      ExamTemplate.official => _officialExamHeader(
        data,
        title,
        isAnswerKey: isAnswerKey,
      ),
      ExamTemplate.framed => _framedExamHeader(
        data,
        title,
        isAnswerKey: isAnswerKey,
      ),
      ExamTemplate.compact => _compactExamHeader(
        data,
        title,
        isAnswerKey: isAnswerKey,
      ),
    };
  }

  pw.Widget _officialExamHeader(
    DocumentDataEntity data,
    String title, {
    required bool isAnswerKey,
  }) {
    final displayTitle = isAnswerKey
        ? '${PdfDocumentStrings.answerKey} - $title'
        : title;

    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 14),
      child: pw.Column(
        children: [
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      PdfDocumentStrings.arabRepublicOfEgypt,
                      style: pw.TextStyle(
                        fontSize: 10,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      PdfDocumentStrings.ministry,
                      style: const pw.TextStyle(fontSize: 9),
                    ),
                    _headerOptionalLine(
                      PdfDocumentStrings.governorate,
                      data.governorate,
                    ),
                    _headerOptionalLine(
                      PdfDocumentStrings.administration,
                      data.educationalAdministration,
                    ),
                    _headerOptionalLine(
                      PdfDocumentStrings.school,
                      data.schoolName,
                    ),
                  ],
                ),
              ),
              pw.Expanded(
                flex: 2,
                child: pw.Column(
                  children: [
                    pw.Text(
                      displayTitle,
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                        fontSize: 17,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      '${PdfDocumentStrings.subject}: ${data.subjectTitle}',
                      style: pw.TextStyle(
                        fontSize: 11,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      '${PdfDocumentStrings.grade}: ${data.gradeTitle}',
                      style: const pw.TextStyle(fontSize: 10),
                    ),
                  ],
                ),
              ),
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    _headerValue(
                      PdfDocumentStrings.academicYear,
                      data.academicYear,
                    ),
                    _headerValue(PdfDocumentStrings.term, data.termName),
                    _headerValue(
                      PdfDocumentStrings.duration,
                      data.examDuration,
                    ),
                    _headerValue(
                      PdfDocumentStrings.totalGrade,
                      data.totalGrade,
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (!isAnswerKey) ...[
            pw.SizedBox(height: 10),
            pw.Container(
              padding: const pw.EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 7,
              ),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: _ink, width: 0.8),
              ),
              child: pw.Row(
                children: [
                  pw.Expanded(
                    flex: 3,
                    child: _studentField(PdfDocumentStrings.studentName),
                  ),
                  pw.SizedBox(width: 12),
                  pw.Expanded(
                    child: _studentField(PdfDocumentStrings.classroom),
                  ),
                  pw.SizedBox(width: 12),
                  pw.Expanded(
                    child: _studentField(PdfDocumentStrings.seatNumber),
                  ),
                ],
              ),
            ),
          ],
          pw.SizedBox(height: 8),
          pw.Container(height: 1.3, color: _ink),
        ],
      ),
    );
  }

  pw.Widget _framedExamHeader(
    DocumentDataEntity data,
    String title, {
    required bool isAnswerKey,
  }) {
    final displayTitle = isAnswerKey
        ? '${PdfDocumentStrings.answerKey} - $title'
        : title;

    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 14),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: _primary, width: 1.4),
      ),
      child: pw.Column(
        children: [
          pw.Container(
            padding: const pw.EdgeInsets.all(10),
            color: _primarySoft,
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        PdfDocumentStrings.arabRepublicOfEgypt,
                        style: pw.TextStyle(
                          fontSize: 9,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      _headerOptionalLine(
                        PdfDocumentStrings.governorate,
                        data.governorate,
                      ),
                      _headerOptionalLine(
                        PdfDocumentStrings.administration,
                        data.educationalAdministration,
                      ),
                      _headerOptionalLine(
                        PdfDocumentStrings.school,
                        data.schoolName,
                      ),
                    ],
                  ),
                ),
                pw.Container(width: 0.7, height: 62, color: _line),
                pw.SizedBox(width: 10),
                pw.Expanded(
                  flex: 2,
                  child: pw.Column(
                    children: [
                      pw.Text(
                        displayTitle,
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                          color: _primary,
                          fontSize: 16,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 5),
                      pw.Text(
                        data.subjectTitle,
                        style: pw.TextStyle(
                          fontSize: 11,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.Text(
                        data.gradeTitle,
                        style: const pw.TextStyle(fontSize: 9, color: _muted),
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(width: 10),
                pw.Container(width: 0.7, height: 62, color: _line),
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      _headerValue(
                        PdfDocumentStrings.academicYear,
                        data.academicYear,
                      ),
                      _headerValue(PdfDocumentStrings.term, data.termName),
                      _headerValue(
                        PdfDocumentStrings.duration,
                        data.examDuration,
                      ),
                      _headerValue(
                        PdfDocumentStrings.totalGrade,
                        data.totalGrade,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (!isAnswerKey)
            pw.Container(
              padding: const pw.EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 8,
              ),
              decoration: const pw.BoxDecoration(
                border: pw.Border(
                  top: pw.BorderSide(color: _primary, width: 0.8),
                ),
              ),
              child: _studentDataRow(),
            ),
        ],
      ),
    );
  }

  pw.Widget _compactExamHeader(
    DocumentDataEntity data,
    String title, {
    required bool isAnswerKey,
  }) {
    final displayTitle = isAnswerKey
        ? '${PdfDocumentStrings.answerKey} - $title'
        : title;

    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 9),
      child: pw.Column(
        children: [
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.symmetric(horizontal: 9, vertical: 7),
            decoration: pw.BoxDecoration(
              color: _paperSoft,
              border: pw.Border.all(color: _ink, width: 0.8),
            ),
            child: pw.Row(
              children: [
                pw.Expanded(
                  flex: 2,
                  child: pw.Text(
                    displayTitle,
                    style: pw.TextStyle(
                      fontSize: 14,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.Expanded(
                  child: pw.Text(
                    '${data.subjectTitle} - ${data.gradeTitle}',
                    textAlign: pw.TextAlign.left,
                    style: const pw.TextStyle(fontSize: 9),
                  ),
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 4),
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: _line, width: 0.6),
            ),
            child: pw.Row(
              children: [
                pw.Expanded(
                  flex: 2,
                  child: pw.Text(
                    [
                      if (data.schoolName.isNotEmpty)
                        '${PdfDocumentStrings.school}: ${data.schoolName}',
                      if (data.educationalAdministration.isNotEmpty)
                        '${PdfDocumentStrings.administration}: ${data.educationalAdministration}',
                    ].join(' | '),
                    style: const pw.TextStyle(fontSize: 8),
                  ),
                ),
                pw.Expanded(
                  child: pw.Text(
                    '${PdfDocumentStrings.academicYear}: '
                    '${data.academicYear.isEmpty ? PdfDocumentStrings.unknown : data.academicYear}',
                    style: const pw.TextStyle(fontSize: 8),
                  ),
                ),
                pw.Expanded(
                  child: pw.Text(
                    '${PdfDocumentStrings.totalGrade}: '
                    '${data.totalGrade.isEmpty ? PdfDocumentStrings.unknown : data.totalGrade}',
                    textAlign: pw.TextAlign.left,
                    style: const pw.TextStyle(fontSize: 8),
                  ),
                ),
              ],
            ),
          ),
          if (!isAnswerKey) ...[
            pw.SizedBox(height: 4),
            pw.Container(
              padding: const pw.EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 5,
              ),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: _ink, width: 0.6),
              ),
              child: _studentDataRow(),
            ),
          ],
          pw.SizedBox(height: 5),
          pw.Container(height: 1, color: _ink),
        ],
      ),
    );
  }

  List<pw.Widget> _questionWidgets({
    required DocumentDataEntity data,
    required bool includeAnswers,
    required bool includeAnswerSpaces,
  }) {
    final widgets = <pw.Widget>[];
    for (
      var sectionIndex = 0;
      sectionIndex < data.sections.length;
      sectionIndex++
    ) {
      final section = data.sections[sectionIndex];
      widgets.add(pw.NewPage(freeSpace: 130));
      widgets.add(_sectionTitle(data, section, sectionIndex));
      widgets.add(pw.SizedBox(height: 8));

      for (
        var questionIndex = 0;
        questionIndex < section.questions.length;
        questionIndex++
      ) {
        widgets.add(
          _questionWidget(
            question: section.questions[questionIndex],
            questionNumber: questionIndex + 1,
            fontSize: data.fontSize,
            includeAnswer: includeAnswers,
            includeAnswerSpaces: includeAnswerSpaces,
            compact:
                !data.isBooklet && data.examTemplate == ExamTemplate.compact,
          ),
        );
        widgets.add(
          pw.SizedBox(
            height: !data.isBooklet && data.examTemplate == ExamTemplate.compact
                ? 5
                : 8,
          ),
        );
      }
      widgets.add(pw.SizedBox(height: 8));
    }
    return widgets;
  }

  pw.Widget _sectionTitle(
    DocumentDataEntity data,
    DocumentSectionEntity section,
    int sectionIndex,
  ) {
    final label =
        '${PdfDocumentStrings.question} ${_ordinal(sectionIndex)}: '
        '${section.title}';

    if (data.isBooklet) {
      return switch (data.bookletTemplate) {
        BookletTemplate.classic => _classicSectionTitle(label),
        BookletTemplate.organized => _organizedSectionTitle(label),
        BookletTemplate.revision => _filledSectionTitle(label),
      };
    }

    return switch (data.examTemplate) {
      ExamTemplate.official => _officialSectionTitle(label),
      ExamTemplate.framed => _organizedSectionTitle(label),
      ExamTemplate.compact => _compactSectionTitle(label),
    };
  }

  pw.Widget _classicSectionTitle(String label) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: pw.BoxDecoration(
        color: _paperSoft,
        border: pw.Border(
          right: const pw.BorderSide(color: _primary, width: 4),
          bottom: pw.BorderSide(color: _line, width: 0.5),
        ),
      ),
      child: pw.Text(
        label,
        style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
      ),
    );
  }

  pw.Widget _organizedSectionTitle(String label) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: pw.BoxDecoration(
        color: _primarySoft,
        border: pw.Border.all(color: _primary, width: 0.8),
      ),
      child: pw.Text(
        label,
        textAlign: pw.TextAlign.center,
        style: pw.TextStyle(
          color: _primary,
          fontSize: 13,
          fontWeight: pw.FontWeight.bold,
        ),
      ),
    );
  }

  pw.Widget _filledSectionTitle(String label) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      color: _primary,
      child: pw.Text(
        label,
        style: pw.TextStyle(
          color: PdfColors.white,
          fontSize: 13,
          fontWeight: pw.FontWeight.bold,
        ),
      ),
    );
  }

  pw.Widget _officialSectionTitle(String label) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.only(bottom: 5),
      decoration: const pw.BoxDecoration(
        border: pw.Border(bottom: pw.BorderSide(color: _ink, width: 1)),
      ),
      child: pw.Text(
        label,
        style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold),
      ),
    );
  }

  pw.Widget _compactSectionTitle(String label) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: pw.BoxDecoration(
        color: _paperSoft,
        border: pw.Border.all(color: _ink, width: 0.6),
      ),
      child: pw.Text(
        label,
        style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold),
      ),
    );
  }

  pw.Widget _questionWidget({
    required QuestionEntity question,
    required int questionNumber,
    required double fontSize,
    required bool includeAnswer,
    required bool includeAnswerSpaces,
    required bool compact,
  }) {
    final children = <pw.Widget>[
      pw.Text(
        '$questionNumber- ${question.questionText}',
        style: pw.TextStyle(
          fontSize: fontSize.clamp(11, 18),
          fontWeight: pw.FontWeight.bold,
        ),
      ),
    ];

    if (question.options.isNotEmpty) {
      children.add(pw.SizedBox(height: 5));
      children.add(
        pw.Wrap(
          spacing: 12,
          runSpacing: 5,
          children: [
            for (var index = 0; index < question.options.length; index++)
              pw.Text(
                '(${_optionLetter(index)}) ${question.options[index]}',
                style: pw.TextStyle(fontSize: (fontSize - 1).clamp(10, 17)),
              ),
          ],
        ),
      );
    }

    if (includeAnswer) {
      children.add(pw.SizedBox(height: 6));
      children.add(
        pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: pw.BoxDecoration(
            color: _primarySoft,
            border: pw.Border.all(color: _line, width: 0.5),
          ),
          child: pw.Text(
            '${PdfDocumentStrings.answer}: ${question.answerText ?? PdfDocumentStrings.unknown}',
            style: pw.TextStyle(
              color: _primary,
              fontSize: (fontSize - 1).clamp(10, 17),
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ),
      );
    } else if (includeAnswerSpaces) {
      children.add(pw.SizedBox(height: 6));
      children.addAll(
        List.generate(
          question.category.defaultAnswerLines,
          (_) => pw.Container(
            height: compact ? 14 : 17,
            decoration: const pw.BoxDecoration(
              border: pw.Border(
                bottom: pw.BorderSide(color: _line, width: 0.6),
              ),
            ),
          ),
        ),
      );
    }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: children,
    );
  }

  List<pw.Widget> _answerKeyWidgets(DocumentDataEntity data) {
    final widgets = <pw.Widget>[];
    for (
      var sectionIndex = 0;
      sectionIndex < data.sections.length;
      sectionIndex++
    ) {
      final section = data.sections[sectionIndex];
      widgets.add(pw.NewPage(freeSpace: 120));
      widgets.add(_sectionTitle(data, section, sectionIndex));
      widgets.add(pw.SizedBox(height: 8));
      widgets.add(
        pw.Table(
          border: pw.TableBorder.all(color: _line, width: 0.6),
          columnWidths: const {
            0: pw.FixedColumnWidth(42),
            1: pw.FlexColumnWidth(),
          },
          children: [
            for (var index = 0; index < section.questions.length; index++)
              pw.TableRow(
                decoration: pw.BoxDecoration(
                  color: index.isEven ? PdfColors.white : _paperSoft,
                ),
                children: [
                  _answerCell('${index + 1}', isBold: true),
                  _answerCell(
                    section.questions[index].answerText ??
                        PdfDocumentStrings.unknown,
                  ),
                ],
              ),
          ],
        ),
      );
      widgets.add(pw.SizedBox(height: 14));
    }
    return widgets;
  }

  pw.Widget _answerCell(String value, {bool isBold = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 7),
      child: pw.Text(
        value,
        style: pw.TextStyle(
          fontSize: 11,
          fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    );
  }

  pw.Widget _pageFooter(pw.Context context) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(top: 10),
      padding: const pw.EdgeInsets.only(top: 6),
      decoration: const pw.BoxDecoration(
        border: pw.Border(top: pw.BorderSide(color: _line, width: 0.5)),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            AppStrings.appName,
            style: const pw.TextStyle(fontSize: 9, color: _muted),
          ),
          pw.Text(
            '${PdfDocumentStrings.page} ${context.pageNumber} ${PdfDocumentStrings.of} ${context.pagesCount}',
            style: const pw.TextStyle(fontSize: 9, color: _muted),
          ),
        ],
      ),
    );
  }

  pw.Widget _coverValue(String label, String value) {
    return pw.Row(
      children: [
        pw.Text(
          '$label: ',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        ),
        pw.Expanded(child: pw.Text(value)),
      ],
    );
  }

  pw.Widget _coverTableCell(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      child: _coverValue(label, value),
    );
  }

  pw.Widget _bookletTeacherFooter(
    DocumentDataEntity data, {
    bool filled = false,
  }) {
    final details = [
      if (data.teacherName.isNotEmpty)
        '${PdfDocumentStrings.teacher}: ${data.teacherName}',
      if (data.teacherPhoneNumber.isNotEmpty)
        '${PdfDocumentStrings.phone}: ${data.teacherPhoneNumber}',
    ];

    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.symmetric(horizontal: 16, vertical: 11),
      decoration: filled
          ? const pw.BoxDecoration(
              color: _primarySoft,
              border: pw.Border(
                top: pw.BorderSide(color: _primary, width: 0.8),
              ),
            )
          : null,
      child: pw.Text(
        details.isEmpty ? AppStrings.appName : details.join(' | '),
        textAlign: pw.TextAlign.center,
        style: pw.TextStyle(
          color: filled ? _primary : _ink,
          fontSize: 11,
          fontWeight: pw.FontWeight.bold,
        ),
      ),
    );
  }

  pw.Widget _headerOptionalLine(String label, String value) {
    if (value.isEmpty) return pw.SizedBox();
    return pw.Text('$label: $value', style: const pw.TextStyle(fontSize: 9));
  }

  pw.Widget _headerValue(String label, String value) {
    return pw.Text(
      '$label: ${value.isEmpty ? PdfDocumentStrings.unknown : value}',
      textAlign: pw.TextAlign.right,
      style: const pw.TextStyle(fontSize: 9),
    );
  }

  pw.Widget _studentField(String label) {
    return pw.Text(
      '$label: ${PdfDocumentStrings.unknown}',
      style: const pw.TextStyle(fontSize: 9),
    );
  }

  pw.Widget _studentDataRow() {
    return pw.Row(
      children: [
        pw.Expanded(
          flex: 3,
          child: _studentField(PdfDocumentStrings.studentName),
        ),
        pw.SizedBox(width: 10),
        pw.Expanded(child: _studentField(PdfDocumentStrings.classroom)),
        pw.SizedBox(width: 10),
        pw.Expanded(child: _studentField(PdfDocumentStrings.seatNumber)),
      ],
    );
  }

  String _fileName(String title, DocumentDataEntity data) {
    final now = DateTime.now();
    final date =
        '${now.year}-${_twoDigits(now.month)}-${_twoDigits(now.day)}_${_twoDigits(now.hour)}-${_twoDigits(now.minute)}-${_twoDigits(now.second)}';
    final safeTitle = _safeName(title);
    final safeGrade = _safeName(data.gradeTitle);
    return '${safeTitle}_${safeGrade}_$date.pdf';
  }

  String _safeName(String value) {
    return value
        .trim()
        .replaceAll(RegExp(r'[\\/:*?"<>|]'), '_')
        .replaceAll(RegExp(r'\s+'), '_');
  }

  String _twoDigits(int value) => value.toString().padLeft(2, '0');

  String _ordinal(int index) {
    const ordinals = [
      'الأول',
      'الثاني',
      'الثالث',
      'الرابع',
      'الخامس',
      'السادس',
      'السابع',
      'الثامن',
    ];
    if (index < ordinals.length) return ordinals[index];
    return '${index + 1}';
  }

  String _optionLetter(int index) {
    const letters = ['أ', 'ب', 'ج', 'د', 'هـ', 'و'];
    if (index < letters.length) return letters[index];
    return '${index + 1}';
  }
}

class _PdfFonts {
  final pw.Font regular;
  final pw.Font bold;

  const _PdfFonts({required this.regular, required this.bold});
}
