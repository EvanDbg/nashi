//
//  registerCardPage.m
//  test2
//
//  Created by 刘卓林 on 2018/2/2.
//  Copyright © 2018年 刘卓林. All rights reserved.
//

#import "registerCardPage.h"

@implementation registerCardPage

- (void)viewDidLoad {
    [super viewDidLoad];
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    self.title = @"卡号充值";
    self.view.backgroundColor = RGB(246, 246, 246);
    
    self.view.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    [self.view addGestureRecognizer:singleTap];
    
    
    _RegisterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _RegisterButton.frame = CGRectMake(0, 0, WIDTH*0.8, WIDTH*0.1);
    _RegisterButton.center = self.view.center;
    _RegisterButton.backgroundColor = RGB(243, 50, 50);
    _RegisterButton.alpha = 0.6;
//    _RegisterButton.tag = 100;
    [_RegisterButton setTitle:@"充值" forState:UIControlStateNormal];
    [_RegisterButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_RegisterButton];
    
    _AccountField = [[UITextField alloc] init];
    _AccountField.frame = CGRectMake(WIDTH*0.1, HEIGHT*0.25, WIDTH*0.8, WIDTH*0.1);
    _AccountField.placeholder = @"请输入账号";
    _AccountField.keyboardType = UIKeyboardTypeASCIICapable;
    [_AccountField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [_AccountField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
//    _AccountField.clearButtonMode = UITextFieldViewModeWhileEditing;
//    _AccountField.clearsOnBeginEditing = YES;
    
    [self.view addSubview:_AccountField];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *str = [defaults objectForKey:@"account"];
    NSArray *array = [str componentsSeparatedByString:@"|"];
    if(array.count>0){
        _AccountField.text = [array objectAtIndex:0];
    }
    UIView *line1 = [[UIView alloc] init];
    line1.backgroundColor = RGB(208, 215, 221);
    line1.frame = CGRectMake(WIDTH*0.1, HEIGHT*0.3, WIDTH*0.8, 1);
    
    [self.view addSubview:line1];
    
    _CardField = [[UITextField alloc] init];
    _CardField.frame = CGRectMake(WIDTH*0.1, HEIGHT*0.35, WIDTH*0.8, WIDTH*0.1);
    _CardField.placeholder = @"请输入卡号";
    _CardField.keyboardType = UIKeyboardTypeASCIICapable;
    [_CardField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [_CardField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    _CardField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _CardField.clearsOnBeginEditing = YES;
    [self.view addSubview:_CardField];
    
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
    if([_CardField.text isEqualToString:@""]){
        [self messageBox:@"请输入卡号"];
        return;
    }
    [_RegisterButton setTitle:@"充值中..." forState:UIControlStateNormal];
    NSString *key = [NSString stringWithFormat:@"NSUserName=%@&NSCardPwd=%@&NSReferral=",_AccountField.text,_CardField.text];
    NSString *repost = [NSNetPost POST:TopupURL key:key];
    
    if([repost isEqualToString:@"1"] || [repost isEqualToString:@"101"]){
//        [self dismissViewControllerAnimated:YES completion:nil];
        [self.navigationController popToRootViewControllerAnimated:NO];
        [self messageBox:@"充值成功"];
//        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
    }else{
        repost = [NSNetPost errorCode:repost];
        [self messageBox:repost];
        [_RegisterButton setTitle:@"充值" forState:UIControlStateNormal];
        return;
    }
    
    
}

-(void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer
{
    [self.view endEditing:YES];
}

- (void)dealloc {
    [_RegisterButton release];
    [_AccountField release];
    [_CardField release];
    [super dealloc];
}

@end
