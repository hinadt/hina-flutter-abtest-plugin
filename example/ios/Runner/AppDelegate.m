#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"
#import <HinaCloudSDK/HinaCloudSDK.h>
#import <HinaABTest/HinaABTest.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [GeneratedPluginRegistrant registerWithRegistry:self];
    // Override point for customization after application launch.
    
    // 测试环境，获取试验地址
    //    NSString* kSABResultsTestURL = @"https://test-hicloud.hinadt.com/gateway/hina-cloud-service/abm/divide/query?project-key=yt888";
    
    // 测试环境，数据接收地址
    NSString* kSABTestServerURL = @"https://test-hicloud.hinadt.com/gateway/hina-cloud-engine/ha?project=yituiAll&token=yt888";
    
    
    
    HNBuildOptions *options = [[HNBuildOptions alloc] initWithServerURL:kSABTestServerURL launchOptions:launchOptions];
    options.autoTrackEventType = HNAutoTrackAppEnd | HNAutoTrackAppClick | HNAutoTrackAppScreen;
    
    
    options.enableJSBridge = YES;
    options.enableLog = YES;
    [HinaCloudSDK startWithConfigOptions:options];
    
    
    
    //    HinaABTestConfigOptions *abtestConfigOptions = [[HinaABTestConfigOptions alloc] initWithURL:kSABResultsTestURL];
    //    [HinaABTest startWithConfigOptions:abtestConfigOptions];
    //
    //    [HinaABTest.sharedInstance setCustomIDs:@{@"custom_subject_id":@"iOS自定义主体333"}];
    
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
