//
//  NSSettingViewBody.m
//  test
//
//  Created by 刘卓林 on 2017/11/6.
//  Copyright © 2017年 刘卓林. All rights reserved.
//

#import "NSSetViewBody.h"
#import "NSSetLua.h"
//#import <objc/runtime.h>
#import <rocketbootstrap/rocketbootstrap.h>
#import <AppSupport/CPDistributedMessagingCenter.h>

#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)

#define serverName @"com.NS_IOS_MHXY.server"

#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define iconStock @"/nsfiles/mhxy/ui/stock.png"
#define iconDown @"/nsfiles/mhxy/ui/down.png"
#define NSCont @"/nsfiles/mhxy/ui/msgbox.png"
#define NSMenu @"/nsfiles/mhxy/ui/menu.png"
#define NSBut @"/nsfiles/mhxy/ui/button.png"
#define startImage @"/nsfiles/mhxy/ui/1.png"
#define sleepImage @"/nsfiles/mhxy/ui/2.png"
#define stopImage @"/nsfiles/mhxy/ui/3.png"
#define settingImage @"/nsfiles/mhxy/ui/4.png"


static UILabel *controllerLabel;
//static UIButton *iconBut;
//static bool iconClickShow;
static UIWindow *mainWindow;
static CGPoint iconInitPoint;
static UIView *myView;
//static NSString *iconStock = @"/nsfiles/mhxy/ui/IconStock.png";
//static NSString *iconDown = @"/nsfiles/mhxy/ui/IconDown.png";
//static NSString *NSCont = @"/nsfiles/mhxy/ui/msgbox.png";
//static NSString *NSMenu = @"/nsfiles/mhxy/ui/menu.png";
//static NSString *NSBut = @"/nsfiles/mhxy/ui/button.png";
//static NSString *startImage = @"/nsfiles/mhxy/ui/1.png";
//static NSString *sleepImage = @"/nsfiles/mhxy/ui/2.png";
//static NSString *stopImage = @"/nsfiles/mhxy/ui/3.png";
//static NSString *settingImage = @"/nsfiles/mhxy/ui/4.png";
static int iconSize;
//static UIButton *settingBut;
//static UIButton *startBut;
//static UIButton *sleepBut;
//static UIButton *stopBut;
static bool butRotate[4];
static UIView *settingView;
static UIView *addView[5];
int viewPage = 5;
//static UIImageView *imageViewController;
//static UIColor *textColor;
static NSSetLua *nsLua;
static bool nsthread_pause;
static bool nsthread_create;
UILabel * sliderLabel[13];
NSMutableArray *shunxu;
//int max = 0;
//static int suoying[12];
CPDistributedMessagingCenter *nsServer;
NSUserDefaults *defaults;
NSDictionary *replyBut;
NSString *objectBut;

@interface NSSetViewBody()

@property(nonatomic,strong)UIButton *iconBut;
@property(nonatomic,strong)UIButton *settingBut;
@property(nonatomic,strong)UIButton *startBut;
@property(nonatomic,strong)UIButton *sleepBut;
@property(nonatomic,strong)UIButton *stopBut;
@property(nonatomic,strong)UIImageView *imageViewController;
@property(nonatomic,strong)UIColor *textColor;
@property(nonatomic)bool iconClickShow;


-(void)craeteView0;
-(void)craeteView1;
-(void)craeteView2;
-(void)craeteView3;
-(void)craeteView4;
-(UISwitch *)createSwitch:(int)view point:(CGPoint)point str:(NSString*)str tag:(int)tag;
-(UISlider *)createSlider:(int)view point:(CGPoint)point min:(int)min max:(int)max width:(int)width tag:(int)tag;
-(UISegmentedControl *)createSeg:(int)view point:(CGPoint)point width:(int)width array:(NSArray *)array str:(NSString*)str tag:(int)tag;
-(void)shunxuPaixu:(UISwitch *)sw str:(NSString *)str num:(int)num;

@end



@implementation NSSetViewBody

-(void)initVariable{
    mainWindow = [UIApplication sharedApplication].windows[0];// 当前顶层窗口
    iconSize = mainWindow.center.y*0.2;
    if(isPad)
        iconSize = iconSize * 0.7;
    iconInitPoint = CGPointMake(iconSize*0.5,mainWindow.center.y);
    butRotate[0]=true;
    self.textColor = [UIColor blackColor];
    shunxu = [[NSMutableArray alloc] init];
    defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *mutableArray = [[defaults objectForKey:@"mission"] mutableCopy];
    if(mutableArray.count>0)
        shunxu = mutableArray;
    nsLua = [[NSSetLua alloc] init];
    nsServer = [NSClassFromString(@"CPDistributedMessagingCenter") centerNamed:serverName];
    rocketbootstrap_distributedmessagingcenter_apply(nsServer);
}

-(void)createController{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    UIImage *image = [UIImage imageNamed:NSCont];
    UIEdgeInsets insets = UIEdgeInsetsMake(2, 2, 2, 2);
    image = [image resizableImageWithCapInsets:insets resizingMode:(UIImageResizingModeStretch)];
    self.imageViewController = [[UIImageView alloc] init];  // 创建imageView对象
    self.imageViewController.frame = CGRectMake(mainWindow.center.x, mainWindow.center.y*0.05, mainWindow.center.x*0.45, mainWindow.center.y*0.1);  // 设置imageView的尺寸
    self.imageViewController.image = image;  // 加载图片
    self.imageViewController.alpha = 0.8;
    [mainWindow addSubview:self.imageViewController];  // 显示图片
    // 创建label
    controllerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, mainWindow.center.x*0.45, mainWindow.center.y*0.1)];
    controllerLabel.font = [UIFont systemFontOfSize:iconSize*0.3];//采用系统默认文字设置大小
    controllerLabel.textColor = self.textColor;//其中textColor要用UIColor类型
    controllerLabel.textAlignment = NSTextAlignmentCenter;
    [controllerLabel setText:@"那是手游助手控制台"];
    [self.imageViewController addSubview:controllerLabel];
    [pool drain];
}

-(void)setController:(NSString *)str{
    dispatch_async(dispatch_get_main_queue(), ^{
        [controllerLabel setText:str];
    });
}

-(void)setMessageBox:(NSString *)title msg:(NSString *)msg{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                            message:msg
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"确定", nil];
        // 显示弹出框
        [alertView show];
        [alertView release];
    });
}

