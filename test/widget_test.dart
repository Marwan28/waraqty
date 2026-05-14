import 'package:flutter_test/flutter_test.dart';

import 'package:waraqty/app/my_app.dart';
import 'package:waraqty/core/constants/app_strings.dart';

void main() {
  testWidgets('Waraqty app renders placeholder screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await tester.pump();

    expect(find.text(AppStrings.appName), findsOneWidget);
  });
}
