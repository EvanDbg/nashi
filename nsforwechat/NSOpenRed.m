//
//  NSOpenRed.m
//  RHWeChatDylib
//
//  Created by 刘卓林 on 2018/3/21.
//  Copyright © 2018年 刘卓林大天才. All rights reserved.
//

#import "NSOpenRed.h"


@implementation NSOpenRed

+(void)openStringDispose:(NSString *)m_nsFromUsr m_nsContent:(NSString *)m_nsContent{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSObject *obj = [[NSUserDefaults standardUserDefaults] objectForKey:@"redopen"];
    NSString *str = [NSString stringWithFormat:@"%@",obj];
    if(![str isEqualToString:@"YES"]){
        [pool drain];
        return;
    }
//    NSLog(@"1=%@    2=%@",m_nsFromUsr,m_nsContent);
    id MMServiceCenter = [NSClassFromString(@"MMServiceCenter") performSelector:@selector(defaultCenter)];
    id logicMgr = [MMServiceCenter performSelector:@selector(getService:) withObject:NSClassFromString(@"WCRedEnvelopesLogicMgr")];
    id CContactMgr = [MMServiceCenter performSelector:@selector(getService:) withObject:NSClassFromString(@"CContactMgr")];
    id selfContact = [CContactMgr performSelector:@selector(getSelfContact)];
    id m_nsUsrName = [selfContact performSelector:@selector(m_nsUsrName)];
    NSLog(@"m_nsUsrName========%@",m_nsUsrName);
    if ([m_nsFromUsr isEqualToString:m_nsUsrName]) {
        [pool drain];
        return;
    }
    if ([m_nsContent rangeOfString:@"wxpay://"].location != NSNotFound) {
        NSString *nativeUrl = m_nsContent;
        NSRange rangeStart = [m_nsContent rangeOfString:@"wxpay://c2cbizmessagehandler/hongbao"];
        if (rangeStart.location != NSNotFound) {
            NSUInteger locationStart = rangeStart.location;
            nativeUrl = [nativeUrl substringFromIndex:locationStart];
        }
        
        NSRange rangeEnd = [nativeUrl rangeOfString:@"]]"];
        if (rangeEnd.location != NSNotFound) {
            NSUInteger locationEnd = rangeEnd.location;
            nativeUrl = [nativeUrl substringToIndex:locationEnd];
        }
        NSString *naUrl = [nativeUrl substringFromIndex:[@"wxpay://c2cbizmessagehandler/hongbao/receivehongbao?" length]];
        NSArray *parameterPairs =[naUrl componentsSeparatedByString:@"&"];
        NSLog(@"parameterPairs===%@",parameterPairs);
        NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:[parameterPairs count]];
        for (NSString *currentPair in parameterPairs) {
            NSRange range = [currentPair rangeOfString:@"="];
            if(range.location == NSNotFound)
                continue;
            NSString *key = [currentPair substringToIndex:range.location];
            NSString *value =[currentPair substringFromIndex:range.location + 1];
            [parameters setObject:value forKey:key];
        }
        NSLog(@"parameters===%@",parameters);
        //红包参数
        NSMutableDictionary *params = [@{} mutableCopy];
        
        [params setObject:parameters[@"msgtype"] forKey:@"msgType"];
        [params setObject:parameters[@"sendid"] forKey:@"sendId"];
        [params setObject:parameters[@"channelid"] forKey:@"channelId"];
        
        id getContactDisplayName = [selfContact performSelector:@selector(getContactDisplayName)];
        id m_nsHeadImgUrl = [selfContact performSelector:@selector(m_nsHeadImgUrl)];
        
        [params setObject:getContactDisplayName forKey:@"nickName"];
        [params setObject:m_nsHeadImgUrl forKey:@"headImg"];
        [params setObject:[NSString stringWithFormat:@"%@", nativeUrl] forKey:@"nativeUrl"];
        [params setObject:m_nsFromUsr forKey:@"sessionUserName"];
        NSLog(@"params=%@", params);
        [[NSUserDefaults standardUserDefaults] setObject:params forKey:@"params"];
        
        NSMutableDictionary* dictParam = [NSMutableDictionary dictionary];
        [dictParam setObject:@"0" forKey:@"agreeDuty"];                                             //agreeDuty
        [dictParam setObject:parameters[@"channelid"] forKey:@"channelId"];        //channelId
        [dictParam setObject:@"1" forKey:@"inWay"];                                                 //inWay
        [dictParam setObject:parameters[@"msgtype"] forKey:@"msgType"];            //msgType
        [dictParam setObject:nativeUrl forKey:@"nativeUrl"];                                     //nativeUrl
        [dictParam setObject:parameters[@"sendid"] forKey:@"sendId"];              //sendId
        NSLog(@"dictParam=%@", dictParam);
        [logicMgr performSelector:@selector(ReceiverQueryRedEnvelopesRequest:) withObject:dictParam];
//        ((void (*)(id, SEL, NSMutableDictionary*))objc_msgSend)(logicMgr, @selector(ReceiverQueryRedEnvelopesRequest:), dictParam);
    }
    [pool drain];
}

+(void)openRedEnvelopes:(NSData *)data{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSError* error = nil;
    id jsonObj = [NSJSONSerialization JSONObjectWithData:data
                                                 options:NSJSONReadingAllowFragments
                                                   error:&error];
    if (nil != error) {
        NSLog(@"error %@", [error localizedDescription]);
    }
    else if (nil != jsonObj){
        if ([NSJSONSerialization isValidJSONObject:jsonObj]) {
            if ([jsonObj isKindOfClass:[NSDictionary class]]) {
                id idTemp = jsonObj[@"timingIdentifier"];
                if(idTemp){
                    NSMutableDictionary *params = [[[NSUserDefaults standardUserDefaults] objectForKey:@"params"] mutableCopy];
                    [[NSUserDefaults standardUserDefaults] setObject:[NSMutableDictionary dictionary] forKey:@"params"];
                     [params setObject:idTemp forKey:@"timingIdentifier"]; // "timingIdentifier"字段
                    // 防止重复请求
                    if (params.allKeys.count < 2) {
                        return;
                    }
                    id MMServiceCenter = [NSClassFromString(@"MMServiceCenter") performSelector:@selector(defaultCenter)];
                    id logicMgr = [MMServiceCenter performSelector:@selector(getService:) withObject:NSClassFromString(@"WCRedEnvelopesLogicMgr")];
//                    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC);
//                    dispatch_after(delayTime, dispatch_get_main_queue(), ^(void) {
                        [logicMgr performSelector:@selector(OpenRedEnvelopesRequest:) withObject:params];
//                    });
                }
            }
        }
    }
    [pool drain];
}


@end
