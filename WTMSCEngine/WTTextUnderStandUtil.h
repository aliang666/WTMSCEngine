//
//  WTTextUnderStandUtil.h
//  WTIFlytek
//  中英文文本互译
//  Created by admin on 2018/1/8.
//  Copyright © 2018年 IFly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WTMSCEnum.h"
#import "WTBaseMSCEngine.h"

typedef NS_ENUM(NSInteger, WTTextUnderStandErrorType) {
     WTTextUnderStandErrorTypeNetError     = 0,//无网络
     WTTextUnderStandErrorTypeCloudError = 1, //云端无法识别
};

@interface WTTextUnderStandUtil : WTBaseMSCEngine
/**
 * 单例对象
 */
+ (instancetype)shareInstance;
//中英文语义理解
- (void)textUnderStandCnUs:(NSString *)orgText isChinese:(BOOL)isChinese success:(void (^)(NSString *result))success fail:(void (^)(WTTextUnderStandErrorType errorType))fail;
@end
