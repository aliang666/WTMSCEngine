//
//  WTMSCEnum.h
//  WTIFlytek
//
//  Created by jienliang on 14-5-8.
//  Copyright (c) 2014年 jienliang. All rights reserved.
//

#ifndef WTLibrary_WTMSCEnum_h
#define WTLibrary_WTMSCEnum_h
typedef NS_ENUM(NSInteger, WTTranslationType) {
     WTTranslationTypeCnUS     = 0,//中英翻译
     WTTranslationTypeCnUG = 1, //汉维翻译
};

#define WT_Language_Chinese @"cn"
#define WT_Language_English @"en"
#define WT_Language_Uygur @"ug"
#endif
