//
//  NSFunction.m
//  test
//
//  Created by 刘卓林 on 2017/11/8.
//  Copyright © 2017年 刘卓林. All rights reserved.
//

#import "NSFunc.h"
#import <OpenGLES/ES2/glext.h>
#import <OpenGLES/ES2/gl.h>
#import <TesseractOCR/TesseractOCR.h>
#import "SimulateTouch.h"
#import <sys/utsname.h>

#define languagePath @"/nsfiles/mhxy"

NSScanner *theScanner;
NSScanner *theScanner2;

NSArray *arrayMulti;
NSArray *arrayMulti2;
NSMutableArray *mutableArrayMulti2;

NSMutableArray *mutableArray;
NSArray *arrayColor1;
CGPoint p;
CGPoint touchPoint;
NSString *point;
Tesseract* tesseract;
CGImageRef newImageRef;
NSOpen *opencv;
UIImage *newImage;

@interface NSFunc()

-(UIImage*)snapshot:(UIView*)eaglview;
-(UIImage *)captureCurrentView:(UIView *)view;
-(void)strMulti:(NSString *)str;
-(UIImage *) getImageWithFullScreenshot;
-(CGPoint)conversions:(int)x y:(int)y;
-(BOOL)isNotCount;

@property(nonatomic,strong)UIImage *mainImage;
@property(nonatomic)unsigned char*data;
@property(nonatomic)int rotateJudge;
@property(nonatomic)int width;
@property(nonatomic)int height;

@end


@implementation NSFunc

-(void)init:(int)rotate{
    //rotate屏幕方向，0 - 竖屏， 1 - Home键在右边， 2 - Home键在左边
    self.rotateJudge = rotate;
}

-(void)startGetImage{//程序入口函数
    self.width=[[UIScreen mainScreen] bounds].size.width;
    self.height=[[UIScreen mainScreen] bounds].size.height;
    if(![self isNotCount]){
        self.width = self.width * 2;
        self.height = self.height * 2;
    }
    NSLog(@"wwww==%d,,,hhhh=%d",self.width,self.height);
    mutableArray = [[NSMutableArray alloc] init];
    mutableArrayMulti2 = [[NSMutableArray alloc] init];
    opencv = [[NSOpen alloc] init];
    tesseract = [[Tesseract alloc] initWithDataPath:languagePath language:@"eng"];
    //添加监听者
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkDidReceiveMessage:)name:@"MAIN_IMAGE" object:nil];
}

-(void)networkDidReceiveMessage:(NSNotification *)notification {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    self.mainImage = [self getImageWithFullScreenshot];
    if(self.mainImage == NULL)
        return;
//        //写入相册
//        UIImageWriteToSavedPhotosAlbum(self.mainImage, self, nil, nil);
    size_t w = CGImageGetWidth(self.mainImage.CGImage);
    size_t h = CGImageGetHeight(self.mainImage.CGImage);
//    NSLog(@"w=%lu,h=%lu",w,h);
    size_t bytesPerPixel=4;
    size_t bytesPerRow=bytesPerPixel*w;
    size_t bitsPerComponent = 8;

    if(!self.data){
        NSLog(@"release data");
//        free(self.data);
        self.data=malloc(w*h*bytesPerPixel);
    }
    

    CGContextRef cgcnt = CGBitmapContextCreate(self.data,
                                       w,
                                       h,
                                       bitsPerComponent,
                                       bytesPerRow,
                                       CGColorSpaceCreateDeviceRGB(),
                                       kCGImageAlphaPremultipliedFirst);
    //将图像写入一个矩形
    if(cgcnt == NULL){
        return;
    }
//    NSLog(@"get data");

    CGContextDrawImage(cgcnt, CGRectMake(0, 0, w, h), [self.mainImage CGImage]);

    CGContextRelease(cgcnt);
    [pool drain];
}

