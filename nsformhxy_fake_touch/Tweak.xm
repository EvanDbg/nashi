#import "NSSetViewBody.h"
#import "NSRestart.h"
#import <rocketbootstrap/rocketbootstrap.h>
#import <AppSupport/CPDistributedMessagingCenter.h>
#import <SpringBoard/SpringBoard.h>

#define serverName @"com.NS_IOS_MHXY.server"
// #define gameURL @"com.netease.mpay.x1ogfvsfn674kgpn://"
#define gameBundleID @"com.netease.my"
#define TimeURL @"http://w.eydata.net/66aa5f845c6349b0"

static bool startIcon;

int autorun = 0;
int superrun = 0;
int postTime = 0;
int mytest = 0;
NSString *showTime;
NSObject *account;
NSUserDefaults *defaults;
NSDateFormatter *dateFormatter;
NSString *destDateString;
NSDateFormatter *date;
NSDate *startD;
NSDate *endD;
NSTimeInterval start;
NSTimeInterval end;
NSTimeInterval value;
NSString *str;
NSString *urlString;
NSMutableURLRequest *request;
NSHTTPURLResponse *response;
NSString *dateStr;
NSDateFormatter *dMatter;
NSDate *netDate;
NSTimeZone *zone;
NSInteger interval;
NSDate *localeDate;
NSURL *url;
NSMutableURLRequest *request2;
NSData *bodyData;
NSURLSession *session;
NSURLSessionDataTask *task;


%hook IOSView

	- (void)layoutSubviews{
		//NSLog(@"被hook了");
		if(startIcon) 
			return;
		startIcon=true;
		//初始化
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		NSSetViewBody * setView = [[NSSetViewBody alloc] init];
		[setView initVariable];
		[setView createController];
		[setView createSettingView];
		[setView createIconButton];
		[setView autoRunScript];
		[pool drain];
		%orig;
	}

%end

