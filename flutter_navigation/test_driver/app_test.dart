import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Flutter Navigation', () {
    FlutterDriver driver;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test('check flutter driver extension', () async {
      final health = await driver.checkHealth();
      print(health.status);
    });

    test('input text and tap next then screen text', () async {
      final textField = find.byValueKey('firstScreenTextField');
      final firstScreenNextButton = find.byValueKey('firstScreenNextButton');
      final secondScreenText = find.byValueKey('secondScreenText');
      await driver.tap(textField);
      await driver.enterText('Hello');
      await driver.tap(firstScreenNextButton);
      expect(await driver.getText(secondScreenText), 'you typed: "Hello"');
    });
  });
}
