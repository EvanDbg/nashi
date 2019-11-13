//
//  HomePage.m
//  test2
//
//  Created by 刘卓林 on 2018/1/22.
//  Copyright © 2018年 刘卓林. All rights reserved.
//

#import "HomePage.h"
#import "TimePage.h"
#import "GamePage.h"
#import "UserPage.h"

@implementation HomePage

-(id)init{
    self = [super init];
    if(self){
        [self addTabControllers];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
}

-(void)addTabControllers{
    float zoom = 1.0;
    if(isPad)
        zoom = 0.5;
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    self.tabBar.tintColor = RGB(26, 173, 25);
    UIImage *image;
    NSMutableArray *controllers = [NSMutableArray array];
    NSBasePage *page = nil;
    UINavigationController *nav = nil;
    
    page = [[TimePage alloc] init];
    page.title = @"Time";
    image = [[NSBasePage alloc] scaleImage:[UIImage imageNamed: [NSString stringWithFormat:@"%@/time.png",[[NSBundle mainBundle] bundlePath]]] toScale:WIDTH*0.1*0.1*0.07*zoom];
    page.tabBarItem.image = image;
    nav = [[UINavigationController alloc] initWithRootViewController:page];
    nav.navigationBar.barTintColor = RGB(15, 15, 15);
    nav.navigationBar.tintColor = [UIColor whiteColor];
    [nav.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [controllers addObject:nav];
    
    page = [[GamePage alloc] init];
    page.title = @"Game";
    image = [[NSBasePage alloc] scaleImage:[UIImage imageNamed: [NSString stringWithFormat:@"%@/game.png",[[NSBundle mainBundle] bundlePath]]] toScale:WIDTH*0.1*0.1*0.07*zoom];
    page.tabBarItem.image = image;
    nav = [[UINavigationController alloc] initWithRootViewController:page];
    nav.navigationBar.barTintColor = RGB(15, 15, 15);
    nav.navigationBar.tintColor = [UIColor whiteColor];
    [nav.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [controllers addObject:nav];
    
    page = [[UserPage alloc] init];
    page.title = @"User";
    image = [[NSBasePage alloc] scaleImage:[UIImage imageNamed: [NSString stringWithFormat:@"%@/user.png",[[NSBundle mainBundle] bundlePath]]] toScale:WIDTH*0.1*0.1*0.07*zoom];
    page.tabBarItem.image = image;
    nav = [[UINavigationController alloc] initWithRootViewController:page];
    nav.navigationBar.barTintColor = RGB(15, 15, 15);
    nav.navigationBar.tintColor = [UIColor whiteColor];
    [nav.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [controllers addObject:nav];
    
    self.viewControllers = controllers;
    [pool drain];
}

- (void)dealloc {

    [super dealloc];
}

@end
