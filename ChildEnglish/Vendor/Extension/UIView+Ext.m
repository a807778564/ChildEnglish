//
//  UIView+Ext.m
//  ChildEnglish
//
//  Created by huangrensheng on 2019/4/16.
//  Copyright © 2019 huangrensheng. All rights reserved.
//

#import "UIView+Ext.h"

@implementation UIView (Ext)
- (void)setLayerCornerRadius:(CGFloat)radius borderColor:(UIColor *)color borderWidth:(CGFloat)borderWidth{
    [self.layer setBorderColor:color.CGColor];
    [self.layer setBorderWidth:borderWidth];
    [self.layer setCornerRadius:radius];
    self.layer.masksToBounds = YES;
}
@end
