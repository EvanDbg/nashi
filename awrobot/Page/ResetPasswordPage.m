//
//  RepasswordPage.m
//  test2
//
//  Created by 刘卓林 on 2018/1/28.
//  Copyright © 2018年 刘卓林. All rights reserved.
//

#import "ResetPasswordPage.h"

@interface ResetPasswordPage ()

@end

@implementation ResetPasswordPage

- (void)viewDidLoad {
    [super viewDidLoad];
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    self.title = @"找回密码";
    [self setNavigationColor:[UIColor colorWithRed:62/255.0 green:173/255.0 blue:176/255.0 alpha:1.0]];
//    NSString *back = [NSString stringWithFormat:@"%@/BackButton.png",appPath];
//    [self setNavigationItem:back selector:@selector(backPage) isRight:NO];
    
//    self.view = [[[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds] autorelease];
    self.view.backgroundColor = RGB(246, 246, 246);
//    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    self.view.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    [self.view addGestureRecognizer:singleTap];
    
    
    _ResetPasswordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _ResetPasswordButton.frame = CGRectMake(0, 0, WIDTH*0.8, WIDTH*0.1);
    _ResetPasswordButton.center = self.view.center;
    _ResetPasswordButton.backgroundColor = RGB(243, 50, 50);
    _ResetPasswordButton.alpha = 0.6;
//    _ResetPasswordButton.tag = 100;
    [_ResetPasswordButton setTitle:@"找回密码" forState:UIControlStateNormal];
    [_ResetPasswordButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_ResetPasswordButton];
    
    _AccountField = [[UITextField alloc] init];
    _AccountField.frame = CGRectMake(WIDTH*0.1, HEIGHT*0.25, WIDTH*0.8, WIDTH*0.1);
    _AccountField.placeholder = @"请输入账号";
    _AccountField.keyboardType = UIKeyboardTypeASCIICapable;
    [_AccountField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [_AccountField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    
    [self.view addSubview:_AccountField];
    
    UIView *line1 = [[UIView alloc] init];
    line1.backgroundColor = RGB(208, 215, 221);
    line1.frame = CGRectMake(WIDTH*0.1, HEIGHT*0.3, WIDTH*0.8, 1);
    
    [self.view addSubview:line1];
    
    _EmailField = [[UITextField alloc] init];
    _EmailField.frame = CGRectMake(WIDTH*0.1, HEIGHT*0.35, WIDTH*0.8, WIDTH*0.1);
    _EmailField.placeholder = @"请输入邮箱";
    _EmailField.keyboardType = UIKeyboardTypeASCIICapable;
    [_EmailField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [_EmailField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    
    [self.view addSubview:_EmailField];
    
    UIView *line2 = [[UIView alloc] init];
    line2.backgroundColor = RGB(208, 215, 221);
    line2.frame = CGRectMake(WIDTH*0.1, HEIGHT*0.4, WIDTH*0.8, 1);
    
    [self.view addSubview:line2];
    [pool drain];
}

- (void)buttonClick:(UIButton *)but
{
    if([_AccountField.text isEqualToString:@""]){
        [self messageBox:@"请输入账号"];
        return;
    }
    if([_EmailField.text isEqualToString:@""]){
        [self messageBox:@"请输入邮箱"];
        return;
    }
    [_ResetPasswordButton setTitle:@"找回中..." forState:UIControlStateNormal];
    NSString *key = [NSString stringWithFormat:@"NSUserName=%@&NSEmail=%@",_AccountField.text,_EmailField.text];
    NSString *repost = [NSNetPost POST:RepasswordURL key:key];
    [_ResetPasswordButton setTitle:@"找回密码" forState:UIControlStateNormal];
    if([repost isEqualToString:@"1"]){
        [self dismissViewControllerAnimated:YES completion:nil];
        [self messageBox:@"找回成功"];
    }else{
        NSString *error = [NSNetPost errorCode:repost];
        [self messageBox:error];
        return;
    }
    
    
}

-(void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer
{
    [self.view endEditing:YES];
}

- (void)dealloc {
    [_ResetPasswordButton release];
    [_AccountField release];
    [_EmailField release];
    [super dealloc];
}
@end
