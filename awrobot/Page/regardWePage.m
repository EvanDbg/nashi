//
//  regardWePage.m
//  test2
//
//  Created by 刘卓林 on 2018/2/2.
//  Copyright © 2018年 刘卓林. All rights reserved.
//

#import "regardWePage.h"

#define read @"\n[-]您好，世界！终于与大家见面了，历时近半年，开发中与海内外多名ios安全研究员，正向逆向开发者交流合作，108个日夜，上万次调试，只为了带给用户更好的体验。我不是一个简简单单的APP，我有一个个性的名字叫做那是（Auto Work Robot），是一款专注于手游脚本自主研发的APP，我能帮您完成游戏里繁琐的日常任务，让您在工作的同时也能成为游戏中的佼佼者。我拥有最新的图像识别技术，智能的AI性能，可视化UI界面，我还能模拟真人操作，让您告别封号的苦恼。还有我提供一站式服务，一个账号就可以使用全部游戏脚本。我们致力于成为西南地区首屈一指的自主研发团队！\n\n[+]only finish, never back!\n\n[~]那是\n\n[-]Hello, world! Finally met with you, lasted nearly six months, the development of a number of ios security researcher at home and abroad, is to reverse the exchange and cooperation, 108 day and night, tens of thousands of debugging, only to bring users a better experience. I am not a simple APP, I have a personality called AwRobot, is a mobile APP devoted to research and development, I can help you complete the tedious daily tasks in the game, let You work at the same time can become the leader in the game. I have the latest image recognition technology, intelligent AI performance, visual UI interface, I can simulate live action, so you bid farewell to the title of distress. And I offer one-stop service, an account can use all the game script. We are committed to become the premier Southwest independent R & D team!\n\n[+]only finish, never back!\n\n[~]nashi\n\n"

@interface regardWePage ()

@end

@implementation regardWePage

- (void)viewDidLoad {
    [super viewDidLoad];
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    self.title = @"关于我们";
    self.view.backgroundColor = [UIColor grayColor];
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.backgroundColor = RGB(246, 246, 246);
    _scrollView.contentSize = CGSizeMake(0, HEIGHT);
    _scrollView.directionalLockEnabled = YES;
    [self.view addSubview:_scrollView];
//    UILabel *readMe = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH*0.9, HEIGHT*1.5)];
//    readMe.center = CGPointMake(WIDTH*0.5, HEIGHT*0.7);
    UILabel *readMe = [[UILabel alloc] init];
    readMe.backgroundColor = RGB(246, 246, 246);
    readMe.text = read;
    readMe.numberOfLines = 0;
    readMe.frame = CGRectMake(WIDTH*0.05, 0, WIDTH*0.9, [readMe.text length]*(HEIGHT*0.01*0.12));
    [readMe sizeToFit];
    _scrollView.contentSize = readMe.frame.size;
    [_scrollView addSubview:readMe];
    [pool drain];
}

- (void)dealloc {
    [_scrollView release];
    [super dealloc];
}

@end
