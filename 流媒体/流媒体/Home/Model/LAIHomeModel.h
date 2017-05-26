//
//  LAIHomeModel.h
//  流媒体
//
//  Created by huazhan Huang on 2017/5/26.
//  Copyright © 2017年 zhiYong_lai. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LAILiveModel;
@interface LAIHomeModel : NSObject
@property (nonatomic, copy)NSString *stream_addr;
@property (nonatomic, assign)NSUInteger online_user;
@property (nonatomic, copy)NSString *city;
@property (nonatomic, strong)LAILiveModel *creator;


@end
