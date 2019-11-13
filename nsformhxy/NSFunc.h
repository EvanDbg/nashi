//
//  NSFunction.h
//  test
//
//  Created by 刘卓林 on 2017/11/8.
//  Copyright © 2017年 刘卓林. All rights reserved.
//
#import "NSOpen.h"

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSFunc : NSObject

-(void)init:(int)rotate;
-(void)inputText:(NSString *)str;
-(void)touchDown:(int)index x:(int)x y:(int)y;
-(void)touchUp:(int)index x:(int)x y:(int)y;
-(void)touchMove:(int)index x:(int)x y:(int)y;
//-(void)mSleep:(int)s;
-(CGPoint)findMultiColor:(NSString *)str x1:(int)x1 y1:(int)y1 x2:(int)x2 y2:(int)y2 help_simi:(float)help_simi;
-(NSString *)findAllColor:(NSString *)str x1:(int)x1 y1:(int)y1 x2:(int)x2 y2:(int)y2 help_simi:(float)help_simi;
-(void)getpm;
-(NSString *)ocrText:(int)x1 y1:(int)y1 x2:(int)x2 y2:(int)y2 whitelist:(NSString *)whitelist min:(int)min max:(int)max;
-(void)startGetImage;

@end
