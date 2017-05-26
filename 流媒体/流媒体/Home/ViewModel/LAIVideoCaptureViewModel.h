//
//  LAIVideoCaptureViewModel.h
//  流媒体
//
//  Created by huazhan Huang on 2017/5/26.
//  Copyright © 2017年 zhiYong_lai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LAIVideoCaptureViewModel : NSObject
+ (instancetype)makeVideoCapture:(void (^)(NSObject *obj))obj;
@end
