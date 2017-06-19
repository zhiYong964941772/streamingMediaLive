//
//  LAIVideoCaptureViewModel.m
//  流媒体
//
//  Created by huazhan Huang on 2017/5/26.
//  Copyright © 2017年 zhiYong_lai. All rights reserved.
//
#import "LAIVideoCaptureViewModel.h"
@interface LAIVideoCaptureViewModel()<AVCaptureAudioDataOutputSampleBufferDelegate,AVCaptureVideoDataOutputSampleBufferDelegate>
{
    AVCaptureSession *_captureSession;//创建捕获会话
    AVCaptureDeviceInput *_currentVideoDeviceInput;//捕获输入流
    AVCaptureVideoPreviewLayer *_prevideoPlayer;//视频预览层
    AVCaptureConnection *_videoConnection;//捕获输出，区分音频和视频
    UIView *_superView;//寄存视图
    NSData *_videoData;//视频数据已处理
    NSData *_audioData;//音频数据已处理
    CMSampleBufferRef _videoSB;
    CMSampleBufferRef _audioSB;
}
@property (nonatomic,strong)UIImageView *focusCursorImageView;
@end
@implementation LAIVideoCaptureViewModel
- (UIImageView *)focusCursorImageView
{
    if (_focusCursorImageView == nil) {
        UIImageView *imageView = [[UIImageView alloc] init];
        _focusCursorImageView = imageView;
        [_superView addSubview:_focusCursorImageView];
    }
    return _focusCursorImageView;
}

