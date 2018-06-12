//
//  WTSpeakingUtil.h
//  WTIFLytek
//  给出文字，将文字语音读出
//  Created by admin on 2017/12/25.
//  Copyright © 2017年 chenSir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WTMSCEnum.h"
#import "WTBaseMSCEngine.h"

@interface WTSpeakingUtil : WTBaseMSCEngine
/**
 * 单例对象
 */
+ (instancetype)shareInstance;
@property (copy, readwrite, nonatomic) void (^onSpeak)(void);
@property (copy, readwrite, nonatomic) void (^onComplete)(void);
//讯飞语音说出文字内容
- (void)startSpeak:(NSString *)voiceText language:(NSString *)language onSpeak:(void (^)(void))onSpeak onComplete:(void (^)(void))onComplete;
- (void)stopSpeaking;
@end
