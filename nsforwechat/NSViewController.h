//
//  NSViewController.h
//  RHWeChatDylib
//
//  Created by 刘卓林 on 2018/3/22.
//  Copyright © 2018年 刘卓林大天才. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface NSViewController : UIWindow

@property(nonatomic,strong)UIButton *icon;

-(void)createWindow;
-(bool)getAllApp;

@end
