import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sample_app/main.dart';
import 'package:sample_app/models/favorites.dart';

import '../../../test_screens/test_screens_library.dart';
import '../../../test_screens/utils/general_test_utils.dart';

Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    // код который выполняется перед всеми тестами
  });

  setUp(() {
    // код который выполняется перед каждым тестом
  });

  group('Добавление в избранное', () {
    testWidgets('На главной', (WidgetTester tester) async {
      await tester.pumpWidget(const TestingApp());

      await tester.pumpAndSettle();
      await tester.implicitTap(MainTestScreen.addToFavorites.first);
      await tester.pumpUntilVisible(MainTestScreen.snackbar);

      final actual = tester.widget<SnackBar>(MainTestScreen.snackbar).content as Text;
      expect(actual.data, 'Added to favorites');
    });
  });

  group('Удаление из избранного', () {
    testWidgets('На главной', (WidgetTester tester) async {
      await tester.pumpWidget(const TestingApp());
      final favourites =
          Provider.of<Favorites>(tester.element(MainTestScreen.favoritesBtn), listen: false);
      favourites.add(0);

      await tester.pumpAndSettle();
      await tester.implicitTap(MainTestScreen.removeFromFavorites.first);
      await tester.pumpUntilVisible(MainTestScreen.snackbar);

      final actual = tester.widget<SnackBar>(MainTestScreen.snackbar).content as Text;
      expect(actual.data, 'Removed from favorites');
    });

    testWidgets('В избранном', (WidgetTester tester) async {
      await tester.pumpWidget(const TestingApp());
      final favourites =
          Provider.of<Favorites>(tester.element(MainTestScreen.favoritesBtn), listen: false);
      favourites.add(0);

      await tester.pumpAndSettle();
      await tester.implicitTap(MainTestScreen.favoritesBtn);
      await tester.implicitTap(FavoritesTestScreen.removeFromFavBtn(0));
      await tester.pumpUntilVisible(MainTestScreen.snackbar);

      final actual = tester.widget<SnackBar>(MainTestScreen.snackbar).content as Text;
      expect(actual.data, 'Removed from favorites');
    });
  });
}
