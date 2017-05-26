//
//  LAIVideoCaptureViewModel.m
//  流媒体
//
//  Created by huazhan Huang on 2017/5/26.
//  Copyright © 2017年 zhiYong_lai. All rights reserved.
//

#import "LAIVideoCaptureViewModel.h"
@interface LAIVideoCaptureViewModel();
@end
@implementation LAIVideoCaptureViewModel
+ (instancetype)makeVideoCapture:(void (^)(NSObject *))obj{
    LAIVideoCaptureViewModel *model = [[LAIVideoCaptureViewModel alloc]init];
    obj(model);
    return model;
}
@end
