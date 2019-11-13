//
//  NSOpen.m
//  test
//
//  Created by 刘卓林 on 2018/3/17.
//  Copyright © 2018年 刘卓林. All rights reserved.
//

#import "NSOpen.h"

@interface NSOpen ()
//{
//    cv::Mat cvImage;
//}

@end

@implementation NSOpen

- (UIImage *)opencvDisposeImage:(UIImage *)image {
    
    // 1.将iOS的UIImage转成c++图片（数据：矩阵）
    cv::Mat resultImage;
    UIImageToMat(image, resultImage);
    //转为灰度图
    cvtColor(resultImage, resultImage, cv::COLOR_BGR2GRAY);
    //利用阈值二值化
    cv::threshold(resultImage, resultImage, 200, 255, CV_THRESH_BINARY);
    //腐蚀，填充（腐蚀是让黑色点变大）
//    cv::Mat erodeElement = getStructuringElement(cv::MORPH_RECT, cv::Size(3,3));
//    cv::erode(resultImage, resultImage, erodeElement);


    // 4. 将c++处理之后的图片转成iOS能识别的UIImage
    return MatToUIImage(resultImage);

}

@end
