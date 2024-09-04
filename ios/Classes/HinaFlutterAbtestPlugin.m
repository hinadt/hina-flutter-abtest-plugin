#import "HinaFlutterAbtestPlugin.h"
//#import "SensorsABTest.h"
#import "HinaABTest/HinaABTest.h"

@implementation HinaFlutterAbtestPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"hina_flutter_abtest_plugin"
                                     binaryMessenger:[registrar messenger]];
    HinaFlutterAbtestPlugin* instance = [[HinaFlutterAbtestPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    /*
    NSLog(@"====== handleMethodCall========");
    NSLog(@"====== call =%@========",call.method);
    NSLog(@"====== result =%@========",result);
    */
    
    if ([@"fetchCacheABTest" isEqualToString:call.method]) {
        [self fetchCacheABTest:call result:result];
    } else if ([@"asyncFetchABTest" isEqualToString:call.method]) {
        [self asyncFetchABTest:call result:result];
    } else if ([@"fastFetchABTest" isEqualToString:call.method]) {
        [self fastFetchABTest:call result:result];
    } else if ([@"startWithConfigOptions" isEqualToString:call.method]) {
        [self startWithConfigOptions:call result:result];
    } else if ([@"init" isEqualToString:call.method]) {
        [self init:call result:result];
    }else if ([@"getPlatformVersion" isEqualToString:call.method]) {
        [self getPlatformVersion:call result:result];
    } else {
        result(FlutterMethodNotImplemented);
    }
}

-(void)startWithConfigOptions:(FlutterMethodCall*)call result:(FlutterResult)result{
    NSString* url = (NSString*)call.arguments;
    HinaABTestConfigOptions *abtestConfigOptions = [[HinaABTestConfigOptions alloc] initWithURL:url];
    [HinaABTest startWithConfigOptions:abtestConfigOptions];
    result(nil);
}

-(void)init:(FlutterMethodCall*)call result:(FlutterResult)result{
    NSArray* arguments = (NSArray *)call.arguments;
    NSString* url = (NSString*)arguments.firstObject;
    HinaABTestConfigOptions *abtestConfigOptions = [[HinaABTestConfigOptions alloc] initWithURL:url];
    [HinaABTest startWithConfigOptions:abtestConfigOptions];
    result(nil);
}

-(void)getPlatformVersion:(FlutterMethodCall*)call result:(FlutterResult)flutterResult {
    
//    NSDictionary* dic = @{
//        @"platform" : @"iOS",
//    };
//    id  finalresult = [self convertToJsonData:dic];
    
    flutterResult(@"platform is iOS");
    
}


-(void)fetchCacheABTest:(FlutterMethodCall*)call result:(FlutterResult)result{
    NSArray* arguments = (NSArray *)call.arguments;
    if (arguments.count < 2) {
        result(nil);
        return;
    }
    id finalresult =  [[HinaABTest sharedInstance] fetchCacheABTestWithParamName:arguments[0] defaultValue:arguments[1]];
    
    if([finalresult isKindOfClass:[NSDictionary class]]){
        NSDictionary* dic = finalresult;
        finalresult = [self convertToJsonData:dic];
    }
    result(finalresult);
}

-(void)asyncFetchABTest:(FlutterMethodCall*)call result:(FlutterResult)flutterResult {
    NSArray* arguments = (NSArray *)call.arguments;
    if (arguments.count < 3) {
        flutterResult(nil);
        return;
    }
    NSString* paramName = arguments[0];
    double second = [arguments[2] doubleValue] / 1000;
    
    [[HinaABTest sharedInstance] asyncFetchABTestWithParamName:paramName defaultValue:arguments[1] timeoutInterval:second  completionHandler:^(id  _Nullable finalresult) {
        if([finalresult isKindOfClass:[NSDictionary class]]) {
            NSDictionary* dic = finalresult;
            finalresult = [self convertToJsonData:dic];
        }
        flutterResult(finalresult);
    }];
}

-(void)fastFetchABTest:(FlutterMethodCall*)call result:(FlutterResult)flutterResult {
    NSArray* arguments = (NSArray *)call.arguments;
    if (arguments.count < 3) {
        flutterResult(nil);
        return;
    }
    
    NSString* paramName = arguments[0];
    double second = [arguments[2] doubleValue] / 1000;
    
    [[HinaABTest sharedInstance] fastFetchABTestWithParamName:paramName defaultValue:arguments[1] timeoutInterval:second  completionHandler:^(id  _Nullable finalresult) {
        if([finalresult isKindOfClass:[NSDictionary class]]) {
            NSDictionary* dic = finalresult;
            finalresult = [self convertToJsonData:dic];
        }
        flutterResult(finalresult);
    }];
}

- (NSString *)convertToJsonData:(NSDictionary *)dict {
    if (![NSJSONSerialization isValidJSONObject:dict]) {
        NSLog(@"obj is not valid JSON: %@",dict);
        return nil;
    }
    
    NSError *error = nil;
    NSData *jsonData = nil;
    
    @try {
        jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    
    if (!jsonData) {
        NSLog(@"error: %@",error);
        return nil;
    }
    return [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
}

@end
