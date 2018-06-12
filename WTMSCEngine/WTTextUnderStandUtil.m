//
//  WTTextUnderStandUtil.h
//  WTIFlytek
//  中英文文本互译
//  Created by admin on 2018/1/8.
//  Copyright © 2018年 IFly. All rights reserved.
//

#import "WTTextUnderStandUtil.h"
#import "IFlyMSC/IFlyMSC.h"

@interface WTTextUnderStandUtil ()
@property (nonatomic,strong) IFlyTextUnderstander *iFlyUnderStand;

@end

@implementation WTTextUnderStandUtil
+ (instancetype)shareInstance
{
     static WTTextUnderStandUtil *share = nil ;
     static dispatch_once_t onceToken;
     dispatch_once(&onceToken, ^{
          share = [[WTTextUnderStandUtil alloc]init];
         [share initSetting];
          share.iFlyUnderStand = [[IFlyTextUnderstander alloc] init];
     });
     return share;
}

//中英
- (void)configueCnUSIFlyTextUnderstander:(BOOL)isChinese {
     [self.iFlyUnderStand setParameter:@"1" forKey:@"sch"];
     [self.iFlyUnderStand setParameter:@"translate" forKey:@"addcap"];
     [self.iFlyUnderStand setParameter:@"0" forKey:@"cua"];
     if (isChinese) {
          [self.iFlyUnderStand setParameter:WT_Language_Chinese forKey:@"orilang"];
          [self.iFlyUnderStand setParameter:WT_Language_English forKey:@"translang"];
     } else {
          [self.iFlyUnderStand setParameter:WT_Language_English forKey:@"orilang"];
          [self.iFlyUnderStand setParameter:WT_Language_Chinese forKey:@"translang"];
     }
}

//汉维
- (void)configueCnUGIFlyTextUnderstander {
     [self.iFlyUnderStand setParameter:@"1" forKey:@"sch"];
     [self.iFlyUnderStand setParameter:@"translate" forKey:@"addcap"];
     [self.iFlyUnderStand setParameter:@"0" forKey:@"cua"];
     [self.iFlyUnderStand setParameter:WT_Language_Chinese forKey:@"orilang"];
     [self.iFlyUnderStand setParameter:WT_Language_Uygur forKey:@"translang"];
}

//中英文语义理解
- (void)textUnderStandCnUs:(NSString *)orgText isChinese:(BOOL)isChinese success:(void (^)(NSString *result))success  fail:(void (^)(WTTextUnderStandErrorType errorType))fail {
     [self configueCnUSIFlyTextUnderstander:isChinese];
     [self.iFlyUnderStand understandText:orgText withCompletionHandler:^(NSString *result, IFlySpeechError *error) {
          NSDictionary *ddd = [WTBaseIFlytek dictionaryWithJsonString:result];
          NSArray *ar = ddd[@"results"];
          if (ar && [ar isKindOfClass:[NSArray class]] && ar.count>0) {
               NSDictionary *dic = ar[0];
//               NSString *orgResult = [WTTextUnderStandUtil relayString:dic[@"original"]];
               NSString *destResult = [WTBaseIFlytek relayString:dic[@"translated"]];
               success(destResult);
          } else {
               fail (WTTextUnderStandErrorTypeCloudError);
          }
     }];
}
@end
