import 'dart:async';

import 'package:flutter/material.dart' hide ErrorWidget;
import 'package:flutter_test/flutter_test.dart';

/// Общие полезности над WidgetTester для удобства и переиспользования кода
extension GeneralExtendedWidgetTester on WidgetTester {
  /// Функция для того чтобы пампить определенное время, когда нельзя использовать
  /// pumpAndSettle или обычный pump
  Future<void> pumpForDuration(Duration duration) async {
    final stopwatch = Stopwatch()..start();
    while (stopwatch.elapsed < duration) {
      await pump(_minimalPumpDelay);
    }
  }

  /// Метод для того, чтобы пампить пока не завершится анимация или до таймаута если анимация долгая
  /// Позволяет пропускать переходы по экранам без использования [pumpForDuration]
  Future<void> pumpUntilSettled({Duration timeout = _defaultPumpTimeout}) async {
    final stopwatch = Stopwatch()..start();
    while (stopwatch.elapsed < timeout && binding.hasScheduledFrame) {
      await pump(_minimalPumpDelay);
    }
  }

  /// Метод для того, чтобы делать pump пока не произойдет условие [condition]
  Future<bool> pumpUntilCondition(bool Function() condition,
      {Duration timeout = _defaultPumpTimeout}) async {
    final stopwatch = Stopwatch()..start();
    var instant = true;
    while (stopwatch.elapsed < timeout) {
      if (condition()) {
        // добавляем доп задержку если нашли не сразу - скорее всего идет анимация
        if (!instant) await pumpForDuration(_minimalInteractionDelay);
        return true;
      }
      await pump(_minimalPumpDelay);
      instant = false;
    }
    return false;
  }

  /// Функция для pump пока не будет обнаружен виджет
  Future<bool> pumpUntilVisible(Finder target,
      {Duration timeout = _defaultPumpTimeout, bool doThrow = true}) async {
    bool condition() => target.evaluate().isNotEmpty;
    final found = await pumpUntilCondition(condition, timeout: timeout);
    // ignore: only_throw_errors
    if (!found && doThrow) throw TestFailure('Target was not found ${target.toString()}');
    return found;
  }

  /// Функция для pump пока не будет обнаружен любой из списка виджетов
  Future<void> pumpUntilVisibleAny(List<Finder> targetList,
      {Duration timeout = _defaultPumpTimeout}) async {
    bool condition() => targetList.any((target) => target.evaluate().isNotEmpty);
    final found = await pumpUntilCondition(condition, timeout: timeout);
    // ignore: only_throw_errors
    if (!found) throw TestFailure('None of targets were found ${targetList.toString()}');
  }

  /// Функция для pump пока не пропадет виджет
  /// Может не работать в некоторых ситуациях несмотря на offstage = true
  Future<bool> pumpUntilNotVisible(Finder target,
      {Duration timeout = _defaultPumpTimeout, bool doThrow = true}) async {
    bool condition() => target.evaluate().isEmpty;
    final found = await pumpUntilCondition(condition, timeout: timeout);
    // ignore: only_throw_errors
    if (!found && doThrow) throw TestFailure('Target did not disappear ${target.toString()}');
    return found;
  }

  /// Функция для pump пока не пропадет любой из списка виджетов
  Future<void> pumpUntilNotVisibleAny(List<Finder> targetList,
      {Duration timeout = _defaultPumpTimeout}) async {
    bool condition() => targetList.any((target) => target.evaluate().isEmpty);
    final found = await pumpUntilCondition(condition, timeout: timeout);
    // ignore: only_throw_errors
    if (!found) throw TestFailure('None of targets did disappear ${targetList.toString()}');
  }

  /// Функция для pump пока на экране не будет меньше чем [amount] количество [target]
  Future<void> pumpUntilVisibleLessThan(Finder target, int amount,
      {Duration timeout = _defaultPumpTimeout}) async {
    bool condition() => target.evaluate().length < amount;
    final found = await pumpUntilCondition(condition, timeout: timeout);
    if (!found) {
      // ignore: only_throw_errors
      throw TestFailure('Amount of targets was not less than $amount ${target.toString()}');
    }
  }