-(void)createIconButton{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    myView= [[UIView alloc] init];
    myView.frame = CGRectMake(0, 0, iconSize, iconSize);  // myView
    myView.center = iconInitPoint;
    //[myView setBackgroundColor:[UIColor grayColor]];
    [mainWindow addSubview: myView];
    //添加拖到手势
    UIPanGestureRecognizer *pan=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePanGestures:)];
    
    //self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGestures:)];
    //无论最大还是最小都只允许一个手指
    pan.minimumNumberOfTouches = 1;
    pan.maximumNumberOfTouches = 1;
   	[myView addGestureRecognizer:pan];
    
    //一、写一个按钮控件，上面有一张图片
    
    //1.使用类创建一个按钮对象
    // UIButton *headbtn=[[UIButton alloc] initWithFrame:CGRectMake(100 ,100, 100, 100)];
    //设置按钮对象为自定义型
    self.iconBut=[UIButton buttonWithType:UIButtonTypeCustom];
    
    //2.设置对象的各项属性
    //(1)位置等通用属性设置
    self.iconBut.frame=CGRectMake(0, 0, iconSize, iconSize);
    //iconBut.center=iconInitPoint;// 让图片出生显示
    //(2)设置普通状态下按钮的属性
    [self.iconBut setBackgroundImage:[UIImage imageNamed:iconStock] forState:UIControlStateNormal];
    
    
    //(3)设置高亮状态下按钮的属性
    [self.iconBut setBackgroundImage:[UIImage imageNamed:iconDown] forState:UIControlStateHighlighted];
    
    
    // 添加到窗口
    [myView addSubview:self.iconBut];
    //3.把对象添加到视图中展现出来
    //[self addSubview:iconBut];
    
    //4.按钮的单击控制事件
    [self.iconBut addTarget:self action:@selector(iconClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //判断位置添加按钮，4个控制按钮
    
    self.settingBut=[UIButton buttonWithType:UIButtonTypeCustom];
    self.startBut=[UIButton buttonWithType:UIButtonTypeCustom];
    self.sleepBut=[UIButton buttonWithType:UIButtonTypeCustom];
    self.stopBut=[UIButton buttonWithType:UIButtonTypeCustom];
    //(1)位置等通用属性设置
    self.settingBut.frame=CGRectMake(0, 0, iconSize, iconSize);
    self.startBut.frame=CGRectMake(0, 0, iconSize, iconSize);
    self.sleepBut.frame=CGRectMake(0, 0, iconSize, iconSize);
    self.stopBut.frame=CGRectMake(0, 0, iconSize, iconSize);
    
    //设置隐藏
    self.settingBut.hidden = YES;
    self.startBut.hidden = YES;
    self.sleepBut.hidden = YES;
    self.stopBut.hidden = YES;
    
    CGPoint butPoint[4];
    // 让图片出生显示
    butPoint[0]= CGPointMake(iconSize + iconSize*0.5,iconSize*0.5);
    butPoint[1]= CGPointMake(iconSize*4 + iconSize*0.5,iconSize*0.5);
    butPoint[2]= CGPointMake(iconSize*3 + iconSize*0.5,iconSize*0.5);
    butPoint[3]= CGPointMake(iconSize*2 + iconSize*0.5,iconSize*0.5);
    self.settingBut.center=butPoint[0];
    self.startBut.center=butPoint[1];
    self.sleepBut.center=butPoint[2];
    self.stopBut.center=butPoint[3];
    //(2)设置普通状态下按钮的属性
    [self.settingBut setBackgroundImage:[UIImage imageNamed:settingImage] forState:UIControlStateNormal];
    [self.startBut setBackgroundImage:[UIImage imageNamed:startImage] forState:UIControlStateNormal];
    [self.sleepBut setBackgroundImage:[UIImage imageNamed:sleepImage] forState:UIControlStateNormal];
    [self.stopBut setBackgroundImage:[UIImage imageNamed:stopImage] forState:UIControlStateNormal];
    //设置高亮光晕
    [self.settingBut setShowsTouchWhenHighlighted:YES];
    [self.startBut setShowsTouchWhenHighlighted:YES];
    [self.sleepBut setShowsTouchWhenHighlighted:YES];
    [self.stopBut setShowsTouchWhenHighlighted:YES];
    // 添加到窗口
    [myView addSubview:self.settingBut];
    [myView addSubview:self.startBut];
    [myView addSubview:self.sleepBut];
    [myView addSubview:self.stopBut];
    //设置tag
    self.settingBut.tag = 100;
    self.startBut.tag = 101;
    self.sleepBut.tag = 102;
    self.stopBut.tag = 103;
    
    
    //4.按钮的单击控制事件
    [self.settingBut addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.startBut addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.sleepBut addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.stopBut addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];

    [pool drain];
}

-(void)createSettingView{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    float zoom = 1;
    if(isPad)
        zoom = 0.8;
    //创建view，添加图片view控件添加到图片view上
    settingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,mainWindow.center.x*2, mainWindow.center.y*2)];
    settingView.center = mainWindow.center;
    [mainWindow addSubview:settingView];
    
    UIImage *image = [UIImage imageNamed:NSMenu];
    UIEdgeInsets insets = UIEdgeInsetsMake(50, 50, 50, 50);
    image = [image resizableImageWithCapInsets:insets resizingMode:(UIImageResizingModeStretch)];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,mainWindow.center.x*2-mainWindow.center.x*0.5, mainWindow.center.y*2 - mainWindow.center.y*0.5)];
    imageView.center = CGPointMake(settingView.frame.size.width*0.5,settingView.frame.size.height*0.5 + settingView.center.y*0.2);
    imageView.image = image;
    imageView.alpha = 0.8;
    [settingView addSubview:imageView];
    
    //隐藏view
    settingView.hidden = YES;
    //外面view添加事件，点击外面隐藏显示按钮
    UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    //选择触发事件的方式（默认单机触发）
    [tapGesturRecognizer setNumberOfTapsRequired:1];
    [settingView addGestureRecognizer:tapGesturRecognizer];
    
    //添加页面选择控件settingView
    UISegmentedControl * segment = [[UISegmentedControl alloc] initWithItems:@[@"日常",@"队伍",@"跑环",@"其它",@"账号"]];
    //segment.frame = CGRectMake(mainWindow.center.x - mainWindow.center.x*0.5, mainWindow.center.y*0.25,mainWindow.center.x, mainWindow.center.y*0.18);
    segment.selectedSegmentIndex = 0;//默认选择日常
    segment.tintColor = self.textColor;//修改默认的色
    segment.backgroundColor = RGB(202, 158, 104);
    segment.layer.frame = CGRectMake(mainWindow.center.x - mainWindow.center.x*0.5, mainWindow.center.y*0.25, mainWindow.center.x - mainWindow.center.x*0.02, mainWindow.center.y*0.18*zoom);
    //segment.layer.borderWidth = 5;
    segment.layer.borderColor = self.textColor.CGColor;
    segment.layer.cornerRadius = 5;//设置圆角
//    [segment.layer setCornerRadius:5];
//    segment.layer.masksToBounds = YES;
    segment.alpha = 0.9;

    [settingView addSubview:segment];
    //添加事件
    [segment addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    
    
    //添加点选控件，5个页面
    for (int i=0; i<viewPage; i++) {
        addView[i] = [[UIView alloc] initWithFrame:CGRectMake(0, 0,mainWindow.center.x*2-mainWindow.center.x*0.5, mainWindow.center.y*2 - mainWindow.center.y*0.5)];
        addView[i].center = CGPointMake(settingView.frame.size.width*0.5,settingView.frame.size.height*0.5 + settingView.center.y*0.2);
        [settingView addSubview:addView[i]];
        UITapGestureRecognizer *topKeep=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(topKeep:)];
        //选择触发事件的方式（默认单机触发）
        [topKeep setNumberOfTapsRequired:1];
        [addView[i] addGestureRecognizer:topKeep];
    }

    //添加控件
    [self craeteView0];
    [self craeteView1];
    [self craeteView2];
    [self craeteView3];
    [self craeteView4];
    //隐藏界面节省资源
    for (int i=1; i<viewPage; i++) {
        addView[i].hidden = YES;
    }
    [pool drain];
}