-(NSString *)ocrText:(int)x1 y1:(int)y1 x2:(int)x2 y2:(int)y2 whitelist:(NSString *)whitelist min:(int)min max:(int)max{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

//    Tesseract* tesseract = [[Tesseract alloc] initWithDataPath:languagePath language:@"eng"];

    [tesseract setVariableValue:whitelist forKey:@"tessedit_char_whitelist"]; //limit search
    //将UIImage转换成CGImageRef
//    CGImageRef sourceImageRef = [self.mainImage CGImage];
//    CGRect rect = CGRectMake(x1,y1, x2-x1,y2-y1);
    //按照给定的矩形区域进行剪裁
    newImageRef = CGImageCreateWithImageInRect([self.mainImage CGImage], CGRectMake(x1,y1, x2-x1,y2-y1));
    //将CGImageRef转换成UIImage
//    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    newImage =[opencv opencvDisposeImage:[UIImage imageWithCGImage:newImageRef] min:min max:max];
    //写入相册
//    UIImageWriteToSavedPhotosAlbum(newImage, self, nil, nil);
    [tesseract setImage:newImage]; //image to check
    [tesseract recognize];
    
//    NSString *recognizedText = [tesseract recognizedText];
//
//    NSLog(@"%@", recognizedText);

//    dispatch_async(dispatch_get_main_queue(), ^{
//
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tesseract OCR iOS" message:recognizedText delegate:nil cancelButtonTitle:@"Yeah!" otherButtonTitles:nil];
//        [alert show];
//
//    });

//    tesseract = nil; //deallocate and free all memory
    [pool drain];
    
    return [tesseract recognizedText];
}

-(void)inputText:(NSString *)str{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [(id)UIKeyboardImpl performSelector:@selector(activeInstance)];
//    [activeInstance performSelector:@selector(deleteBackward)];
    [activeInstance performSelector:@selector(addInputString:) withObject:str];
    [pool drain];
}

-(CGPoint)conversions:(int)x y:(int)y{
    p = CGPointMake(0, 0);
    switch (self.rotateJudge) {
        case 0:
            p.x = x;
            p.y = y;
            break;
        case 1:
            p.x = self.height - y;
            p.y = self.width - (self.width - x);
            break;
        case 2:
            p.x = y;
            p.y = self.width - x;
            break;
            
        default:
            break;
    }
    NSLog(@"%f,%f",p.x,p.y);
    return p;
}
-(BOOL)isNotCount{
    bool isCount = false;
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    if ([deviceString isEqualToString:@"iPad1,1"])      isCount = true;
    
    if ([deviceString isEqualToString:@"iPad1,2"])      isCount = true;
    
    if ([deviceString isEqualToString:@"iPad2,1"])      isCount = true;
    
    if ([deviceString isEqualToString:@"iPad2,2"])      isCount = true;
    
    if ([deviceString isEqualToString:@"iPad2,3"])      isCount = true;
    
    if ([deviceString isEqualToString:@"iPad2,4"])      isCount = true;
    
    if ([deviceString isEqualToString:@"iPad2,5"])      isCount = true;
    
    if ([deviceString isEqualToString:@"iPad2,6"])      isCount = true;
    
    if ([deviceString isEqualToString:@"iPad2,7"])      isCount = true;
    
    return isCount;
}
-(void)touchDown:(int)index x:(int)x y:(int)y{
    //    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    p = [self conversions:x y:y];
    touchPoint = CGPointMake(ceil(p.x*0.5),ceil(p.y*0.5));
    //NSLog(@"down=%f,%f",touchPoint.x,touchPoint.y);
    int r = [SimulateTouch simulateTouch:index atPoint:touchPoint withType:STTouchDown];
    if(r==0)
        NSLog(@"按下失败");
    //    });
}

-(void)touchUp:(int)index x:(int)x y:(int)y{
    //    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    p = [self conversions:x y:y];
    touchPoint = CGPointMake(ceil(p.x*0.5),ceil(p.y*0.5));
    //NSLog(@"up=%f,%f",touchPoint.x,touchPoint.y);
    int r = [SimulateTouch simulateTouch:index atPoint:touchPoint withType:STTouchUp];
    if(r==0)
        NSLog(@"抬起失败");
    //    });
}

