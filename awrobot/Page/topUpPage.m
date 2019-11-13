//
//  topUpPage.m
//  test2
//
//  Created by 刘卓林 on 2018/2/2.
//  Copyright © 2018年 刘卓林. All rights reserved.
//

#import "topUpPage.h"
#import "registerCardPage.h"

@implementation topUpPage

- (UITableView *)tabelView{
    if(!_tabelView){
        _tabelView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tabelView.dataSource = self;
        _tabelView.delegate = self;
        _tabelView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tabelView.sectionHeaderHeight = 0;
        _tabelView.sectionFooterHeight = WIDTH*0.05;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, WIDTH*0.05)];
        _tabelView.tableHeaderView = view;
    }
    return _tabelView;
}

//显示每组几个
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = @"卡号充值";
            break;
        case 1:
            cell.textLabel.text = @"自动发卡平台";
            break;
        case 2:
            cell.textLabel.text = @"淘宝店铺";
            break;
        default:
            break;
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

//显示几组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section==0){
        [self.navigationController pushViewController:[[registerCardPage alloc] init] animated:YES];
    }else if(indexPath.section==1){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:AotocardURL]];
    }else if(indexPath.section==2){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:TaobaoURL]];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"充值";
    self.view.backgroundColor = [UIColor grayColor];
    //卡号
    //自动发卡平台
    //淘宝
    [self.view addSubview:self.tabelView];
}

- (void)dealloc {
    [_tabelView release];
    [super dealloc];
}
@end