-(void)craeteView0{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    int view = 0;
    NSString *str;
    [self createSwitch:view point:CGPointMake(addView[view].center.x*0.2, addView[view].center.y*0.25) str:@"主线任务" tag:900];
    [self createSwitch:view point:CGPointMake(addView[view].center.x*0.2, addView[view].center.y*0.45) str:@"师门任务" tag:901];
    [self createSwitch:view point:CGPointMake(addView[view].center.x*0.4, addView[view].center.y*0.45) str:@"抓鬼任务" tag:902];
    [self createSwitch:view point:CGPointMake(addView[view].center.x*0.6, addView[view].center.y*0.45) str:@"打宝任务" tag:903];
    [self createSwitch:view point:CGPointMake(addView[view].center.x*0.2, addView[view].center.y*0.65) str:@"挖宝任务" tag:904];
    [self createSwitch:view point:CGPointMake(addView[view].center.x*0.4, addView[view].center.y*0.65) str:@"封妖任务" tag:905];
    [self createSwitch:view point:CGPointMake(addView[view].center.x*0.6, addView[view].center.y*0.65) str:@"普通运镖" tag:906];
    [self createSwitch:view point:CGPointMake(addView[view].center.x*0.2, addView[view].center.y*0.85) str:@"高级运镖" tag:907];
    [self createSwitch:view point:CGPointMake(addView[view].center.x*0.4, addView[view].center.y*0.85) str:@"随机答题" tag:908];
    [self createSwitch:view point:CGPointMake(addView[view].center.x*0.6, addView[view].center.y*0.85) str:@"副本任务" tag:909];
    [self createSwitch:view point:CGPointMake(addView[view].center.x*0.2, addView[view].center.y + addView[view].center.y*0.05) str:@"秘境任务" tag:910];
    [self createSwitch:view point:CGPointMake(addView[view].center.x*0.4, addView[view].center.y + addView[view].center.y*0.05) str:@"跑环任务" tag:911];
    [self createSwitch:view point:CGPointMake(addView[view].center.x*0.6, addView[view].center.y + addView[view].center.y*0.05) str:@"帮派任务" tag:912];
    UISlider * smSlider1 = [self createSlider:view point:CGPointMake(addView[view].center.x*0.7, addView[view].center.y*0.18) min:0 max:1000 width:addView[view].frame.size.width*0.5 tag:913];
    sliderLabel[0] = [[UILabel alloc] initWithFrame:CGRectMake(0, -smSlider1.frame.size.height, smSlider1.frame.size.width, smSlider1.frame.size.height)];
    if(smSlider1.value>0){
        str = [NSString stringWithFormat:@"师门超过 :%.0f0 金币重接", smSlider1.value];
    }else{
        str = @"师门超过 :0 金币重接";
    }
    sliderLabel[0].text = str;
    sliderLabel[0].font = [UIFont systemFontOfSize:iconSize*0.4];//采用系统默认文字设置大小
    sliderLabel[0].textColor = self.textColor;//其中textColor要用UIColor类型
    sliderLabel[0].textAlignment = NSTextAlignmentLeft;
    [smSlider1 addSubview:sliderLabel[0]];
    UISlider * smSlider2 = [self createSlider:view point:CGPointMake(addView[view].center.x*0.7, addView[view].center.y*0.38) min:0 max:1000 width:addView[view].frame.size.width*0.5 tag:914];
    sliderLabel[1] = [[UILabel alloc] initWithFrame:CGRectMake(0, -smSlider2.frame.size.height, smSlider2.frame.size.width, smSlider2.frame.size.height)];
    if(smSlider2.value>0){
        str = [NSString stringWithFormat:@"帮派超过 :%.0f0 金币重接", smSlider2.value];
    }else{
        str = @"帮派超过 :0 金币重接";
    }
    sliderLabel[1].text = str;
    sliderLabel[1].font = [UIFont systemFontOfSize:iconSize*0.4];//采用系统默认文字设置大小
    sliderLabel[1].textColor = self.textColor;//其中textColor要用UIColor类型
    sliderLabel[1].textAlignment = NSTextAlignmentLeft;
    [smSlider2 addSubview:sliderLabel[1]];
    
    UISlider * smSlider3 = [self createSlider:view point:CGPointMake(addView[view].center.x*0.7, addView[view].center.y*0.58) min:0 max:100 width:addView[view].frame.size.width*0.5 tag:915];
    sliderLabel[3] = [[UILabel alloc] initWithFrame:CGRectMake(0, -smSlider3.frame.size.height, smSlider3.frame.size.width, smSlider3.frame.size.height)];
    if(smSlider3.value>0){
        str = [NSString stringWithFormat:@"帮派超过 :%.0f0000 银币重接", smSlider3.value];
    }else{
        str = @"帮派超过 :0 银币重接";
    }
    sliderLabel[3].text = str;
    sliderLabel[3].font = [UIFont systemFontOfSize:iconSize*0.4];//采用系统默认文字设置大小
    sliderLabel[3].textColor = self.textColor;//其中textColor要用UIColor类型
    sliderLabel[3].textAlignment = NSTextAlignmentLeft;
    [smSlider3 addSubview:sliderLabel[3]];
    
    UISlider * smSlider4 = [self createSlider:view point:CGPointMake(addView[view].center.x*0.7, addView[view].center.y*0.78) min:0 max:30 width:addView[view].frame.size.width*0.5 tag:916];
    sliderLabel[11] = [[UILabel alloc] initWithFrame:CGRectMake(0, -smSlider4.frame.size.height, smSlider4.frame.size.width, smSlider4.frame.size.height)];
    if(smSlider4.value>0){
        str = [NSString stringWithFormat:@"秘境几关结束 :%.0f", smSlider4.value];
    }else{
        str = @"秘境几关结束 :死亡结束";
    }
    sliderLabel[11].text = str;
    sliderLabel[11].font = [UIFont systemFontOfSize:iconSize*0.4];//采用系统默认文字设置大小
    sliderLabel[11].textColor = self.textColor;//其中textColor要用UIColor类型
    sliderLabel[11].textAlignment = NSTextAlignmentLeft;
    [smSlider4 addSubview:sliderLabel[11]];
    
    UISlider * smSlider5 = [self createSlider:view point:CGPointMake(addView[view].center.x*0.3, addView[view].center.y*0.19) min:0 max:4 width:addView[view].frame.size.width*0.28 tag:917];
    sliderLabel[12] = [[UILabel alloc] initWithFrame:CGRectMake(0, -smSlider5.frame.size.height, smSlider5.frame.size.width, smSlider5.frame.size.height)];
    str = [NSString stringWithFormat:@"任务循环 :%.0f", smSlider5.value+1];
    sliderLabel[12].text = str;
    sliderLabel[12].font = [UIFont systemFontOfSize:iconSize*0.4];//采用系统默认文字设置大小
    sliderLabel[12].textColor = self.textColor;//其中textColor要用UIColor类型
    sliderLabel[12].textAlignment = NSTextAlignmentLeft;
    [smSlider5 addSubview:sliderLabel[12]];
    
    [self createSeg:view point:CGPointMake(addView[view].center.x*0.79, addView[view].center.y+addView[view].center.y*0.01) width:addView[view].frame.size.width*0.4 array:@[@"一次",@"二次",@"三次"] str:@"主线红尘死亡结束" tag:918];

//    [self createSeg:view point:CGPointMake(addView[view].center.x*0.79, addView[view].center.y+addView[view].center.y*0.01) width:addView[view].frame.size.width*0.4 array:@[@"一轮",@"二轮",@"三轮",@"四轮",@"五轮"] str:@"任务循环" tag:917];
    [pool drain];
}

