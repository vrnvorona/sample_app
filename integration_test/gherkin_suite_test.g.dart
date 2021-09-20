// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gherkin_suite_test.dart';

// **************************************************************************
// GherkinSuiteTestGenerator
// **************************************************************************

class _CustomGherkinIntegrationTestRunner extends GherkinIntegrationTestRunner {
  _CustomGherkinIntegrationTestRunner(
    TestConfiguration configuration,
    void Function(World) appMainFunction,
  ) : super(configuration, appMainFunction);

  @override
  void onRun() {
    testFeature0();
  }

  void testFeature0() {
    runFeature(
      'Пример:',
      <String>[],
      () async {
        runScenario(
          'Добавление в избранное, удаление на главной',
          <String>[],
          (TestDependencies dependencies) async {
            await runStep(
              'Когда Я открываю приложение',
              <String>[],
              null,
              dependencies,
            );

            await runStep(
              'И Я добавляю первый товар в избранное',
              <String>[],
              null,
              dependencies,
            );

            await runStep(
              'И Я вижу снек "Added to favorites"',
              <String>[],
              null,
              dependencies,
            );

            await runStep(
              'И Я удаляю первый товар из избранного на главной',
              <String>[],
              null,
              dependencies,
            );

            await runStep(
              'Тогда Я вижу снек "Removed from favorites"',
              <String>[],
              null,
              dependencies,
            );
          },
        );

        runScenario(
          'Добавление в избранное, удаление в избранном',
          <String>[],
          (TestDependencies dependencies) async {
            await runStep(
              'Когда Я открываю приложение',
              <String>[],
              null,
              dependencies,
            );

            await runStep(
              'И Я добавляю первый товар в избранное',
              <String>[],
              null,
              dependencies,
            );

            await runStep(
              'И Я вижу снек "Added to favorites"',
              <String>[],
              null,
              dependencies,
            );

            await runStep(
              'И Я перехожу в избранное',
              <String>[],
              null,
              dependencies,
            );

            await runStep(
              'И Я удаляю первый товар из избранного в избранном',
              <String>[],
              null,
              dependencies,
            );

            await runStep(
              'Тогда Я вижу снек "Removed from favorites"',
              <String>[],
              null,
              dependencies,
            );
          },
        );
      },
    );
  }
}

void executeTestSuite(
  TestConfiguration configuration,
  void Function(World) appMainFunction,
) {
  _CustomGherkinIntegrationTestRunner(configuration, appMainFunction).run();
}
