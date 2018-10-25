//
//  UIButton+Ext.h
//  sowon
//
//  Created by fdh on 15/4/27.
//  Copyright (c) 2015年 sowon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIButton (Ext)

+(id) instanceWithFrame:(CGRect)frame image:(UIImage*)image;
+(id) instanceWithFrame:(CGRect)frame title:(NSString*)title titleColor:(UIColor*)titleColor  font:(UIFont*)font;

@end