-(void)touchMove:(int)index x:(int)x y:(int)y{
    //    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    p = [self conversions:x y:y];
    touchPoint = CGPointMake(ceil(p.x*0.5),ceil(p.y*0.5));
    //NSLog(@"move=%f,%f",touchPoint.x,touchPoint.y);
    int r = [SimulateTouch simulateTouch:index atPoint:touchPoint withType:STTouchMove];
    if(r==0)
        NSLog(@"移动失败");
    //    });
}

//-(void)mSleep:(int)s{
//    usleep(s*1000);
//}

-(void)getpm{
//    NSLog(@"getpm");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MAIN_IMAGE" object:self];
}

-(void)strMulti:(NSString *)str{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    [mutableArrayMulti2 removeAllObjects];
    arrayMulti = [str componentsSeparatedByString:@","];
    if(arrayMulti.count == 1){
        [mutableArrayMulti2 addObject:@0];
        [mutableArrayMulti2 addObject:@0];
        [mutableArrayMulti2 addObject:str];
        [mutableArray addObject:mutableArrayMulti2];
        //NSLog(@"mutableArray=%@,%@,%@",mutableArray[0][0],mutableArray[0][1],mutableArray[0][2]);
    }
    else{
        for (int i=0; i<arrayMulti.count; i++) {
            arrayMulti2 = [arrayMulti[i] componentsSeparatedByString:@"|"];
            [mutableArray addObject:arrayMulti2];
            //NSLog(@"mutableArray=%@,%@,%@",mutableArray[i][0],mutableArray[i][1],mutableArray[i][2]);
        }
    }

    [pool drain];
}

