import 'package:flutter/material.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gherkin/gherkin.dart';
import '../../test_screens/test_screens_library.dart';
import '../../test_screens/utils/general_test_utils.dart';

class SampleSteps {
  static Iterable<StepDefinitionGeneric> get steps => [
        when<FlutterWidgetTesterWorld>(RegExp(r'Я открываю приложение$'), (context) async {
          final tester = context.world.rawAppDriver;
          await tester.pumpUntilVisible(MainTestScreen.scroll);
        }),
        when<FlutterWidgetTesterWorld>(RegExp(r'Я добавляю первый товар в избранное$'),
            (context) async {
          final tester = context.world.rawAppDriver;
          await tester.implicitTap(MainTestScreen.addToFavorites.first);
        }),
        when<FlutterWidgetTesterWorld>(RegExp(r'Я удаляю первый товар из избранного на главной$'),
            (context) async {
          final tester = context.world.rawAppDriver;
          await tester.implicitTap(MainTestScreen.removeFromFavorites.first);
        }),
        when<FlutterWidgetTesterWorld>(RegExp(r'Я перехожу в избранное$'), (context) async {
          final tester = context.world.rawAppDriver;
          await tester.implicitTap(MainTestScreen.favoritesBtn);
        }),
        when<FlutterWidgetTesterWorld>(RegExp(r'Я удаляю первый товар из избранного в избранном$'),
            (context) async {
          final tester = context.world.rawAppDriver;
          await tester.implicitTap(FavoritesTestScreen.removeFromFavBtn(0));
        }),
        given1<String, FlutterWidgetTesterWorld>(RegExp(r'Я вижу снек {string}$'),
            (text, context) async {
          final tester = context.world.rawAppDriver;
          await tester.pumpUntilVisibleAmount(MainTestScreen.snackbar, 1);
          final actual = tester.widget<SnackBar>(MainTestScreen.snackbar).content as Text;
          expect(actual.data, text);
          await tester.pumpUntilNotVisible(MainTestScreen.snackbar);
        }),
      ];
}