-(void)craeteView1{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    int view = 1;
    NSString *str;
    
    [self createSeg:view point:CGPointMake(addView[view].center.x*0.15, addView[view].center.y*0.21) width:addView[view].frame.size.width*0.25 array:@[@"固定队",@"随机队"] str:@"抓鬼队伍类型" tag:800];

    [self createSeg:view point:CGPointMake(addView[view].center.x*0.15, addView[view].center.y*0.46) width:addView[view].frame.size.width*0.4 array:@[@"三人",@"四人",@"五人"] str:@"抓鬼匹配人数" tag:801];
    
    [self createSeg:view point:CGPointMake(addView[view].center.x*0.15, addView[view].center.y*0.71) width:addView[view].frame.size.width*0.25 array:@[@"固定队",@"随机队"] str:@"副本队伍类型" tag:802];
    
    [self createSeg:view point:CGPointMake(addView[view].center.x*0.15, addView[view].center.y*0.96) width:addView[view].frame.size.width*0.4 array:@[@"三人",@"四人",@"五人"] str:@"副本匹配人数" tag:803];
    
    UISlider *slider = [self createSlider:view point:CGPointMake(addView[view].center.x*0.7, addView[view].center.y*0.2) min:0 max:10 width:addView[view].frame.size.width*0.5 tag:804];
    sliderLabel[2] = [[UILabel alloc] initWithFrame:CGRectMake(0, -slider.frame.size.height, slider.frame.size.width, slider.frame.size.height)];
    if(slider.value>0){
        str = [NSString stringWithFormat:@"抓鬼领双环数 :%.0f", slider.value];
    }else{
        str = @"抓鬼领双环数 :不领";
    }
    sliderLabel[2].text = str;
    sliderLabel[2].font = [UIFont systemFontOfSize:iconSize*0.4];//采用系统默认文字设置大小
    sliderLabel[2].textColor = self.textColor;//其中textColor要用UIColor类型
    sliderLabel[2].textAlignment = NSTextAlignmentLeft;
    [slider addSubview:sliderLabel[2]];
    
    UISlider *slider2 = [self createSlider:view point:CGPointMake(addView[view].center.x*0.7, addView[view].center.y*0.4) min:0 max:100 width:addView[view].frame.size.width*0.5 tag:805];
    sliderLabel[9] = [[UILabel alloc] initWithFrame:CGRectMake(0, -slider2.frame.size.height, slider2.frame.size.width, slider2.frame.size.height)];
    if(slider2.value>0){
        str = [NSString stringWithFormat:@"抓鬼轮数 :%.0f", slider2.value];
    }else{
        str = @"抓鬼轮数 :无限";
    }
    sliderLabel[9].text = str;
    sliderLabel[9].font = [UIFont systemFontOfSize:iconSize*0.4];//采用系统默认文字设置大小
    sliderLabel[9].textColor = self.textColor;//其中textColor要用UIColor类型
    sliderLabel[9].textAlignment = NSTextAlignmentLeft;
    [slider2 addSubview:sliderLabel[9]];

    UISlider *slider3 = [self createSlider:view point:CGPointMake(addView[view].center.x*0.7, addView[view].center.y*0.6) min:0 max:30 width:addView[view].frame.size.width*0.5 tag:806];
    sliderLabel[10] = [[UILabel alloc] initWithFrame:CGRectMake(0, -slider3.frame.size.height, slider3.frame.size.width, slider3.frame.size.height)];
    if(slider3.value>0){
        str = [NSString stringWithFormat:@"队伍匹配时间 :%.0f 分钟", slider3.value];
    }else{
        str = @"队伍匹配时间 :无限";
    }
    sliderLabel[10].text = str;
    sliderLabel[10].font = [UIFont systemFontOfSize:iconSize*0.4];//采用系统默认文字设置大小
    sliderLabel[10].textColor = self.textColor;//其中textColor要用UIColor类型
    sliderLabel[10].textAlignment = NSTextAlignmentLeft;
    [slider3 addSubview:sliderLabel[10]];
    
    [self createSeg:view point:CGPointMake(addView[view].center.x*0.8, addView[view].center.y*0.96) width:addView[view].frame.size.width*0.4 array:@[@"50级副本",@"70级副本",@"全部副本"] str:@"" tag:807];
    [pool drain];
}

