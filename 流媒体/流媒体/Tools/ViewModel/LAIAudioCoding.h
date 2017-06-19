//
//  LAIAudioCoding.h
//  流媒体
//
//  Created by huazhan Huang on 2017/6/19.
//  Copyright © 2017年 zhiYong_lai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@interface LAIAudioCoding : NSObject

/**
硬编码acc数据

 @param samplebufferRef pcm音频数据
 @return  获取一个硬编码acc数据

 */
+(id)getCodingAudioBoxWithHard:(CMSampleBufferRef)samplebufferRef;

/**
 软编码acc数据

 @param samplebufferRef pcm音频数据
 @return 获取一个软编码acc数据
 */
+(id)getCodingAudioBoxWithSoft:(CMSampleBufferRef)samplebufferRef;

@end
