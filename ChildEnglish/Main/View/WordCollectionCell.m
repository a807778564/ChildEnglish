//
//  WordCollectionCell.m
//  ChildEnglish
//
//  Created by huangrensheng on 2018/5/17.
//  Copyright © 2018年 huangrensheng. All rights reserved.
//

#import "WordCollectionCell.h"
#import "WordModel.h"
#import "PainterView.h"

#define DRAW_TAG 1001

@interface WordCollectionCell()
@property (nonatomic , strong) UILabel *wordLabel;
@property (nonatomic , strong) UIView *topLine;
@property (nonatomic , strong) UIView *secondLine;
@property (nonatomic , strong) UIView *threeLine;
@property (nonatomic , strong) UIView *bottomLine;
@end

@implementation WordCollectionCell

- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.topLine = [[UIView alloc] init];
        self.topLine.backgroundColor = RGBA(126, 211, 33, 1);
        [self.contentView addSubview:self.topLine];
        
        self.secondLine = [[UIView alloc] init];
        self.secondLine.tag = 2;
        [self.contentView addSubview:self.secondLine];
        
        self.threeLine = [[UIView alloc] init];
        self.threeLine.tag = 3;
        [self.contentView addSubview:self.threeLine];
        
        self.bottomLine = [[UIView alloc] init];
        self.bottomLine.backgroundColor = RGBA(126, 211, 33, 1);
        [self.contentView addSubview:self.bottomLine];
        
        self.wordLabel = [UILabel instanceWithFrame:CGRectZero text:@"" textColor:RGB(34, 34, 34) font:kFont(25)];
        self.wordLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.wordLabel];
        
        [self.topLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.top.equalTo(self.contentView);
            make.height.offset(1);
        }];
        [self.secondLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.contentView.mas_leading);
            make.width.offset(self.contentView.frame.size.width);
            make.height.offset(1);
            make.top.equalTo(self.contentView.mas_top).offset(self.contentView.frame.size.height*1/3);
        }];
        [self.threeLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.contentView.mas_leading);
            make.height.offset(1);
            make.width.offset(self.contentView.frame.size.width);
            make.top.equalTo(self.contentView.mas_top).offset(self.contentView.frame.size.height*2.2/3);
        }];
        [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.bottom.equalTo(self.contentView);
            make.height.offset(1);
        }];
        [self.wordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        
        [self.wordLabel.superview layoutIfNeeded];
        
    }
    return self;
}

- (void)setWord:(WordModel *)word{
    self.wordLabel.text = word.word_english;
    if (_canDraw) {
        [self updateLineWidth:word.word_english font:kFont(75)];
        self.wordLabel.font = kFont(75);
        UIView *view = [self.contentView viewWithTag:DRAW_TAG];
        if (view) {
            [view removeFromSuperview];
            PainterView *paiView = [[PainterView alloc] init];
            paiView.tag = DRAW_TAG;
            [self.contentView addSubview:paiView];
            [paiView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.contentView);
            }];
        }
        self.wordLabel.textColor = RGB(34, 34, 34);
    }else{
        if (word.word_is_study == 1) {
            self.wordLabel.textColor = [UIColor redColor];
        }else{
            self.wordLabel.textColor = RGB(34, 34, 34);
        }
        [self updateLineWidth:word.word_english font:kFont(25)];
    }
}

- (void)updateLineWidth:(NSString *)english font:(UIFont *)font{
    
    CGSize size = [Utils sizeWithString:english andFont:font andMaxSize:CGSizeMake(SCREEN_WIDTH, 35)];
    [self.secondLine mas_updateConstraints:^(MASConstraintMaker *make) {
        if (self.lineFull) {
            make.width.offset(self.contentView.frame.size.width);
        }else{
            make.width.offset(size.width+15);
        }
    }];
    [self.threeLine mas_updateConstraints:^(MASConstraintMaker *make) {
        if (self.lineFull) {
            make.width.offset(self.contentView.frame.size.width);
        }else{
            make.width.offset(size.width+15);
        }
    }];
    [self.threeLine.superview layoutIfNeeded];
    
    [Utils drawLineOfDashByCAShapeLayer:self.secondLine lineLength:5 lineSpacing:2 lineColor:RGBA(126, 211, 33, 1) lineDirection:YES];
    [Utils drawLineOfDashByCAShapeLayer:self.threeLine lineLength:5 lineSpacing:2 lineColor:RGBA(126, 211, 33, 1) lineDirection:YES];
}

- (void)setCanDraw:(BOOL)canDraw{
    _canDraw = canDraw;
    if (canDraw) {
        PainterView *paiView = [[PainterView alloc] init];
        paiView.tag = DRAW_TAG;
        [self.contentView addSubview:paiView];
        [paiView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
}
@end
