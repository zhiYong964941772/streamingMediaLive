//
//  LAIVideoCaptureViewModel.h
//  流媒体
//
//  Created by huazhan Huang on 2017/5/26.
//  Copyright © 2017年 zhiYong_lai. All rights reserved.
//
/*1、视频：yuv是什么？NV12又是什么？
 
 视频是由一帧一帧的数据连接而成，而一帧视频数据其实就是一张图片。
 
 yuv是一种图片储存格式，跟RGB格式类似。
 
 RGB格式的图片很好理解，计算机中的大多数图片，都是以RGB格式存储的。
 
 yuv中，y表示亮度，单独只有y数据就可以形成一张图片，只不过这张图片是灰色的。u和v表示色差(u和v也被称为：Cb－蓝色差，Cr－红色差)，
 
 为什么要yuv？
 
 有一定历史原因，最早的电视信号，为了兼容黑白电视，采用的就是yuv格式。
 
 一张yuv的图像，去掉uv，只保留y，这张图片就是黑白的。
 
 而且yuv可以通过抛弃色差来进行带宽优化。
 
 比如yuv420格式图像相比RGB来说，要节省一半的字节大小，抛弃相邻的色差对于人眼来说，差别不大。
 
 一张yuv格式的图像，占用字节数为 (width * height + (width * height) / 4 + (width * height) / 4) = (width * height) * 3 / 2
 一张RGB格式的图像，占用字节数为（width * height） * 3
 
 在传输上，yuv格式的视频也更灵活(yuv3种数据可分别传输)。
 
 很多视频编码器最初是不支持rgb格式的。但是所有的视频编码器都支持yuv格式。
 
 综合来讲，我们选择使用yuv格式，所以我们编码之前，首先将视频数据转成yuv格式。
 
 我们这里使用的就是yuv420格式的视频。
 
 yuv420也包含不同的数据排列格式：I420，NV12，NV21.
 
 其格式分别如下，
 I420格式：y,u,v 3个部分分别存储：Y0,Y1…Yn,U0,U1…Un/2,V0,V1…Vn/2
 NV12格式：y和uv 2个部分分别存储：Y0,Y1…Yn,U0,V0,U1,V1…Un/2,Vn/2
 NV21格式：同NV12，只是U和V的顺序相反。
 
 综合来说，除了存储顺序不同之外，上述格式对于显示来说没有任何区别。
 
 使用哪种视频的格式，取决于初始化相机时设置的视频输出格式。
 设置为kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange时，表示输出的视频格式为NV12；
 设置为kCVPixelFormatType_420YpCbCr8Planar时，表示使用I420。
 
 2、音频：脉冲编码调制，其实是将不规则的模拟信号转换成数字信号，这样就可以通过物理介质存储起来。
 
 而声音也是一种特定频率（20-20000HZ）的模拟信号，也可以通过这种技术转换成数字信号，从而保存下来。
 
 PCM格式，就是录制声音时，保存的最原始的声音数据格式。
 
 相信你应该听说过wav格式的音频，它其实就是给PCM数据流加上一段header数据，就成为了wav格式。
 
 而wav格式有时候之所以被称为无损格式，就是因为他保存的是原始pcm数据（也跟采样率和比特率有关）。
 
 像我们耳熟能详的那些音频格式，mp3，aac等等，都是有损压缩，为了节约占用空间，在很少损失音效的基础上，进行最大程度的压缩。
 
 所有的音频编码器，都支持pcm编码，而且录制的声音，默认也是PCM格式，所以我们下一步就是要获取录制的PCM数据
 */
#define VIDEOERROR @"自定义提醒"
#define AUDIOERROR @"自定义提醒"
#import <Foundation/Foundation.h>
@import AVFoundation;

@interface LAIVideoCaptureViewModel : NSObject
/*
 *初始化一个ViewModel对象，传入一个layer赖以存在的父视图
 */
+ (instancetype)makeVideoCaptureWithSuperView:(UIView *)view WithMakeObj:(void (^)(LAIVideoCaptureViewModel *obj))obj;
/*
 *对焦的时候用到，在父视图touchBegan里面调用
 */
- (LAIVideoCaptureViewModel *)touchFocusCursorWithBegan:(NSSet<UITouch *> *)touches WithFocus:(void (^)(CGPoint))focusPoint;
/*
 *建立连接
 */
- (LAIVideoCaptureViewModel *)startDeviceRunning;
/*
 *断开连接
 */
- (LAIVideoCaptureViewModel *)stopDeviceRunning;
/*
 *转换摄像头，一般在点击时间调用
 */
- (LAIVideoCaptureViewModel *)toggleCapture;
/*
 *设置焦点图片
 */
- (void)setImageName:(NSString *)imageName;
/*
 *配置视频格式，默认：yuv420
 */
- (LAIVideoCaptureViewModel *)setupCaputure:(NSNumber *)VideoFormat;

/*
 * 获取数据（未转换的视频数据）
 */
@property (nonatomic, copy)void (^videoSampleBuffer)(CMSampleBufferRef videoSB ,id videoSelf);
@property (nonatomic, copy)void (^audioSampleBuffer)(CMSampleBufferRef audioSB ,id audioSelf);
/*
 * 获取数据（已转换的视频数据）,必须在各自对应的SampleBufferBlock里调用，目前只提供yuv420转码
 */
- (id)getVideoData;
- (id)getAudioData;

@end