-(void)craeteView2{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    int view = 2;
    NSString *str;
    [self createSeg:view point:CGPointMake(addView[view].center.x*0.5, addView[view].center.y*0.15) width:addView[view].frame.size.width*0.4 array:@[@"直接购买",@"帮派求助",@"判断金币"] str:@"" tag:600];
    
    UISlider * smSlider = [self createSlider:view point:CGPointMake(addView[view].center.x*0.07, addView[view].center.y*0.35) min:0 max:50 width:addView[view].frame.size.width*0.5 tag:601];
    sliderLabel[4] = [[UILabel alloc] initWithFrame:CGRectMake(0, -smSlider.frame.size.height, smSlider.frame.size.width, smSlider.frame.size.height)];
    if(smSlider.value>0){
        str = [NSString stringWithFormat:@"帮派求助(2分钟/次) :%.0f 次", smSlider.value];
    }else{
        str = @"帮派求助(2分钟/次) :不限";
    }
    sliderLabel[4].text = str;
    sliderLabel[4].font = [UIFont systemFontOfSize:iconSize*0.4];//采用系统默认文字设置大小
    sliderLabel[4].textColor = self.textColor;//其中textColor要用UIColor类型
    sliderLabel[4].textAlignment = NSTextAlignmentLeft;
    [smSlider addSubview:sliderLabel[4]];
    
    UISlider * smSlider1 = [self createSlider:view point:CGPointMake(addView[view].center.x*0.07, addView[view].center.y*0.55) min:0 max:1000 width:addView[view].frame.size.width*0.5 tag:602];
    sliderLabel[5] = [[UILabel alloc] initWithFrame:CGRectMake(0, -smSlider1.frame.size.height, smSlider1.frame.size.width, smSlider1.frame.size.height)];
    if(smSlider1.value>0){
        str = [NSString stringWithFormat:@"超过 :%.0f0 金币去传说", smSlider1.value];
    }else{
        str = @"超过 :0 金币去传说";
    }
    sliderLabel[5].text = str;
    sliderLabel[5].font = [UIFont systemFontOfSize:iconSize*0.4];//采用系统默认文字设置大小
    sliderLabel[5].textColor = self.textColor;//其中textColor要用UIColor类型
    sliderLabel[5].textAlignment = NSTextAlignmentLeft;
    [smSlider1 addSubview:sliderLabel[5]];
    
    UISlider * smSlider2 = [self createSlider:view point:CGPointMake(addView[view].center.x*0.07, addView[view].center.y*0.75) min:0 max:100 width:addView[view].frame.size.width*0.5 tag:603];
    sliderLabel[6] = [[UILabel alloc] initWithFrame:CGRectMake(0, -smSlider2.frame.size.height, smSlider2.frame.size.width, smSlider2.frame.size.height)];
    if(smSlider2.value>0){
        str = [NSString stringWithFormat:@"超过 :%.0f0000 银币去传说", smSlider2.value];
    }else{
        str = @"超过 :0 银币去传说";
    }
    sliderLabel[6].text = str;
    sliderLabel[6].font = [UIFont systemFontOfSize:iconSize*0.4];//采用系统默认文字设置大小
    sliderLabel[6].textColor = self.textColor;//其中textColor要用UIColor类型
    sliderLabel[6].textAlignment = NSTextAlignmentLeft;
    [smSlider2 addSubview:sliderLabel[6]];
    
    UISlider * smSlider3 = [self createSlider:view point:CGPointMake(addView[view].center.x*0.7, addView[view].center.y*0.55) min:0 max:1000 width:addView[view].frame.size.width*0.5 tag:604];
    sliderLabel[7] = [[UILabel alloc] initWithFrame:CGRectMake(0, -smSlider3.frame.size.height, smSlider3.frame.size.width, smSlider3.frame.size.height)];
    if(smSlider3.value>0){
        str = [NSString stringWithFormat:@"超过 :%.0f0 金币结束任务", smSlider3.value];
    }else{
        str = @"超过 :0 金币结束任务";
    }
    sliderLabel[7].text = str;
    sliderLabel[7].font = [UIFont systemFontOfSize:iconSize*0.4];//采用系统默认文字设置大小
    sliderLabel[7].textColor = self.textColor;//其中textColor要用UIColor类型
    sliderLabel[7].textAlignment = NSTextAlignmentLeft;
    [smSlider3 addSubview:sliderLabel[7]];
    
    UISlider * smSlider4 = [self createSlider:view point:CGPointMake(addView[view].center.x*0.7, addView[view].center.y*0.75) min:0 max:100 width:addView[view].frame.size.width*0.5 tag:605];
    sliderLabel[8] = [[UILabel alloc] initWithFrame:CGRectMake(0, -smSlider4.frame.size.height, smSlider4.frame.size.width, smSlider4.frame.size.height)];
    if(smSlider4.value>0){
        str = [NSString stringWithFormat:@"超过 :%.0f0000 银币结束任务", smSlider4.value];
    }else{
        str = @"超过 :0 银币结束任务";
    }
    sliderLabel[8].text = str;
    sliderLabel[8].font = [UIFont systemFontOfSize:iconSize*0.4];//采用系统默认文字设置大小
    sliderLabel[8].textColor = self.textColor;//其中textColor要用UIColor类型
    sliderLabel[8].textAlignment = NSTextAlignmentLeft;
    [smSlider4 addSubview:sliderLabel[8]];
    
    [self createSwitch:view point:CGPointMake(addView[view].center.x + addView[view].center.x*0.1, addView[view].center.y + addView[view].center.y*0.04) str:@"传说前求助" tag:606];
    [self createSwitch:view point:CGPointMake(addView[view].center.x + addView[view].center.x*0.3, addView[view].center.y + addView[view].center.y*0.04) str:@"失败后购买" tag:607];
    [self createSeg:view point:CGPointMake(addView[view].center.x*0.15, addView[view].center.y*0.95) width:addView[view].frame.size.width*0.4 array:@[@"全部任务链",@"道具链",@"经验链"] str:@"" tag:608];
    [pool drain];
}

-(void)craeteView3{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    float zoom = 1;
    if (isPad)
        zoom = 0.8;
    int view = 3;
    [self createSwitch:view point:CGPointMake(addView[view].center.x*0.2, addView[view].center.y*0.25) str:@"接平定+领活跃" tag:500];
    [self createSwitch:view point:CGPointMake(addView[view].center.x*0.2, addView[view].center.y*0.45) str:@"清理背包" tag:501];
    [self createSwitch:view point:CGPointMake(addView[view].center.x*0.4, addView[view].center.y*0.45) str:@"红尘试炼" tag:502];
    [self createSwitch:view point:CGPointMake(addView[view].center.x*0.6, addView[view].center.y*0.45) str:@"每日福利" tag:503];
    [self createSwitch:view point:CGPointMake(addView[view].center.x*0.2, addView[view].center.y*0.85) str:@"全部任务完成后挂机" tag:504];
    [self createSwitch:view point:CGPointMake(addView[view].center.x*0.2, addView[view].center.y+addView[view].center.y*0.05) str:@"挂机领取双倍" tag:505];
    [self createSeg:view point:CGPointMake(addView[view].center.x*0.8, addView[view].center.y*0.15) width:addView[view].frame.size.width*0.4 array:@[@"不制作",@"打工",@"制作烹饪",@"制作药品"] str:@"" tag:506];
    [self createSeg:view point:CGPointMake(addView[view].center.x*0.8, addView[view].center.y*0.3) width:addView[view].frame.size.width*0.4 array:@[@"不卖",@"卖烹饪",@"卖药品"] str:@"" tag:507];
    
    
    
    
    
    UIButton *reSetBut = [UIButton buttonWithType:UIButtonTypeCustom];
    reSetBut.frame = CGRectMake(addView[view].center.x - (addView[view].center.x*0.1), addView[view].center.y - addView[view].center.y*0.03, addView[view].frame.size.width*0.2, addView[view].frame.size.height*0.1*zoom);
    [reSetBut setBackgroundImage:[UIImage imageNamed:NSBut] forState:UIControlStateNormal];
    //设置高亮光晕
//    [reSetBut setShowsTouchWhenHighlighted:YES];
    //设置透明
    reSetBut.alpha = 0.8;
    //设置文字
    [reSetBut setTitle:@"重置设置信息" forState:UIControlStateNormal];
    reSetBut.titleLabel.font = [UIFont systemFontOfSize:iconSize*0.3];
    [reSetBut setTitleColor:self.textColor forState:UIControlStateNormal];
    [addView[view] addSubview:reSetBut];
    //按钮点击事件
    [reSetBut addTarget:self action:@selector(reSetButClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self createSwitch:view point:CGPointMake(addView[view].center.x + addView[view].center.x*0.3, addView[view].center.y + addView[view].center.y*0.05) str:@"隐藏控制台" tag:999];
    [pool drain];
}

-(void)craeteView4{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    int view = 4;
    [self createSwitch:view point:CGPointMake(addView[view].center.x*0.2, addView[view].center.y*0.25) str:@"多号日常" tag:400];
    [pool drain];
}

-(void)reSetButClick:(UIButton *)button{

    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"NS提示"
                                                            message:@"关闭游戏后生效！"
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"OK", nil];
        // 显示弹出框
        [alertView show];
        [alertView release];
    });
    /*
    // 1.创建UIAlertController
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"NS提示"
                                            message:@"关闭游戏后生效！"
                                            preferredStyle:UIAlertControllerStyleAlert];
    // 2.创建并添加按钮
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"OK Action");
        exit(0);
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Cancel Action");
        [self setController:@"需要重启游戏设置重置"];
    }];
    
    [alertController addAction:okAction];           // A
    [alertController addAction:cancelAction];       // B
    // 3.呈现UIAlertContorller
    [self presentViewController:alertController animated:YES completion:nil];
     */
}
//监听点击事件 代理方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSString *btnTitle = [alertView buttonTitleAtIndex:buttonIndex];
    if ([btnTitle isEqualToString:@"Cancel"]) {
        [self setController:@"取消重置设置"];
    }else if ([btnTitle isEqualToString:@"OK"] ) {
//        NSUserDefaults *defatluts = [NSUserDefaults standardUserDefaults];
        NSDictionary *dictionary = [defaults dictionaryRepresentation];
        for(NSString *key in [dictionary allKeys]){
            [defaults removeObjectForKey:key];
            [defaults synchronize];
        }
        exit(0);
    }
    [pool drain];
}

