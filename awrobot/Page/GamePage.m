//
//  GamePage.m
//  test2
//
//  Created by 刘卓林 on 2018/2/1.
//  Copyright © 2018年 刘卓林. All rights reserved.
//

#import "GamePage.h"

@interface GamePage ()

@end

@implementation GamePage

- (void)viewDidLoad {
    [super viewDidLoad];
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    float zoom = 1.0;
    if(isPad)
        zoom = 0.7;
//    self.view = [[[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds] autorelease];
    self.view.backgroundColor = [UIColor grayColor];
//    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.backgroundColor = RGB(246, 246, 246);
    _scrollView.contentSize = CGSizeMake(0, HEIGHT);
    _scrollView.directionalLockEnabled = YES;
    [self.view addSubview:_scrollView];

    NSString *path = [NSString stringWithFormat:@"%@/mhxy.png",appPath];
    UIView *view1 = [self creatView:path title:@"梦幻西游" tag:100];
    view1.center = CGPointMake(WIDTH*0.16*zoom, HEIGHT*0.12);
    [_scrollView addSubview:view1];

    path = [NSString stringWithFormat:@"%@/wzry.png",appPath];
    UIView *view2 = [self creatView:path title:@"王者荣耀" tag:101];
    view2.center = CGPointMake(WIDTH*0.4*zoom, HEIGHT*0.12);
    [_scrollView addSubview:view2];

    path = [NSString stringWithFormat:@"%@/wechat.png",appPath];
    UIView *view3 = [self creatView:path title:@"微信" tag:102];
    view3.center = CGPointMake(WIDTH*0.64*zoom, HEIGHT*0.12);
    [_scrollView addSubview:view3];
    [pool drain];
}

-(UIView *)creatView:(NSString *)imagePath title:(NSString *)title tag:(int)tag{
    float zoom = 1.0;
    if(isPad)
        zoom = 0.6;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH*0.17*zoom, WIDTH*0.21*zoom)];
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    but.frame = CGRectMake(0, 0, WIDTH*0.17*zoom, WIDTH*0.17*zoom);
    [but setBackgroundImage:[UIImage imageNamed:imagePath] forState:UIControlStateNormal];
    [but.layer setCornerRadius:10];
    //切割超出圆角范围的子视图
    but.layer.masksToBounds = YES;
    but.tag = tag;
    [view addSubview:but];
    [but addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = title;
    label.textColor = RGB(55, 55, 55);
    label.font = [UIFont boldSystemFontOfSize:WIDTH*0.03*zoom];//采用系统默认文字设置大小
//    label.backgroundColor = [UIColor redColor];
    label.frame = CGRectMake(0, 0,WIDTH*0.17,WIDTH*0.01);
    label.center = CGPointMake(view.frame.size.width*0.5, view.frame.size.height*0.95);
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    
    return view;
}

-(void)click:(UIButton *)but{
    switch (but.tag) {
        case 100:
            [self openGame:@"com.netease.my"];
            break;
        case 101:
            [self messageBox:@"敬请期待"];
            break;
        case 102:
            [self openGame:@"com.tencent.xin"];
            break;
        default:
            break;
    }
}

- (void)dealloc {
    [_scrollView release];
    [super dealloc];
}


@end
