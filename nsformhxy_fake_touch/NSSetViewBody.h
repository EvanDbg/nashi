//
//  NSSettingViewBody.h
//  test
//
//  Created by 刘卓林 on 2017/11/6.
//  Copyright © 2017年 刘卓林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface NSSetViewBody : UIWindow

-(void)initVariable;
-(void)createController;
-(void)createIconButton;
-(void)createSettingView;
-(void)setController:(NSString *)str;
-(void)setMessageBox:(NSString *)title msg:(NSString *)msg;
-(void)newLuaThread;
-(NSMutableArray *)getMissionSort;
-(void)autoRunScript;

@end
