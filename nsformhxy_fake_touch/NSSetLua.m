//
//  NSSetLuaEnvironment.m
//  test
//
//  Created by 刘卓林 on 2017/11/19.
//  Copyright © 2017年 刘卓林. All rights reserved.
//

#import "NSSetLua.h"
#import "NSSetViewBody.h"
#import "NSFunc.h"
#import "lua/lua.h"
#import "lua/lauxlib.h"
#import "lua/lualib.h"
#include <pthread.h>
#import <rocketbootstrap/rocketbootstrap.h>
#import <AppSupport/CPDistributedMessagingCenter.h>
#import <sys/utsname.h>

#define serverName @"com.NS_IOS_MHXY.server"


static const char *mainLuaPath = "/nsfiles/mhxy/sp/main.lua";
static NSSetViewBody *body;
static NSFunc *fun;
pthread_t Tid;
//static NSTimer *Tim;
int showTime;
lua_State *state;//定义一个lua_State结构
bool thread_pause;
bool thread_exit;
CPDistributedMessagingCenter *nsServer;
NSDictionary *reply;
NSObject *object;
NSObject *objectMain;
NSUserDefaults *defaults;
NSDictionary *replyMain;
NSString *endTime;
NSString *action;
const char *name;
NSString *str;
//NSMutableArray *mutableArray;

@interface NSSetLua()

//-(void)luaInit;

@end


@implementation NSSetLua



-(id)init{
    if(self = [super init]){
        body = [NSSetViewBody new];
        fun = [NSFunc new];
        [fun startGetImage];
        defaults = [NSUserDefaults standardUserDefaults];
        nsServer = [NSClassFromString(@"CPDistributedMessagingCenter") centerNamed:serverName];
        rocketbootstrap_distributedmessagingcenter_apply(nsServer);
        state = luaL_newstate();    //创建新的lua_State结构体
        luaL_openlibs(state);        //加载标准库
        
        //注册调用函数
        lua_register(state, "msg", msg);//msg
        lua_register(state, "mSleep", mSleep);//sleep
        lua_register(state, "inputText", inputText);//inputText
        lua_register(state, "touchDown", touchDown);//touchDown
        lua_register(state, "touchUp", touchUp);//touchUp
        lua_register(state, "touchMove", touchMove);//touchMove
        lua_register(state, "findColor", findColor);//findColor
        lua_register(state, "findMultiColor", findMultiColor);//findMultiColor
        lua_register(state, "getpm", getpm);//getpm
        lua_register(state, "dofile", dofile);//dofile
        lua_register(state, "getHeight", getHeight);//getHeight
        lua_register(state, "getWidth", getWidth);//getWidth
        lua_register(state, "getSwitch", getSwitch);//getSwitch
        lua_register(state, "getInt", getInt);//getInt
        lua_register(state, "getMission", getMission);//getMission
        lua_register(state, "ocrText", ocrText);//ocrText

    }
    return self;
}
/*
-(void)luaInit{
    state = luaL_newstate();    //创建新的lua_State结构体
    luaL_openlibs(state);        //加载标准库
    
    //注册调用函数
    lua_register(state, "msg", msg);//msg
    lua_register(state, "mSleep", mSleep);//sleep
    lua_register(state, "inputText", inputText);//inputText
    lua_register(state, "touchDown", touchDown);//touchDown
    lua_register(state, "touchUp", touchUp);//touchUp
    lua_register(state, "touchMove", touchMove);//touchMove
    lua_register(state, "findColor", findColor);//findColor
    lua_register(state, "findMultiColor", findMultiColor);//findMultiColor
    lua_register(state, "getpm", getpm);//getpm
    lua_register(state, "dofile", dofile);//dofile
    lua_register(state, "getHeight", getHeight);//getHeight
    lua_register(state, "getWidth", getWidth);//getWidth
    lua_register(state, "getSwitch", getSwitch);//getSwitch
    lua_register(state, "getInt", getInt);//getInt
    lua_register(state, "getMission", getMission);//getMission
    lua_register(state, "ocrText", ocrText);//ocrText
    lua_register(state, "getOrien", getOrien);//getOrien

}
*/
-(void)runLuaScript{
    
    if(!Tid){
//        [self luaInit];
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            Tim = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(showTime:) userInfo:nil repeats:true];
//            [[NSRunLoop currentRunLoop] run];
//        });
        pthread_create(&Tid,NULL,(void *)PosixThreadMainRoutine,NULL);
    }
}

