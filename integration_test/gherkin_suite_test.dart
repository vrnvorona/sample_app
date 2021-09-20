import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gherkin/gherkin.dart';
// The application under test.
import 'package:sample_app/main.dart' as app;

import 'step_definitions_library.dart';

part 'gherkin_suite_test.g.dart';

//flutter drive --driver=integration_test/integration_test.dart --target=integration_test/gherkin_suite_test.dart
@GherkinTestSuite(featureDefaultLanguage: 'ru')
void main() {
  executeTestSuite(
    FlutterTestConfiguration.DEFAULT([])
      ..reporters = [
        StdoutReporter(MessageLevel.error)
          ..setWriteLineFn(print)
          ..setWriteFn(print),
        ProgressReporter()
          ..setWriteLineFn(print)
          ..setWriteFn(print),
        TestRunSummaryReporter()
          ..setWriteLineFn(print)
          ..setWriteFn(print),
        JsonReporter(writeReport: (_, __) => Future<void>.value()),
      ]
      ..defaultTimeout = const Duration(minutes: 3)
      ..order = ExecutionOrder.sequential
      ..stepDefinitions = steps
      ..tagExpression = 'not @todo and not @fail and not @debug',
    (world) => app.main(),
  );
}
