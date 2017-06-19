//
//  NSObject+extension.h
//  testModel
//
//  Created by huazhan Huang on 2017/5/23.
//  Copyright © 2017年 zhiYong_lai. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol modelDelegate <NSObject>
@optional
+(NSDictionary *)arrayContainModelClass;
@end
@interface NSObject (extension)
+ (void)resolveDict:(NSDictionary *)dict;
+ (void)resolveArrt:(NSArray *)arrt;

+ (instancetype)modelWithDict:(NSDictionary *)dict;
@end