-(void)thread_pause:(bool)pause{
    thread_pause = pause;
}

-(void)thread_exit:(bool)mexit{
    thread_exit = mexit;
}
/*
-(void)showTime:(NSTimer *)timer{
//    NSLog(@"wwwww");
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSDictionary *reply = [nsServer sendMessageAndReceiveReplyName:@"NSENDTIME" userInfo:nil];
//    NSLog(@"222222x%@",reply);
    NSObject *object = [reply objectForKey:@"endtime"];
    NSString *timeEnd = [NSString stringWithFormat:@"%@",object];
//    NSLog(@"xxxxxxx%@",timeEnd);
    if([timeEnd isEqualToString:@"-1"]){
        [body setController:@"使用时间已到，请充值"];
        [body newLuaThread];
        thread_pause = false;
        thread_exit = true;
        Tim = nil;
        [timer invalidate];
    }else if([timeEnd isEqualToString:@"-2"]){
        [body setController:@"网络不给力"];
    }
    if(timeThread_exit){
        
//        [body setController:@"tuituituit"];
//        sleep(5);
        timeThread_exit = false;
        Tim = nil;
        [timer invalidate];
    }
    [pool drain];
}
*/
/*
void* PosixThreadShowTime(void* data){
    while (1) {
//        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        reply = [nsServer sendMessageAndReceiveReplyName:@"NSENDTIME" userInfo:nil];
        //    NSLog(@"222222x%@",reply);
        object = [reply objectForKey:@"endtime"];
        timeEnd = [NSString stringWithFormat:@"%@",object];
        //    NSLog(@"xxxxxxx%@",timeEnd);
        if([timeEnd isEqualToString:@"-1"]){
            [body setController:@"使用时间已到，请充值"];
            [body newLuaThread];
            thread_pause = false;
            thread_exit = true;
            Tim = nil;
            pthread_exit(NULL);
        }else if([timeEnd isEqualToString:@"-2"]){
            [body setController:@"网络不给力"];
        }
        if(timeThread_exit){
            
            //        [body setController:@"tuituituit"];
            //        sleep(5);
            thread_exit = true;
            timeThread_exit = false;
            Tim = nil;
            pthread_exit(NULL);
        }
//        [pool drain];
        sleep(1);
    }
}
*/
void* PosixThreadMainRoutine(void* data)
{
    //保存配置
    objectMain = [defaults objectForKey:@"actiontime"];
    action = [NSString stringWithFormat:@"%@",objectMain];
    if([action isEqualToString:@"YES"]){
        [defaults setObject:@"NO" forKey:@"actiontime"];
        [defaults synchronize];
        replyMain = [nsServer sendMessageAndReceiveReplyName:@"NSENDTIME" userInfo:nil];
        objectMain = [replyMain objectForKey:@"endtime"];
        endTime = [NSString stringWithFormat:@"%@",objectMain];
        if([endTime isEqualToString:@"-1"] || [endTime isEqualToString:@"-2"] || [endTime isEqualToString:@"-3"] || [endTime length]<5){
            if([endTime isEqualToString:@"-1"]){
                [body setController:@"请充值后使用"];
            }else if([endTime isEqualToString:@"-2"]){
                [body setController:@"网络不给力"];
            }else if([endTime isEqualToString:@"-3"]){
                [body setController:@"用户是否存在?"];
            }else if([endTime length]<5){
                endTime = [NSString stringWithFormat:@"启动太频繁,等待10分钟%@",endTime];
                [body setController:endTime];
            }
            [body newLuaThread];
            thread_pause = false;
            thread_exit = false;
            //        [body setController:@"2222222"];
            //        sleep(5);
            Tid = nil;
            pthread_exit(NULL);
        }
//        [body setController:endTime];
//        sleep(1);
    }
    //    sleep(10);
    //运行Lua文件,这里需要判断时间防止破解
    //int bRet = lua_pcall(state,0,0,0);

    int bRet = luaL_dofile(state, mainLuaPath);
    if(bRet)
    {
        [body setMessageBox:@"错误提示" msg:[NSString stringWithUTF8String:lua_tostring(state, -1)]];
        lua_pop(state, 1);
    }else{
        [body setController:@"脚本运行完毕!"];
    }
    [body newLuaThread];
    thread_pause = false;
    thread_exit = false;
    Tid = nil;
    //    [pool drain];
    pthread_exit(NULL);
}

