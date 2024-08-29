package com.hina.cloud.hina_flutter_abtest_plugin;

import android.content.Context;
import android.os.Handler;
import android.os.Looper;

import androidx.annotation.NonNull;

import com.hina.analytics.abtest.HinaABTest;
import com.hina.analytics.abtest.HinaABTestConfig;
import com.hina.analytics.abtest.OnABTestReceivedData;

import org.json.JSONObject;

import java.util.List;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/**
 * HinaFlutterAbtestPlugin
 */
public class HinaFlutterAbtestPlugin implements FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private MethodChannel channel;
    private Context applicationContext;
    private Handler uiThreadHandler = new Handler(Looper.getMainLooper());

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "hina_flutter_abtest_plugin");
        channel.setMethodCallHandler(this);
        applicationContext = flutterPluginBinding.getApplicationContext();
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        switch (call.method) {
            case "init":
                init(call, result);
                break;
            case "fetchCacheABTest":
                fetchCacheABTest(call, result);
                break;
            case "asyncFetchABTest":
                asyncFetchABTest(call, result);
                break;
            case "fastFetchABTest":
                fastFetchABTest(call, result);
                break;
            case "getPlatformVersion":
                result.success("Android " + android.os.Build.VERSION.RELEASE);
                break;
            default:
                result.notImplemented();
                break;
        }
    }

    private void init(MethodCall call, Result result) {
        try {
            List list = (List) call.arguments();
            // 配置项目的分流接口
            String serverUrl = (String) list.get(0);

            // 确保先初始化“海纳嗨数埋点SDK”
            // A/B Testing SDK 初始化
            HinaABTestConfig abTestConfigOptions = new HinaABTestConfig(serverUrl);
            HinaABTest.init(applicationContext, abTestConfigOptions);
            result.success(null);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void fetchCacheABTest(MethodCall call, Result result) {
        List list = (List) call.arguments();
        String paramName = (String) list.get(0);
        Object defaultValue = list.get(1);
        if (defaultValue instanceof Map) {
            defaultValue = new JSONObject((Map) defaultValue);
        }
        Object abResult = HinaABTest.getInstance().fetchCacheABTest(paramName, defaultValue);
        checkResult(abResult, result);
    }

    private void asyncFetchABTest(MethodCall call, final Result result) {
        List list = (List) call.arguments();
        String paramName = (String) list.get(0);
        Object defaultValue = list.get(1);
        int timeout = (int) list.get(2);
        if (defaultValue instanceof Map) {
            defaultValue = new JSONObject((Map) defaultValue);
        }
        HinaABTest.getInstance().asyncFetchABTest(paramName, defaultValue, timeout, new OnABTestReceivedData<Object>() {
            @Override
            public void onResult(final Object value) {
                uiThreadHandler.post(new Runnable() {
                    @Override
                    public void run() {
                        checkResult(value, result);
                    }
                });
            }
        });
    }

    private void fastFetchABTest(MethodCall call, final Result result) {
        List list = (List) call.arguments();
        String paramName = (String) list.get(0);
        Object defaultValue = list.get(1);
        int timeout = (int) list.get(2);
        if (defaultValue instanceof Map) {
            defaultValue = new JSONObject((Map) defaultValue);
        }
        HinaABTest.getInstance().fastFetchABTest(paramName, defaultValue, timeout, new OnABTestReceivedData<Object>() {
            @Override
            public void onResult(final Object value) {
                uiThreadHandler.post(new Runnable() {
                    @Override
                    public void run() {
                        checkResult(value, result);
                    }
                });

            }
        });
    }

    private void checkResult(Object abResult, Result result) {
        if (abResult instanceof JSONObject) {
            JSONObject jsonObject = (JSONObject) abResult;
            result.success(jsonObject.toString());
            return;
        }
        result.success(abResult);
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }
}
