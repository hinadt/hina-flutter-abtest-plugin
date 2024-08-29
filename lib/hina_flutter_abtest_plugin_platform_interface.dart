import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'hina_flutter_abtest_plugin_method_channel.dart';

abstract class HinaFlutterAbtestPluginPlatform extends PlatformInterface {
  /// Constructs a HinaFlutterAbtestPluginPlatform.
  HinaFlutterAbtestPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static HinaFlutterAbtestPluginPlatform _instance = MethodChannelHinaFlutterAbtestPlugin();

  /// The default instance of [HinaFlutterAbtestPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelHinaFlutterAbtestPlugin].
  static HinaFlutterAbtestPluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [HinaFlutterAbtestPluginPlatform] when
  /// they register themselves.
  static set instance(HinaFlutterAbtestPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