-(UISegmentedControl *)createSeg:(int)view point:(CGPoint)point width:(int)width array:(NSArray *)array str:(NSString*)str tag:(int)tag{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    float zoom = 1;
    if(isPad)
        zoom = 0.7;
    UISegmentedControl * seg = [[UISegmentedControl alloc] initWithItems:array];
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *key = [NSString stringWithFormat:@"%d",tag];
    seg.selectedSegmentIndex = [defaults integerForKey: key];//默认选择日常
    seg.tintColor = self.textColor;//修改默认的色
    UIFont *font = [UIFont boldSystemFontOfSize:iconSize*0.3];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    [seg setTitleTextAttributes:attributes forState:UIControlStateNormal];
    seg.frame = CGRectMake(point.x, point.y, width, addView[view].frame.size.height*0.1*zoom);
    seg.tag = tag;
    [addView[view] addSubview:seg];
    //添加事件
    [seg addTarget:self action:@selector(segmentChange:) forControlEvents:UIControlEventValueChanged];
    if(![str isEqual:@""]){
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, -seg.frame.size.height, seg.frame.size.width, seg.frame.size.height)];
        label.text = str;
        label.font = [UIFont systemFontOfSize:iconSize*0.3];//采用系统默认文字设置大小
        label.textColor = self.textColor;//其中textColor要用UIColor类型
        label.textAlignment = NSTextAlignmentCenter;
        [seg addSubview:label];
    }
    [pool drain];
    return seg;
}

-(UISlider *)createSlider:(int)view point:(CGPoint)point min:(int)min max:(int)max width:(int)width tag:(int)tag{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    float zoom = 1;
    if(isPad)
        zoom = 0.7;
    float Scale = 0.2;
    if(mainWindow.bounds.size.width<568)
        Scale = 0.1;
    float zoomSlider = mainWindow.bounds.size.height/mainWindow.bounds.size.width + Scale;
    UISlider *sl = [[UISlider alloc] initWithFrame:CGRectMake(point.x, point.y, width, addView[view].frame.size.height*0.1)];
    sl.minimumValue = min;
    sl.maximumValue = max;
    sl.userInteractionEnabled=YES;
    //初始化状态
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *key = [NSString stringWithFormat:@"%d",tag];
    sl.value = [defaults integerForKey:key];
    sl.transform = CGAffineTransformMakeScale(zoomSlider*zoom, zoomSlider*zoom);//缩放
    sl.tag = tag;
    
    [addView[view] addSubview:sl];
    

    //添加事件
    [sl addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [pool drain];
    return sl;
}

-(UISwitch *)createSwitch:(int)view point:(CGPoint)point str:(NSString*)str tag:(int)tag{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    float zoom = 1;
    if(isPad)
        zoom = 0.9;
    float Scale = 0.2;
    if(mainWindow.bounds.size.width<568)
        Scale = 0.1;
    float zoomSwitch = mainWindow.bounds.size.height/mainWindow.bounds.size.width + Scale;
//    NSLog(@"test--------:%f-------%f",zoom,mainWindow.frame.size.width);
    UISwitch * sw = [[UISwitch alloc] init];
    sw.center = CGPointMake(point.x, point.y);
    sw.transform = CGAffineTransformMakeScale(zoomSwitch*zoom, zoomSwitch*zoom);//缩放
    [addView[view] addSubview:sw];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, -sw.frame.size.height, sw.frame.size.width*4, sw.frame.size.height)];
    label.text = str;
    label.font = [UIFont systemFontOfSize:iconSize*0.35];//采用系统默认文字设置大小
    label.textColor = self.textColor;//其中textColor要用UIColor类型
    label.textAlignment = NSTextAlignmentLeft;
    [sw addSubview:label];
    sw.tag = tag;
    //初始化状态
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *key = [NSString stringWithFormat:@"%d",tag];
    sw.on = [defaults boolForKey:key];
    //有事件的控件
    if(tag==999)
        self.imageViewController.hidden = [defaults boolForKey:key];
    //添加事件
    [sw addTarget:self action:@selector(switchController:) forControlEvents:UIControlEventValueChanged];
    [pool drain];
    return sw;
}

-(void)segmentChange:(UISegmentedControl *)seg{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    //保存配置
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *key = [NSString stringWithFormat:@"%d",(int)seg.tag];
    [defaults setInteger:seg.selectedSegmentIndex forKey:key];
    [defaults synchronize];
    [pool drain];
}

-(void)sliderValueChanged:(UISlider *)sl{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSString *str;
    switch (sl.tag) {
        case 601:
            if(sl.value>1){
                str = [NSString stringWithFormat:@"帮派求助(2分钟/次) :%.0f 次", sl.value];
            }else{
                str = @"帮派求助(2分钟/次) :不限";
            }
            sliderLabel[4].text = str;
            break;
        case 602:
            if(sl.value>1){
                str = [NSString stringWithFormat:@"超过 :%.0f0 金币去传说", sl.value];
            }else{
                str = @"超过 :0 金币去传说";
            }
            sliderLabel[5].text = str;
            break;
        case 603:
            if(sl.value>1){
                str = [NSString stringWithFormat:@"超过 :%.0f0000 银币去传说", sl.value];
            }else{
                str = @"超过 :0 银币去传说";
            }
            sliderLabel[6].text = str;
            break;
        case 604:
            if(sl.value>1){
                str = [NSString stringWithFormat:@"超过 :%.0f0 金币结束任务", sl.value];
            }else{
                str = @"超过 :0 金币结束任务";
            }
            sliderLabel[7].text = str;
            break;
        case 605:
            if(sl.value>1){
                str = [NSString stringWithFormat:@"超过 :%.0f0000 银币结束任务", sl.value];
            }else{
                str = @"超过 :0 银币结束任务";
            }
            sliderLabel[8].text = str;
            break;
        case 804:
            if(sl.value>1){
                str = [NSString stringWithFormat:@"抓鬼领双环数 :%.0f", sl.value];
            }else{
                str = @"抓鬼领双环数 :不领";
            }
            sliderLabel[2].text = str;
            break;
        case 805:
            if(sl.value>1){
                str = [NSString stringWithFormat:@"抓鬼轮数 :%.0f", sl.value];
            }else{
                str = @"抓鬼轮数 :无限";
            }
            sliderLabel[9].text = str;
            break;
        case 806:
            if(sl.value>1){
                str = [NSString stringWithFormat:@"队伍匹配时间 :%.0f 分钟", sl.value];
            }else{
                str = @"队伍匹配时间 :无限";
            }
            sliderLabel[10].text = str;
            break;
        case 913:
            if(sl.value>1){
                str = [NSString stringWithFormat:@"师门超过 :%.0f0 金币重接", sl.value];
            }else{
                str = @"师门超过 :0 金币重接";
            }
            sliderLabel[0].text = str;
            break;
        case 914:
            if(sl.value>1){
                str = [NSString stringWithFormat:@"帮派超过 :%.0f0 金币重接", sl.value];
            }else{
                str = @"帮派超过 :0 金币重接";
            }
            sliderLabel[1].text = str;
            break;
        case 915:
            if(sl.value>1){
                str = [NSString stringWithFormat:@"帮派超过 :%.0f0000 银币重接", sl.value];
            }else{
                str = @"帮派超过 :0 银币重接";
            }
            sliderLabel[3].text = str;
            break;
        case 916:
            if(sl.value>1){
                str = [NSString stringWithFormat:@"秘境几关结束 :%.0f", sl.value];
            }else{
                str = @"秘境几关结束 :死亡结束";
            }
            sliderLabel[11].text = str;
            break;
        case 917:
            str = [NSString stringWithFormat:@"任务循环 :%.0f", sl.value + 1];
            sliderLabel[12].text = str;
            break;
        default:
            break;
    }
    //保存配置
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *key = [NSString stringWithFormat:@"%d",(int)sl.tag];
    [defaults setInteger:sl.value forKey:key];
    [defaults synchronize];
    [pool drain];
}

