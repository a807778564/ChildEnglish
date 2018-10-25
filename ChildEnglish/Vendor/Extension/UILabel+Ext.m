//
//  UIColor (extension).m
//  sowon
//
//  Created by fdh on 15/4/27.
//  Copyright (c) 2015年 sowon. All rights reserved.
//

#import "UILabel+Ext.h"

@implementation UILabel (Ext)

+(instancetype)instanceWithFrame:(CGRect)frame
                            text:(NSString*)text
                       textColor:(UIColor*)textColor
                            font:(UIFont*)font;
{
    UILabel* instace = [[UILabel alloc] initWithFrame:frame];
    instace.text = text;
    instace.textColor = textColor;
    instace.font = font;
    return instace;
}

-(void)hightlightText:(NSString*)text hColor:(UIColor*)hColor
{
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:self.text];
    NSRange r = [self.text rangeOfString:text];
    if (NSNotFound != r.location) {
        [attrString addAttribute:NSForegroundColorAttributeName value:hColor range:r];
    }
    
    self.attributedText = attrString;
}

-(void)hightlightText:(NSString*)text hColor:(UIColor*)hColor hFont:(UIFont*)font {
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:self.text];
    NSRange r = [self.text rangeOfString:text];
    if (NSNotFound != r.location) {
        [attrString addAttribute:NSForegroundColorAttributeName value:hColor range:r];
        [attrString addAttribute:NSFontAttributeName value:font range:r];
    }
    
    self.attributedText = attrString;
}

-(void)underlineText:(NSString*)text hColor:(UIColor*)hColor {
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:self.text];
    NSRange r = [self.text rangeOfString:text];
    if (NSNotFound != r.location) {
        [attrString addAttribute:NSForegroundColorAttributeName value:hColor range:r];
        [attrString addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:r];//下划线
    }
    
    self.attributedText = attrString;
}

-(void)deletelineText:(NSString*)text hColor:(UIColor*)hColor {
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:self.text];
    NSRange r = [self.text rangeOfString:text];
    if (NSNotFound != r.location) {
        [attrString addAttribute:NSForegroundColorAttributeName value:hColor range:r];
        [attrString addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:r];//下划线
    }
    
    self.attributedText = attrString;
}

-(void)setText:(NSString *)text hColor:(UIColor*)hColor;
{
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:text];
    NSRange r = [text rangeOfString:@"："];
    if (NSNotFound == r.location) {
        r = [text rangeOfString:@"  "];
    }
    if (NSNotFound != r.location) {
        [attrString addAttribute:NSForegroundColorAttributeName value:hColor range:NSMakeRange(r.location+1,text.length-r.location-1)];
    }
    
    self.attributedText = attrString;
}

//@"     点击右上角  图标，为群组添加成员"
-(void)setTextWithImageStr:(NSString*)imageStr
{
    NSMutableAttributedString * attriStr = [[NSMutableAttributedString alloc] initWithString:imageStr];
    
    /**
     添加图片到指定的位置
     */
    NSTextAttachment *attchImage = [NSTextAttachment new];
    // 表情图片
    attchImage.image = [UIImage imageNamed:@"zjl_tips_icon_t"];
    // 设置图片大小
    attchImage.bounds = CGRectMake(0, -2, 15, 15);
    NSAttributedString *stringImage = [NSAttributedString attributedStringWithAttachment:attchImage];
    [attriStr insertAttributedString:stringImage atIndex:4];
    
    attchImage = [NSTextAttachment new];
    // 表情图片
    attchImage.image = [UIImage imageNamed:@"zjl_icon_tjcy"];
    // 设置图片大小
    attchImage.bounds = CGRectMake(0, -4, 18, 18);
    stringImage = [NSAttributedString attributedStringWithAttachment:attchImage];
    [attriStr insertAttributedString:stringImage atIndex:12];
    
    self.attributedText = attriStr;
}

- (void)changeFont:(UIFont *)font
{
    if (font) {
        [self setFont:font];
    }
}

-(void)setlineH:(CGFloat)lineH {
    //设置行高
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.paragraphSpacing         = 10;  //段落高度
    paragraphStyle.lineSpacing              = lineH;   //行高
    NSDictionary *attributes                = @{NSParagraphStyleAttributeName:paragraphStyle};
    
    //设置值
    //创建富文本
    NSAttributedString *atStr               = [[NSAttributedString alloc]initWithString:self.text attributes:attributes];
    //赋值
    self.attributedText                    = atStr;
}

-(CGSize)sizeUtilForTitle:(NSString *)title
{
    return [title sizeWithAttributes:@{NSFontAttributeName:self.font}];
}

//以字符进行截断，免得出现半个字符//以下代码片段仅供参考
-(void)setTextExt:(NSString*)text;
{
    CGSize size = [self sizeUtilForTitle:text];
    CGSize bounds = self.bounds.size;
    if (size.width>bounds.width) {
        NSInteger currentLength = text.length*(bounds.width/size.width);
        
        NSString *retString=nil;
        if (currentLength+2<text.length) {
            retString=[text substringWithRange:NSMakeRange(0, currentLength+2)];
        }
        else {
            retString=[text substringWithRange:NSMakeRange(0, currentLength)];
        }
        
        while ([self sizeUtilForTitle:retString].width>bounds.width) {
            retString = [retString substringToIndex:retString.length-1];
        };
        
        self.text = retString;
        
//        LOG(@"text[%@], retString[%@]", text, retString);
    }
    else {
        self.text = text;
    }
}

- (CGSize)sizeWithSize:(CGSize)size {
    return [self sizeWithSize:size withFont:self.font];
}

- (CGSize)sizeWithSize:(CGSize)size withFont:(UIFont*)font;
{
    if ( !self.text.length ) {
        return CGSizeMake(0, 0);
    }
    CGSize textSize = [self.text boundingRectWithSize:size
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{ NSFontAttributeName : font }
                                              context:nil].size;
    
    textSize = CGSizeMake((int)ceil(textSize.width), (int)ceil(textSize.height));
    return textSize;
}


@end
