//
//  LAIVideoCaptureViewController.m
//  流媒体
//
//  Created by huazhan Huang on 2017/5/26.
//  Copyright © 2017年 zhiYong_lai. All rights reserved.
//

#import "LAIVideoCaptureViewController.h"
#import "LAIVideoCaptureViewModel.h"
@interface LAIVideoCaptureViewController ()
{
    LAIVideoCaptureViewModel *_captureViewModel;
}
@end

@implementation LAIVideoCaptureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 _captureViewModel = [LAIVideoCaptureViewModel makeVideoCaptureWithSuperView:self.view WithMakeObj:^(LAIVideoCaptureViewModel *obj) {
     [obj setImageName:@"focus"];
     [[obj setupCaputure:@(kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange)]startDeviceRunning];
     obj.videoSampleBuffer = ^(CMSampleBufferRef videoSB, id videoSelf) {
         if ([videoSelf isMemberOfClass:[LAIVideoCaptureViewModel class]]) {
             [videoSelf getVideoData];
         }else{
             NSLog(@"%@",videoSelf);
  
         }
     };
     obj.audioSampleBuffer = ^(CMSampleBufferRef audioSB, id audioSelf) {
         if ([audioSelf isMemberOfClass:[LAIVideoCaptureViewModel class]]) {
             [audioSelf getAudioData];
         }else{
             NSLog(@"%@",audioSelf);
         }
     };
     
       }];
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_captureViewModel touchFocusCursorWithBegan:touches WithFocus:^(CGPoint focusPoint) {
        NSLog(@"%@",NSStringFromCGPoint(focusPoint));
    }];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [_captureViewModel startDeviceRunning];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
