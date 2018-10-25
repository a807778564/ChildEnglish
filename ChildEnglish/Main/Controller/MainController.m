//
//  MainController.m
//  ChildEnglish
//
//  Created by huangrensheng on 2018/5/4.
//  Copyright © 2018年 huangrensheng. All rights reserved.
//

#import "MainController.h"
#import "CardCollectionStyleLayout.h"
#import "ChapterCollectionCell.h"
#import "ChapterModel.h"
#import "WordDetailController.h"

#define cellHeight 150

@interface MainController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic , strong) UICollectionView *chaperView;
@property (nonatomic , strong) DBHelper *helper;
@property (nonatomic , strong) NSMutableArray *chaterArray;
@end

@implementation MainController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UICollectionViewFlowLayout *layout = [[CardCollectionStyleLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = (SCREEN_HEIGHT-cellHeight)/2;
    layout.itemSize = CGSizeMake(100, 150);
    
    self.helper = [[DBHelper alloc] init];
    self.chaterArray = [self.helper getChapterArray];
    
    self.chaperView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.chaperView.delegate = self;
    self.chaperView.dataSource = self;
    self.chaperView.showsHorizontalScrollIndicator = NO;
    self.chaperView.showsVerticalScrollIndicator = NO;
    self.chaperView.backgroundColor = [UIColor whiteColor];
    [self.chaperView registerClass:[ChapterCollectionCell class] forCellWithReuseIdentifier:@"ChapterCollectionCell"];
    [self.view addSubview:self.chaperView];
    [self.chaperView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view.mas_centerY);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.offset(SCREEN_HEIGHT);
        make.height.offset(SCREEN_HEIGHT);
    }];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"wmsj" ofType:@"txt"];
    NSString *content = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    // Do any additional setup after loading the view.
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.chaterArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 1;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (section == 0 ){
        CGFloat inset = (self.chaperView.frame.size.width - 100) /2;
        return UIEdgeInsetsMake(0, inset, 0, 10);
    }
    return UIEdgeInsetsMake(0, 10, 0, 10);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ChapterCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ChapterCollectionCell" forIndexPath:indexPath];
    cell.chapter = self.chaterArray[indexPath.section];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ChapterModel *chapter = self.chaterArray[indexPath.section];
    WordDetailController *wordDetail = [[WordDetailController alloc] init];
    wordDetail.chapterId = chapter.chapter_id;
    [self presentViewController:wordDetail animated:NO completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
