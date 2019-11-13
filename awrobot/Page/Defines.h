//
//  Defines.h
//  test2
//
//  Created by 刘卓林 on 2018/1/22.
//  Copyright © 2018年 刘卓林. All rights reserved.
//

#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)

#define serverName @"com.NS_IOS_MHXY.server"

#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define WIDTH self.view.frame.size.width
#define HEIGHT self.view.frame.size.height
#define kScreenWidth [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height

#define appPath [[NSBundle mainBundle] bundlePath]

#define RegisterURL @"http://w.eydata.net/02678856006c321f"
#define RepasswordURL @"http://w.eydata.net/8728e157fcc7b8d2"
#define LoginURL @"http://w.eydata.net/13234c2a7e299b65"
#define TimeURL @"http://w.eydata.net/66aa5f845c6349b0"
#define TopupURL @"http://w.eydata.net/d5ae88c4e757149d"
#define OutLoginURL @"http://w.eydata.net/ffe9d25a5567e9fb"
#define ClearDataURL @"http://w.eydata.net/834155cac43d7069"
#define ChangePasswordURL @"http://w.eydata.net/fc39399e6c8222b7"
#define BulletinURL @"http://w.eydata.net/8c869199b8c247e1"

#define AotocardURL @"http://k.1ka123.com/item/quiiya.html"

#define TaobaoURL @"https://shop122676084.taobao.com"

#define WebURL @"http://32ecd9e5b9774995a48d832e40048e7b.wqdian.cn/"

#define Version @"版本v1.3"
