//
//  WTRecognizerUtil.h
//  WTIFlytekUtilDemo
//
//  Created by admin on 2018/3/28.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WTBaseIFlytek.h"
#import "IFlyMSC/IFlyMSC.h"
#import "WTIFlyEnum.h"
@interface WTRecognizerUtil : WTBaseIFlytek
/**
 * 单例对象
 */
+ (instancetype)shareInstance;
@property (copy, nonatomic) void (^recognizerSuccess)(NSString *orgString,NSString *destString);
@property (copy, nonatomic) void (^recognizerFail)(void);

//开启语音识别模式，language表示说话的语言
- (void)startRecognizer:(NSString *)language onFail:(void (^)(void))onFail onSuccess:(void (^)(NSString *orgString,NSString *destString))onSuccess;
@end
