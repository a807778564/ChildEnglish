//
//  HDAlertView.h
//  HomeDo
//
//  Created by huangrensheng on 2017/6/6.
//  Copyright © 2017年 Lynn. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HDAlertViewClick)(NSInteger index,NSString *text);

@interface HDAlertView : UIView
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message attributeMessage:(NSMutableAttributedString *)attributeMessage btnArray:(NSArray *)btnArray alertClick:(HDAlertViewClick)click;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIView *btnTopLine;
@property (nonatomic, copy) HDAlertViewClick alertClick;
@property (nonatomic, assign) BOOL canNotTouchBack;//是否可以点击背景  (YES 不可点击  NO可点击)
- (void)show;
- (void)setBackColor:(UIColor *)backColor textColor:(UIColor *)textColor textFont:(float)font withText:(NSString *)text;
@end