-(void)switchController:(UISwitch *)sw{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    switch (sw.tag) {
        case 901:
            [self shunxuPaixu:sw str:@"师" num:0];
            break;
        case 902:
            [self shunxuPaixu:sw str:@"鬼" num:1];
            break;
        case 903:
            [self shunxuPaixu:sw str:@"打" num:2];
            break;
        case 904:
            [self shunxuPaixu:sw str:@"挖" num:3];
            break;
        case 905:
            [self shunxuPaixu:sw str:@"封" num:4];
            break;
        case 906:
            [self shunxuPaixu:sw str:@"普" num:5];
            break;
        case 907:
            [self shunxuPaixu:sw str:@"高" num:6];
            break;
        case 908:
            [self shunxuPaixu:sw str:@"答" num:7];
            break;
        case 909:
            [self shunxuPaixu:sw str:@"副" num:8];
            break;
        case 910:
            [self shunxuPaixu:sw str:@"秘" num:9];
            break;
        case 911:
            [self shunxuPaixu:sw str:@"环" num:10];
            break;
        case 912:
            [self shunxuPaixu:sw str:@"帮" num:11];
            break;
        case 999:
            self.imageViewController.hidden = sw.isOn;
            break;
        default:
            break;
    }
    
    //保存配置
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *key = [NSString stringWithFormat:@"%d",(int)sw.tag];
    [defaults setBool:sw.isOn forKey:key];
    [defaults synchronize];
    [pool drain];
}

-(void)shunxuPaixu:(UISwitch *)sw str:(NSString *)str num:(int)num{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSString *bc = @"";
    if(sw.isOn){
        [shunxu addObject:str];
        for (int i=0; i<shunxu.count; i++) {
            bc = [NSString stringWithFormat:@"%@%@",bc,[shunxu objectAtIndex:i]];
        }
        [self setController:bc];
    }else if(shunxu.count>0){
        [shunxu removeObject:str];
        for (int i=0; i<shunxu.count; i++) {
            bc = [NSString stringWithFormat:@"%@%@",bc,[shunxu objectAtIndex:i]];
        }
        if([bc  isEqual: @""])
            bc = @"任务全部关闭";
        [self setController:bc];
    }
    //保存配置
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:shunxu forKey:@"mission"];
    [defaults synchronize];
    [pool drain];
}

-(NSMutableArray *)getMissionSort{
    return shunxu;
}

-(void)segmentAction:(UISegmentedControl *)seg{
    
    NSInteger Index = seg.selectedSegmentIndex;
    NSLog(@"Index %ld", (long)Index);

    addView[Index].hidden = NO;
    for (int i=0; i<viewPage; i++) {
        if(i != Index)
            addView[i].hidden = YES;
    }

}

-(void)topKeep:(UITapGestureRecognizer *)gesture//保持界面不被隐藏
{
    return;
}

-(void)tapAction:(UITapGestureRecognizer *)gesture
{
    [self setController:@"设置完成！"];
    if(nsthread_pause){
        nsthread_pause = false;
        [nsLua thread_pause:false];
    }
    myView.hidden = NO;
    settingView.hidden = YES;
}

-(void)autoRunScript{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSDictionary *reply;
    reply = [nsServer sendMessageAndReceiveReplyName:@"NSAUTOSP" userInfo:nil];
    
    NSString *object = [reply objectForKey:@"RunScript"];
    
    if([object isEqualToString:@"YES"]){
        nsthread_create = true;
        [nsLua thread_exit:false];
        [nsLua performSelectorOnMainThread:@selector(runLuaScript) withObject:nil waitUntilDone:NO];
    }
    [pool drain];
}

-(void)buttonClick:(UIButton *)button{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    if(button.tag == 100){
        
        replyBut = [nsServer sendMessageAndReceiveReplyName:@"NSTEST" userInfo:nil];
        
        objectBut = [replyBut objectForKey:@"MyTest"];
//        [self setController:@"设置中ing..."];
        [self setController:objectBut];
        if(nsthread_create){
            nsthread_pause = true;
            [nsLua thread_pause:true];
        }
        self.iconClickShow=true;
        [self iconClick:self.iconBut];
        myView.hidden = YES;
        settingView.hidden = NO;
    }else if(button.tag == 101){
        [self iconClick:self.iconBut];
        [nsServer sendMessageName:@"NSSTART" userInfo:nil];
        if(!nsthread_pause && !nsthread_create){
            [self setController:@"开始运行脚本"];
//            NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
            //保存配置
//            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:@"YES" forKey:@"actiontime"];
            if(shunxu.count>0)
                [defaults setObject:shunxu[0] forKey:@"nsstring"];
            [defaults synchronize];
            nsthread_create = true;
            [nsLua thread_exit:false];
            [nsLua performSelectorOnMainThread:@selector(runLuaScript) withObject:nil waitUntilDone:NO];
//            [pool drain];
        }else
        {
            [self setController:@"继续运行脚本"];
            nsthread_pause = false;
            [nsLua thread_pause:false];
        }
    }else if(button.tag == 102){
        [self setController:@"暂停脚本"];
        [nsServer sendMessageName:@"NSEND" userInfo:nil];
        if(nsthread_create){
            nsthread_pause = true;
            [nsLua thread_pause:true];
        }
    }else if(button.tag == 103){
        [self setController:@"停止脚本"];
        [nsServer sendMessageName:@"NSEND" userInfo:nil];
        if(nsthread_create){
            nsthread_create = false;
            nsthread_pause = false;
            [nsLua thread_pause:false];
            [nsLua thread_exit:true];
        }
    }
    [pool drain];
}

-(void)newLuaThread{
    [nsServer sendMessageName:@"NSEND" userInfo:nil];
    nsthread_create = false;
    nsthread_pause = false;
}

