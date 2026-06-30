import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:waraqty/features/document_builder/presentation/widgets/document_details_text_field.dart';

void main() {
  testWidgets(
    'keeps booklet and exam field values isolated when switching type',
    (tester) async {
      final isBooklet = ValueNotifier(true);
      var bookletTitle = '';
      var schoolName = '';

      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(360, 800),
          builder: (_, _) => MaterialApp(
            home: Scaffold(
              body: ValueListenableBuilder<bool>(
                valueListenable: isBooklet,
                builder: (_, showBooklet, _) {
                  return DocumentDetailsTextField(
                    label: showBooklet ? 'عنوان الملزمة' : 'اسم المدرسة',
                    hint: '',
                    initialValue: showBooklet ? bookletTitle : schoolName,
                    onChanged: (value) {
                      if (showBooklet) {
                        bookletTitle = value;
                      } else {
                        schoolName = value;
                      }
                    },
                    icon: LucideIcons.fileText,
                  );
                },
              ),
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), 'test');
      expect(bookletTitle, 'test');

      isBooklet.value = false;
      await tester.pump();

      expect(find.text('test'), findsNothing);
      expect(schoolName, isEmpty);

      await tester.enterText(find.byType(TextFormField), 'مدرسة النيل');
      expect(schoolName, 'مدرسة النيل');

      isBooklet.value = true;
      await tester.pump();

      expect(find.text('test'), findsOneWidget);
      expect(bookletTitle, 'test');
      expect(schoolName, 'مدرسة النيل');
    },
  );
}
