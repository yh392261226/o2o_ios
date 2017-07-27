//
//  myselfway.m
//  worker
//
//  Created by 郭健 on 2017/7/26.
//  Copyright © 2017年 郭健. All rights reserved.
//

#import "myselfway.h"

@implementation myselfway

+ (UIColor *) stringTOColor:(NSString *)str

{
    if (!str || [str isEqualToString:@""])
    {
        return nil;
    }
    
    unsigned red,green,blue;
    
    NSRange range;
    
    range.length = 2;
    
    range.location = 2;
    
    [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&red];
    
    range.location = 4;
    
    [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&green];
    
    range.location = 6;
    
    [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&blue];
    
    UIColor *color= [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:1];
    
    return color;
    
}


+ (void)initHeadView: (UIView *)backview title:(NSString *)titleText
{
    backview.backgroundColor = [myselfway stringTOColor:@"0xF3F3F3"];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    
    view.backgroundColor = [myselfway stringTOColor:@"0x3E9FEA"];
    
    [backview addSubview:view];
    
    UILabel *headlabel = [[UILabel alloc] init];
    
    headlabel.text = titleText;
    
    [headlabel setTextColor:[UIColor whiteColor]];
    
    headlabel.textAlignment = NSTextAlignmentCenter;
    
    headlabel.font = [UIFont systemFontOfSize:17];
    
    [backview addSubview:headlabel];
    
    [headlabel mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.center.equalTo(backview);
         make.bottom.mas_equalTo(view).offset(-7);
         make.height.mas_equalTo(30);
         make.width.mas_equalTo(200);
     }];
    
   

}








@end