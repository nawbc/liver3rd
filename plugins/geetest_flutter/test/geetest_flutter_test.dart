import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geetest_flutter/geetest_flutter.dart';

void main() {
  const MethodChannel channel = MethodChannel('geetest_flutter');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await GeetestFlutter.platformVersion, '42');
  });
}
