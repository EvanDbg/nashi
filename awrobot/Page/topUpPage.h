//
//  topUpPage.h
//  test2
//
//  Created by 刘卓林 on 2018/2/2.
//  Copyright © 2018年 刘卓林. All rights reserved.
//

#import "NSBasePage.h"

@interface topUpPage : NSBasePage<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView *tabelView;

@end