+ (instancetype)makeVideoCaptureWithSuperView:(UIView *)view WithMakeObj:(void (^)(LAIVideoCaptureViewModel *))obj{
    LAIVideoCaptureViewModel *model = [[LAIVideoCaptureViewModel alloc]initWithView:view];
    
    obj(model);
    return model;
}
- (instancetype)initWithView:(UIView *)view{
    self = [super init];
    if (self) {
        _superView = view;
    }
    return self;
}
#pragma mark -- 配置数据获取
- (LAIVideoCaptureViewModel *)setupCaputure:(NSNumber *)videoFormat{
    NSNumber *videoF = (videoFormat)? videoFormat:@(kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange);
    _captureSession = [[AVCaptureSession alloc]init];
    
    AVCaptureDevice *videoDevice = [self getVideoDevice:AVCaptureDevicePositionFront];//配置设备摄像头
    
    AVCaptureDevice *audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];//配置设备音频
    
    _currentVideoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:nil];
    
    AVCaptureDeviceInput *audioDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:audioDevice error:nil];
    
    if ([_captureSession canAddInput:_currentVideoDeviceInput]) {
        [_captureSession addInput:_currentVideoDeviceInput];
    }
    if ([_captureSession canAddInput:audioDeviceInput]) {
        [_captureSession addInput:audioDeviceInput];
    }
    
    AVCaptureVideoDataOutput *videoOutPut = [[AVCaptureVideoDataOutput alloc]init];//获取视频输出设备
    [videoOutPut setAlwaysDiscardsLateVideoFrames:YES];//抛弃过期帧
    [videoOutPut setVideoSettings:@{(__bridge NSString*) kCVPixelBufferPixelFormatTypeKey:videoF}];//设置视频格式，yuv420
    dispatch_queue_t videoQueue = dispatch_queue_create("VideoCaptreQueue", DISPATCH_QUEUE_SERIAL);//创建串行队列，才能获取视频数据
    [videoOutPut setSampleBufferDelegate:self queue:videoQueue];
    if ([_captureSession canAddOutput:videoOutPut]) {
        [_captureSession addOutput:videoOutPut];
    }
    
    AVCaptureAudioDataOutput *audioOutPut = [[AVCaptureAudioDataOutput alloc]init];
    dispatch_queue_t audioQueue = dispatch_queue_create("VideoCaptreQueue", DISPATCH_QUEUE_SERIAL);//创建串行队列，才能获取音频数据
    [audioOutPut setSampleBufferDelegate:self queue:audioQueue];
    if ([_captureSession canAddOutput:audioOutPut]) {
        [_captureSession addOutput:audioOutPut];
    }
    #pragma mark -- //捕获数据
    _videoConnection = [videoOutPut connectionWithMediaType:AVMediaTypeVideo];
    
    _prevideoPlayer = [AVCaptureVideoPreviewLayer layerWithSession:_captureSession];
    _prevideoPlayer.frame = _superView.bounds;
    [_superView.layer insertSublayer:_prevideoPlayer atIndex:0];
    
    return self;
}
#pragma mark -- 启动
- (LAIVideoCaptureViewModel *)startDeviceRunning{
    if (_captureSession) {
        [_captureSession startRunning];
    }
    return self;
}
#pragma mark -- 停止
- (LAIVideoCaptureViewModel *)stopDeviceRunning{
    if (_captureSession) {
        [_captureSession stopRunning];
    }
    return self;
}
#pragma mark -- 设置初始摄像头
- (AVCaptureDevice *)getVideoDevice:(AVCaptureDevicePosition)postion{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if (device.position == postion) {
            return device;
        }
    }
    return nil;
}
#pragma mark -- 切换摄像头
- (LAIVideoCaptureViewModel *)toggleCapture{
    
    AVCaptureDevicePosition curPosition = _currentVideoDeviceInput.device.position;//获取当前方向
    
    // 获取需要改变的方向
    AVCaptureDevicePosition togglePosition = (curPosition == AVCaptureDevicePositionFront)?AVCaptureDevicePositionBack:AVCaptureDevicePositionFront;

    AVCaptureDevice *toggleDevice = [self getVideoDevice:togglePosition];//配置新方向
    
    AVCaptureDeviceInput *toggleDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:toggleDevice error:nil];//获取新方向的输入流
    
    [_captureSession removeInput:_currentVideoDeviceInput];//添加
    if ([_captureSession canAddInput:toggleDeviceInput]) {
        [_captureSession addInput:toggleDeviceInput];
        _currentVideoDeviceInput = toggleDeviceInput;
    }
    return self;
}
#pragma mark -- 聚焦
- (LAIVideoCaptureViewModel *)touchFocusCursorWithBegan:(NSSet<UITouch *> *)touches WithFocus:(void (^)(CGPoint focusPoint))focusPoint{
    
    UITouch *touch = [touches anyObject];
    
    CGPoint point = [touch locationInView:_superView];
    
    CGPoint capturePoint  = [_prevideoPlayer captureDevicePointOfInterestForPoint:point];//将点击位置转换为摄像上的位置
    [self setFocuscursorWithPoint:point];
    // 设置聚焦
    [self focusWithMode:AVCaptureFocusModeAutoFocus exposureMode:AVCaptureExposureModeAutoExpose atPoint:capturePoint];
    return self;
  }
