//
//  LAIHomeViewModel.m
//  流媒体
//
//  Created by huazhan Huang on 2017/5/26.
//  Copyright © 2017年 zhiYong_lai. All rights reserved.
//

#import "LAIHomeViewModel.h"
#import "LAIHomeModel.h"
@implementation LAIHomeViewModel
- (instancetype)init{
    self = [super init];
    if (self) {
        [self bindLiveCommand];
        [self bindVideoCature];

    }
    return self;
}
#pragma mark -- 绑定直播列表
- (void)bindLiveCommand{
    self.liveCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
       return [self gettingData];
    }];
    

    [[self.liveCommand.executing skip:1] subscribeNext:^(id x) {
        if ([x isEqualToNumber:@(YES)]) {
            [[MBProgressHUD shareProgress]showProgress];
        }else{
            [[MBProgressHUD shareProgress]hideProgress];

        }
        
    }];
}
- (RACSignal *)gettingData{
       return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
           AFNW(manager);
           [manager GET:LIVEURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
               _liveDataArr = [LAIHomeModel mj_objectArrayWithKeyValuesArray:responseObject[@"lives"]];
               [subscriber sendNext:_liveDataArr];
               [subscriber sendCompleted];
               
           } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
               NSLog(@"%@",error);
           }];

        return nil;
    }];

}
#pragma mark -- 绑定视频采集
- (void)bindVideoCature{
    _collectCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:SUCCESS];
            [subscriber sendCompleted];
            return nil;
        }];
    }];
    [[self.liveCommand.executing skip:1] subscribeNext:^(id x) {
        if ([x isEqualToNumber:@(YES)]) {
            [[MBProgressHUD shareProgress]showProgress];
        }else{
            [[MBProgressHUD shareProgress]hideProgress];
            
        }
        
    }];

}
@end
