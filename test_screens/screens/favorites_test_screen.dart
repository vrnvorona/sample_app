import 'package:flutter_test/flutter_test.dart';
import 'package:sample_app/res/test_keys.dart';

abstract class FavoritesTestScreen {
  /// кнопка удаления товара из избранного по индексу
  static Finder removeFromFavBtn(int i) => find.byKey(FavoritesTestKeys.removeItem(i));
}
