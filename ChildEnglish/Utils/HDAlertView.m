//
//  HDAlertView.m
//  HomeDo
//
//  Created by huangrensheng on 2017/6/6.
//  Copyright © 2017年 Lynn. All rights reserved.
//

#import "HDAlertView.h"
#define AlertWidth ([UIScreen mainScreen].bounds.size.width)
#define AlertHeight ([UIScreen mainScreen].bounds.size.height)
@interface HDAlertView()
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *btnView;
@end

@implementation HDAlertView

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message attributeMessage:(NSMutableAttributedString *)attributeMessage btnArray:(NSArray *)btnArray alertClick:(HDAlertViewClick)click{
    if ([super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)]) {
        self.backgroundColor = [UIColor clearColor];
        [self initChildViewsTitle:title message:message attributeMessage:attributeMessage btnArray:btnArray];
        self.alertClick = click;
    }
    return self;
}

- (void)initChildViewsTitle:(NSString *)title message:(NSString *)message attributeMessage:(NSMutableAttributedString *)attributeMessage btnArray:(NSArray *)btnArray{
//    CGSize size = [Utils getNewTextSize:message font:12 limitWidth:AlertWidth-138];
    self.contentView  = [[UIView alloc] init];
    self.contentView.alpha = 0;
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.layer.masksToBounds = YES;
    [self.contentView setLayerCornerRadius:8 borderColor:[UIColor clearColor] borderWidth:1];
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.mas_leading).offset(45);
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
        make.trailing.equalTo(self.mas_trailing).offset(-45);
    }];
    
    self.titleLabel = [[UILabel alloc] initWithTitle:title titleColor:RGBA(34, 34, 34, 1) titleFont:[UIFont systemFontOfSize:17]];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(20);
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.leading.equalTo(self.contentView.mas_leading).offset(16);
        make.trailing.equalTo(self.contentView.mas_trailing).offset(-16);
    }];
    
    self.messageLabel = [[UILabel alloc] initWithTitle:@"" titleColor:RGBA(109, 109, 109, 1) titleFont:[UIFont systemFontOfSize:12]];
    if (message) {
        self.messageLabel.text = message;
    }
    if (attributeMessage) {
        self.messageLabel.attributedText = attributeMessage;
    }
    self.messageLabel.numberOfLines = 0;
    [self.contentView addSubview:self.messageLabel];
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(12);
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.leading.equalTo(self.contentView.mas_leading).offset(16);
        make.trailing.equalTo(self.contentView.mas_trailing).offset(-16);
    }];
    
    self.btnTopLine = [[UIView alloc] init];
    self.btnTopLine.hidden = NO;
    self.btnTopLine.backgroundColor = RGBA(233, 233, 233, 1);
    [self.contentView addSubview:self.btnTopLine];
    [self.btnTopLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(1);
        make.leading.and.trailing.equalTo(self.contentView);
        make.top.equalTo(self.messageLabel.mas_bottom).offset(11);
    }];
    
    self.btnView = [[UIView alloc] init];
    self.btnView.backgroundColor =  RGBA(233, 233, 233, 1);
    [self.contentView addSubview:self.btnView];
    [self.btnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.messageLabel.mas_bottom).offset(12);
        make.leading.trailing.and.bottom.equalTo(self.contentView);
    }];
    float padding = (SCREEN_WIDTH-90)/btnArray.count;
    for (int i = 0; i<btnArray.count; i++) {
        UIButton *clickBtn = [[UIButton alloc] initWithNomalTitle:btnArray[i] nomalColor:RGBA(34, 34, 34, 1) heightColor:RGBA(34, 34, 34, 1) sizeFont:[UIFont systemFontOfSize:17]];
        clickBtn.tag = i;
        [clickBtn addTarget:self action:@selector(alertBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        clickBtn.backgroundColor = RGBA(245, 245, 245, 1);
        [self.btnView addSubview:clickBtn];
        [clickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.btnView.mas_top);
            make.leading.equalTo(self.btnView.mas_leading).offset(padding*i+((i+1)*1));
            make.height.offset(45);
            make.width.offset(padding);
            make.bottom.equalTo(self.btnView.mas_bottom);
        }];
    }
}


/**
 根据text设置按钮的背景色  字体颜色 字体大小

 @param backColor 背景色
 @param textColor 字体颜色
 @param font 字体大小
 @param text 需要设置的按钮 text
 */
- (void)setBackColor:(UIColor *)backColor textColor:(UIColor *)textColor textFont:(float)font withText:(NSString *)text{
    for (UIView *sub in self.btnView.subviews) {
        if ([sub isKindOfClass:[UIButton class]] && [((UIButton *)sub).titleLabel.text isEqualToString:text]) {
            if (backColor) {
                [((UIButton *)sub) setBackgroundColor:backColor];
            }
            if (textColor) {
                [((UIButton *)sub) setTitleColor:textColor forState:UIControlStateNormal];
                [((UIButton *)sub) setTitleColor:textColor forState:UIControlStateHighlighted];
            }
            if (font>0) {
                [((UIButton *)sub).titleLabel setFont:[UIFont systemFontOfSize:font]];
            }
            
        }
    }
}

//弹出窗按钮点击事件
- (void)alertBtnOnClick:(UIButton *)btn{
    self.alertClick(btn.tag,btn.titleLabel.text);
    [self removeFromSuperview];
}

//显示alertView;
- (void)show{
    UIViewController *controller = [self topViewController];
    [controller.view addSubview:self];
    [UIView animateWithDuration:0.1 animations:^{
        self.contentView.alpha = 1;
    } completion:^(BOOL finished) {
        self.backgroundColor = RGBA(0, 0, 0, 0.5);
    }];
}

- (UIViewController*)topViewController
{
    return [self topViewControllerWithRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

- (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController
{
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarController = (UITabBarController *)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    } else {
        return rootViewController;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    if (self.canNotTouchBack) {
        return;
    }
    [self removeFromSuperview];
}

@end
