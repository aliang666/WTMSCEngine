//
//  WTBaseIFlytek.h
//  WTIFlytek
//
//  Created by jienliang on 2018/3/28.
//  Copyright © 2018年 jienliang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTBaseIFlytek : NSObject
- (void)initSetting;
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
+ (NSString *)relayString:(id)str;
@end
