//
//  LoginPage.m
//  test2
//
//  Created by 刘卓林 on 2018/1/22.
//  Copyright © 2018年 刘卓林. All rights reserved.
//

#import "LoginPage.h"
#import "HomePage.h"
#import "topUpPage.h"
#import "ResetPasswordPage.h"

@implementation LoginPage

- (void)viewDidLoad {
    [super viewDidLoad];
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    self.title = @"登陆";
//    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
//    [self setNavigationItem:@"返回" selector:@selector(backPage) isRight:NO];
//    [self setNavigationColor:[UIColor colorWithRed:62/255.0 green:173/255.0 blue:176/255.0 alpha:1.0]];
//    [[UIApplication sharedApplication] setStatusBarHidden:YES];
//    self.view = [[[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds] autorelease];
    self.view.backgroundColor = RGB(246, 246, 246);
//    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    self.view.userInteractionEnabled = YES;

    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    [self.view addGestureRecognizer:singleTap];
    
//    NSString *appPath = [NSString stringWithFormat:@"%@/robot.png",[[NSBundle mainBundle] bundlePath]];
//    UIImageView *imageView = [[UIImageView alloc] init];
//    imageView.frame = CGRectMake(WIDTH*0.09, HEIGHT*0.09,WIDTH*0.15,WIDTH*0.15);
//    imageView.image = [UIImage imageNamed:appPath];
//    [self.view addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"nà shì";
    label.textColor = RGB(55, 55, 55);
    label.font = [UIFont boldSystemFontOfSize:WIDTH*0.1];//采用系统默认文字设置大小
//    label.shadowColor = [UIColor blackColor];
//    label.shadowOffset = CGSizeMake(1.0,1.0);
    label.frame = CGRectMake(WIDTH*0.1, HEIGHT*0.1,WIDTH*0.5,WIDTH*0.2);
    [self.view addSubview:label];
    
    _AccountField = [[UITextField alloc] init];
    _AccountField.frame = CGRectMake(WIDTH*0.1, HEIGHT*0.25, WIDTH*0.8, WIDTH*0.1);
    _AccountField.placeholder = @"请输入登陆账号";
//    _AccountField.autocapitalizationType = UITextAutocapitalizationTypeNone;
//    _AccountField.userInteractionEnabled = YES;
    _AccountField.keyboardType = UIKeyboardTypeASCIICapable;
    [_AccountField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [_AccountField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    
    [self.view addSubview:_AccountField];
    
    UIView *line1 = [[UIView alloc] init];
    line1.backgroundColor = RGB(208, 215, 221);
    line1.frame = CGRectMake(WIDTH*0.1, HEIGHT*0.3, WIDTH*0.8, 1);
    
    [self.view addSubview:line1];
    
    _PasswordField = [[UITextField alloc] init];
    _PasswordField.frame = CGRectMake(WIDTH*0.1, HEIGHT*0.35, WIDTH*0.8, WIDTH*0.1);
    _PasswordField.placeholder = @"请输入密码";
    _PasswordField.autocapitalizationType = UITextAutocapitalizationTypeNone;
//    _PasswordField.userInteractionEnabled = NO;
    _PasswordField.keyboardType = UIKeyboardTypeASCIICapable;
    _PasswordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _PasswordField.secureTextEntry = YES;
//    _PasswordField.clearsOnBeginEditing = YES;
    
    [self.view addSubview:_PasswordField];
    
    UIView *line2 = [[UIView alloc] init];
    line2.backgroundColor = RGB(208, 215, 221);
    line2.frame = CGRectMake(WIDTH*0.1, HEIGHT*0.4, WIDTH*0.8, 1);
    
    [self.view addSubview:line2];
    
    _LoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _LoginButton.frame = CGRectMake(0, 0, WIDTH*0.8, WIDTH*0.1);
    _LoginButton.center = self.view.center;
    _LoginButton.backgroundColor = RGB(35, 169, 220);
    _LoginButton.alpha = 0.6;
    _LoginButton.tag = 100;
//    [LoginButton.layer setCornerRadius:12];
//    LoginButton.layer.masksToBounds = YES;
    [_LoginButton setTitle:@"登陆" forState:UIControlStateNormal];
    [_LoginButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_LoginButton];
    
    _ChangeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _ChangeButton.frame = CGRectMake(WIDTH*0.09, HEIGHT*0.54, WIDTH*0.2, WIDTH*0.1);
    _ChangeButton.alpha = 0.6;
    _ChangeButton.tag = 101;
    [_ChangeButton setTitle:@"忘记密码?" forState:UIControlStateNormal];
    _ChangeButton.titleLabel.font = [UIFont boldSystemFontOfSize:WIDTH*0.04];
    [_ChangeButton setTitleColor:RGB(35, 169, 220) forState:UIControlStateNormal];
    [_ChangeButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_ChangeButton];
    
    _NewUserButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _NewUserButton.frame = CGRectMake(WIDTH*0.7, HEIGHT*0.54, WIDTH*0.2, WIDTH*0.1);
    _NewUserButton.alpha = 0.6;
    _NewUserButton.tag = 102;
    [_NewUserButton setTitle:@"需要充值?" forState:UIControlStateNormal];
    _NewUserButton.titleLabel.font = [UIFont boldSystemFontOfSize:WIDTH*0.04];
    [_NewUserButton setTitleColor:RGB(35, 169, 220) forState:UIControlStateNormal];
    [_NewUserButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_NewUserButton];
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.text = @"©那是团队版权所有";
    label2.textColor = RGB(200, 200, 200);
    label2.font = [UIFont boldSystemFontOfSize:WIDTH*0.04];//采用系统默认文字设置大小
    label2.frame = CGRectMake(0, 0,WIDTH*0.4,WIDTH*0.1);
    label2.center = CGPointMake(WIDTH*0.5, HEIGHT*0.95);
    label2.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label2];
    
    //已经有账号
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *str = [defaults objectForKey:@"account"];
    NSArray *array = [str componentsSeparatedByString:@"|"];
    if(array.count>0){
        _AccountField.text = [array objectAtIndex:0];
        _PasswordField.text = [array objectAtIndex:1];
    }
    [pool drain];
}
- (void)buttonClick:(UIButton *)but
{
//    UINavigationController *nav = [[UINavigationController alloc] init];
    switch (but.tag) {
        case 100:
            if([_AccountField.text isEqualToString:@""]){
                [self messageBox:@"请输入账号"];
                return;
            }
            if([_PasswordField.text isEqualToString:@""]){
                [self messageBox:@"请输入密码"];
                return;
            }
            [_LoginButton setTitle:@"登陆中..." forState:UIControlStateNormal];
            NSString *key = [NSString stringWithFormat:@"NSUserName=%@&NSUserPwd=%@&NSVersion=1.0&NSMac=",_AccountField.text,_PasswordField.text];
            NSString *repost = [NSNetPost POST:LoginURL key:key];

            if([repost length]>5 || [repost isEqualToString:@"-110"]){
                [self removeFromParentViewController];
                [NSNetPost saveAccount:_AccountField.text password:_PasswordField.text state:repost];
//                [nav initWithRootViewController:[[HomePage alloc] init]];
//                nav.navigationBar.barTintColor = RGB(15, 15, 15);
//                nav.navigationBar.tintColor = [UIColor whiteColor];
//                [nav.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
                [self presentViewController:[[HomePage alloc] init] animated:NO completion:nil];
            }else{
                NSString *error = [NSNetPost errorCode:repost];
                [self messageBox:error];
                [_LoginButton setTitle:@"登陆" forState:UIControlStateNormal];
                return;
            }
            break;
        case 101:
//            [nav initWithRootViewController:[[RepasswordPage alloc] init]];
//            [self presentViewController:nav animated:YES completion:nil];
            [self.navigationController pushViewController:[[ResetPasswordPage alloc] init] animated:YES];
            break;
        case 102:
//            [nav initWithRootViewController:[[RegisterPage alloc] init]];
//            [self presentViewController:nav animated:YES completion:nil];
            [self.navigationController pushViewController:[[topUpPage alloc] init] animated:YES];
            break;
        default:
            break;
    }
}

//-(void)backPage{
//    //    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

//隐藏导航栏
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}

-(void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer
{
    [self.view endEditing:YES];
}

- (void)dealloc {
    [_LoginButton release];
    [_NewUserButton release];
    [_ChangeButton release];
    [_PasswordField release];
    [_AccountField release];
    [super dealloc];
}

@end
