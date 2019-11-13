//
//  UserPage.m
//  test2
//
//  Created by 刘卓林 on 2018/2/1.
//  Copyright © 2018年 刘卓林. All rights reserved.
//

#import "UserPage.h"
#import "GuidePage.h"


@implementation UserPage

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
    NSInteger num= 0;
    switch (section) {
        case 0:
            num = 1;
            break;
        case 1:
            num = 2;
            break;
        case 2:
            num = 2;
            break;
        case 3:
            num = 1;
            break;
        default:
            break;
    }
    return num;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat f;
    if(indexPath.section==0){
        f = HEIGHT*0.15;
        return f;
    }else{
//        f = HEIGHT*0.08;
    }
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    NSString *path;
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = [_array objectAtIndex:0];
            path = [NSString stringWithFormat:@"%@/userhead.png",appPath];
            cell.imageView.image = [UIImage imageNamed:path];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        case 1:
            if(indexPath.row==0){
                cell.textLabel.text = @"充值";
                path = [NSString stringWithFormat:@"%@/rechatge.png",appPath];
                cell.imageView.image = [UIImage imageNamed:path];
            }else if(indexPath.row==1){
                cell.textLabel.text = @"关于我们";
                path = [NSString stringWithFormat:@"%@/aboutwe.png",appPath];
                cell.imageView.image = [UIImage imageNamed:path];
            }
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        case 2:
            if(indexPath.row==0){
                cell.textLabel.text = @"QQGroup:423760450";
                path = [NSString stringWithFormat:@"%@/network.png",appPath];
                cell.imageView.image = [UIImage imageNamed:path];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }else if(indexPath.row==1){
                cell.textLabel.text = Version;
                path = [NSString stringWithFormat:@"%@/versions.png",appPath];
                cell.imageView.image = [UIImage imageNamed:path];
            }
            break;
        case 3:
            cell.textLabel.text = @"退出登陆";
            cell.textLabel.textColor = [UIColor redColor];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            break;
        default:
            break;
    }
    return cell;
}
//显示几组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section==3){
//            NSUserDefaults *defatluts = [NSUserDefaults standardUserDefaults];
//            NSDictionary *dictionary = [defatluts dictionaryRepresentation];
//            for(NSString *key in [dictionary allKeys]){
//                [defatluts removeObjectForKey:key];
//                [defatluts synchronize];
//            }
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *str1 = [defaults objectForKey:@"state"];
        NSString *str2 = [defaults objectForKey:@"account"];
        NSArray *arrayAccount = [str2 componentsSeparatedByString:@"|"];
        if([str1 isEqualToString:@""])
            return;
        NSString *key = [NSString stringWithFormat:@"NSStatusCode=%@&NSUserName=%@",str1,[arrayAccount objectAtIndex:0]];
        NSString *repost = [NSNetPost POST:OutLoginURL key:key];
        if([repost isEqualToString:@"1"] || [repost isEqualToString:@"-103"] || [repost isEqualToString:@"-114"]){
            key = [NSString stringWithFormat:@"NSUserName=%@&NSUserPwd=%@",[arrayAccount objectAtIndex:0],[arrayAccount objectAtIndex:1]];
            repost = [NSNetPost POST:ClearDataURL key:key];
            if(![repost isEqualToString:@"1"] && ![repost isEqualToString:@"-103"]){
                repost = [NSNetPost errorCode:repost];
                [self messageBox:repost];
            }
//            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[GuidePage alloc] init]];
            [self.navigationController pushViewController:[[GuidePage alloc] init] animated:NO];
//            [self presentViewController:[[GuidePage alloc] init] animated:NO completion:nil];
            [self removeFromParentViewController];
        }else{
            repost = [NSNetPost errorCode:repost];
            [self messageBox:repost];
        }
    }else if(indexPath.section == 2 && indexPath.row == 0){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:WebURL]];
    }else if(indexPath.section != 2){
        NSString *targetName = self.targetList[indexPath.section][indexPath.row];
        UIViewController * view = [[NSClassFromString(targetName) alloc] init];
        [self.navigationController pushViewController:view animated:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view = [[[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds] autorelease];
    self.view.backgroundColor = [UIColor grayColor];
//    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    NSArray *section1 = @[@"setUserPage"];
    NSArray *section2 = @[@"topUpPage",@"regardWePage"];
    
    self.targetList = @[section1,section2];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *str = [defaults objectForKey:@"account"];
    _array = [str componentsSeparatedByString:@"|"];
    [self.view addSubview:self.tabelView];
}

- (void)dealloc {
    [_tabelView release];
    [_array release];
    [_targetList release];
    [super dealloc];
}
@end
