//
//  NSNetPost.m
//  test2
//
//  Created by 刘卓林 on 2018/1/31.
//  Copyright © 2018年 刘卓林. All rights reserved.
//

#import "NSNetPost.h"
//#import "AFNetworking/AFNetworking.h"
#import <rocketbootstrap/rocketbootstrap.h>
#import <AppSupport/CPDistributedMessagingCenter.h>


@implementation NSNetPost

+(NSString *)POST:(NSString *)urlStr key:(NSString*)key{
    /*
    NSString *urlString = urlStr;
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"https" ofType:@"cer"];
    NSData * certData =[NSData dataWithContentsOfFile:cerPath];
    NSSet * certSet = [[NSSet alloc] initWithObjects:certData, nil];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    // 是否允许,NO-- 不允许无效的证书
    [securityPolicy setAllowInvalidCertificates:YES];
    // 设置证书
    [securityPolicy setPinnedCertificates:certSet];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = securityPolicy;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    // request
    [manager POST:urlString parameters:key progress:^(NSProgress * progress){
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray * array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"OK === %@",array);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"error ==%@",error.description);
    }];
    return @"";
     */
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0); //创建信号量
    // iOS 9以后
    // 1、 创建URL
    NSURL *url = [NSURL URLWithString:urlStr];
    // 2、  创建请求对象
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    // 3、
    NSData *bodyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:bodyData];
    [request setTimeoutInterval:60];
    // 4.1、  创建会话
    NSURLSession *session = [NSURLSession sharedSession];
//    NSURLSessionConfiguration *defaultConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
//    NSURLSession *session = [NSURLSession sessionWithConfiguration: defaultConfig delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    // 4.2、 创建数据请求任务
    __block NSString *newStr = @"";
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        //        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        //
        //        NSLog(@"%@", dict);
        newStr = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
//        NSLog(@"新请求结果%@",newStr);
//        NSLog(@"error ==%@",error.description);
        dispatch_semaphore_signal(semaphore);   //发送信号
    }];
    // 4.3、 启动任务
    [task resume];
    dispatch_semaphore_wait(semaphore,DISPATCH_TIME_FOREVER);  //等待
//    NSLog(@"xxxxx%@",newStr);
    return newStr;
    
    /*
    //第一步，创建URL
    NSURL *url = [NSURL URLWithString:urlStr];
    //第二步，创建请求
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
    NSString *str = key;//设置参数
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    //第三步，连接服务器
    
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSString *str1 = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];

    return str1;*/
}

+(void)saveAccount:(NSString *)account password:(NSString *)password state:(NSString *)state{
    //保存配置
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *str = [NSString stringWithFormat:@"%@|%@|%@",account,password,state];
    [defaults setObject:str forKey:@"account"];
    CPDistributedMessagingCenter *server = [NSClassFromString(@"CPDistributedMessagingCenter") centerNamed:serverName];
    rocketbootstrap_distributedmessagingcenter_apply(server);
    NSMutableDictionary *userInfo = [@{} mutableCopy];
    [userInfo setObject:account forKey:@"endtime"];
    [server sendMessageAndReceiveReplyName:@"NSENDTIME" userInfo:userInfo];
    //发送到插件
    if(![state isEqualToString:@""]){

        //本地页面使用的stateid
        [defaults setObject:state forKey:@"state"];
        //发送完成后把state清除
        str = [NSString stringWithFormat:@"%@|%@|",account,password];
        [defaults setObject:str forKey:@"account"];
    }
    [defaults synchronize];
}

//+(void)setEndTime:(NSString *)str{
//    CPDistributedMessagingCenter *server = [NSClassFromString(@"CPDistributedMessagingCenter") centerNamed:serverName];
//    rocketbootstrap_distributedmessagingcenter_apply(server);
//    NSMutableDictionary *userInfo = [@{} mutableCopy];
//    [userInfo setObject:str forKey:@"endtime"];
//    [server sendMessageAndReceiveReplyName:@"NSENDTIME" userInfo:userInfo];
//}

