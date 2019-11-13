//
//  NSViewController.m
//  RHWeChatDylib
//
//  Created by 刘卓林 on 2018/3/22.
//  Copyright © 2018年 刘卓林大天才. All rights reserved.
//

#import "NSViewController.h"

#define free @"那是助手提供所有功能，主要解释权由那是助手作者所有，如果用于非法用途，如赌博等，涉嫌到刑事责任与那是助手无关。开启则同意协议"
#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

@implementation NSViewController

-(void)createWindow{
    float zoom = 1;
    if(isPad)
        zoom = 0.5;
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    _icon = [UIButton buttonWithType:UIButtonTypeCustom];
    int width = window.bounds.size.width;
    if(width > window.bounds.size.height){
        width = window.bounds.size.height;
    }
    _icon.frame = CGRectMake(window.bounds.size.width*0.65,0,width*0.14*zoom,width*0.14*zoom);
//    [icon setBackgroundImage:[UIImage imageNamed:@"/nsfiles/wechat/ui/icon.png"] forState:UIControlStateNormal];
    _icon.backgroundColor = [UIColor redColor];
    [_icon setTitle:@"抢" forState:0];
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"redopen"] isEqualToString:@"YES"])
        [_icon setTitle:@"open" forState:0];
    [_icon setTitleColor:[UIColor whiteColor] forState:0];
    //设置透明
    _icon.alpha = 0.8;
    _icon.layer.cornerRadius = 10.0f;
    _icon.layer.masksToBounds = YES;
    [window addSubview:_icon];
    //按钮点击事件

    [_icon addTarget:self action:@selector(iconButClick) forControlEvents:UIControlEventTouchUpInside];
}

-(void)iconButClick{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"免责协议"
                                                    message:free
                                                    delegate:self
                                                    cancelButtonTitle:@"关闭"
                                                    otherButtonTitles:@"开启", nil];
        [alert show];
        [alert release];
}
//监听点击事件 代理方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *btnTitle = [alertView buttonTitleAtIndex:buttonIndex];
    if ([btnTitle isEqualToString:@"关闭"]) {
        NSLog(@"close");
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"redopen"];
        [_icon setTitle:@"C" forState:0];
    }else if ([btnTitle isEqualToString:@"开启"] ) {
        bool bundleYes = [self getAllApp];
        if(bundleYes)
        {
            [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"redopen"];
            [_icon setTitle:@"O" forState:0];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"没有安装app"
                                                            message:@"请添加源：http://apt.so/nashizhushou 下载那是助手app，后在使用"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
    }
}

-(bool)getAllApp
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    Class LSApplicationWorkspace_class = NSClassFromString(@"LSApplicationWorkspace");
    NSObject* workspace = [LSApplicationWorkspace_class performSelector:@selector(defaultWorkspace)];
    NSArray *allApplications = [workspace performSelector:@selector(allApplications)];//这样就能获取到手机中安装的所有App
//    NSLog(@"设备上安装的所有app:%@",allApplications);
    NSString *bundleID = @"";
    for (LSApplicationWorkspace_class in allApplications)
    {
        //这里可以查看一些信息
        bundleID = [LSApplicationWorkspace_class performSelector:@selector(applicationIdentifier)];
        if([bundleID isEqualToString:@"com.ns.awrobot"]){
            [pool drain];
            return true;
        }
    }
    [pool drain];
    return false;
}

@end
