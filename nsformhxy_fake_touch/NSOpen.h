//
//  NSOpen.h
//  test
//
//  Created by 刘卓林 on 2018/3/17.
//  Copyright © 2018年 刘卓林. All rights reserved.
//
#ifdef __cplusplus
#import <opencv2/opencv.hpp>
#import <opencv2/imgproc/types_c.h>
#import <opencv2/highgui/ios.h>
#endif
#import <Foundation/Foundation.h>

@interface NSOpen : NSObject

- (UIImage *)opencvDisposeImage:(UIImage *)image;

@end
