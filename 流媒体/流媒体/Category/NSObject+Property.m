//
//  NSObject+Property.m
//  自动生成模型
//
//  Created by huazhan Huang on 2016/10/24.
//  Copyright © 2016年 zhiYong_lai. All rights reserved.
//

#import "NSObject+Property.h"
#import <objc/message.h>
@implementation NSObject (Property)
+(void)createPropertyCodeWithDict:(NSDictionary *)dict{
    /*
     key:属性名
     obj:属性类型
     根据字典分析属性类型
     */
    NSMutableString *strM = [NSMutableString new];

    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSLog(@"%@",[obj class]);

        NSString *code;
        if ([obj isKindOfClass:NSClassFromString(@"__NSCFString")]||[obj isKindOfClass:NSClassFromString(@"__NSCFConstantString")]||[obj isKindOfClass:NSClassFromString(@"NSTaggedPointerString")]) {
            code = [NSString stringWithFormat:@"@property (nonatomic, copy)NSString *%@;",key];
        }else if ([obj isKindOfClass:NSClassFromString(@"__NSCFNumber")]){
            code = [NSString stringWithFormat:@"@property (nonatomic, assign)int %@;",key];
        }else if ([obj isKindOfClass:NSClassFromString(@"__NSArrayI")]){
            code = [NSString stringWithFormat:@"@property (nonatomic, strong)NSArray *%@;",key];
        }else if ([obj isKindOfClass:NSClassFromString(@"__NSArrayM")]){
            code = [NSString stringWithFormat:@"@property (nonatomic, strong)NSMutableArray *%@;",key];
        }else if ([obj isKindOfClass:NSClassFromString(@"__NSCFDictionary")]){
            code = [NSString stringWithFormat:@"@property (nonatomic, strong)NSDictionary *%@;",key];
        }


        
        [strM appendFormat:@"\n%@",code];
        
    }];
    NSLog(@"%@",strM);

}
+(instancetype)modelWithDict:(NSDictionary *)dict{
    /*
     runtime:遍历模型中的所有成员属性，去字典中查找
     ivar：成员列表数组
     class_copyIvarList：获取model成员列表
     
     
     */
    id objc = [[self alloc]init];
   unsigned int count = 0;
    Ivar *modelV = class_copyIvarList(self, &count);
    for (int i=0; i<count; i++) {
        Ivar ivar = modelV[i];
        NSString *propertyName = [NSString stringWithUTF8String:ivar_getName(ivar)];
        NSString *key = [propertyName substringFromIndex:1];
        id value = dict[key];
        if (value) {
            [objc setValue:value forKey:key];
          }
        
            }
    return objc;

}

/*
 @property (nonatomic, copy)NSString *source;
 @property (nonatomic, assign)int reposts_count;
 @property (nonatomic, strong)NSArray *pic_urls;
 @property (nonatomic, copy)NSString *created_at;
 @property (nonatomic, assign)int attitudes_count;
 @property (nonatomic, copy)NSString *idstr;
 @property (nonatomic, copy)NSString *text;
 @property (nonatomic, assign)int comments_count;
 @property (nonatomic, strong)NSDictionary *user;
 自动生成对应得类型，哇哈哈哈哈
 */
@end
