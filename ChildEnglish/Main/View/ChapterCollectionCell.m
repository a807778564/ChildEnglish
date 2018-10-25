//
//  ChapterCollectionCell.m
//  ChildEnglish
//
//  Created by huangrensheng on 2018/5/12.
//  Copyright © 2018年 huangrensheng. All rights reserved.
//

#import "ChapterCollectionCell.h"
#import "ChapterModel.h"
@interface ChapterCollectionCell()
@property (nonatomic , strong) UILabel *chapterName;
@property (nonatomic , strong) UIImageView *backImage;
@property (nonatomic , strong) UIImageView *lock;
@end

@implementation ChapterCollectionCell

- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        
        self.contentView.backgroundColor = RGBA(240, 240, 240, 1);
        
        self.backImage = [[UIImageView alloc] init];
        [self.contentView addSubview:self.backImage];
        [self.backImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        
        self.chapterName = [UILabel instanceWithFrame:CGRectZero text:@"章节名" textColor:[UIColor blackColor] font:kFont(13)];
        self.chapterName.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.chapterName];
        [self.chapterName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.and.bottom.equalTo(self.contentView);
            make.height.offset(21);
        }];
        
        
    }
    return self;
}

- (void)setChapter:(ChapterModel *)chapter{
    self.chapterName.text = chapter.chapter_name;
}

@end
