//
//  UIButton+Ext.m
//  sowon
//
//  Created by fdh on 15/4/27.
//  Copyright (c) 2015年 sowon. All rights reserved.
//

#import "UIButton+Ext.h"

@implementation UIButton (Ext)

+(id) instanceWithFrame:(CGRect)frame image:(UIImage*)image
{
    UIButton* button = [[UIButton alloc] initWithFrame:frame];
    
    [button setImageEx:image];
    
    return button;
}
+(id) instanceWithFrame:(CGRect)frame title:(NSString*)title titleColor:(UIColor*)titleColor  font:(UIFont*)font;
{
    UIButton* button = [[UIButton alloc] initWithFrame:frame];
    
    [button setTitleEx:title];
    [button setTitleColorEx:titleColor];
    [button setFontEx:font];
    
    return button;
}

-(UIImage*)imageEx;
{
    return [self imageForState:UIControlStateNormal];
}
-(void)setImageEx:(UIImage*)image;
{
    [self setImage:image forState:UIControlStateNormal];
}

-(void)setImage:(UIImage*)image hImage:(UIImage*)hImage;
{
    [self setImage:image forState:UIControlStateNormal];
    [self setImage:hImage forState:UIControlStateHighlighted];
}

-(void)setImage:(UIImage*)image selImage:(UIImage*)selImage;
{
    [self setImage:image forState:UIControlStateNormal];
    [self setImage:selImage forState:UIControlStateSelected];
}

-(void)setImage:(UIImage*)image disImage:(UIImage*)disImage;
{
    [self setImage:image forState:UIControlStateNormal];
    [self setImage:disImage forState:UIControlStateDisabled];
}

-(UIImage*)backgroundImageEx;
{
    return [self backgroundImageForState:UIControlStateNormal];
}
-(void)setBackgroundImageEx:(UIImage*)image;
{
    [self setBackgroundImage:image forState:UIControlStateNormal];
}

-(void)setBackgroundImage:(UIImage*)image hBackgroundImage:(UIImage*)hBackgroundImage;
{
    [self setBackgroundImage:image forState:UIControlStateNormal];
    [self setBackgroundImage:hBackgroundImage forState:UIControlStateHighlighted];
}

-(NSString*)titleEx;
{
    return [self titleForState:UIControlStateNormal];
}
-(void)setTitleEx:(NSString*)title;
{
    [self setTitle:title forState:UIControlStateNormal];
}

- (void)setAttributedTitleEx:(NSAttributedString *)title
{
    [self setAttributedTitle:title forState:UIControlStateNormal];
}

-(void)setTitleEx:(NSString*)title offset:(CGFloat)offset;
{
    NSMutableString* ret = [NSMutableString string];
    for (; offset-->0; ) {
        [ret appendString:@" "];
    }
    [self setTitle:[ret stringByAppendingString:title] forState:UIControlStateNormal];
}

-(void)setTitleColorEx:(UIColor*)color;
{
    [self setTitleColor:color forState:UIControlStateNormal];
}

-(void)setColor:(UIColor*)color selColor:(UIColor*)selColor;
{
    [self setTitleColor:color forState:UIControlStateNormal];
    [self setTitleColor:selColor forState:UIControlStateSelected];
}

-(void)setFontEx:(UIFont*)font;
{
    self.titleLabel.font = font;
}

- (UIButton *)initWithNomalTitle:(NSString *)nomal nomalColor:(UIColor *)nomalColor selectColor:(UIColor *)selectColor sizeFont:(UIFont *)font{
    
    UIButton *btn = [[UIButton alloc] init];
    [btn setTitle:nomal forState:UIControlStateNormal];
    [btn setTitleColor:nomalColor forState:UIControlStateNormal];
    [btn setTitleColor:selectColor forState:UIControlStateSelected];
    [btn.titleLabel setFont:font];
    
    return btn;
}

- (UIButton *)initWithNomalTitle:(NSString *)nomal nomalColor:(UIColor *)nomalColor heightColor:(UIColor *)heightColor sizeFont:(UIFont *)font{
    
    UIButton *btn = [[UIButton alloc] init];
    [btn setTitle:nomal forState:UIControlStateNormal];
    [btn setTitleColor:nomalColor forState:UIControlStateNormal];
    if (heightColor) {
        [btn setTitleColor:heightColor forState:UIControlStateHighlighted];
    }
    [btn.titleLabel setFont:font];
    
    return btn;
}

@end
