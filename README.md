# sample_app

A Sample app that shows different types of testing in Flutter.

This particular sample uses the [Provider][] package but any other state management approach
would do.
It also uses [flutter_gherkin][] package with integration_test support.

[provider]: https://pub.dev/packages/provider
[flutter_gherkin]: https://github.com/jonsamwell/flutter_gherkin

## Goals for this sample

Show how to perform:

- Widget Testing
- Integration Testing

## How to run tests
- Navigate to the project's root folder using command line and follow the instructions below.

### To run tests using only the Flutter SDK:
The Flutter SDK can run unit tests and widget tests in a virtual machine, without the need of a physical device or emulator.
- To run all the test files in the `test/` directory in one go, run `flutter test`.
- To run a particular test file, run `flutter test test/<file_path>`

### To run tests on a physical device/emulator:
- Widget Tests:
  - Run `flutter run test/<file_path>`
- Integration Tests:
  - Run `flutter drive --driver=integration_test/integration_test.dart --target=integration_test/gherkin_suite_test.dart`

### Prerequisites
- Flutter 2.5.0 (with respective Dart version). Instructions https://flutter.dev/docs/get-started/install
- Can also be used with FVM with `fvm install`