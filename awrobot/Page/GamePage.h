//
//  GamePage.h
//  test2
//
//  Created by 刘卓林 on 2018/2/1.
//  Copyright © 2018年 刘卓林. All rights reserved.
//

#import "NSBasePage.h"

@interface GamePage : NSBasePage

@property(nonatomic,strong)UIScrollView *scrollView;
-(UIView *)creatView:(NSString *)imagePath title:(NSString *)title tag:(int)tag;

@end
