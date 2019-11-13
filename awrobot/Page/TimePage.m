//
//  TimePage.m
//  test2
//
//  Created by 刘卓林 on 2018/2/1.
//  Copyright © 2018年 刘卓林. All rights reserved.
//

#import "TimePage.h"

static int showTimeTitle;
//static NSString *timeKey;
//static NSString *timeEnd;
//static NSString *timeDestDateString;
//static NSDateFormatter *timeDateFormatter;

@implementation TimePage

- (void)viewDidLoad {
    [super viewDidLoad];
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    self.view = [[[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds] autorelease];
    self.view.backgroundColor = [UIColor grayColor];
//    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.backgroundColor = RGB(246, 246, 246);
    _scrollView.contentSize = CGSizeMake(0, HEIGHT);
    _scrollView.directionalLockEnabled = YES;
    [self.view addSubview:_scrollView];

    _timeLabel = [[UILabel alloc] init];
    _timeLabel.text = @"nil";
    _timeLabel.textColor = RGB(55, 55, 55);
    _timeLabel.font = [UIFont boldSystemFontOfSize:WIDTH*0.08];//采用系统默认文字设置大小
//    _timeLabel.backgroundColor = [UIColor redColor];
    _timeLabel.frame = CGRectMake(0, 0,WIDTH*0.9,WIDTH*0.1);
    _timeLabel.center = CGPointMake(WIDTH*0.5, HEIGHT*0.1);
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    [_scrollView addSubview:_timeLabel];
    
    UILabel *bulletinText = [[UILabel alloc] init];
    bulletinText.text = @"公告";
    bulletinText.textColor = RGB(186, 47, 55);
    bulletinText.font = [UIFont boldSystemFontOfSize:WIDTH*0.06];//采用系统默认文字设置大小
    bulletinText.frame = CGRectMake(0, 0,WIDTH*0.5,WIDTH*0.1);
    bulletinText.center = CGPointMake(WIDTH*0.5, HEIGHT*0.2);
    bulletinText.textAlignment = NSTextAlignmentCenter;
    [_scrollView addSubview:bulletinText];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH*0.9, HEIGHT*0.5)];
    view.backgroundColor = RGB(186, 47, 55);
    view.alpha = 0.6;
    view.center = CGPointMake(WIDTH*0.5, HEIGHT*0.5);
    [view.layer setCornerRadius:12];
    view.layer.masksToBounds = YES;
    [_scrollView addSubview:view];
    
    _bulletinLabel = [[UILabel alloc] init];
    _bulletinLabel.textColor = RGB(255, 255, 255);
    _bulletinLabel.frame = CGRectMake(0, 0, view.frame.size.width*0.9, view.frame.size.height*0.9);
    _bulletinLabel.center = CGPointMake(view.frame.size.width*0.5, view.frame.size.height*0.5);
//    [_bulletinLabel sizeToFit];
    _bulletinLabel.numberOfLines = 0;
    [view addSubview:_bulletinLabel];
    NSString *text = [NSNetPost POST:BulletinURL key:@""];
    NSString *str1 = [defaults objectForKey:@"bulletin"];
    if(![text isEqualToString:str1] && [text length]>5){
        [self messageBox:@"有新公告哦"];
        _bulletinLabel.text = text;
        bulletinText.text = @"新的公告New!!!";
        [defaults setObject:text forKey:@"bulletin"];
        [defaults synchronize];
    }else{
        _bulletinLabel.text = str1;
    }
    //向插件发送账号信息
    defaults = [NSUserDefaults standardUserDefaults];
    NSString *str = [defaults objectForKey:@"account"];
    NSArray *array = [str componentsSeparatedByString:@"|"];
    if(array.count>0 && [[array objectAtIndex:2] isEqualToString:@""]){
        NSLog(@"自动登录");
        NSString *key = [NSString stringWithFormat:@"NSUserName=%@&NSUserPwd=%@&NSVersion=1.0&NSMac=",[array objectAtIndex:0],[array objectAtIndex:1]];
        dispatch_async(dispatch_queue_create(NULL, NULL), ^{
            BOOL errorTrue = false;
            while (1) {
                _stateID = [NSNetPost POST:LoginURL key:key];
//                NSLog(@"_stateID：%@",_stateID);
                if([_stateID length]>5){
                    [NSNetPost saveAccount:[array objectAtIndex:0] password:[array objectAtIndex:1] state:_stateID];
                    break;
                }else if([_stateID isEqualToString:@"-15"]){
                    
                }else if(!errorTrue){
                    errorTrue= true;
                    NSString *error = [NSNetPost errorCode:_stateID];
                    NSLog(@"错误代码：%@",error);
                    [self messageBox:error];
//                    break;
                }
                sleep(5);
            };
//            NSLog(@"======%@",_stateID);
        });
    }
    
    _account = [array objectAtIndex:0];
    _password = [array objectAtIndex:1];
    NSString *timeKey = [NSString stringWithFormat:@"NSUserName=%@",_account];
    NSString *timeEnd = [NSNetPost POST:TimeURL key:timeKey];
