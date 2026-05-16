import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:waraqty/app/my_app.dart';
import 'package:waraqty/core/constants/app_strings.dart';

void main() {
  testWidgets('Waraqty app renders placeholder screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MyApp(
        hasSeenOnboarding: true,
        sharedPreferences: await SharedPreferences.getInstance(),
      ),
    );

    await tester.pump();

    expect(find.text(AppStrings.appName), findsOneWidget);
  });
}
