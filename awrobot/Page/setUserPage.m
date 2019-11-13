//
//  setUserPage.m
//  test2
//
//  Created by 刘卓林 on 2018/2/2.
//  Copyright © 2018年 刘卓林. All rights reserved.
//

#import "setUserPage.h"

@interface setUserPage ()

@end

@implementation setUserPage

- (void)viewDidLoad {
    [super viewDidLoad];
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    self.title = @"修改密码";
    self.view.backgroundColor = RGB(246, 246, 246);
    
    self.view.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    [self.view addGestureRecognizer:singleTap];
    
    
    _ChangeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _ChangeButton.frame = CGRectMake(0, 0, WIDTH*0.8, WIDTH*0.1);
    _ChangeButton.center = self.view.center;
    _ChangeButton.backgroundColor = RGB(243, 50, 50);
    _ChangeButton.alpha = 0.6;
//    _ChangeButton.tag = 100;
    [_ChangeButton setTitle:@"修改" forState:UIControlStateNormal];
    [_ChangeButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_ChangeButton];
    
    _PasswordField = [[UITextField alloc] init];
    _PasswordField.frame = CGRectMake(WIDTH*0.1, HEIGHT*0.15, WIDTH*0.8, WIDTH*0.1);
    _PasswordField.placeholder = @"请输入现在密码";
    _PasswordField.keyboardType = UIKeyboardTypeASCIICapable;
    [_PasswordField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [_PasswordField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    _PasswordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _PasswordField.clearsOnBeginEditing = YES;
    
    [self.view addSubview:_PasswordField];

    UIView *line1 = [[UIView alloc] init];
    line1.backgroundColor = RGB(208, 215, 221);
    line1.frame = CGRectMake(WIDTH*0.1, HEIGHT*0.2, WIDTH*0.8, 1);
    
    [self.view addSubview:line1];
    
    _isPasswordField = [[UITextField alloc] init];
    _isPasswordField.frame = CGRectMake(WIDTH*0.1, HEIGHT*0.25, WIDTH*0.8, WIDTH*0.1);
    _isPasswordField.placeholder = @"请输入修改密码";
    _isPasswordField.keyboardType = UIKeyboardTypeASCIICapable;
    [_isPasswordField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [_isPasswordField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    _isPasswordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _isPasswordField.clearsOnBeginEditing = YES;
    _isPasswordField.secureTextEntry = YES;
    [self.view addSubview:_isPasswordField];
    
    UIView *line2 = [[UIView alloc] init];
    line2.backgroundColor = RGB(208, 215, 221);
    line2.frame = CGRectMake(WIDTH*0.1, HEIGHT*0.3, WIDTH*0.8, 1);
    
    [self.view addSubview:line2];
    
    _onPasswordField = [[UITextField alloc] init];
    _onPasswordField.frame = CGRectMake(WIDTH*0.1, HEIGHT*0.35, WIDTH*0.8, WIDTH*0.1);
    _onPasswordField.placeholder = @"请确认修改密码";
    _onPasswordField.keyboardType = UIKeyboardTypeASCIICapable;
    [_onPasswordField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [_onPasswordField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    _onPasswordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _onPasswordField.clearsOnBeginEditing = YES;
    _onPasswordField.secureTextEntry = YES;
    [self.view addSubview:_onPasswordField];
    
    UIView *line3 = [[UIView alloc] init];
    line3.backgroundColor = RGB(208, 215, 221);
    line3.frame = CGRectMake(WIDTH*0.1, HEIGHT*0.4, WIDTH*0.8, 1);
    
    [self.view addSubview:line3];
    [pool drain];
}
- (void)buttonClick:(UIButton *)but
{
    if([_PasswordField.text isEqualToString:@""]){
        [self messageBox:@"请输入现在密码"];
        return;
    }
    if([_isPasswordField.text isEqualToString:@""] || [_onPasswordField.text isEqualToString:@""]){
        [self messageBox:@"请输入修改密码"];
        return;
    }
    if(![_isPasswordField.text isEqualToString:_onPasswordField.text]){
        [self messageBox:@"两次密码输入错误"];
        return;
    }
    if([_PasswordField.text isEqualToString:_isPasswordField.text]){
        [self messageBox:@"请不要修改一样的密码"];
        return;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *str = [defaults objectForKey:@"account"];
    NSArray *array = [str componentsSeparatedByString:@"|"];
    
    NSString *key = [NSString stringWithFormat:@"NSUserName=%@&NSUserPwd=%@&NSNewUserPwd=%@",[array objectAtIndex:0],_PasswordField.text,_isPasswordField.text];
    NSString *repost = [NSNetPost POST:ChangePasswordURL key:key];
    
    if([repost isEqualToString:@"1"]){
        [self.navigationController popToRootViewControllerAnimated:NO];
        NSString *str = [NSString stringWithFormat:@"%@|%@|%@",[array objectAtIndex:0],_isPasswordField.text,@""];
        [defaults setObject:str forKey:@"account"];
        [defaults synchronize];
        [self messageBox:@"修改成功"];
    }else{
        repost = [NSNetPost errorCode:repost];
        [self messageBox:repost];
        return;
    }
    
    
}

-(void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer
{
    [self.view endEditing:YES];
}

- (void)dealloc {
    [_ChangeButton release];
    [_PasswordField release];
    [_isPasswordField release];
    [_onPasswordField release];
    [super dealloc];
}
@end
