//
//  NSOpenRed.h
//  RHWeChatDylib
//
//  Created by 刘卓林 on 2018/3/21.
//  Copyright © 2018年 刘卓林大天才. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface NSOpenRed : NSObject

+(void)openStringDispose:(NSString *)m_nsFromUsr m_nsContent:(NSString *)m_nsContent;
+(void)openRedEnvelopes:(NSData *)data;

@end

