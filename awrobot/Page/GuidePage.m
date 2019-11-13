//
//  GuidePage.m
//  test2
//
//  Created by 刘卓林 on 2018/2/2.
//  Copyright © 2018年 刘卓林. All rights reserved.
//

#import "GuidePage.h"
#import "LoginPage.h"
#import "RegisterPage.h"

@interface GuidePage ()

@end

@implementation GuidePage

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"返回";
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
//    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:62/255.0 green:173/255.0 blue:176/255.0 alpha:1.0];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.view.backgroundColor = RGB(246, 246, 246);
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"nà shì";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = RGB(55, 55, 55);
    label.font = [UIFont boldSystemFontOfSize:WIDTH*0.2];//采用系统默认文字设置大小
    //    label.shadowColor = [UIColor blackColor];
    //    label.shadowOffset = CGSizeMake(1.0,1.0);
    label.frame = CGRectMake(0, 0,WIDTH*0.7,WIDTH*0.2);
    label.center = CGPointMake(WIDTH*0.5, HEIGHT*0.3);
    [self.view addSubview:label];
    
    _LoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _LoginButton.frame = CGRectMake(0, 0, WIDTH*0.45, WIDTH*0.2);
    _LoginButton.center = CGPointMake(WIDTH*0.2, HEIGHT*0.9);
    _LoginButton.backgroundColor = RGB(35, 169, 220);
//    _LoginButton.alpha = 0.6;
    _LoginButton.tag = 100;
    [_LoginButton.layer setCornerRadius:12];
    _LoginButton.layer.masksToBounds = YES;
    [_LoginButton setTitle:@"登陆" forState:UIControlStateNormal];
    [_LoginButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_LoginButton];
    
    _TopupButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _TopupButton.frame = CGRectMake(0, 0, WIDTH*0.45, WIDTH*0.2);
    _TopupButton.center = CGPointMake(WIDTH*0.8, HEIGHT*0.9);
    _TopupButton.backgroundColor = RGB(237, 74, 86);
//    _TopupButton.alpha = 0.6;
    _TopupButton.tag = 101;
    [_TopupButton.layer setCornerRadius:12];
    _TopupButton.layer.masksToBounds = YES;
    [_TopupButton setTitle:@"注册" forState:UIControlStateNormal];
    [_TopupButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_TopupButton];
    [pool drain];
}

-(void)buttonClick:(UIButton *)but{
//    [[UIApplication sharedApplication] setStatusBarHidden:NO];
//    UINavigationController *nav = [[UINavigationController alloc] init];
    UIViewController *view = nil;
    switch (but.tag) {
        case 100:
            view = [[LoginPage alloc] init];
//            [nav initWithRootViewController:[[LoginPage alloc] init]];
//            [self presentViewController:nav animated:YES completion:nil];
            break;
        case 101:
            view = [[RegisterPage alloc] init];
//            [nav initWithRootViewController:[[RegisterPage alloc] init]];
//            [self presentViewController:nav animated:YES completion:nil];
            break;
            
        default:
            break;
    }
    [self.navigationController pushViewController:view animated:YES];
}

//隐藏导航栏
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = YES;
//    [self.tabBarController makeTabBarHidden:YES];
}

//-(BOOL)prefersStatusBarHidden
//{
//    return YES;// 返回YES表示隐藏，返回NO表示显示
//}

- (void)dealloc {
    [_LoginButton release];
    [_TopupButton release];
    [super dealloc];
}

@end
