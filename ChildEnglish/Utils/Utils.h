//
//  Utils.h
//  ChildEnglish
//
//  Created by huangrensheng on 2018/5/17.
//  Copyright © 2018年 huangrensheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject

+ (CGSize)sizeWithString:(NSString*)str andFont:(UIFont*)font andMaxSize:(CGSize)size;

+ (void)drawLineOfDashByCAShapeLayer:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor lineDirection:(BOOL)isHorizonal;
@end
