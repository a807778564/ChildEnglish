//
//  CardCollectionStyleLayout.m
//  ChildEnglish
//
//  Created by huangrensheng on 2018/5/11.
//  Copyright © 2018年 huangrensheng. All rights reserved.
//

#import "CardCollectionStyleLayout.h"
@interface CardCollectionStyleLayout()
@property (nonatomic, assign) CGFloat previousOffset;
@property (nonatomic, assign) NSInteger currentPage;
@end

@implementation CardCollectionStyleLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(void)prepareLayout{
    [super prepareLayout];
    //每个section的inset，用来设定最左和最右item距离边界的距离，此处设置在中间
    CGFloat inset = (self.collectionView.frame.size.width - self.itemSize.width) /2;
    self.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
}

-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}

//cell缩放的设置
-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    //取出父类算出的布局属性
    //不能直接修改需要copy
    NSArray * original = [super layoutAttributesForElementsInRect:rect];
    NSArray * attsArray = [[NSArray alloc] initWithArray:original copyItems:YES];
    //    NSIndexPath *mainIndex = nil;
    //    NSArray *attsArray = [super layoutAttributesForElementsInRect:rect];
    
    //collectionView中心点的值
    //屏幕中心点对应于collectionView中content位置
    CGFloat centerX = self.collectionView.frame.size.width / 2 + self.collectionView.contentOffset.x;
    //cell中的item一个个取出来进行更改
    for (UICollectionViewLayoutAttributes *atts in attsArray) {
        // cell的中心点x 和 屏幕中心点 的距离
        CGFloat space = ABS(atts.center.x - centerX);
        CGFloat scale = 1 - (space/self.collectionView.frame.size.width/3);//计算缩放比例
        CGFloat alpha = 1 - (space/self.collectionView.frame.size.width/1.5);//计算透明度
        //        NSLog(@"space = %.2f scale = %.2f alpha = %.2f",space,scale,alpha);
        atts.transform = CGAffineTransformMakeScale(scale, scale);
        atts.alpha = alpha;
    }
    //    [self addCellAlphaView:mainIndex atts:attsArray];
    return attsArray;
}

- (void)addCellAlphaView:(NSIndexPath *)main atts:(NSArray *)attsArray{
    for (UICollectionViewLayoutAttributes *atts in attsArray) {
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:atts.indexPath];
        for (UIView *sub in cell.contentView.subviews) {
            if (sub.tag == 10002) {
                [sub removeFromSuperview];
                break;
            }
        }
        if (atts.indexPath.row != main.row) {
            UIView *alpView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 150)];
            alpView.tag = 10002;
            alpView.backgroundColor = [UIColor redColor];
//            alpView.alpha = 0.6;
            [cell.contentView addSubview:alpView];
        }
    }
}

//设置滑动停止时的collectionView的位置
-(CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity{
    
    // 计算出最终显示的矩形框
    CGRect rect;
    rect.origin.y = 0;
    rect.origin.x = proposedContentOffset.x;//最终要停下来的X
    rect.size = self.collectionView.frame.size;
    
    //获得计算好的属性
    NSArray * original = [super layoutAttributesForElementsInRect:rect];
    NSArray * attsArray = [[NSArray alloc] initWithArray:original copyItems:YES];
    //计算collection中心点X
    //视图中心点相对于collectionView的content起始点的位置
    CGFloat centerX = proposedContentOffset.x + self.collectionView.frame.size.width / 2;
    CGFloat minSpace = MAXFLOAT;
    for (UICollectionViewLayoutAttributes *attrs in attsArray) {
        //找到距离视图中心点最近的cell，并将minSpace值置为两者之间的距离
        if (ABS(minSpace) > ABS(attrs.center.x - centerX)) {
            minSpace = attrs.center.x - centerX;        //各个不同的cell与显示中心点的距离
        }
    }
    // 修改原有的偏移量
    proposedContentOffset.x += minSpace;
    return proposedContentOffset;
}

@end
