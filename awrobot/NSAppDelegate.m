#import "NSAppDelegate.h"
#import "Page/GuidePage.h"
#import "Page/HomePage.h"

@implementation NSAppDelegate

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	_window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *str = [defaults objectForKey:@"account"];
    if([str isEqualToString:@""] || str == nil){
        [self showGuidePage];
    }else{
        [self showHomePage];
    }

}

-(void)showGuidePage{
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[GuidePage alloc] init]];
    _window.rootViewController = nav;
    [_window makeKeyAndVisible];
}

-(void)showHomePage{
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[HomePage alloc] init]];
//    nav.navigationBar.barTintColor = RGB(15, 15, 15);
//    nav.navigationBar.tintColor = [UIColor whiteColor];
//    [nav.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    _window.rootViewController = [[HomePage alloc] init];
    [_window makeKeyAndVisible];
}

+(NSAppDelegate *)appDeg{
    return (NSAppDelegate *)[UIApplication sharedApplication].delegate;
}

//进入后台的时候调用
- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSLog(@"进入后台");
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *str1 = [defaults objectForKey:@"state"];
    NSString *str2 = [defaults objectForKey:@"account"];
    NSArray *arrayAccount = [str2 componentsSeparatedByString:@"|"];
    if(![str1 isEqualToString:@""]){
        NSString *key = [NSString stringWithFormat:@"NSStatusCode=%@&NSUserName=%@",str1,[arrayAccount objectAtIndex:0]];
        [NSNetPost POST:OutLoginURL key:key];
        key = [NSString stringWithFormat:@"NSUserName=%@&NSUserPwd=%@",[arrayAccount objectAtIndex:0],[arrayAccount objectAtIndex:1]];
        [NSNetPost POST:ClearDataURL key:key];
    }
}

//从后台进入的时候调用
- (void)applicationWillEnterForeground:(UIApplication *)application {
    NSLog(@"回到app");
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    //向插件发送账号信息
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *str = [defaults objectForKey:@"account"];
    NSArray *array = [str componentsSeparatedByString:@"|"];
    if(array.count>0 && [[array objectAtIndex:2] isEqualToString:@""]){
        NSLog(@"自动登录");
        NSString *key = [NSString stringWithFormat:@"NSUserName=%@&NSUserPwd=%@&NSVersion=1.0&NSMac=",[array objectAtIndex:0],[array objectAtIndex:1]];
        dispatch_async(dispatch_queue_create(NULL, NULL), ^{
            BOOL errorTrue = false;
            while (1) {
                NSString *state = [NSNetPost POST:LoginURL key:key];
                if([state length]>5){
                    [NSNetPost saveAccount:[array objectAtIndex:0] password:[array objectAtIndex:1] state:state];
                    break;
                }else if([state isEqualToString:@"-15"]){
                    
                }else if(!errorTrue){
                    errorTrue= true;
                    NSString *error = [NSNetPost errorCode:state];
                    NSLog(@"错误代码：%@",error);
                    [[[GuidePage alloc] init] messageBox:error];
                    break;
                }
                sleep(5);
            };
            //            NSLog(@"======%@",_stateID);
        });
    }
}

- (void)dealloc {
	[_window release];
	[super dealloc];
}

@end
