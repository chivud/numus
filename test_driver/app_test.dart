import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('App test', () {
    FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
      await driver.waitUntilFirstFrameRasterized();
    });

    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });
    test('- show Pick currency screen', () async {
      expect(await driver.getText(find.byValueKey('currency_title')),
          'Pick your currency');
      expect(await driver.getText(find.text('\$ - United States dollar')),
          '\$ - United States dollar');
      expect(await driver.getText(find.text('lei - Romanian leu')),
          'lei - Romanian leu');
      expect(find.byValueKey('currency_list'), true);
    });

  });
}
