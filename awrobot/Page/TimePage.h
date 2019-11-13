//
//  TimePage.h
//  test2
//
//  Created by 刘卓林 on 2018/2/1.
//  Copyright © 2018年 刘卓林. All rights reserved.
//

#import "NSBasePage.h"
#import "HomePage.h"

@interface TimePage : NSBasePage

@property(nonatomic,strong)NSString *account;
@property(nonatomic,strong)NSString *password;
@property(nonatomic,strong)NSString *stateID;
@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,strong)UILabel *bulletinLabel;
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)NSTimer *timerThread;
- (NSString *)dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime;
- (NSString*)getCurrentTime;
- (NSDate *)getInternetDate;

@end