-(CGPoint)findMultiColor:(NSString *)str x1:(int)x1 y1:(int)y1 x2:(int)x2 y2:(int)y2 help_simi:(float)help_simi{
//    NSLog(@"开始遍历：%@",str);
    p = CGPointMake(-1, -1);
    
    if(!str)
        return p;
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    unsigned int iValue=0;
    unsigned int iValue2=0;
    
    [mutableArray removeAllObjects];
    [self strMulti:str];
    
    float rMain=0,gMain=0,bMain=0;
    float rMain1=0,gMain1=0,bMain1=0;
    arrayColor1 = [mutableArray[0][2] componentsSeparatedByString:@"-"];
    if(arrayColor1.count>1){
        theScanner = [NSScanner scannerWithString:[arrayColor1 objectAtIndex:0]];
        [theScanner scanHexInt:&iValue];
        rMain = ((float)((iValue & 0xFF0000) >> 16));
        gMain = ((float)((iValue & 0xFF00) >> 8));
        bMain = ((float)(iValue & 0xFF));
        theScanner2 = [NSScanner scannerWithString:[arrayColor1 objectAtIndex:1]];
        [theScanner2 scanHexInt:&iValue2];
        rMain1 = iValue2;
        gMain1 = iValue2;
        bMain1 = iValue2;
         /*
        NSMutableArray *rgb = [self systemToRGB:[array1 objectAtIndex:0]];
        rMain = [[rgb objectAtIndex:0] floatValue];
        gMain = [[rgb objectAtIndex:1] floatValue];
        bMain = [[rgb objectAtIndex:2] floatValue];
        rgb = [self systemToRGB:[array1 objectAtIndex:1]];
        rMain1 = [[rgb objectAtIndex:0] floatValue];
        gMain1 = [[rgb objectAtIndex:1] floatValue];
        bMain1 = [[rgb objectAtIndex:2] floatValue];*/
    }else{
        theScanner = [NSScanner scannerWithString:[[mutableArray objectAtIndex:0] objectAtIndex:2]];
        [theScanner scanHexInt:&iValue];
        rMain = ((float)((iValue & 0xFF0000) >> 16));
        gMain = ((float)((iValue & 0xFF00) >> 8));
        bMain = ((float)(iValue & 0xFF));
        /*
        NSMutableArray *rgb = [self systemToRGB:[[mutableArray objectAtIndex:0] objectAtIndex:2]];
        rMain = [[rgb objectAtIndex:0] floatValue];
        gMain = [[rgb objectAtIndex:1] floatValue];
        bMain = [[rgb objectAtIndex:2] floatValue];*/
    }
    [pool drain];
//    NSLog(@"%f,%f,%f--------%f,%f,%f",rMain,gMain,bMain,rMain1,gMain1,bMain1);
    int simi = (1-help_simi)*100;
    //NSLog(@"simi=%d",simi);
    if(self.mainImage == NULL)
        return p;
    //NSLog(@"image = %@",self.mainImage);
    
    if(self.data == NULL)
        return p;
    //NSLog(@"data2=%d",(int)strlen((char*)self.data));

//    NSLog(@"遍历data");
    int offset = 0;
    float red = 0,green = 0,blue = 0;
    int w = (int)CGImageGetWidth(self.mainImage.CGImage);
//        offset = 4*((self.width*round(10))+round(10));
//        red = self.data[offset+1];
//        green = self.data[offset+2];
//        blue = self.data[offset+3];
//        //0xd97358
//        rMain = ((float)((0x1f2e7f & 0xFF0000) >> 16));
//        gMain = ((float)((0x1f2e7f & 0xFF00) >> 8));
//        bMain = ((float)(0x1f2e7f & 0xFF));
//        NSLog(@" %f，%f，%f=====%f,%f,%f",red,green,blue,rMain,gMain,bMain);
//        return p;
    for (int m=y1; m<y2; m++) {
        for (int n=x1; n<x2; n++) {
            offset = 4*((w*round(m))+round(n));
            red = self.data[offset+1];
            green = self.data[offset+2];
            blue = self.data[offset+3];
            //NSLog(@"x=%d,y=%d   %f<=%f,%d",n,m,red,rMain,offset);
            if(fabsf(red-rMain)<=(rMain1+simi) && fabsf(green-gMain)<=(gMain1+simi) && fabsf(blue-bMain)<=(bMain1+simi) ){
                //NSLog(@"x=%d,y=%d",n,m);
                if(mutableArray.count == 1){
                    //NSLog(@"单点找色释放data   x=%d,y=%d   RGB  %f %f %f",n,m,red,green,blue);
                    p.x = n;
                    p.y = m;
                    return p;
                }else{
                    int max=0;
                    float rValue=0,gValue=0,bValue=0;
                    float rValue1=0,gValue1=0,bValue1=0;
                    for (int i=0; i<mutableArray.count; i++) {
                        NSAutoreleasePool *pool2 = [[NSAutoreleasePool alloc] init];
                        arrayColor1 = [mutableArray[i][2] componentsSeparatedByString:@"-"];
                        if(arrayColor1.count>1){
                            theScanner = [NSScanner scannerWithString:[arrayColor1 objectAtIndex:0]];
                            [theScanner scanHexInt:&iValue];
                            rValue = ((float)((iValue & 0xFF0000) >> 16));
                            gValue = ((float)((iValue & 0xFF00) >> 8));
                            bValue = ((float)(iValue & 0xFF));
                            theScanner2 = [NSScanner scannerWithString:[arrayColor1 objectAtIndex:1]];
                            [theScanner2 scanHexInt:&iValue2];
                            rValue1 = iValue2;
                            gValue1 = iValue2;
                            bValue1 = iValue2;
                            /*
                            NSMutableArray *rgb = [self systemToRGB:[array objectAtIndex:0]];
                            rValue = [[rgb objectAtIndex:0] floatValue];
                            gValue = [[rgb objectAtIndex:1] floatValue];
                            bValue = [[rgb objectAtIndex:2] floatValue];
                            rgb = [self systemToRGB:[array objectAtIndex:1]];
                            rValue1 = [[rgb objectAtIndex:0] floatValue];
                            gValue1 = [[rgb objectAtIndex:1] floatValue];
                            bValue1 = [[rgb objectAtIndex:2] floatValue];*/
                        }else{
                            theScanner = [NSScanner scannerWithString:[[mutableArray objectAtIndex:i] objectAtIndex:2]];
                            [theScanner scanHexInt:&iValue];
                            rValue = ((float)((iValue & 0xFF0000) >> 16));
                            gValue = ((float)((iValue & 0xFF00) >> 8));
                            bValue = ((float)(iValue & 0xFF));
                            /*
                            NSMutableArray *rgb = [self systemToRGB:[[mutableArray objectAtIndex:i] objectAtIndex:2]];
                            rValue = [[rgb objectAtIndex:0] floatValue];
                            gValue = [[rgb objectAtIndex:1] floatValue];
                            bValue = [[rgb objectAtIndex:2] floatValue];*/
                        }
                        [pool2 drain];
                        int px=n+[mutableArray[i][0] intValue];
                        int py=m+[mutableArray[i][1] intValue];
                        if(px>=x2 && py>=y2)
                        {
                            //                            NSLog(@"循环完成过界");
                            return p;
                        }
                        if(px < 0){
                            n=n+abs(px);
                            //                            NSLog(@"n========%d",n);
                        }
                        if(py < 0){
                            m=m+abs(py);
                            //                            NSLog(@"m========%d",m);
                        }
                        if(py >= y2){
                            //                            NSLog(@"循环完成py过界");
                            return p;
                        }
                        if(px>=x2 || px < 0 || py < 0){
                            //NSLog(@"过界break px=%d,py=%d---\nx=%d,y=%d---\nn=%d,m=%d----\nx2=%d,y2=%d",px,py,[mutableArray[i][0] intValue],[mutableArray[i][1] intValue],n,m,x2,y2);
                            break;
                        }
                        int offset1 = 4*((w*round(py))+round(px));
                        float red1 = self.data[offset1+1];
                        float green1 = self.data[offset1+2];
                        float blue1 = self.data[offset1+3];
                        if(fabsf(red1-rValue)<=(rValue1+simi) && fabsf(green1-gValue)<=(gValue1+simi) && fabsf(blue1-bValue)<=(bValue1+simi) ){
                            max++;
                            //NSLog(@"%d x=%d,y=%d  RGB  %f %f %f",max,n,m,red1,green1,blue1);
                        }else{
                            break;
                        }
                    }
                    if(max == mutableArray.count){
//                        NSLog(@"找到了完全释放data   x=%d,y=%d  x2=%d,y2=%d RGB  %f %f %f",n,m,x2,y2,red,green,blue);
                        p.x = n;
                        p.y = m;
                        return p;
                    }
                }// if mutable==1
            }
        }
    }
//    NSLog(@"没能找到图片");
    return p;
}

