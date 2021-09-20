import 'package:gherkin/gherkin.dart';

import 'step_definitions/sample_steps.dart';

Iterable<StepDefinitionGeneric> steps = [
  ...SampleSteps.steps,
];
