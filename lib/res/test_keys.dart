import 'package:flutter/widgets.dart';

abstract class HomeTestKeys {
  /// скролл на экране списка
  static const Key scroll = Key('main_list_scroll');

  /// кнопка добавления/удаление в избранное
  static Key favoritesToggleBtn(int i) => Key('favorites_toggle_btn_$i');

  /// кнопка открытия избранного
  static const Key favoritesBtn = Key('main_favorites_btn');
}

abstract class FavoritesTestKeys {
  /// кнопка удаления товара из избранного по индексу
  static Key removeItem(int index) => Key('remove_icon_$index');
}