#pragma mark -- 确定聚焦位置
- (void)setFocuscursorWithPoint:(CGPoint)point{
    
    self.focusCursorImageView.center=point;
    self.focusCursorImageView.transform=CGAffineTransformMakeScale(1.5, 1.5);
    self.focusCursorImageView.alpha=1.0;
    [UIView animateWithDuration:1.0 animations:^{
        self.focusCursorImageView.transform=CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.focusCursorImageView.alpha=0;
        
    }];

}
#pragma mark -- 设置聚焦
-(void)focusWithMode:(AVCaptureFocusMode)focusMode exposureMode:(AVCaptureExposureMode)exposureMode atPoint:(CGPoint)point{
    
    AVCaptureDevice *captureDevice = _currentVideoDeviceInput.device;
    // 锁定配置
    [captureDevice lockForConfiguration:nil];
    
    // 设置聚焦
    if ([captureDevice isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
        [captureDevice setFocusMode:AVCaptureFocusModeAutoFocus];
    }
    if ([captureDevice isFocusPointOfInterestSupported]) {
        [captureDevice setFocusPointOfInterest:point];
    }
    
    // 设置曝光
    if ([captureDevice isExposureModeSupported:AVCaptureExposureModeAutoExpose]) {
        [captureDevice setExposureMode:AVCaptureExposureModeAutoExpose];
    }
    if ([captureDevice isExposurePointOfInterestSupported]) {
        [captureDevice setExposurePointOfInterest:point];
    }
    
    // 解锁配置
    [captureDevice unlockForConfiguration];
}
#pragma mark -- 获取音视频数据
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
    if (connection == _videoConnection) {
        _videoSB = sampleBuffer;
        if (_videoSampleBuffer) {
            _videoSampleBuffer(_videoSB ,self);
        }

    }else{
        _audioSB = sampleBuffer;
        if (_audioSampleBuffer) {
            _audioSampleBuffer(_audioSB ,self);
        }

    }
}
#pragma mark -- 设置对焦图片
- (void)setImageName:(NSString *)imageName{
    self.focusCursorImageView.image = [UIImage imageNamed:@"focus"];
}
#pragma mark -- 转换视频格式
- (id)convertVideoSmapleBufferToYuvData:(CMSampleBufferRef)SampleBufferRef{
    if (!SampleBufferRef)return VIDEOERROR;
    CVImageBufferRef pBuffer = CMSampleBufferGetImageBuffer(SampleBufferRef);//yuv420数据
    CVPixelBufferLockBaseAddress(pBuffer, 0);//锁定开始操作数据
    size_t pixelW = CVPixelBufferGetWidth(pBuffer);//图像宽度（像素）设置支持的录取像素
    size_t pixelH = CVPixelBufferGetHeight(pBuffer);//图像高度（像素）设置支持的录取像素
    size_t y_size = pixelW * pixelH;//yuv中的y所占字节数
    size_t uv_size = y_size*0.5; //yuv中的uv所占的字节数
    uint8_t *yuv_frame = malloc(y_size + uv_size);//总字节
    uint8_t *y_frame = CVPixelBufferGetBaseAddressOfPlane(pBuffer, 0);//获取y亮度数据指针
    uint8_t *uv_frame = CVPixelBufferGetBaseAddressOfPlane(pBuffer, 1);
    if ((yuv_frame == NULL)||(y_frame == NULL))return VIDEOERROR;
    memcpy(yuv_frame, y_frame, y_size);//memcpy函数的功能是从源src所指的内存地址的起始位置开始拷贝n个字节到目标dest所指的内存地址的起始位置中。
    memcpy(yuv_frame + y_size, uv_frame, uv_size);
    //获取uv色差数据
    CVPixelBufferUnlockBaseAddress(pBuffer, 0);
    return [NSData dataWithBytesNoCopy:yuv_frame length:(y_size+uv_size)];
    
    
}
#pragma mark -- 转换音频pcm格式
- (id)convertAudioSmapleBufferToPcmData:(CMSampleBufferRef)SampleBufferRef{
    if (!SampleBufferRef)return AUDIOERROR;
    //获取pcm数据大小
    NSInteger audioDataSize = CMSampleBufferGetTotalSampleSize(SampleBufferRef);
    
    //分配空间
    int8_t *audio_data = malloc((int32_t)audioDataSize);
    if (audio_data == NULL)return AUDIOERROR;
    //这个结构里面就保存了 PCM数据
    CMBlockBufferRef dataBuffer = CMSampleBufferGetDataBuffer(SampleBufferRef);//获取CMBlockBufferRef
    //直接将数据copy至我们自己分配的内存中
    CMBlockBufferCopyDataBytes(dataBuffer, 0, audioDataSize, audio_data);
    
    //返回数据
    return [NSData dataWithBytesNoCopy:audio_data length:audioDataSize];
}
#pragma mark -- 获取转换的音视频数据
- (id)getAudioData{
    
     id audioData = [self convertAudioSmapleBufferToPcmData:_audioSB];
    return audioData;
}
- (id)getVideoData{
    id videoData = [self convertVideoSmapleBufferToYuvData:_videoSB];
    return videoData;
}
@end