//    [NSNetPost setEndTime:timeEnd];
//    NSLog(@"ssss1%@",timeEnd);
    NSDateFormatter *timeDateFormatter = [[NSDateFormatter alloc] init];
    [timeDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//zzz表示时区
    NSMutableDictionary *userInfo = [@{} mutableCopy];
    [userInfo setObject:timeKey forKey:@"timeKey"];
    [userInfo setObject:timeEnd forKey:@"timeEnd"];
    [userInfo setObject:timeDateFormatter forKey:@"timeDate"];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        _timerThread = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(showTime:) userInfo:userInfo repeats:true];
        [[NSRunLoop currentRunLoop] run];
    });
//    _timerThread = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(showTime:) userInfo:userInfo repeats:YES];
//    //更改模式
//    [[NSRunLoop currentRunLoop] addTimer:_timerThread forMode:NSRunLoopCommonModes];
    [pool drain];
    
}

-(void)showTime:(NSTimer *)timer{
//    NSLog(@"ssss%d",showTimeTitle++);
//    NSLog(@"s=%@",[timer userInfo]);
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    if([[[timer userInfo] objectForKey:@"timeEnd"] length]<5 || [_timeLabel.text isEqualToString:@"请充值后使用"]){
        if(showTimeTitle>30){
            showTimeTitle = 0;
            NSString *timeEnd = [NSNetPost POST:TimeURL key:[[timer userInfo] objectForKey:@"timeKey"]];
//            [NSNetPost setEndTime:timeEnd];
            [[timer userInfo] setObject:timeEnd forKey:@"timeEnd"];
        }
        showTimeTitle++;
    }
    NSString *timeDestDateString = [[[timer userInfo] objectForKey:@"timeDate"] stringFromDate:[NSDate date]];
//    NSLog(@"sss2s%@",timeDestDateString);
    _timeLabel.text = [self dateTimeDifferenceWithStartTime:timeDestDateString endTime:[[timer userInfo] objectForKey:@"timeEnd"]];
    [pool drain];
}

- (NSString *)dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime{
    if(!startTime)
        return @"请连接网络";
    if([endTime length]<5)
        return [NSNetPost errorCode:endTime];
    NSDateFormatter *date = [[NSDateFormatter alloc]init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *startD =[date dateFromString:startTime];
    NSDate *endD = [date dateFromString:endTime];
    NSTimeInterval start = [startD timeIntervalSince1970]*1;
    NSTimeInterval end = [endD timeIntervalSince1970]*1;
    NSTimeInterval value = end - start;
    int second = (int)value %60;//秒
    int minute = (int)value /60%60;
//    int house = (int)value / (24 *3600)%3600;
    int house = ((int)value / 3600)%24;
    int day = (int)value / (24 *3600);
    NSString *str;
    if(day<=0 && house<=0 && minute<=0 && second<=0){
        str = @"请充值后使用";
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

-(NSString*)getCurrentTime {
    
    NSDateFormatter*formatter = [[NSDateFormatter alloc]init];[formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString*dateTime = [formatter stringFromDate:[NSDate date]];
    
    return dateTime;
    
}

- (NSDate *)getInternetDate
{
    NSString *urlString = @"http://m.baidu.com";
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString: urlString]];
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    [request setTimeoutInterval: 2];
    [request setHTTPShouldHandleCookies:FALSE];
    [request setHTTPMethod:@"GET"];
    NSHTTPURLResponse *response;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    NSString *date = [[response allHeaderFields] objectForKey:@"Date"];
    date = [date substringFromIndex:5];
    date = [date substringToIndex:[date length]-4];
    NSDateFormatter *dMatter = [[NSDateFormatter alloc] init];
    dMatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dMatter setDateFormat:@"dd MMM yyyy HH:mm:ss"];
//    NSDate *netDate = [[dMatter dateFromString:date] dateByAddingTimeInterval:60];
    NSDate *netDate = [dMatter dateFromString:date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: netDate];
    NSDate *localeDate = [netDate  dateByAddingTimeInterval: interval];
    return localeDate;
}

- (void)dealloc {
    [_account release];
    [_password release];
    [_stateID release];
    [_timeLabel release];
    [_scrollView release];
    if (_timerThread) {
        if ([_timerThread isValid]) {
            [_timerThread invalidate];
            _timerThread = nil;
        }
    }
    [super dealloc];
}

@end
