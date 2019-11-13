//
//  LoginPage.h
//  test2
//
//  Created by 刘卓林 on 2018/1/22.
//  Copyright © 2018年 刘卓林. All rights reserved.
//

#import "NSBasePage.h"

@interface LoginPage : NSBasePage

@property(nonatomic,strong)UIButton *LoginButton;
@property(nonatomic,strong)UITextField *AccountField;
@property(nonatomic,strong)UITextField *PasswordField;
@property(nonatomic,strong)UIButton *ChangeButton;
@property(nonatomic,strong)UIButton *NewUserButton;

@end
