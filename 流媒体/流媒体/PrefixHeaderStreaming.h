//
//  PrefixHeaderStreaming.h
//  流媒体
//
//  Created by huazhan Huang on 2017/5/26.
//  Copyright © 2017年 zhiYong_lai. All rights reserved.
//

#ifndef PrefixHeaderStreaming_h
#define PrefixHeaderStreaming_h
#define SCREEN_WIDTH     [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT    [UIScreen mainScreen].bounds.size.height
#define DEVICE(version)  ([[[UIDevice currentDevice] systemVersion] floatValue] >=version)
#define BASECOLORLA(r,g,b,A) [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:A]
#define BASECOLORL(r,g,b) BASECOLORLA(r,g,b,1.0)
#define NSNOTIFICATION [NSNotificationCenter defaultCenter]
#define NSUSERDEFAULTS [NSUserDefaults standardUserDefaults]
#define HomeDirectory [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
#define WS(weakSelf)  __weak typeof(self)weakSelf = self;
#define ZHI_NSNotificationCenter [NSNotificationCenter defaultCenter]
#define SUCCESS @"成功"
#define FAULT @"失败"
#define AFNW(manager) AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];  \
manager.responseSerializer = [AFJSONResponseSerializer serializer];  \
manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",nil];

#endif /* PrefixHeaderStreaming_h */
