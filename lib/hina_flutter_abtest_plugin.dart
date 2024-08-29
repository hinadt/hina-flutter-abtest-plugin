
import 'dart:convert';

import 'package:flutter/services.dart';

import 'hina_flutter_abtest_plugin_platform_interface.dart';

class HinaFlutterAbtestPlugin {
  static MethodChannel get _channel =>
      ChannelManager.getInstance().methodChannel;

  ///初始化 A/B Testing，在此之前请确保先初始化海纳嗨数分析 SDK：
  ///[url] 为分流接口地址
  static void initForMobile(String url) {
    _channel.invokeMethod('init', [url]);
  }

  /// 从缓存中获取试验结果。[paramName] 是参数名称，[defaultValue] 是对应参数的默认值，
  /// 泛型 [T] 的支持类型包括：[int]、[String]、[bool] 和代表 JSON 的 [Map<String,dynamic>] 类型。
  static Future<T?> fetchCacheABTest<T>(String paramName, T defaultValue) async {
    return handleInvokeMethod('fetchCacheABTest', [paramName, defaultValue], defaultValue is Map);
  }

  /// 始终从网络请求试验结果，默认 30s 超时时间。[paramName] 是参数名称，[defaultValue] 是对应参数的默认值，
  /// 泛型 [T] 的支持类型包括：[int]、[String]、[bool] 和代表 JSON 的 [Map<String,dynamic>] 类型，
  /// [timeoutMillSeconds] 的值默认是 30  * 1000，单位是 ms。
  static Future<T?> asyncFetchABTest<T>(String paramName, T defaultValue, [int timeoutMillSeconds = 30 * 1000]) async {
    return handleInvokeMethod('asyncFetchABTest', [paramName, defaultValue, timeoutMillSeconds], defaultValue is Map);
  }

  /// 如果本地有缓存，则返回缓存数据；否则从网络请求最新的试验数据，默认 30s 超时时间。[paramName] 是参数名称，[defaultValue] 是对应参数的默认值，
  /// 泛型 [T] 的支持类型包括：[int]、[String]、[bool] 和代表 JSON 的 [Map<String,dynamic>] 类型，
  /// [timeoutMillSeconds] 的值默认是 30  * 1000，单位是 ms。
  static Future<T?> fastFetchABTest<T>(String paramName, T defaultValue, [int timeoutMillSeconds = 30 * 1000]) async {
    return handleInvokeMethod('fastFetchABTest', [paramName, defaultValue, timeoutMillSeconds], defaultValue is Map);
  }

  static Future<T?> handleInvokeMethod<T>(String method, dynamic arguments, bool isMap) async {
    if (isMap) {
      dynamic result = await _channel.invokeMethod(method, arguments);
      dynamic finalResult = jsonDecode(result);
      return Future.value(finalResult);
    }
    return _channel.invokeMethod(method, arguments);
  }

  Future<String?> getPlatformVersion() {
    return HinaFlutterAbtestPluginPlatform.instance.getPlatformVersion();
  }
}

/// Flutter MethodChannel Manager
class ChannelManager {
  static ChannelManager _instance = ChannelManager._();

  factory ChannelManager.getInstance() => _instance;

  final MethodChannel _channel = const MethodChannel('hina_flutter_abtest_plugin');

  ChannelManager._();

  MethodChannel get methodChannel => _channel;
}