bool showtime(){
    bool timeYes = false;
    reply = [nsServer sendMessageAndReceiveReplyName:@"NSENDTIME" userInfo:nil];
    //    NSLog(@"222222x%@",reply);
    object = [reply objectForKey:@"endtime"];
    str = [NSString stringWithFormat:@"%@",object];
    //    NSLog(@"xxxxxxx%@",timeEnd);
    if([str isEqualToString:@"-1"]){
        [body setController:@"使用时间已到，请充值"];
        timeYes = true;
    }
    
    return timeYes;
}

int dofile(lua_State *L)  //加载lua 脚本
{
    if(thread_exit){
//        lua_close(L);
        Tid = nil;
        pthread_exit(NULL);
    }
    while (thread_pause) {
        sleep(1);
    }
    if (lua_gettop(L) > 0)
    {
//        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        str = [NSString stringWithFormat: @"/nsfiles/mhxy/sp/%s",lua_tostring(L,  1)];
        int s1;
        s1 = luaL_dofile(L, str.UTF8String);
        if (s1)
        {
            str = [NSString stringWithUTF8String:lua_tostring(L, -1)];
            [body setMessageBox:@"错误提示" msg:str];
            lua_pop(L, 1);
        }
//        [pool drain];
    }
    return 0;
}

int getSwitch(lua_State *L){

    if(thread_exit || showtime()){
//        lua_close(L);
        Tid = nil;
        pthread_exit(NULL);
    }
    while (thread_pause) {
        sleep(1);
    }
    if(lua_gettop(state) > 0){
//        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        name = lua_tostring(L, 1);
        str = [NSString stringWithUTF8String:name];
        lua_pushboolean(L, [defaults boolForKey:str]);
//        [pool drain];
        return 1;
    }
    
    return 0;
}

int getInt(lua_State *L){
 
    if(thread_exit){
//        lua_close(L);
        Tid = nil;
        pthread_exit(NULL);
    }
    while (thread_pause) {
        sleep(1);
    }
    if(lua_gettop(L) > 0){
//        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        name = lua_tostring(L, 1);
        str = [NSString stringWithUTF8String:name];
//        int value = (int)[defaults integerForKey:key];
        lua_pushinteger(L, [defaults integerForKey:str]);
//        [pool drain];
        return 1;
    }
    return 0;
}

int getMission(lua_State *L){
    if(thread_exit || showtime()){
//        lua_close(L);
        Tid = nil;
        pthread_exit(NULL);
    }
    while (thread_pause) {
        sleep(1);
    }

    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
//    [mutableArray removeAllObjects];
    NSMutableArray *mutableArray = [body getMissionSort];
    lua_newtable(L);
    for (int i=0; i<mutableArray.count; i++) {
        str = mutableArray[i];
        lua_pushnumber(L, i+1);
        lua_pushstring(L, str.UTF8String);
        lua_settable(L, -3);
    }
    [pool drain];
    return 1;
}

int getHeight(lua_State *L)  //你想要让Lua执行的方法，需用C++写
{
    if(thread_exit){
//        lua_close(L);
        Tid = nil;
        pthread_exit(NULL);
    }
    while (thread_pause) {
        sleep(1);
    }
    NSInteger age=[[UIScreen mainScreen] bounds].size.height;
    if(!isNotCount()){
        age = age *2;
    }
    lua_pushnumber(L, age);
    return 1;
}

int getWidth(lua_State *L)  //你想要让Lua执行的方法，需用C++写
{
    if(thread_exit){
//        lua_close(L);
        Tid = nil;
        pthread_exit(NULL);
    }
    while (thread_pause) {
        sleep(1);
    }
    NSInteger age=[[UIScreen mainScreen] bounds].size.width;
    if(!isNotCount()){
        age = age *2;
    }
    lua_pushnumber(L, age);
    
    return 1;
}

