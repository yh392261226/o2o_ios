//
//  myselfway.h
//  worker
//
//  Created by 郭健 on 2017/7/26.
//  Copyright © 2017年 郭健. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface myselfway : NSObject

//16进制设置颜色
+ (UIColor *) stringTOColor:(NSString *)str;

//设置navi主页的headview
+ (void)initHeadView: (UIView *)backview title:(NSString *)titleText;

//类的对象转成字典对象
+ (NSDictionary *)entityToDictionary:(id)entity;

//十六进制转二进制
+ (NSString *)getBinaryByhex:(NSString *)hex;

//获取本地用户，判断是否登录
+ (NSString *)userPath;

@end
