//
//  NSRestart.m
//  test
//
//  Created by 刘卓林 on 2018/1/14.
//  Copyright © 2018年 刘卓林. All rights reserved.
//

#import "NSRestart.h"
#include <sys/types.h>
#include <sys/sysctl.h>
#import <MobileGestalt/MobileGestalt.h>

@implementation NSRestart

+ (void)openGame:(NSString *)bundleID{
    Class LSAppClass = NSClassFromString(@"LSApplicationWorkspace");
    id workSpace = [(id)LSAppClass performSelector:@selector(defaultWorkspace)];
    [workSpace performSelector:@selector(openApplicationWithBundleID:) withObject:bundleID];
}

+ (NSString*)getuuid
{
    
    CFStringRef value  = MGCopyAnswer(kMGUniqueDeviceID);

    NSString* key  = (__bridge NSString *)value;

    CFRelease(value);

    return key;
}

//返回所有正在运行的进程的 id，name，占用cpu，运行时间
//使用函数int    sysctl(int *, u_int, void *, size_t *, void *, size_t)
+ (BOOL )runningProcesses:(NSString *)str
{
    
    bool  ret=false;
    //指定名字参数，按照顺序第一个元素指定本请求定向到内核的哪个子系统，第二个及其后元素依次细化指定该系统的某个部分。
    //CTL_KERN，KERN_PROC,KERN_PROC_ALL 正在运行的所有进程
    int mib[4] = {CTL_KERN, KERN_PROC, KERN_PROC_ALL ,0};
    
    
    size_t miblen = 4;
    //值-结果参数：函数被调用时，size指向的值指定该缓冲区的大小；函数返回时，该值给出内核存放在该缓冲区中的数据量
    //如果这个缓冲不够大，函数就返回ENOMEM错误
    size_t size;
    //返回0，成功；返回-1，失败
    int st = sysctl(mib, miblen, NULL, &size, NULL, 0);
    
    struct kinfo_proc * process = NULL;
    struct kinfo_proc * newprocess = NULL;
    do
    {
        size += size / 10;
        newprocess = realloc(process, size);
        if (!newprocess)
        {
            if (process)
            {
                free(process);
                process = NULL;
            }
            return false;
        }
        
        process = newprocess;
        st = sysctl(mib, miblen, process, &size, NULL, 0);
    } while (st == -1 && errno == ENOMEM);
    
    if (st == 0)
    {
        if (size % sizeof(struct kinfo_proc) == 0)
        {
            int nprocess = size / sizeof(struct kinfo_proc);
            if (nprocess)
            {
                NSMutableArray * array = [[NSMutableArray alloc] init];
                for (int i = nprocess - 1; i >= 0; i--)
                {
                    // NSString * processID = [[NSString alloc] initWithFormat:@"%d", process[i].kp_proc.p_pid];
                    NSString * processName = [[NSString alloc] initWithFormat:@"%s", process[i].kp_proc.p_comm];
                    NSString * proc_CPU = [[NSString alloc] initWithFormat:@"%u",process[i].kp_proc.p_pctcpu];
                    // double t = [[NSDate date] timeIntervalSince1970] - process[i].kp_proc.p_un.__p_starttime.tv_sec;
                    // NSString * proc_useTiem = [[NSString alloc] initWithFormat:@"%f",t];
                    
                    
                    
                    if  ( [processName isEqualToString:str])
                    {
                        NSLog(@"%@",proc_CPU);
                        NSLog(@"找到！！！");
                        ret =true;
                        [proc_CPU release];
                        [processName release];
                        break;
                        
                        
                    }
                    //NSLog(@"process.kp_proc.p_stat = %c",process.kp_proc.p_stat);
                    
                    
                    /*
                     NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                     [dic setValue:processID forKey:@"ProcessID"];
                     [dic setValue:processName forKey:@"ProcessName"];
                     [dic setValue:proc_CPU forKey:@"ProcessCPU"];
                     [dic setValue:proc_useTiem forKey:@"ProcessUseTime"];
                     
                     [array addObject:dic];
                     */
                    [proc_CPU release];
                    
                    [processName release];
                }
                
                free(process);
                process = NULL;
                //NSLog(@"array = %@",array);
                
                
                [array release];
                
                return ret;
            }
        }
    }
    
    return ret;
}


@end