-(NSString *)findAllColor:(NSString *)str x1:(int)x1 y1:(int)y1 x2:(int)x2 y2:(int)y2 help_simi:(float)help_simi{
//    NSLog(@"开始遍历：%@",str);
    point = @"";
    
    if(!str)
        return point;
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    unsigned int iValue=0;
    unsigned int iValue2=0;
    
    [mutableArray removeAllObjects];
    [self strMulti:str];
    
    float rMain=0,gMain=0,bMain=0;
    float rMain1=0,gMain1=0,bMain1=0;
    arrayColor1 = [mutableArray[0][2] componentsSeparatedByString:@"-"];
    if(arrayColor1.count>1){
        theScanner = [NSScanner scannerWithString:[arrayColor1 objectAtIndex:0]];
        [theScanner scanHexInt:&iValue];
        rMain = ((float)((iValue & 0xFF0000) >> 16));
        gMain = ((float)((iValue & 0xFF00) >> 8));
        bMain = ((float)(iValue & 0xFF));
        theScanner2 = [NSScanner scannerWithString:[arrayColor1 objectAtIndex:1]];
        [theScanner2 scanHexInt:&iValue2];
        rMain1 = iValue2;
        gMain1 = iValue2;
        bMain1 = iValue2;
    }else{
        theScanner = [NSScanner scannerWithString:[[mutableArray objectAtIndex:0] objectAtIndex:2]];
        [theScanner scanHexInt:&iValue];
        rMain = ((float)((iValue & 0xFF0000) >> 16));
        gMain = ((float)((iValue & 0xFF00) >> 8));
        bMain = ((float)(iValue & 0xFF));
    }
    [pool drain];
    int simi = (1-help_simi)*100;
    //NSLog(@"simi=%d",simi);
    if(self.mainImage == NULL)
        return point;
    //NSLog(@"image = %@",self.mainImage);
    
    if(self.data == NULL)
        return point;
    //NSLog(@"data2=%d",(int)strlen((char*)self.data));
    
//    NSLog(@"遍历data");
    int offset = 0;
    float red = 0,green = 0,blue = 0;
    int w = (int)CGImageGetWidth(self.mainImage.CGImage);
    for (int m=y1; m<y2; m++) {
        for (int n=x1; n<x2; n++) {
            offset = 4*((w*round(m))+round(n));
            red = self.data[offset+1];
            green = self.data[offset+2];
            blue = self.data[offset+3];
            //NSLog(@"x=%d,y=%d   %f<=%f,%d",n,m,red,rMain,offset);
            if(fabsf(red-rMain)<=(rMain1+simi) && fabsf(green-gMain)<=(gMain1+simi) && fabsf(blue-bMain)<=(bMain1+simi) ){
                //NSLog(@"x=%d,y=%d",n,m);
                if(mutableArray.count == 1){
                    point = [NSString stringWithFormat:@"%d,%d",n,m];
                    return point;
                }else{
                    int max=0;
                    float rValue=0,gValue=0,bValue=0;
                    float rValue1=0,gValue1=0,bValue1=0;
                    for (int i=0; i<mutableArray.count; i++) {
                        NSAutoreleasePool *pool2 = [[NSAutoreleasePool alloc] init];
                        arrayColor1 = [mutableArray[i][2] componentsSeparatedByString:@"-"];
                        if(arrayColor1.count>1){
                            theScanner = [NSScanner scannerWithString:[arrayColor1 objectAtIndex:0]];
                            [theScanner scanHexInt:&iValue];
                            rValue = ((float)((iValue & 0xFF0000) >> 16));
                            gValue = ((float)((iValue & 0xFF00) >> 8));
                            bValue = ((float)(iValue & 0xFF));
                            theScanner2 = [NSScanner scannerWithString:[arrayColor1 objectAtIndex:1]];
                            [theScanner2 scanHexInt:&iValue2];
                            rValue1 = iValue2;
                            gValue1 = iValue2;
                            bValue1 = iValue2;
                        }else{
                            theScanner = [NSScanner scannerWithString:[[mutableArray objectAtIndex:i] objectAtIndex:2]];
                            [theScanner scanHexInt:&iValue];
                            rValue = ((float)((iValue & 0xFF0000) >> 16));
                            gValue = ((float)((iValue & 0xFF00) >> 8));
                            bValue = ((float)(iValue & 0xFF));
                        }
                        [pool2 drain];
                        int px=n+[mutableArray[i][0] intValue];
                        int py=m+[mutableArray[i][1] intValue];
                        if(px>=x2 && py>=y2)
                        {
                            //                            NSLog(@"循环完成过界");
                            return point;
                        }
                        if(px < 0){
                            n=n+abs(px);
                            //                            NSLog(@"n========%d",n);
                        }
                        if(py < 0){
                            m=m+abs(py);
                            //                            NSLog(@"m========%d",m);
                        }
                        if(py >= y2){
                            //                            NSLog(@"循环完成py过界");
                            return point;
                        }
                        if(px>=x2 || px < 0 || py < 0){
                            //NSLog(@"过界break px=%d,py=%d---\nx=%d,y=%d---\nn=%d,m=%d----\nx2=%d,y2=%d",px,py,[mutableArray[i][0] intValue],[mutableArray[i][1] intValue],n,m,x2,y2);
                            break;
                        }
                        int offset1 = 4*((w*round(py))+round(px));
                        float red1 = self.data[offset1+1];
                        float green1 = self.data[offset1+2];
                        float blue1 = self.data[offset1+3];
                        if(fabsf(red1-rValue)<=(rValue1+simi) && fabsf(green1-gValue)<=(gValue1+simi) && fabsf(blue1-bValue)<=(bValue1+simi) ){
                            max++;
                            //NSLog(@"%d x=%d,y=%d  RGB  %f %f %f",max,n,m,red1,green1,blue1);
                        }else{
                            break;
                        }
                    }
                    if(max == mutableArray.count){
//                        NSLog(@"找到了完全%@",p);
                        if([point isEqual:@""]){
                            point = [NSString stringWithFormat:@"%d,%d",n,m];
                        }else{
                            point = [NSString stringWithFormat:@"%@|%d,%d",point,n,m];
                        }

                    }
                }// if mutable==1
            }
        }
    }

    return point;
}

