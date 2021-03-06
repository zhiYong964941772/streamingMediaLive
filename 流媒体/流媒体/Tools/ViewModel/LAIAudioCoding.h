//
//  LAIAudioCoding.h
//  流媒体
//
//  Created by huazhan Huang on 2017/6/19.
//  Copyright © 2017年 zhiYong_lai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
typedef NS_ENUM(NSInteger,PCMCodecType){
    PCMCodecTypeSOFT = 0,//软编码
    PCMCodecTypeHARD = 1//硬编码
};
@interface LAIAudioCoding : NSObject


/**
编码acc数据

 @param type pcm编码格式
·@return 对象
 */
+ (instancetype)getCodingOfCodeType:(PCMCodecType)type;
- (instancetype)setupAudioBoxWithPCM:(CMSampleBufferRef)samplebufferRef;
@end
