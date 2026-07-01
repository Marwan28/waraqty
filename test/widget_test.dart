import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:waraqty/app/my_app.dart';
import 'package:waraqty/core/ads/ads_cubit.dart';
import 'package:waraqty/core/constants/app_strings.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Waraqty app renders the first setup screen', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final sharedPreferences = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      MyApp(
        hasSeenOnboarding: true,
        sharedPreferences: sharedPreferences,
        adsCubit: AdsCubit(sharedPreferences: sharedPreferences),
      ),
    );

    await tester.pump();

    expect(find.text(GradeSelectionStrings.selectGradeTitle), findsOneWidget);
  });
}