%hook SpringBoard
	@interface SpringBoard()
	-(NSDate *)getInternetDate;
	-(NSString *)dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime;
	-(NSString *)POST:(NSString *)urlStr key:(NSString*)key;
	@end
	- (void)applicationDidFinishLaunching:(id)arg1 {
	    %orig;
	    dateFormatter = [[NSDateFormatter alloc] init];
	    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//zzz表示时区
	    date = [[NSDateFormatter alloc]init];
	    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	    request = [[NSMutableURLRequest alloc] init];
	    dMatter = [[NSDateFormatter alloc] init];
	    zone = [NSTimeZone systemTimeZone];
	    session = [NSURLSession sharedSession];

		CPDistributedMessagingCenter *server = [%c(CPDistributedMessagingCenter) centerNamed:serverName];

		rocketbootstrap_distributedmessagingcenter_apply(server);

		[server registerForMessageName:@"NSSTART" target:self selector:@selector(MyHandleMessageNamed:userInfo:)];

		[server registerForMessageName:@"NSEND" target:self selector:@selector(MyHandleMessageNamed:userInfo:)];

		[server registerForMessageName:@"NSOPEN" target:self selector:@selector(MyHandleMessageNamed:userInfo:)];

		[server registerForMessageName:@"NSSUPEROPEN" target:self selector:@selector(MyHandleMessageNamed:userInfo:)];

		[server registerForMessageName:@"NSAUTOSP" target:self selector:@selector(MyHandleMessageNamedWith:withUserInfo:)];
		//设置到期时间
    	[server registerForMessageName:@"NSENDTIME" target:self selector:@selector(Mysetend:withUserInfo:)];

    	[server registerForMessageName:@"NSTEST" target:self selector:@selector(MyTest:withUserInfo:)];

		[server runServerOnCurrentThread];

		[NSThread detachNewThreadSelector:@selector(MyRunGame:) toTarget:self withObject:nil];
	}

	%new
	- (void)MyRunGame:(NSThread *)thread
	{
		sleep(10);

		CPDistributedMessagingCenter *c = [%c(CPDistributedMessagingCenter) centerNamed:serverName];
		rocketbootstrap_distributedmessagingcenter_apply(c);
		while(1){
			if(autorun == 1){
				[c sendMessageName:@"NSOPEN" userInfo:nil];
				superrun++;
				if(superrun>6){
					superrun=0;
					[c sendMessageName:@"NSSUPEROPEN" userInfo:nil];
				}
			}
			
			sleep(5);
		}
		
	}

	%new
	-(void)MyHandleMessageNamed:(NSString *)name userInfo:(NSDictionary *)userInfo
	{
		// if ([[UIApplication sharedApplication] canOpenURL:mapUrl])//判断是否有应用

		if([name isEqualToString: @"NSSTART"])
	    {
	    	mytest=0;
	    	autorun=1;
	    }
	   	if([name isEqualToString: @"NSEND"])
	    {
	    	autorun=0;
	    }
		if([name isEqualToString: @"NSOPEN"])
	    {
	        if (![NSRestart runningProcesses:@"client"])
	        {
	        	mytest++;
	        	[NSRestart openGame:gameBundleID];
	            // [[UIApplication sharedApplication] openURL:[NSURL URLWithString:gameURL]];
	        }
	    }
	    if([name isEqualToString: @"NSSUPEROPEN"])
	    {
	    	// [NSRestart openGame:gameBundleID];
	        // [[UIApplication sharedApplication] openURL:[NSURL URLWithString:gameURL]];
	    }
	}
	%new
	- (NSDictionary *)MyHandleMessageNamedWith:(NSString *)name withUserInfo:(NSDictionary *)userinfo
	{
	    if([name isEqualToString:@"NSAUTOSP"])
	    {
	        if(autorun ==1)
	        {
	           return [NSDictionary dictionaryWithObjectsAndKeys:@"YES",@"RunScript", nil];
	        }
	        else
	        {
	            return [NSDictionary dictionaryWithObjectsAndKeys:@"NO",@"RunScript", nil];
	        }
	    }
	    return userinfo;
	}
	%new
	- (NSDictionary *)MyTest:(NSString *)name withUserInfo:(NSDictionary *)userinfo
	{
		if([name isEqualToString:@"NSTEST"])
		{
			return [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"当前重启次数：%d",mytest],@"MyTest", nil];
		}
		return userinfo;
	}
	%new   //设置到期时间
	- (NSDictionary *)Mysetend:(NSString *)name withUserInfo:(NSDictionary *)userinfo {

		if([name isEqualToString: @"NSENDTIME"]){
		    account = [userinfo objectForKey:@"endtime"];
		    // NSLog(@"----------1%@",userinfo);
		    defaults=[NSUserDefaults standardUserDefaults];
       		if(account!=nil){
       			// NSLog(@"----------2%@",account);
       			[defaults setObject:account forKey:@"endtime"];
       			// NSString *showTime = [self POST:TimeURL key:[NSString stringWithFormat:@"NSUserName=%@",account]];
       			// [defaults setObject:showTime forKey:@"showtime"];
       			[defaults synchronize];
       		}else{
       			account = [defaults objectForKey:@"endtime"];
       			// NSLog(@"----------3%@",account);
       		}
       		if([[NSString stringWithFormat:@"%@",account] isEqualToString:@""]){
       			return [NSDictionary dictionaryWithObjectsAndKeys:@"-3",@"endtime", nil];
       		}
       		// NSLog(@"---------4=%d",postTime);
       		if(postTime>60 || postTime==0){
       			postTime = 0;
       			showTime = [self POST:TimeURL key:[NSString stringWithFormat:@"NSUserName=%@",account]];
       			// [defaults setObject:showTime forKey:@"showtime"];
       		}
       		postTime++;
       		// NSLog(@"---------5=%@",showTime);
       		// NSString *endTime = [NSString stringWithFormat:@"%@",[defaults objectForKey:@"showtime"]];
		    
		    destDateString = [dateFormatter stringFromDate:[self getInternetDate]];
		    // NSLog(@"tie111 ======%@",destDateString);
		    destDateString = [self dateTimeDifferenceWithStartTime:destDateString endTime:showTime];
		    // NSLog(@"tie2222 ======%@",destDateString);
		    return [NSDictionary dictionaryWithObjectsAndKeys:destDateString,@"endtime", nil];
		}

		return userinfo;
	}
	%new
	-(NSString *)dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime{
	    if(!startTime)
	        return @"-2";
	    if(!endTime)
	        return @"-3";
	    if([endTime length]<5)
	        return endTime;
	    
	    startD =[date dateFromString:startTime];
	    endD = [date dateFromString:endTime];
	    start = [startD timeIntervalSince1970]*1;
	    end = [endD timeIntervalSince1970]*1;
	    value = end - start;
	    int second = (int)value %60;//秒
	    int minute = (int)value /60%60;
	    //    int house = (int)value / (24 *3600)%3600;
	    int house = ((int)value / 3600)%24;
	    int day = (int)value / (24 *3600);
	    
	    if(day<=0 && house<=0 && minute<=0 && second<=0){
	        str = @"-1";
	    }else if (day != 0) {
	        str = [NSString stringWithFormat:@"%d天%d小时%d分%d秒",day,house,minute,second];
	    }else if (day==0 && house !=0) {
	        str = [NSString stringWithFormat:@"%d小时%d分%d秒",house,minute,second];
	    }else if (day==0 && house==0 && minute!=0) {
	        str = [NSString stringWithFormat:@"%d分%d秒",minute,second];
	    }else{
	        str = [NSString stringWithFormat:@"%d秒",second];
	    }

	    return str;
	}
	%new
	-(NSDate *)getInternetDate
	{
	//    NSLog(@"JJJJJ");
	    // NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	    urlString = @"http://m.baidu.com";
	    urlString = [urlString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
	    [request setURL:[NSURL URLWithString: urlString]];
	    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
	    [request setTimeoutInterval: 2];
	    [request setHTTPShouldHandleCookies:FALSE];
	    [request setHTTPMethod:@"GET"];
	    
	    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
	    
	    dateStr = [[response allHeaderFields] objectForKey:@"Date"];
	    dateStr = [dateStr substringFromIndex:5];
	    dateStr = [dateStr substringToIndex:[dateStr length]-4];
	    dMatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
	    [dMatter setDateFormat:@"dd MMM yyyy HH:mm:ss"];
	    //    NSDate *netDate = [[dMatter dateFromString:date] dateByAddingTimeInterval:60];
	    netDate = [dMatter dateFromString:dateStr];
	    
	    interval = [zone secondsFromGMTForDate: netDate];
	    localeDate = [netDate  dateByAddingTimeInterval: interval];
	    // [pool drain];
	    return localeDate;
	}
	%new
	-(NSString *)POST:(NSString *)urlStr key:(NSString*)key{
	    // NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0); //创建信号量
	    // iOS 9以后
	    // 1、 创建URL
	    url = [NSURL URLWithString:urlStr];
	    // 2、  创建请求对象
	    request2 = [[NSMutableURLRequest alloc] initWithURL:url];
	    [request2 setHTTPMethod:@"POST"];
	    // 3、
	    bodyData = [key dataUsingEncoding:NSUTF8StringEncoding];
	    [request2 setHTTPBody:bodyData];
	    [request2 setTimeoutInterval:60];
	    // 4.1、  创建会话
	    
	    //    NSURLSessionConfiguration *defaultConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
	    //    NSURLSession *session = [NSURLSession sessionWithConfiguration: defaultConfig delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
	    // 4.2、 创建数据请求任务
	    __block NSString *newStr = @"";
	    task = [session dataTaskWithRequest:request2 completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
	        
	        //        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
	        //
	        //        NSLog(@"%@", dict);
	        newStr = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
	        //        NSLog(@"新请求结果%@",newStr);
	//        NSLog(@"error===%@",error);
	        dispatch_semaphore_signal(semaphore);   //发送信号
	    }];
	    // 4.3、 启动任务
	    [task resume];
	    dispatch_semaphore_wait(semaphore,DISPATCH_TIME_FOREVER);  //等待
	    //    NSLog(@"xxxxx%@",newStr);
	    // [pool drain];
	    return newStr;
	}
%end
