import 'dart:convert';
import 'dart:io';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:path/path.dart' as path;
import 'package:integration_test/integration_test_driver.dart' as integration_test_driver;

const JsonEncoder _prettyEncoder = JsonEncoder.withIndent('  ');

String _encodeJson(Object jsonObject, bool pretty) {
  return pretty ? _prettyEncoder.convert(jsonObject) : json.encode(jsonObject);
}

Future<void> writeGherkinReports(Map<String, dynamic>? data) async {
  await integration_test_driver.writeResponseData(
    data,
    testOutputFilename: 'gherkin_reports',
  );

  final reports = json.decode(data!['gherkin_reports'].toString()) as List<dynamic>;
  for (var i = 0; i < reports.length; i += 1) {
    final reportData = reports.elementAt(i) as List<dynamic>;

    await fs.directory(integration_test_driver.testOutputsDirectory).create(recursive: true);
    final File file = fs.file(path.join(
      integration_test_driver.testOutputsDirectory,
      'report_$i.json',
    ));
    final String resultString = _encodeJson(reportData, true);
    await file.writeAsString(resultString);
  }
}

Future<void> main() async {
  integration_test_driver.testOutputsDirectory = 'integration_test/gherkin/reports';

  /// Выдаем симулятору enrollment на TouchID
  await Process.run('xcrun', [
    'simctl',
    'spawn',
    'booted',
    'notifyutil',
    '-s',
    'com.apple.BiometricKit.enrollmentChanged',
    '1'
  ]);
  await Process.run('xcrun', [
    'simctl',
    'spawn',
    'booted',
    'notifyutil',
    '-p',
    'com.apple.BiometricKit.enrollmentChanged'
  ]);

  /// Выдаем права на геолокацию чтобы не было проблем
  await Process.run(
      'xcrun', ['simctl', 'privacy', 'booted', 'grant', 'location-always', '<package>']);
  [
    'ACCESS_COARSE_LOCATION',
    'ACCESS_FINE_LOCATION',
  ].forEach((permission) async =>
      Process.run('adb', ['shell', 'pm', 'grant', '<package>', 'android.permission.$permission']));
  return integration_test_driver.integrationDriver(
    timeout: const Duration(minutes: 120),
    responseDataCallback: writeGherkinReports,
  );
}
