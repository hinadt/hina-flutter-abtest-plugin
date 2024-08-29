import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'hina_flutter_abtest_plugin_platform_interface.dart';

/// An implementation of [HinaFlutterAbtestPluginPlatform] that uses method channels.
class MethodChannelHinaFlutterAbtestPlugin extends HinaFlutterAbtestPluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('hina_flutter_abtest_plugin');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