bool isNotCount(){
    bool isCount = false;
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    str = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    if ([str isEqualToString:@"iPad1,1"])      isCount = true;
    
    if ([str isEqualToString:@"iPad1,2"])      isCount = true;
    
    if ([str isEqualToString:@"iPad2,1"])      isCount = true;
    
    if ([str isEqualToString:@"iPad2,2"])      isCount = true;
    
    if ([str isEqualToString:@"iPad2,3"])      isCount = true;
    
    if ([str isEqualToString:@"iPad2,4"])      isCount = true;
    
    if ([str isEqualToString:@"iPad2,5"])      isCount = true;
    
    if ([str isEqualToString:@"iPad2,6"])      isCount = true;
    
    if ([str isEqualToString:@"iPad2,7"])      isCount = true;
    
    return isCount;
}

int msg(lua_State *L){
    if(thread_exit){
//        lua_close(L);
        Tid = nil;
        pthread_exit(NULL);
    }
    while (thread_pause) {
        sleep(1);
    }
    if (lua_gettop(L) > 0)
    {
//        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        name = lua_tostring(L, -1);
        str = [NSString stringWithUTF8String:name];
        NSLog(@"%@",str);
        [body setController:str];
//        [pool drain];
    }
    return 0;
}

int mSleep(lua_State *L){
    if(thread_exit){
//        lua_close(L);
        Tid = nil;
        pthread_exit(NULL);
    }
    while (thread_pause) {
        sleep(1);
    }
    if (lua_gettop(L) > 0)
    {
//        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        int num = lua_tonumber(L, -1);
        //NSLog(@"sleep=%d",num);
        [fun mSleep:num];
//        [pool drain];
    }
    return 0;
}

int getpm(lua_State *L){
    if(thread_exit){
//        lua_close(L);
        Tid = nil;
        pthread_exit(NULL);
    }
    while (thread_pause) {
        sleep(1);
    }
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    [fun getpm];
    [pool drain];
    return 0;
}

int inputText(lua_State *L){
    if(thread_exit){
//        lua_close(L);
        Tid = nil;
        pthread_exit(NULL);
    }
    while (thread_pause) {
        sleep(1);
    }
    if (lua_gettop(L) > 0)
    {
//        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        name = lua_tostring(L, -1);
        str = [NSString stringWithUTF8String:name];
        NSLog(@"%@",str);
        [fun inputText:str];
//        [pool drain];
    }
    
    return 0;
}

int ocrText(lua_State *L){
    if(thread_exit){
//        lua_close(L);
        Tid = nil;
        pthread_exit(NULL);
    }
    while (thread_pause) {
        sleep(1);
    }
    if (lua_gettop(L) > 0)
    {
//        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        lua_rawgeti(L, 1, 1);
        int num1 = lua_tonumber(L, -1);
        //NSLog(@"value = %d", num1);
        lua_rawgeti(L, 1, 2);
        int num2 = lua_tonumber(L, -1);
        //NSLog(@"value = %d", num2);
        lua_rawgeti(L, 1, 3);
        int num3 = lua_tonumber(L, -1);
        //NSLog(@"value = %d", num3);
        lua_rawgeti(L, 1, 4);
        int num4 = lua_tonumber(L, -1);
        name = lua_tostring(L, 2);
        
        str = [fun ocrText:num1 y1:num2 x2:num3 y2:num4 whitelist:[NSString stringWithUTF8String:name]];
        str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
        if(str == nil)
            str = @"";
        NSLog(@"ocr==%@",str);
        lua_pushstring(L, [str UTF8String]);
//        [pool drain];
        return 1;
    }
    return 0;
}

int touchDown(lua_State *L){
    if(thread_exit){
//        lua_close(L);
        Tid = nil;
        pthread_exit(NULL);
    }
    while (thread_pause) {
        sleep(1);
    }
    if (lua_gettop(L) > 0)
    {
//        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        int num1 = lua_tonumber(L, 1);//这里的-1 表示栈顶
        int num2 = lua_tonumber(L, 2);
        //NSLog(@"-----------%d,%d,%d",num1,num2,num3);
//        NSString *str = [NSString stringWithFormat:@"-----------%d,%d,%d",num1,num2,num3];
//        [body setController:str];
        NSInteger pointId = [fun touchDown:num1 y:num2];
        lua_pushinteger(L, pointId);
//        [pool drain];
        return 1;
    }
    return 0;
}

