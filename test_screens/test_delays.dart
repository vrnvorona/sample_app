abstract class TestDelays {
  /// задержки для запроса
  static const requestDelay = Duration(seconds: 60);
  static const longRequestDelay = Duration(seconds: 120);

  /// задержки для взаимодействия
  static const shortInteractionDelay = Duration(milliseconds: 300);
  static const interactionDelay = Duration(milliseconds: 500);
  static const longInteractionDelay = Duration(seconds: 1);
}
