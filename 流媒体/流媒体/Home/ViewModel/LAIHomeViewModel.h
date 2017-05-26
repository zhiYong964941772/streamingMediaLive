//
//  LAIHomeViewModel.h
//  流媒体
//
//  Created by huazhan Huang on 2017/5/26.
//  Copyright © 2017年 zhiYong_lai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LAIHomeViewModel : NSObject
@property (nonatomic, strong)RACCommand *liveCommand;
@property (nonatomic, strong)RACCommand *collectCommand;
@property (nonatomic, strong)RACSignal *dataSignal;

@property (nonatomic, strong)NSMutableArray *liveDataArr;

@end