-(UIImage *)captureCurrentView:(UIView *)view//切换账号使用这个截图
{
    //view = [[UIScreen mainScreen] snapshotViewAfterScreenUpdates:YES];//屏幕更新后的快照视图
    //UIGraphicsBeginImageContext(view.frame.size);//开启上下文（尺寸可以修改）
    UIGraphicsBeginImageContextWithOptions(view.frame.size, YES, 0);//用选择的view的上下文//透明//比例尺寸
    //CGContextRef contextRef = UIGraphicsGetCurrentContext();//获取当前上下文
    //[[UIColor yellowColor] set];//设置为黄色
    //CGContextFillRect(contextRef, view.frame);//CG上下文填充矩形
    [[view layer] renderInContext:UIGraphicsGetCurrentContext()];//呈现上下文在view.layer中
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();//图形从当前图像环境中获取图像
    
    UIGraphicsEndImageContext();//关闭上下文
    
    return image;
}

// IMPORTANT: Call this method after you draw and before -presentRenderbuffer:.
-(UIImage*)snapshot:(UIView*)eaglview
{
    //GLuint colorRenderbuffer = 0;
    GLint backingWidth = eaglview.frame.size.width*2;
    GLint backingHeight = eaglview.frame.size.height*2;
    
    
    // Bind the color renderbuffer used to render the OpenGL ES view
    
    // If your application only creates a single color renderbuffer which is already bound at this point,
    
    // this call is redundant, but it is needed if you're dealing with multiple renderbuffers.
    
    // Note, replace "_colorRenderbuffer" with the actual name of the renderbuffer object defined in your class.

    //glBindRenderbuffer(GL_RENDERBUFFER, colorRenderbuffer);
    

    // Get the size of the backing CAEAGLLayer
    
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &backingWidth);
    
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &backingHeight);
    
    
    
    NSInteger x = 0, y = 0, width = backingWidth, height = backingHeight;
    
    NSInteger dataLength = width * height * 4;
    
    GLubyte *data = (GLubyte*)malloc(dataLength * sizeof(GLubyte));
    
    
    // Read pixel data from the framebuffer
    
    glPixelStorei(GL_PACK_ALIGNMENT, 4);
    
    glReadPixels((int)x, (int)y, (int)width, (int)height, GL_RGBA, GL_UNSIGNED_BYTE, data);
    
    
    
    // Create a CGImage with the pixel data
    
    // If your OpenGL ES content is opaque, use kCGImageAlphaNoneSkipLast to ignore the alpha channel
    
    // otherwise, use kCGImageAlphaPremultipliedLast
    
    CGDataProviderRef ref = CGDataProviderCreateWithData(NULL, data, dataLength, NULL);
    
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    
    CGImageRef iref = CGImageCreate(width, height, 8, 32, width * 4, colorspace, kCGBitmapByteOrder32Big | kCGImageAlphaPremultipliedLast,ref, NULL, true, kCGRenderingIntentDefault);
    
    
    
    // OpenGL ES measures data in PIXELS
    
    // Create a graphics context with the target size measured in POINTS
    
    NSInteger widthInPoints, heightInPoints;
    
    // On iOS 4 and later, use UIGraphicsBeginImageContextWithOptions to take the scale into consideration
        
    // Set the scale parameter to your OpenGL ES view's contentScaleFactor
        
    // so that you get a high-resolution snapshot when its value is greater than 1.0
        
    CGFloat scale = eaglview.contentScaleFactor;
        
    widthInPoints = width / scale;
        
    heightInPoints = height / scale;
        
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(widthInPoints, heightInPoints), NO, scale);

    
    
    CGContextRef cgcontext = UIGraphicsGetCurrentContext();
    
    
    
    // UIKit coordinate system is upside down to GL/Quartz coordinate system
    
    // Flip the CGImage by rendering it to the flipped bitmap context
    
    // The size of the destination area is measured in POINTS
    
    CGContextSetBlendMode(cgcontext, kCGBlendModeCopy);
    
    CGContextDrawImage(cgcontext, CGRectMake(0.0, 0.0, widthInPoints, heightInPoints), iref);
    

    // Retrieve the UIImage from the current context
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    
    
    UIGraphicsEndImageContext();
    
    
    // Clean up

    free(data);
    
    CFRelease(ref);
    
    CFRelease(colorspace);
    
    CGImageRelease(iref);
    
    //UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
    return image;
    
}
//屏幕截图
-(UIImage *) getImageWithFullScreenshot  //
{

    // Source (Under MIT License): https://github.com/shinydevelopment/SDScreenshotCapture/blob/master/SDScreenshotCapture/SDScreenshotCapture.m#L35
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
    
    UIImage *image;
    
    BOOL ignoreOrientation = SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0");
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    CGSize imageSize = CGSizeZero;
    if (UIInterfaceOrientationIsPortrait(orientation) || ignoreOrientation)
        imageSize = [UIScreen mainScreen].bounds.size;
    else
        imageSize = CGSizeMake([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    
    UIGraphicsBeginImageContextWithOptions(imageSize, YES, [UIScreen mainScreen].scale);//[UIScreen mainScreen].scale);
    //UIGraphicsBeginImageContext(imageSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    for (UIWindow * windowcc in [[UIApplication sharedApplication] windows])
    {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, windowcc.center.x, windowcc.center.y);
        CGContextConcatCTM(context, windowcc.transform);
        CGContextTranslateCTM(context, -windowcc.bounds.size.width * windowcc.layer.anchorPoint.x, -windowcc.bounds.size.height * windowcc.layer.anchorPoint.y);
        
        
        // Correct for the screen orientation
        if(!ignoreOrientation)  //如果不是8.0
        {
            if(orientation == UIInterfaceOrientationLandscapeLeft)
            {
                CGContextRotateCTM(context, (CGFloat)M_PI_2);
                CGContextTranslateCTM(context, 0, -imageSize.width);
            }
            else if(orientation == UIInterfaceOrientationLandscapeRight)
            {
                CGContextRotateCTM(context, (CGFloat)-M_PI_2);
                CGContextTranslateCTM(context, -imageSize.height, 0);
            }
            else if(orientation == UIInterfaceOrientationPortraitUpsideDown)
            {
                CGContextRotateCTM(context, (CGFloat)M_PI);
                CGContextTranslateCTM(context, -imageSize.width, -imageSize.height);
            }
        }
        
        // [windowcc drawViewHierarchyInRect:windowcc.bounds afterScreenUpdates:NO];
        
        if([windowcc respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)])
        {
            [windowcc drawViewHierarchyInRect:windowcc.bounds afterScreenUpdates:NO];
            
        }
        else
        {
            [windowcc.layer renderInContext:UIGraphicsGetCurrentContext()];
        }
        
        CGContextRestoreGState(context);
        
        break;
    }
    
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
//    CGContextRelease(context);
    
    return image;
}


@end
