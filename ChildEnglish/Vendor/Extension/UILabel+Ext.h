//
//  UIColor (extension).h
//  sowon
//
//  Created by fdh on 15/4/27.
//  Copyright (c) 2015年 sowon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UILabel (Ext)

+(instancetype)instanceWithFrame:(CGRect)frame
                            text:(NSString*)text
                       textColor:(UIColor*)textColor
                            font:(UIFont*)font;

-(void)hightlightText:(NSString*)text hColor:(UIColor*)hColor;
-(void)hightlightText:(NSString*)text hColor:(UIColor*)hColor hFont:(UIFont*)font;

-(void)underlineText:(NSString*)text hColor:(UIColor*)hColor;
-(void)deletelineText:(NSString*)text hColor:(UIColor*)hColor;

-(void)setText:(NSString *)text hColor:(UIColor*)hColor;

-(void)setTextWithImageStr:(NSString*)imageStr;


- (void)changeFont:(UIFont *)font;
-(void)setlineH:(CGFloat)lineH;

-(void)setTextExt:(NSString*)text;

- (CGSize)sizeWithSize:(CGSize)size;
- (CGSize)sizeWithSize:(CGSize)size withFont:(UIFont*)font;

@end
