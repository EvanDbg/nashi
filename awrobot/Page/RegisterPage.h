//
//  RegisterPage.h
//  test2
//
//  Created by 刘卓林 on 2018/1/25.
//  Copyright © 2018年 刘卓林. All rights reserved.
//

#import "NSBasePage.h"

@interface RegisterPage : NSBasePage

@property(nonatomic,strong)UITextField *AccountField;
@property(nonatomic,strong)UITextField *PasswordField;
@property(nonatomic,strong)UITextField *isPasswordField;
@property(nonatomic,strong)UITextField *EmailField;
@property(nonatomic,strong)UIButton *RegisterButton;

@end
