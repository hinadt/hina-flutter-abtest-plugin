import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:hina_flutter_abtest_plugin/hina_flutter_abtest_plugin.dart';
import 'package:hina_flutter_plugin/hina_flutter_plugin.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    print('======== init web =========');
    HinaFlutterPlugin.callMethodForWeb('init', [{
      'serverUrl': 'https://loanetc.mandao.com/hn?token=BHRfsTQS',
      'showLog' : true,
      //单页面配置，默认开启，若页面中有锚点设计，需要将该配置删除，否则触发锚点会多触发 H_pageview 事件
      'isSinglePage': true,
      'autoTrackConfig': {
        //是否开启自动点击采集, true表示开启，自动采集 H_WebClick 事件
        'clickAutoTrack': true,
        //是否开启页面停留采集, true表示开启，自动采集 H_WebStay 事件
        'stayAutoTrack': true,
      }
    }]);
  } else {
    HinaFlutterPlugin.initForMobile(
        serverUrl: "https://test-hicloud.hinadt.com/gateway/hina-cloud-engine/ha?project=yituiAll&token=yt888",
        flushInterval: 5000,
        flushPendSize: 1,
        enableLog: true,
        autoTrackTypeList: {
          HAAutoTrackType.APP_START,
          HAAutoTrackType.APP_END
        });
    HinaFlutterAbtestPlugin.initForMobile('https://test-hicloud.hinadt.com/gateway/hina-cloud-service/abm/divide/query?project-key=yt888');
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _hinaFlutterAbtestPlugin = HinaFlutterAbtestPlugin();

  void checkColor() async {
    String? color = await HinaFlutterAbtestPlugin.fetchCacheABTest('color', '无色');
    print('测试ABTest: color=$color');
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await _hinaFlutterAbtestPlugin.getPlatformVersion() ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: GestureDetector(child: Text('Running on: $_platformVersion\n'), onTap: ()=>{
            checkColor()
          },),
        ),
      ),
    );
  }
}
