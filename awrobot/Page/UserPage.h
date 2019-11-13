//
//  UserPage.h
//  test2
//
//  Created by 刘卓林 on 2018/2/1.
//  Copyright © 2018年 刘卓林. All rights reserved.
//

#import "NSBasePage.h"

@interface UserPage : NSBasePage<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView *tabelView;
@property(nonatomic,strong)NSArray *array;
@property(nonatomic,strong)NSArray *targetList;

@end
