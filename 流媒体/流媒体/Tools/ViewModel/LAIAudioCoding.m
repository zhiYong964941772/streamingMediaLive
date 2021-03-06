//
//  LAIAudioCoding.m
//  流媒体
//
//  Created by huazhan Huang on 2017/6/19.
//  Copyright © 2017年 zhiYong_lai. All rights reserved.
//

#import "LAIAudioCoding.h"

@interface LAIAudioCoding()
{
    unsigned int _code;
    AudioConverterRef _audioConverter;
}
@end

@implementation LAIAudioCoding
@dynamic description;
+(instancetype)getCodingOfCodeType:(PCMCodecType)type{
    unsigned int code;//编码类型

    switch (type) {
        case PCMCodecTypeSOFT:
            code = kAppleSoftwareAudioCodecManufacturer;
            break;
        case PCMCodecTypeHARD:
            code = kAppleHardwareAudioCodecManufacturer;

            break;
        default:
            break;
    }
    
    LAIAudioCoding *audioCode = [[LAIAudioCoding alloc]initWithCode:code];
    return audioCode;
    
}
- (instancetype)initWithCode:(unsigned int)code{
    if (self = [super init]) {
        _code = code;
    }
    return self;
}
- (instancetype)setupAudioBoxWithPCM:(CMSampleBufferRef)samplebufferRef{
    AudioStreamBasicDescription intputAudioStream  = *CMAudioFormatDescriptionGetStreamBasicDescription((CMAudioFormatDescriptionRef)CMSampleBufferGetFormatDescription(samplebufferRef));
    AudioStreamBasicDescription outputAudioStream = {0};
    // 初始化输出流的结构体描述为0. 很重要。
    outputAudioStream.mSampleRate = intputAudioStream.mSampleRate; // 音频流，在正常播放情况下的帧率。如果是压缩的格式，这个属性表示解压缩后的帧率。帧率不能为0。
    outputAudioStream.mFormatID = kAudioFormatMPEG4AAC; // 设置编码格式
    outputAudioStream.mFormatFlags = kMPEG4Object_AAC_LC; // 无损编码 ，0表示没有
    outputAudioStream.mBytesPerPacket = 0; // 每一个packet的音频数据大小。如果的动态大小，设置为0。动态大小的格式，需要用AudioStreamPacketDescription 来确定每个packet的大小。
    outputAudioStream.mFramesPerPacket = 1024; // 每个packet的帧数。如果是未压缩的音频数据，值是1。动态帧率格式，这个值是一个较大的固定数字，比如说AAC的1024。如果是动态大小帧数（比如Ogg格式）设置为0。
    outputAudioStream.mBytesPerFrame = 0; //  每帧的大小。每一帧的起始点到下一帧的起始点。如果是压缩格式，设置为0 。
    outputAudioStream.mChannelsPerFrame = 1; // 声道数
    outputAudioStream.mBitsPerChannel = 0; // 压缩格式设置为0
    outputAudioStream.mReserved = 0; // 8字节对齐，填0.
    AudioClassDescription *description = [self getAudioClassDescriptionWithCodeType:kAudioFormatMPEG4AAC];
    OSStatus status = AudioConverterNewSpecific(&intputAudioStream, &outputAudioStream, 1, description, &_audioConverter); // 创建转换器
    if (status != 0) {
        NSLog(@"setup converter: %d", (int)status);
    }

    return self;
}
- (AudioClassDescription *)getAudioClassDescriptionWithCodeType:(UInt32)type{
    static AudioClassDescription desc;
    UInt32 encoderSpecifier = type;
    OSStatus ost;
    UInt32 size;
    ost = AudioFormatGetPropertyInfo(kAudioFormatProperty_Encoders, sizeof(encoderSpecifier), &encoderSpecifier, &size); //获取一个缓冲大小
    NSLog(@"%d",ost);
    unsigned int count = size/ sizeof(AudioClassDescription);
    AudioClassDescription descriptions[count];
    
    ost = AudioFormatGetProperty(kAudioFormatProperty_Encoders, sizeof(encoderSpecifier), &encoderSpecifier, &size, descriptions);//往缓冲区写入数据
    NSLog(@"%d",ost);
    for (int i = 0; i<count; i++) {
        if ((type == descriptions[i].mSubType)&&(_code == descriptions[i].mManufacturer)) {
            memcpy(&desc, &(descriptions[i]), sizeof(desc));
            return &desc;
        }
    }
    return nil;
}
@end
