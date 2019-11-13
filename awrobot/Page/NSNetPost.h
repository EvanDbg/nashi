//
//  NSNetPost.h
//  test2
//
//  Created by 刘卓林 on 2018/1/31.
//  Copyright © 2018年 刘卓林. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Defines.h"

@interface NSNetPost : NSObject

+(NSString *)POST:(NSString *)urlStr key:(NSString*)key;
+(NSString *)errorCode:(NSString *)str;
+(void)saveAccount:(NSString *)account password:(NSString *)password state:(NSString *)state;
//+(void)setEndTime:(NSString *)str;

@end
