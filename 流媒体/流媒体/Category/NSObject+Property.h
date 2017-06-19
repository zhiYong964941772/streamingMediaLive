//
//  NSObject+Property.h
//  自动生成模型
//
//  Created by huazhan Huang on 2016/10/24.
//  Copyright © 2016年 zhiYong_lai. All rights reserved.
//
/*
 通过解析字典，自动生成代码
 字典转模型kvc实现
 
 */
#import <Foundation/Foundation.h>

@interface NSObject (Property)
+ (void)createPropertyCodeWithDict:(NSDictionary *)dict;
+ (instancetype)modelWithDict:(NSDictionary *)dict;
@end
