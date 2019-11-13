//
//  NSBasePage.m
//  test2
//
//  Created by 刘卓林 on 2018/1/22.
//  Copyright © 2018年 刘卓林. All rights reserved.
//

#import "NSBasePage.h"

@interface NSBasePage ()

@end

@implementation NSBasePage

- (void)viewDidLoad {
    [super viewDidLoad];

}

-(void)setNavigationItem:(NSString *)title selector:(SEL)selector isRight:(BOOL)isRight{
    UIBarButtonItem *item;
    if([title hasSuffix:@"png"]){
        UIImage *image = [UIImage imageNamed:title];
        item = [[UIBarButtonItem alloc] initWithImage:[self scaleImage:image toScale:WIDTH*0.1*0.1*0.1] style:UIBarButtonItemStylePlain target:self action:selector];
    }else{
        item = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:selector];
    }
    
    item.tintColor = [UIColor whiteColor];
    
    if(isRight){
        self.navigationItem.rightBarButtonItem = item;
    }else{
        self.navigationItem.leftBarButtonItem = item;
    }
}

- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
                                
- (void)setNavigationColor:(UIColor *)color
{
    UINavigationBar *bar = [UINavigationBar appearance];
    //设置显示的颜色
    bar.barTintColor = color;
    //设置字体颜色
    bar.tintColor = [UIColor whiteColor];
    [bar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    //或者用这个都行
    //    [bar setTitleTextAttributes:@{UITextAttributeTextColor : [UIColor whiteColor]}];
    
}

- (void)messageBox:(NSString *)str{
    // 1.创建UIAlertController
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示"
                                                                             message:str
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    // 2.创建并添加按钮
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"OK Action");
    }];
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        NSLog(@"Cancel Action");
//    }];
//
    [alertController addAction:okAction];           // A
//    [alertController addAction:cancelAction];       // B
    // 3.呈现UIAlertContorller
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)openGame:(NSString *)bundleID{
    Class LSAppClass = NSClassFromString(@"LSApplicationWorkspace");
    id workSpace = [(id)LSAppClass performSelector:@selector(defaultWorkspace)];
    [workSpace performSelector:@selector(openApplicationWithBundleID:) withObject:bundleID];
}

@end
