//
//  WTBaseMSCEngine.m
//  WTIFlytek
//
//  Created by jienliang on 2018/3/28.
//  Copyright © 2018年 jienliang. All rights reserved.
//

#import "WTBaseMSCEngine.h"
#import "IATConfig.h"
#import "TTSConfig.h"

@implementation WTBaseMSCEngine
- (void)initSetting {
    [IFlySetting setLogFile:LVL_ALL];
    [IFlySetting showLogcat:YES];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = paths.firstObject;
    [IFlySetting setLogFilePath:cachePath];
    
    //登陆语音平台
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@",@"appid"];
    [IFlySpeechUtility createUtility:initString];
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

+ (NSString *)relayString:(id)str
{
    if(str == nil
       || str == NULL
       || [str isKindOfClass:[NSNull class]]
       ||([str respondsToSelector:@selector(length)]
          && [(NSData *)str length] == 0)
       || ([str respondsToSelector:@selector(count)]
           && [(NSArray *)self count] == 0)){
           return @"";
       }
    else if([str isKindOfClass:[NSString class]]){
        return str;
    } else if ([str isKindOfClass:[NSNumber class]]) {
        return [str stringValue];
    }
    return str;
}

@end
