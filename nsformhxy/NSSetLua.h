//
//  NSSetLuaEnvironment.h
//  test
//
//  Created by 刘卓林 on 2017/11/19.
//  Copyright © 2017年 刘卓林. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSSetLua : NSObject

-(void)runLuaScript;
-(void)thread_pause:(bool)pause;
-(void)thread_exit:(bool)mexit;

@end
