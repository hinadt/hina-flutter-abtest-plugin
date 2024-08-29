import 'package:flutter_test/flutter_test.dart';
import 'package:hina_flutter_abtest_plugin/hina_flutter_abtest_plugin.dart';
import 'package:hina_flutter_abtest_plugin/hina_flutter_abtest_plugin_platform_interface.dart';
import 'package:hina_flutter_abtest_plugin/hina_flutter_abtest_plugin_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockHinaFlutterAbtestPluginPlatform
    with MockPlatformInterfaceMixin
    implements HinaFlutterAbtestPluginPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final HinaFlutterAbtestPluginPlatform initialPlatform = HinaFlutterAbtestPluginPlatform.instance;

  test('$MethodChannelHinaFlutterAbtestPlugin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelHinaFlutterAbtestPlugin>());
  });

  test('getPlatformVersion', () async {
    HinaFlutterAbtestPlugin hinaFlutterAbtestPlugin = HinaFlutterAbtestPlugin();
    MockHinaFlutterAbtestPluginPlatform fakePlatform = MockHinaFlutterAbtestPluginPlatform();
    HinaFlutterAbtestPluginPlatform.instance = fakePlatform;

    expect(await hinaFlutterAbtestPlugin.getPlatformVersion(), '42');
  });
}
