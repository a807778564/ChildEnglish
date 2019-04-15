//
//  WordCollectionCell.h
//  ChildEnglish
//
//  Created by huangrensheng on 2018/5/17.
//  Copyright © 2018年 huangrensheng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WordModel,PainterView;
@interface WordCollectionCell : UICollectionViewCell
@property (nonatomic , strong) WordModel *word;
@property (nonatomic , assign) BOOL canDraw;
@property (nonatomic , assign) BOOL lineFull;
@end