  /// Функция для pump пока на экране не будет [amount] количество [target]
  Future<void> pumpUntilVisibleAmount(Finder target, int amount,
      {Duration timeout = _defaultPumpTimeout}) async {
    bool condition() => target.evaluate().length == amount;
    final found = await pumpUntilCondition(condition, timeout: timeout);
    // ignore: only_throw_errors
    if (!found) throw TestFailure('There were not $amount targets ${target.toString()}');
  }

  /// Функция для pump пока количество видимых элементов не уменьшится
  /// Полезно когда на экране есть два лоадера
  Future<void> pumpUntilLessVisible(Finder target, {Duration timeout = _defaultPumpTimeout}) async {
    final initialCount = target.evaluate().length;
    bool condition() => target.evaluate().length < initialCount;
    final found = await pumpUntilCondition(condition, timeout: timeout);
    // ignore: only_throw_errors
    if (!found) throw TestFailure('Amount of targets did not decrease ${target.toString()}');
  }

  /// Функция чтобы убрать избыточные pump из кода шагов при тапах
  Future<void> implicitTap(Finder finder, {Duration timeout = _defaultPumpTimeout}) async {
    await pumpUntilVisibleAmount(finder, 1, timeout: timeout);
    try {
      await tap(finder);
      await pump();
    }
    // ignore: avoid_catching_errors
    on StateError catch (e) {
      // ignore: only_throw_errors
      throw TestFailure(e.message);
    }
  }

  /// Функция чтобы убрать избыточные pump из кода шагов при вводе текста
  Future<void> implicitEnterText(Finder finder, String text,
      {Duration timeout = _defaultPumpTimeout}) async {
    await pumpUntilVisible(finder, timeout: timeout);
    try {
      await enterText(finder, text);
      await pump();
    }
    // ignore: avoid_catching_errors
    on StateError catch (e) {
      // ignore: only_throw_errors
      throw TestFailure(e.message);
    }
  }

  /// Метод который свайпает [view] в направлении [moveStep] пока [finder] не будет обнаружен
  /// [followUp] делает еще один свайп после выполнения условия
  /// [delay] добавляет задержку после каждого свайпа, т.к. есть проблема с обнаружением [view]
  /// в движении
  Future<void> customDragUntilVisible(
    Finder finder,
    Finder view,
    Offset moveStep, {
    int maxIteration = 50,
    Duration duration = const Duration(milliseconds: 50),
    bool followUp = false,
    Duration delay = const Duration(),
    Finder? errorWidget,
  }) {
    return TestAsyncUtils.guard<void>(() async {
      await pumpUntilVisible(view);
      for (int i = 0; i < maxIteration && finder.evaluate().isEmpty; i++) {
        await dragFrom(getCenter(view), moveStep);
        await pumpUntilSettled(timeout: duration + delay);
        if (errorWidget != null) {
          if (errorWidget.evaluate().isNotEmpty) {
            // ignore: only_throw_errors
            throw TestFailure('Error was encountered $errorWidget');
          }
        }
      }
      if (followUp) await flingFrom(getCenter(view), moveStep, 5000);
    });
  }

  /// Метод который свайпает [view] в направлении [moveStep] пока [finder] не пропадет из виду
  /// [followUp] делает еще один свайп после выполнения условия
  /// [delay] добавляет задержку после каждого свайпа, т.к. есть проблема с обнаружением [view]
  /// в движении
  Future<void> customDragUntilNotVisible(
    Finder finder,
    Finder view,
    Offset moveStep, {
    int maxIteration = 50,
    Duration duration = const Duration(milliseconds: 50),
    bool followUp = false,
    Duration delay = const Duration(),
  }) {
    return TestAsyncUtils.guard<void>(() async {
      await pumpUntilVisible(view);
      for (int i = 0; i < maxIteration && finder.evaluate().isNotEmpty; i++) {
        await dragFrom(getCenter(view), moveStep);
        await pumpUntilSettled(timeout: duration + delay);
      }
      if (followUp) await flingFrom(getCenter(view), moveStep, 5000);
    });
  }
}

/// Минимальное время которое будет происходить между действиями с виджетами
/// Нужно чтобы большинство анимаций успевали завершаться
const Duration _minimalInteractionDelay = Duration(milliseconds: 50);

/// Время которое будут выполняться методы pumpUntil* перед завершением по умолчанию
const Duration _defaultPumpTimeout = Duration(seconds: 10);

/// Время между pump внутри pumpUntil* методов чтобы освободить поток
const Duration _minimalPumpDelay = Duration(milliseconds: 50);
