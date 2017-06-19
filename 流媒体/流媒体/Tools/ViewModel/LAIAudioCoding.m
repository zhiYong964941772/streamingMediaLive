//
//  LAIAudioCoding.m
//  流媒体
//
//  Created by huazhan Huang on 2017/6/19.
//  Copyright © 2017年 zhiYong_lai. All rights reserved.
//

#import "LAIAudioCoding.h"
//@import AudioToolbox;
@implementation LAIAudioCoding
+(id)getCodingAudioBoxWithSoft:(CMSampleBufferRef)samplebufferRef{
    AudioStreamBasicDescription intputAudioStream  = *CMAudioFormatDescriptionGetStreamBasicDescription((CMAudioFormatDescriptionRef)CMSampleBufferGetFormatDescription(samplebufferRef));
    AudioStreamBasicDescription outputAudioStream = {0};
    outputAudioStream.mSampleRate = intputAudioStream.mSampleRate;
    outputAudioStream.mFormatID = kAudioFormatMPEG4AAC;
    outputAudioStream.mFormatFlags = kMPEG4Object_AAC_LC;
    outputAudioStream.mBytesPerPacket = 0;
    outputAudioStream.mFramesPerPacket = 1024;
    return nil;
}
@end
