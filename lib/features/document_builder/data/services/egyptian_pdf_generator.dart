import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:waraqty/core/constants/app_strings.dart';
import 'package:waraqty/core/enums/question_category_type.dart';
import 'package:waraqty/features/document_builder/domain/entities/document_data_entity.dart';
import 'package:waraqty/features/document_builder/domain/entities/document_section_entity.dart';
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
        pageTheme: _pageTheme(theme),
        build: (context) => _bookletCover(data, title),
      ),
    );
    document.addPage(
      pw.MultiPage(
        pageTheme: _pageTheme(theme),
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
        pageTheme: _pageTheme(theme),
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
        pageTheme: _pageTheme(theme),
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

  pw.PageTheme _pageTheme(pw.ThemeData theme) {
    return pw.PageTheme(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.fromLTRB(30, 28, 30, 30),
      textDirection: pw.TextDirection.rtl,
      theme: theme,
    );
  }

  pw.Widget _bookletCover(DocumentDataEntity data, String title) {
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

  pw.Widget _bookletHeader(DocumentDataEntity data, String title) {
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

  pw.Widget _examHeader(
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
      widgets.add(_sectionTitle(section, sectionIndex));
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
          ),
        );
        widgets.add(pw.SizedBox(height: 8));
      }
      widgets.add(pw.SizedBox(height: 8));
    }
    return widgets;
  }

  pw.Widget _sectionTitle(DocumentSectionEntity section, int sectionIndex) {
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
        '${PdfDocumentStrings.question} ${_ordinal(sectionIndex)}: ${section.title}',
        style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
      ),
    );
  }

  pw.Widget _questionWidget({
    required QuestionEntity question,
    required int questionNumber,
    required double fontSize,
    required bool includeAnswer,
    required bool includeAnswerSpaces,
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
            height: 17,
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
      widgets.add(_sectionTitle(section, sectionIndex));
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