+(NSString *)errorCode:(NSString *)str{
    if([str isEqualToString:@""]){
        return @"请连接网络";
    }else if([str isEqualToString:@"0"]){
        return @"失败";
    }else if([str isEqualToString:@"-1"]){
        return @"网络链接失败";
    }else if([str isEqualToString:@"-2"]){
        return @"请填写程序密钥";
    }else if([str isEqualToString:@"-3"]){
        return @"数据异常";
    }else if([str isEqualToString:@"-4"]){
        return @"数据异常";
    }else if([str isEqualToString:@"-5"]){
        return @"错误的参数,请检查参数是否正确";
    }else if([str isEqualToString:@"-6"]){
        return @"还未登录";
    }else if([str isEqualToString:@"-7"]){
        return @"私人服务器,没有权限进行登录";
    }else if([str isEqualToString:@"-8"]){
        return @"账户余额不足";
    }else if([str isEqualToString:@"-9"]){
        return @"注册用户达到上限";
    }else if([str isEqualToString:@"-10"]){
        return @"VIP 插件,非 VIP 无法使用";
    }else if([str isEqualToString:@"-11"]){
        return @"开启自动状态检测失败,还未登陆!";
    }else if([str isEqualToString:@"-12"]){
        return @"开启自动状态检测失败!";
    }else if([str isEqualToString:@"-13"]){
        return @"动态算法只支持独立服务器调用";
    }else if([str isEqualToString:@"-14"]){
        return @"错误的调用";
    }else if([str isEqualToString:@"-15"]){
        return @"频繁调用,请等待10分钟后再做尝试";
    }else if([str isEqualToString:@"-16"]){
        return @"接口未开启";
    }else if([str isEqualToString:@"-17"]){
        return @"错误的调用方式,请确认后台接口的调用方式";
    }else if([str isEqualToString:@"-18"]){
        return @"服务器内部错误,请联系管理员解决";
    }else if([str isEqualToString:@"-19"]){
        return @"接口调用失败,调用次数不足";
    }else if([str isEqualToString:@"-20"]){
        return @"变量数据不存在";
    }else if([str isEqualToString:@"-21"]){
        return @"机器码一样,无需转绑";
    }else if([str isEqualToString:@"-23"]){
        return @"此接口开启了强制算法,但是没使用";
    }else if([str isEqualToString:@"-101"]){
        return @"用户名填写错误,必须以字母开头6-16位字母或数字!";
    }else if([str isEqualToString:@"-102"]){
        return @"用户不存在";
    }else if([str isEqualToString:@"-103"]){
        return @"请先登陆再调用此方法";
    }else if([str isEqualToString:@"-104"]){
        return @"密码填写错误,请输入6-16位密码！";
    }else if([str isEqualToString:@"-105"]){
        return @"邮箱填写错误,请正确输入邮箱！";
    }else if([str isEqualToString:@"-106"]){
        return @"用户名重复";
    }else if([str isEqualToString:@"-107"]){
        return @"邮箱重复";
    }else if([str isEqualToString:@"-108"]){
        return @"新密码输入错误";
    }else if([str isEqualToString:@"-109"]){
        return @"用户名或密码错误";
    }else if([str isEqualToString:@"-110"]){
        return @"用户使用时间已到期";
    }else if([str isEqualToString:@"-111"]){
        return @"用户未在绑定的电脑上登陆";
    }else if([str isEqualToString:@"-112"]){
        return @"用户在别的地方登陆";
    }else if([str isEqualToString:@"-113"]){
        return @"过期时间有误";
    }else if([str isEqualToString:@"-114"]){
        return @"登录数据不存在";
    }else if([str isEqualToString:@"-115"]){
        return @"用户已被禁用";
    }else if([str isEqualToString:@"-116"]){
        return @"密码修改申请过于频繁";
    }else if([str isEqualToString:@"-117"]){
        return @"未输入机器码";
    }else if([str isEqualToString:@"-118"]){
        return @"重绑次数超过限制";
    }else if([str isEqualToString:@"-119"]){
        return @"使用天数不足,重绑失败";
    }else if([str isEqualToString:@"-120"]){
        return @"注册失败,注册次数超过限制";
    }else if([str isEqualToString:@"-121"]){
        return @"用户机器码不能超过32位";
    }else if([str isEqualToString:@"-122"]){
        return @"用户已经被删除";
    }else if([str isEqualToString:@"-123"]){
        return @"用户密码输入错误";
    }else if([str isEqualToString:@"-124"]){
        return @"用户登录数达到最大";
    }else if([str isEqualToString:@"-125"]){
        return @"错误的用户操作类别";
    }else if([str isEqualToString:@"-126"]){
        return @"过期时间变更记录创建失败";
    }else if([str isEqualToString:@"-127"]){
        return @"用户充值失败";
    }else if([str isEqualToString:@"-128"]){
        return @"用户数据超过最大限制";
    }else if([str isEqualToString:@"-129"]){
        return @"用户被开发者禁止使用,请咨询开发者是否被拉到黑名单";
    }else if([str isEqualToString:@"-131"]){
        return @"用户使用次数不足";
    }else if([str isEqualToString:@"-132"]){
        return @"用户使用点数不足";
    }else if([str isEqualToString:@"-201"]){
        return @"程序不存在";
    }else if([str isEqualToString:@"-202"]){
        return @"程序密钥输入错误";
    }else if([str isEqualToString:@"-203"]){
        return @"程序版本号错误";
    }else if([str isEqualToString:@"-204"]){
        return @"程序版本不存在";
    }else if([str isEqualToString:@"-205"]){
        return @"用户未申请使用程序";
    }else if([str isEqualToString:@"-206"]){
        return @"程序版本需要更新";
    }else if([str isEqualToString:@"-207"]){
        return @"程序版本已停用";
    }else if([str isEqualToString:@"-208"]){
        return @"程序未开启后台接口功能";
    }else if([str isEqualToString:@"-209"]){
        return @"程序接口密码错误";
    }else if([str isEqualToString:@"-210"]){
        return @"程序停止新用户注册";
    }else if([str isEqualToString:@"-211"]){
        return @"程序不允许用户机器码转绑";
    }else if([str isEqualToString:@"-301"]){
        return @"卡密输入错误";
    }else if([str isEqualToString:@"-302"]){
        return @"卡密不存在";
    }else if([str isEqualToString:@"-303"]){
        return @"卡密已经使用";
    }else if([str isEqualToString:@"-304"]){
        return @"卡密已经过期";
    }else if([str isEqualToString:@"-305"]){
        return @"卡密已经冻结";
    }else if([str isEqualToString:@"-306"]){
        return @"卡密已经退换";
    }else if([str isEqualToString:@"-308"]){
        return @"卡密已经换卡";
    }else if([str isEqualToString:@"101"]){
        return @"充值成功!填写的推荐人不存在";
    }else if([str isEqualToString:@"102"]){
        return @"充值成功!填写推荐人获赠时间失败";
    }else if([str isEqualToString:@"103"]){
        return @"充值成功!添加推荐信息失败";
    }else if([str isEqualToString:@"104"]){
        return @"充值成功!推荐人获赠时间失败";
    }else if([str isEqualToString:@"105"]){
        return @"充值成功!充值的卡密类别不支持推荐人功能";
    }else if([str isEqualToString:@"106"]){
        return @"充值成功!充值的卡密类别推荐功能已关闭";
    }else if([str isEqualToString:@"107"]){
        return @"充值成功!成功使用推荐功能";
    }else if([str isEqualToString:@"108"]){
        return @"充值成功!但是填写的推荐人无效";
    }
    return str;
}

