//
//  ExamController.m
//  ChildEnglish
//
//  Created by huangrensheng on 2018/6/4.
//  Copyright © 2018年 huangrensheng. All rights reserved.
//

#import "ExamController.h"
#import "DBHelper.h"
#import "WordCollectionCell.h"
#import "WordModel.h"

@interface ExamController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic , strong) UICollectionView *wordCollection;
@property (nonatomic , strong) DBHelper *helper;
@property (nonatomic , strong) NSMutableArray *examWordArray;
@property (nonatomic , strong) WordModel *examWord;
@end

@implementation ExamController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.wordCollection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.wordCollection.backgroundColor = [UIColor whiteColor];
    self.wordCollection.delegate = self;
    self.wordCollection.dataSource = self;
    self.wordCollection.showsVerticalScrollIndicator = NO;
    self.wordCollection.showsHorizontalScrollIndicator = NO;
    [self.wordCollection registerClass:[WordCollectionCell class] forCellWithReuseIdentifier:@"WordCollectionCell"];
    [self.view addSubview:self.wordCollection];
    [self.wordCollection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.leading.equalTo(self.view.mas_leading).offset(44);
        make.trailing.equalTo(self.view.mas_trailing).offset(-44);
        make.height.offset(44);
    }];
    
    self.helper = [[DBHelper alloc] init];
    
    NSMutableArray *allWord = [self.helper getWordWithChapter:self.chapterId];
    
    self.examWordArray = [[NSMutableArray alloc] init];
    do {
        int x = arc4random() % 20;
        WordModel *word = allWord[x];
        if (![self.examWordArray containsObject:word]) {
            [self.examWordArray addObject:word];
        }
    } while (self.examWordArray.count < 10);
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.examWordArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WordModel *word = self.examWordArray[indexPath.row];
    CGSize size = [Utils sizeWithString:word.word_english andFont:kFont(25) andMaxSize:CGSizeMake(SCREEN_WIDTH, 35)];
    return CGSizeMake(size.width + 15, size.height);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WordCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WordCollectionCell" forIndexPath:indexPath];
    cell.word = self.examWordArray[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

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
