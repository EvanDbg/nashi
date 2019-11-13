//
//  NSBasePage.h
//  test2
//
//  Created by 刘卓林 on 2018/1/22.
//  Copyright © 2018年 刘卓林. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Defines.h"
#import "NSNetPost.h"

@interface NSBasePage : UIViewController

-(void)setNavigationItem:(NSString *)title selector:(SEL)selector isRight:(BOOL)isRight;
- (void)setNavigationColor:(UIColor *)color;
-(void)messageBox:(NSString *)str;
- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize;
- (void)openGame:(NSString *)bundleID;

@end
