//
//  WTRecognizerUtil.m
//  WTIFlytekUtilDemo
//
//  Created by admin on 2018/3/28.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "WTRecognizerUtil.h"
#import "IATConfig.h"
#import "WTSpeakingUtil.h"
@interface WTRecognizerUtil ()<IFlyRecognizerViewDelegate>
@property (nonatomic, strong) IFlyRecognizerView *iflyRecognizerView;//带界面的识别对象
@property (nonatomic, copy) NSString *speakLanguage;
- (void)setLanguageParam:(NSString *)language;
@end

@implementation WTRecognizerUtil
+ (instancetype)shareInstance
{
    static WTRecognizerUtil *share = nil ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        share = [[WTRecognizerUtil alloc]init];
        [share initSetting];
    });
    return share;
}

- (void)setLanguageParam:(NSString *)language {
    self.speakLanguage = language;
    
    [self.iflyRecognizerView setParameter:@"1" forKey:@"sch"];
    [self.iflyRecognizerView setParameter:@"translate" forKey:@"addcap"];
    [self.iflyRecognizerView setParameter:@"0" forKey:@"cua"];
    if ([language isEqualToString:WT_Language_Chinese]) {
        //设置语言
        [self.iflyRecognizerView setParameter:WT_Language_Chinese forKey:[IFlySpeechConstant LANGUAGE]];
        //设置方言
        [self.iflyRecognizerView setParameter:IATConfig.sharedInstance.accent forKey:[IFlySpeechConstant ACCENT]];
        [self.iflyRecognizerView setParameter:WT_Language_Chinese forKey:@"orilang"];
        [self.iflyRecognizerView setParameter:WT_Language_English forKey:@"translang"];
    } else if ([language isEqualToString:WT_Language_English]) {
        //设置语言
        [self.iflyRecognizerView setParameter:WT_Language_English forKey:[IFlySpeechConstant LANGUAGE]];
        
        [self.iflyRecognizerView setParameter:WT_Language_English forKey:@"orilang"];
        [self.iflyRecognizerView setParameter:WT_Language_Chinese forKey:@"translang"];
    }
}

// 设置识别参数
-(void)initRecognizer {
    //单例模式，UI的实例
    if (_iflyRecognizerView == nil) {
        //UI显示居中
        _iflyRecognizerView= [[IFlyRecognizerView alloc] initWithCenter:[UIApplication sharedApplication].keyWindow.center];
        [_iflyRecognizerView setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
        //设置听写模式
        [_iflyRecognizerView setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
    }
    
    _iflyRecognizerView.delegate = self;
    if (_iflyRecognizerView != nil) {
        IATConfig *instance = [IATConfig sharedInstance];
        //设置最长录音时间
        [_iflyRecognizerView setParameter:instance.speechTimeout forKey:[IFlySpeechConstant SPEECH_TIMEOUT]];
        //设置后端点
        [_iflyRecognizerView setParameter:instance.vadEos forKey:[IFlySpeechConstant VAD_EOS]];
        //设置前端点
        [_iflyRecognizerView setParameter:instance.vadBos forKey:[IFlySpeechConstant VAD_BOS]];
        //网络等待时间
        [_iflyRecognizerView setParameter:@"20000" forKey:[IFlySpeechConstant NET_TIMEOUT]];
        //设置采样率，推荐使用16K
        [_iflyRecognizerView setParameter:instance.sampleRate forKey:[IFlySpeechConstant SAMPLE_RATE]];
        
        [self setLanguageParam:self.speakLanguage];
        //设置是否返回标点符号
        [_iflyRecognizerView setParameter:instance.dot forKey:[IFlySpeechConstant ASR_PTT]];
    }
}

- (void)startRecognizer:(NSString *)language onFail:(void (^)(void))onFail onSuccess:(void (^)(NSString *orgString,NSString *destString))onSuccess {
    self.speakLanguage = language;
    self.recognizerFail = onFail;
    self.recognizerSuccess = onSuccess;

    [[WTSpeakingUtil shareInstance] stopSpeaking];
    [self initRecognizer];
    [self setLanguageParam:language];
    
    [_iflyRecognizerView setParameter:IFLY_AUDIO_SOURCE_MIC forKey:@"audio_source"];
    [_iflyRecognizerView setParameter:@"plain" forKey:[IFlySpeechConstant RESULT_TYPE]];
    [_iflyRecognizerView setParameter:@"asr.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
    [_iflyRecognizerView setParameter:@"its" forKey:@"trssrc"];
    [_iflyRecognizerView start];
}

#pragma mark 错误的回调函数
- (void) onError:(IFlySpeechError *) error
{
    if ([IATConfig sharedInstance].haveView == NO ) {
    }else {
        NSLog(@"errorCode:%d",[error errorCode]);
    }
    
    if (error.errorCode!=0 && self.recognizerFail) {
        self.recognizerFail();
    }
}

// 有界面，听写结果回调
// resultArray：听写结果
// isLast：表示最后一次
- (void)onResult:(NSArray *)resultArray isLast:(BOOL)isLast
{
    NSMutableString *result = [[NSMutableString alloc] init];
    NSDictionary *dic = [resultArray objectAtIndex:0];
    
    for (NSString *key in dic) {
        [result appendFormat:@"%@",key];
    }
    NSString *resultString = [NSString stringWithFormat:@"%@",result];
    NSDictionary *ddd = [WTBaseMSCEngine dictionaryWithJsonString:resultString];
    if (ddd[@"trans_result"]) {
        NSString *src = [WTBaseMSCEngine relayString:ddd[@"trans_result"][@"src"]];
        NSString *dst = [WTBaseMSCEngine relayString:ddd[@"trans_result"][@"dst"]];
        if (src.length>0 && dst.length>0) {
            if (self.recognizerSuccess) {
                self.recognizerSuccess(src, dst);
            }
        }
    }
}

@end