-(void)iconClick:(UIButton *)button
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    CGRect btnFrame = myView.frame;
    if(!self.iconClickShow){
        float angle;
        [button setBackgroundImage:[UIImage imageNamed:iconDown] forState:UIControlStateNormal];
        self.iconClickShow=true;
        //旋转控件方向
        if(myView.center.x <= iconSize*0.5){//左边
            if(!butRotate[0]){
                angle = 0;
                self.iconBut.transform = CGAffineTransformMakeRotation(-angle);
                myView.transform = CGAffineTransformMakeRotation(angle);
            }
            for (int i=0; i<4; i++) {
                if(i == 0)
                    butRotate[i]=true;
                else
                    butRotate[i]=false;
            }
        }else if(myView.center.x >= mainWindow.center.x*2 - iconSize*0.5){//右边
            if(!butRotate[1]){
                angle = M_PI;
                self.iconBut.transform = CGAffineTransformMakeRotation(-angle);
                myView.transform = CGAffineTransformMakeRotation(angle);
            }
            for (int i=0; i<4; i++) {
                if(i == 1)
                    butRotate[i]=true;
                else
                    butRotate[i]=false;
            }
        }else if(myView.center.y <= iconSize*0.5){//上边
            if(!butRotate[2]){
                angle = M_PI_2;
                self.iconBut.transform = CGAffineTransformMakeRotation(-angle);
                myView.transform = CGAffineTransformMakeRotation(angle);
            }
            for (int i=0; i<4; i++) {
                if(i == 2)
                    butRotate[i]=true;
                else
                    butRotate[i]=false;
            }
        }else if(myView.center.y >= mainWindow.center.y*2 - iconSize*0.5){//下边
            if(!butRotate[3]){
                angle = -M_PI_2;
                self.iconBut.transform = CGAffineTransformMakeRotation(-angle);
                myView.transform = CGAffineTransformMakeRotation(angle);
            }
            for (int i=0; i<4; i++) {
                if(i == 3)
                    butRotate[i]=true;
                else
                    butRotate[i]=false;
            }
        }
        //设置可见
        self.settingBut.hidden = NO;
        self.startBut.hidden = NO;
        self.sleepBut.hidden = NO;
        self.stopBut.hidden = NO;
        //设置view变长
        if(butRotate[0]){
            btnFrame.origin.x = 0;
        }else if(butRotate[1]){
            btnFrame.origin.x -= iconSize*4;
        }else if(butRotate[2]){
            btnFrame.origin.y = 0;
        }else if(butRotate[3]){
            btnFrame.origin.y = mainWindow.center.y*2 - iconSize*5;
        }
        if(butRotate[0] || butRotate[1]){
            btnFrame.size.width = iconSize*5;
        }else{
            btnFrame.size.height = iconSize*5;
        }
        myView.frame = btnFrame;
        
    }else{
        [button setBackgroundImage:[UIImage imageNamed:iconStock] forState:UIControlStateNormal];
        self.iconClickShow=false;
        
        //设置隐藏
        self.settingBut.hidden = YES;
        self.startBut.hidden = YES;
        self.sleepBut.hidden = YES;
        self.stopBut.hidden = YES;
        int width = btnFrame.size.width;
        int height = btnFrame.size.height;
        //view变小，必须先变小在移动
        if(butRotate[0] || butRotate[1]){
            btnFrame.size.width = iconSize;
        }else{
            btnFrame.size.height = iconSize;
        }
        myView.frame = btnFrame;
        
        //如果左边就x=0，右边x=mainWindow。x，上y=0，下y=mainWindow。y
        NSLog(@"%f  -  %f  =  %f",myView.center.x,mainWindow.center.x*2,myView.center.x - mainWindow.center.x*2);
        if(myView.center.x <= iconSize*0.5){
            NSLog(@"在左边");
            myView.center = CGPointMake(iconSize*0.5,myView.center.y);
        }else if(myView.center.x >= mainWindow.center.x*2 - iconSize*5 && width > iconSize){
            NSLog(@"在右边");
            myView.center = CGPointMake(mainWindow.center.x*2 - iconSize*0.5,myView.center.y);
        }else if(myView.center.y <= iconSize*0.5){
            NSLog(@"在上边");
            myView.center = CGPointMake(myView.center.x,iconSize*0.5);
        }else if(myView.center.y >= mainWindow.center.y*2 - iconSize*5 && height > iconSize){
            NSLog(@"在下边");
            myView.center = CGPointMake(myView.center.x,mainWindow.center.y*2 - iconSize*0.5);
        }
        
        
    }
    [pool drain];
}

- (void) handlePanGestures:(UIPanGestureRecognizer*)paramSender{
    if(self.iconClickShow)
        return;
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    //通过使用 locationInView 这个方法,来获取到手势的坐标
    CGPoint location = [paramSender locationInView:paramSender.view.superview];
    if(paramSender.state == UIGestureRecognizerStateBegan)
        [self.iconBut setBackgroundImage:[UIImage imageNamed:iconDown] forState:UIControlStateNormal];
    if(paramSender.state == UIGestureRecognizerStateEnded){
        //还原图标
        [self.iconBut setBackgroundImage:[UIImage imageNamed:iconStock] forState:UIControlStateNormal];
        //判断当前位置，然后找到最近点移动过去
        //paramSender.view.center.x
        //paramSender.view.center.y
        int iconCenter = iconSize*0.5;
        int y = location.y;
        int x = location.x;
        if(y - iconCenter < 0)
            y = iconCenter;
        if(y + iconCenter > mainWindow.center.y*2)
            y = mainWindow.center.y*2 - iconCenter;
        if(x - iconCenter < 0)
            x = iconCenter;
        if(x +iconCenter > mainWindow.center.x*2)
            x = mainWindow.center.x*2 - iconCenter;
        if(x - iconCenter <= 0)//zuoshang
        {
            NSLog(@"左上");
            paramSender.view.center = CGPointMake(iconCenter,y);
            return;
        }
        
        if(x + iconCenter >= mainWindow.center.x*2)//zuoxia
        {
            paramSender.view.center = CGPointMake(mainWindow.center.x*2 - iconCenter,y);
            return;
        }
        NSLog(@"-----%d------",y-iconCenter);
        if(y - iconCenter <= 0)//youshang
        {
            NSLog(@"右上");
            paramSender.view.center = CGPointMake(x,iconCenter);
            return;
        }
        if(y + iconCenter >= mainWindow.center.y*2)//youxia
        {
            NSLog(@"右下");
            paramSender.view.center = CGPointMake(x,mainWindow.center.y*2 - iconCenter);
            return;
        }
        
        if(x < iconSize * 3)//zuo
        {
            [UIView animateWithDuration:0.4 animations:^{
                paramSender.view.center = CGPointMake(iconCenter,y);
            }];
            return;
        }
        
        if(x > (mainWindow.center.x * 2) - (iconSize * 3))//you
        {
            [UIView animateWithDuration:0.4 animations:^{
                paramSender.view.center = CGPointMake((mainWindow.center.x * 2) - iconCenter,y);
            }];
            return;
        }
        
        if(y < mainWindow.center.y && x > iconSize * 2 && x > iconSize * 3 && x < (mainWindow.center.x * 2) - (iconSize * 3))//shang
        {
            [UIView animateWithDuration:0.4 animations:^{
                paramSender.view.center = CGPointMake(x, iconCenter);
            }];
            return;
        }
        
        if(y > mainWindow.center.y && x < (mainWindow.center.x * 2) - (iconSize * 2) && x > iconSize * 3 && x < (mainWindow.center.x * 2) - (iconSize * 3))//xia
        {
            [UIView animateWithDuration:0.4 animations:^{
                paramSender.view.center = CGPointMake(x, (mainWindow.center.y * 2) - iconCenter);
            }];
            return;
        }
    }
    
    if (paramSender.state != UIGestureRecognizerStateEnded && paramSender.state != UIGestureRecognizerStateFailed){ 
        paramSender.view.center = location; 
    }
    [pool drain];
}

@end
