//
//  CEStartView.m
//  ChildEnglish
//
//  Created by huangrensheng on 2019/4/16.
//  Copyright © 2019 huangrensheng. All rights reserved.
//

#import "CEStartView.h"

@implementation CEStartView

- (instancetype)init {
    if ([super init]) {
        for (int i = 0; i < 5; i++) {
            UIImageView *startView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"start_gray"]];
            [self addSubview:startView];
            UIView *upView = nil;
            if (i>0) {
                upView = self.subviews[i-1];
            }
            [startView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.offset(25);
                make.height.offset(25);
                if (i == 0) {
                    make.top.equalTo(self.mas_top);
                }else{
                    make.top.equalTo(upView.mas_bottom);
                }
                if(i==4){
                    make.bottom.equalTo(self.mas_bottom);
                }
            }];
        }
    }
    return self;
}

- (void)updateStart:(NSInteger)count{
    if (count <= 0) {
        return;
    }
    for (int i = 0; i < self.subviews.count; i++) {
        UIImageView *image = self.subviews[i];
        if (i<count) {
            [image setImage:[UIImage imageNamed:@"start"]];
        }else{
            [image setImage:[UIImage imageNamed:@"start_gray"]];
        }
    }
}
@end