@end
/***
 
 - (void)netPOST {
 //第一步，创建URL
 NSURL *url = [NSURL URLWithString:@"http://w.eydata.net/68410c1b175c8e24"];
 //第二步，创建请求
 NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
 [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
 NSString *str = @"NSUserName=aaaddd&NSUserPwd=aaaddddd&NSEmail=&NSMac=";//设置参数
 NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
 [request setHTTPBody:data];
 //第三步，连接服务器
 
 NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
 
 NSString *str1 = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
 
 [self messageBox:str1];
 //    NSString *stringUrl = [NSString stringWithFormat:@"http://w.eydata.net/68410c1b175c8e24"];
 //
 //    NSURL *url = [NSURL URLWithString:stringUrl];
 //
 //    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
 //
 //    request.timeoutInterval = 5.0;
 //
 //    request.HTTPMethod = @"POST";
 //
 //    NSString *bodyString = [NSString stringWithFormat:@"NSUserName=aaaddd&NSUserPwd=aaaddddd&NSEmail=&NSMac="]; //带一个参数key传给服务器
 //
 //    request.HTTPBody = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
 //
 //    NSURLSession *session = [NSURLSession sharedSession];
 //
 //    [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
 //        // 数据解析...
 //
 //    }] resume];
 //     [self messageBox:@"sss"];
 }

 
 ***/
