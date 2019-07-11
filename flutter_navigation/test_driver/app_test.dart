import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Flutter Navigation Test', () {
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

    test('tap next, check text, tap next, check text', () async {
      final firstScreenText = find.byValueKey('firstScreenText');
      final firstScreenNextButton = find.byValueKey('firstScreenNextButton');
      final secondScreenText = find.byValueKey('secondScreenText');
      final secondScreenNextButton = find.byValueKey('secondScreenNextButton');

      expect(await driver.getText(firstScreenText), 'Home Screen');
      await driver.tap(firstScreenNextButton);
      expect(await driver.getText(secondScreenText), 'Second Screen');
      await driver.tap(secondScreenNextButton);
      expect(await driver.getText(secondScreenText), 'Third Screen');
    });

//    test('tap next, check text, tap back, check text', () async {
//      final firstScreenText = find.byValueKey('firstScreenText');
//      final firstScreenNextButton = find.byValueKey('firstScreenNextButton');
//      final secondScreenText = find.byValueKey('secondScreenText');
//      final secondScreenBackButton = find.byValueKey('secondScreenBackButton');
//
//      expect(await driver.getText(firstScreenText), 'Home Screen');
//      await driver.tap(firstScreenNextButton);
//      expect(await driver.getText(secondScreenText), 'Second Screen');
//      await driver.tap(secondScreenBackButton);
//      expect(await driver.getText(firstScreenText), 'Home Screen');
//    });
  });
}
