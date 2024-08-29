import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hina_flutter_abtest_plugin/hina_flutter_abtest_plugin_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelHinaFlutterAbtestPlugin platform = MethodChannelHinaFlutterAbtestPlugin();
  const MethodChannel channel = MethodChannel('hina_flutter_abtest_plugin');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
