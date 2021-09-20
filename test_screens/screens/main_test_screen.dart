import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sample_app/res/test_keys.dart';

abstract class MainTestScreen {
  /// снекбар
  static Finder snackbar = find.byType(SnackBar);

  /// скролл на экране списка
  static Finder scroll = find.byKey(HomeTestKeys.scroll);

  /// кнопки добавление/удаления в избранное
  static Finder favoriteToggleBtn = find.byType(IconButton);
  static Finder addToFavorites = find
      .byWidgetPredicate((w) => w is IconButton && (w.icon as Icon).icon == Icons.favorite_border);
  static Finder removeFromFavorites =
      find.byWidgetPredicate((w) => w is IconButton && (w.icon as Icon).icon == Icons.favorite);

  /// кнопка перехода в избранное
  static Finder favoritesBtn = find.byKey(HomeTestKeys.favoritesBtn);

  /// иконки добавления/удаления из избранного
  static Finder addFavoritesIcon =
      find.byWidgetPredicate((w) => w is Icon && w.icon == Icons.favorite_border);
  static Finder removeFavoritesIcon =
      find.byWidgetPredicate((w) => w is Icon && w.icon == Icons.favorite);
}
