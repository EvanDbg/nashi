//
//  RegisterPage.m
//  test2
//
//  Created by 刘卓林 on 2018/1/25.
//  Copyright © 2018年 刘卓林. All rights reserved.
//

#import "RegisterPage.h"
#import "HomePage.h"

@implementation RegisterPage

- (void)viewDidLoad {
    [super viewDidLoad];
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    self.title = @"账号注册";
//    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
//    [self setNavigationColor:[UIColor colorWithRed:62/255.0 green:173/255.0 blue:176/255.0 alpha:1.0]];
//    NSString *back = [NSString stringWithFormat:@"%@/BackButton.png",appPath];
//    [self setNavigationItem:@"返回" selector:@selector(backPage) isRight:NO];
    
//    self.view = [[[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds] autorelease];
    self.view.backgroundColor = RGB(246, 246, 246);
//    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    self.view.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    [self.view addGestureRecognizer:singleTap];
    
    _AccountField = [[UITextField alloc] init];
    _AccountField.frame = CGRectMake(WIDTH*0.1, HEIGHT*0.15, WIDTH*0.8, WIDTH*0.1);
    _AccountField.placeholder = @"请输入注册账号";
    _AccountField.keyboardType = UIKeyboardTypeASCIICapable;
    [_AccountField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [_AccountField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    
    [self.view addSubview:_AccountField];
    
    UIView *line1 = [[UIView alloc] init];
    line1.backgroundColor = RGB(208, 215, 221);
    line1.frame = CGRectMake(WIDTH*0.1, HEIGHT*0.2, WIDTH*0.8, 1);
    
    [self.view addSubview:line1];
    
    _PasswordField = [[UITextField alloc] init];
    _PasswordField.frame = CGRectMake(WIDTH*0.1, HEIGHT*0.25, WIDTH*0.8, WIDTH*0.1);
    _PasswordField.placeholder = @"请输入密码";
    _PasswordField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _PasswordField.keyboardType = UIKeyboardTypeASCIICapable;
    _PasswordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _PasswordField.secureTextEntry = YES;
//    _PasswordField.clearsOnBeginEditing = YES;
    
    [self.view addSubview:_PasswordField];
    
    UIView *line2 = [[UIView alloc] init];
    line2.backgroundColor = RGB(208, 215, 221);
    line2.frame = CGRectMake(WIDTH*0.1, HEIGHT*0.3, WIDTH*0.8, 1);
    
    [self.view addSubview:line2];
    
    _isPasswordField = [[UITextField alloc] init];
    _isPasswordField.frame = CGRectMake(WIDTH*0.1, HEIGHT*0.35, WIDTH*0.8, WIDTH*0.1);
    _isPasswordField.placeholder = @"请确认密码";
    _isPasswordField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _isPasswordField.keyboardType = UIKeyboardTypeASCIICapable;
    _isPasswordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _isPasswordField.secureTextEntry = YES;
//    _isPasswordField.clearsOnBeginEditing = YES;
    
    [self.view addSubview:_isPasswordField];
    
    UIView *line3 = [[UIView alloc] init];
    line3.backgroundColor = RGB(208, 215, 221);
    line3.frame = CGRectMake(WIDTH*0.1, HEIGHT*0.4, WIDTH*0.8, 1);
    
    [self.view addSubview:line3];
    
    _EmailField = [[UITextField alloc] init];
    _EmailField.frame = CGRectMake(WIDTH*0.1, HEIGHT*0.45, WIDTH*0.8, WIDTH*0.1);
    _EmailField.placeholder = @"请输入邮箱,用于找回密码";
    _EmailField.keyboardType = UIKeyboardTypeASCIICapable;
    [_EmailField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [_EmailField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    
    [self.view addSubview:_EmailField];
    
    UIView *line4 = [[UIView alloc] init];
    line4.backgroundColor = RGB(208, 215, 221);
    line4.frame = CGRectMake(WIDTH*0.1, HEIGHT*0.5, WIDTH*0.8, 1);
    
    [self.view addSubview:line4];
    
    _RegisterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _RegisterButton.frame = CGRectMake(0, 0, WIDTH*0.8, WIDTH*0.1);
    _RegisterButton.center = CGPointMake(WIDTH*0.5, HEIGHT*0.6);
    _RegisterButton.backgroundColor = RGB(250, 157, 59);
    _RegisterButton.alpha = 0.6;
//    _RegisterButton.tag = 100;
    //    [LoginButton.layer setCornerRadius:12];
    //    LoginButton.layer.masksToBounds = YES;
    [_RegisterButton setTitle:@"注册" forState:UIControlStateNormal];
    [_RegisterButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_RegisterButton];
    [pool drain];
}

- (void)buttonClick:(UIButton *)but
{
    if([_AccountField.text isEqualToString:@""]){
        [self messageBox:@"请输入账号"];
        return;
    }
    if(![_PasswordField.text isEqualToString:_isPasswordField.text]){
        [self messageBox:@"两次密码输入不正确"];
        return;
    }
    if([_PasswordField.text isEqualToString:@""] || [_isPasswordField.text isEqualToString:@""]){
        [self messageBox:@"请输入密码"];
        return;
    }
    if([_EmailField.text isEqualToString:@""]){
        [self messageBox:@"请输入邮箱"];
        return;
    }
    [_RegisterButton setTitle:@"注册中..." forState:UIControlStateNormal];
    NSString *key = [NSString stringWithFormat:@"NSUserName=%@&NSUserPwd=%@&NSEmail=%@&NSMac=",_AccountField.text,_PasswordField.text,_EmailField.text];
    NSString *repost = [NSNetPost POST:RegisterURL key:key];

    if([repost isEqualToString:@"1"]){
        [self removeFromParentViewController];
        [NSNetPost saveAccount:_AccountField.text password:_PasswordField.text state:@""];
//        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[HomePage alloc] init]];
//        nav.navigationBar.barTintColor = RGB(15, 15, 15);
//        nav.navigationBar.tintColor = [UIColor whiteColor];
//        [nav.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
        [self presentViewController:[[HomePage alloc] init] animated:true completion:nil];
    }else{
        NSString *error = [NSNetPost errorCode:repost];
        [self messageBox:error];
        [_RegisterButton setTitle:@"注册" forState:UIControlStateNormal];
        return;
    }
}


-(void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer
{
    [self.view endEditing:YES];
}

//-(void)backPage{
//    //    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
//    [self dismissViewControllerAnimated:YES completion:nil];
//}
//隐藏导航栏
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}

- (void)dealloc {
    [_RegisterButton release];
    [_EmailField release];
    [_isPasswordField release];
    [_PasswordField release];
    [_AccountField release];
    [super dealloc];
}

@end