int touchUp(lua_State *L){
    if(thread_exit){
//        lua_close(L);
        Tid = nil;
        pthread_exit(NULL);
    }
    while (thread_pause) {
        sleep(1);
    }
    if (lua_gettop(L) > 0)
    {
//        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        int num1 = lua_tonumber(L, 1);//这里的-1 表示栈顶
        int num2 = lua_tonumber(L, 2);
        int num3 = lua_tonumber(L, 3);
        //NSLog(@"-----------%d,%d,%d",num1,num2,num3);
//        NSString *str = [NSString stringWithFormat:@"-----------%d,%d,%d",num1,num2,num3];
//        [body setController:str];
        [fun touchUp:num1 x:num2 y:num3];
//        [pool drain];
    }
    return 0;
}

int touchMove(lua_State *L){
    if(thread_exit){
//        lua_close(L);
        Tid = nil;
        pthread_exit(NULL);
    }
    while (thread_pause) {
        sleep(1);
    }
    if (lua_gettop(L) > 0)
    {
//        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        int num1 = lua_tonumber(L, 1);//这里的-1 表示栈顶
        int num2 = lua_tonumber(L, 2);
        int num3 = lua_tonumber(L, 3);
        //NSLog(@"-----------%d,%d,%d",num1,num2,num3);
//        NSString *str = [NSString stringWithFormat:@"-----------%d,%d,%d",num1,num2,num3];
//        [body setController:str];
        [fun touchMove:num1 x:num2 y:num3];
//        [pool drain];
    }
    return 0;
}

int findColor(lua_State *L){
    if(thread_exit){
//        lua_close(L);
        Tid = nil;
        pthread_exit(NULL);
    }
    while (thread_pause) {
        sleep(1);
    }
    if(lua_gettop(L) > 0){
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        lua_rawgeti(L, 1, 1);
        int num1 = lua_tonumber(L, -1);
        //NSLog(@"value = %d", num1);
        lua_rawgeti(L, 1, 2);
        int num2 = lua_tonumber(L, -1);
        //NSLog(@"value = %d", num2);
        lua_rawgeti(L, 1, 3);
        int num3 = lua_tonumber(L, -1);
        //NSLog(@"value = %d", num3);
        lua_rawgeti(L, 1, 4);
        int num4 = lua_tonumber(L, -1);
        //NSLog(@"value = %d", num4);
        
        name = lua_tostring(L, 2);
        str = [NSString stringWithUTF8String:name];
        //NSLog(@"value = %@", str);
        float value = lua_tonumber(L, 3);
        //NSLog(@"value = %f", value);
        
        CGPoint p = [fun findMultiColor:str x1:num1 y1:num2 x2:num3 y2:num4 help_simi:value];
//        CGPoint p = [fun findColor:str left:num1 top:num2 right:num3 bottom:num4 help_simi:value];
        
        lua_pushinteger(L, ceil(p.x));
        lua_pushinteger(L, ceil(p.y));
        [pool drain];
        return 2;
    }
    
    return 0;
}

int findMultiColor(lua_State *L){
    if(thread_exit){
//        lua_close(L);
        Tid = nil;
        pthread_exit(NULL);
    }
    while (thread_pause) {
        sleep(1);
    }
    if(lua_gettop(L) > 0){
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        lua_rawgeti(L, 1, 1);
        int num1 = lua_tonumber(L, -1);
        //NSLog(@"value = %d", num1);
        lua_rawgeti(L, 1, 2);
        int num2 = lua_tonumber(L, -1);
        //NSLog(@"value = %d", num2);
        lua_rawgeti(L, 1, 3);
        int num3 = lua_tonumber(L, -1);
        //NSLog(@"value = %d", num3);
        lua_rawgeti(L, 1, 4);
        int num4 = lua_tonumber(L, -1);
        //NSLog(@"value = %d", num4);
        
        name = lua_tostring(L, 2);
        str = [NSString stringWithUTF8String:name];
        //NSLog(@"value = %@", str);
        float value = lua_tonumber(L, 3);
        //NSLog(@"value = %f", value);
        
        str = [fun findAllColor:str x1:num1 y1:num2 x2:num3 y2:num4 help_simi:value];

        lua_pushstring(L, str.UTF8String);
        [pool drain];
        return 1;
    }
    
    return 0;
}

@end

