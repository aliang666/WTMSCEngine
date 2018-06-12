//
//  WTSpeakingUtil.h
//  WTIFLytek
//  给出文字，将文字语音读出
//  Created by admin on 2017/12/25.
//  Copyright © 2017年 chenSir. All rights reserved.
//

#import "WTSpeakingUtil.h"
#import "TTSConfig.h"
#import "PcmPlayer.h"
#import "IFlyMSC/IFlyMSC.h"

@interface WTSpeakingUtil ()<IFlySpeechSynthesizerDelegate>
@property (nonatomic, strong) IFlySpeechSynthesizer *iFlySpeechSynthesizer;
@end

@implementation WTSpeakingUtil
+ (instancetype)shareInstance
{
    static WTSpeakingUtil *share = nil ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        share = [[WTSpeakingUtil alloc]init];
         [share initSetting];
        [share initSpeak];
    });
    return share;
}

- (void)initSpeak {
    _iFlySpeechSynthesizer = [IFlySpeechSynthesizer sharedInstance];
    _iFlySpeechSynthesizer.delegate = self;
}

- (void)setLanguageParam:(NSString *)language {
    TTSConfig *instance = [TTSConfig sharedInstance];
    if (instance == nil) {
        return;
    }
     
    [self.iFlySpeechSynthesizer setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
    // 设置语速1-100
    [self.iFlySpeechSynthesizer setParameter:instance.speed forKey:[IFlySpeechConstant SPEED]];
    // 设置音量1-100
    [self.iFlySpeechSynthesizer setParameter:instance.volume forKey:[IFlySpeechConstant VOLUME]];
    // 设置音调1-100
    [self.iFlySpeechSynthesizer setParameter:instance.pitch forKey:[IFlySpeechConstant PITCH]];
    // 设置采样率
    [self.iFlySpeechSynthesizer setParameter:instance.sampleRate forKey:[IFlySpeechConstant SAMPLE_RATE]];
    // 设置文本编码格式
    [self.iFlySpeechSynthesizer setParameter:@"unicode" forKey:[IFlySpeechConstant TEXT_ENCODING]];
    // 云端
    [self.iFlySpeechSynthesizer setParameter:@"cloud" forKey:[IFlySpeechConstant ENGINE_TYPE]];
    
    if ([language isEqualToString:WT_Language_Uygur]) {// 维语
        [self.iFlySpeechSynthesizer setParameter:@"Guli" forKey:[IFlySpeechConstant VOICE_NAME]];
        [self.iFlySpeechSynthesizer setParameter:@"http://dev.voicecloud.cn:80/msp.do" forKey:@"server_url"];
    }
    else if ([language isEqualToString:WT_Language_Chinese]) {//汉语
        //默认使用女声
        [self.iFlySpeechSynthesizer setParameter:@"x" forKey:@"ent"];
        [self.iFlySpeechSynthesizer setParameter:@"xiaoyan" forKey:[IFlySpeechConstant VOICE_NAME]];
    } else if ([language isEqualToString:WT_Language_English]) {//英语
        //默认使用女声
        [self.iFlySpeechSynthesizer setParameter:@"x" forKey:@"ent"];
        [self.iFlySpeechSynthesizer setParameter:@"Catherine" forKey:[IFlySpeechConstant VOICE_NAME]];
    }
}

- (PcmPlayer *)audioPlayer {
    PcmPlayer *player = [[PcmPlayer alloc] init];
    return player;
}

- (void)startSpeak:(NSString *)voiceText language:(NSString *)language onSpeak:(void (^)(void))onSpeak onComplete:(void (^)(void))onComplete {
     self.onSpeak = onSpeak;
     self.onComplete = onComplete;
     [self.iFlySpeechSynthesizer stopSpeaking];
    PcmPlayer *ppp = [self audioPlayer];
    if (ppp.isPlaying) {
        [ppp stop];
    }
     if (voiceText==nil||voiceText.length==0) {
          return;
     }
     [self setLanguageParam:language];
    [self.iFlySpeechSynthesizer startSpeaking:voiceText];
}

- (void)stopSpeaking {
     [self.iFlySpeechSynthesizer stopSpeaking];
}

#pragma IFlySpeechSynthesizerDelegate 代理方法
-(void)onSpeakBegin
{
    NSLog(@"=====开始识别中=====");
     if (self.onSpeak) {
          self.onSpeak();
     }
}

-(void)onCompleted:(IFlySpeechError *) error
{
    NSLog(@"=====识别完成了=====");
     if (self.onComplete) {
          self.onComplete();
     }
}
@end
