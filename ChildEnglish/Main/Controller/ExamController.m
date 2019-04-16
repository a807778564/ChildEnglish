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
#import "CEStartView.h"
#import "HDAlertView.h"

@interface ExamController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic , strong) UICollectionView *wordCollection;
@property (nonatomic , strong) DBHelper *helper;
@property (nonatomic , strong) NSMutableArray *examWordArray;
@property (nonatomic , strong) NSMutableArray *allWordArray;
@property (nonatomic , strong) WordModel *examWord;
@property (nonatomic , assign) float maxWidth;
@property (nonatomic , strong) UIImageView *checkImage;//选择正确失败照片
@property (nonatomic , strong) CEStartView *startView;
@property (nonatomic , assign) NSInteger errorCount;//错误次数
@end

@implementation ExamController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton *backBtn = [UIButton instanceWithFrame:CGRectZero title:@"返回" titleColor:[UIColor blackColor] font:kFont(14)];
    [backBtn addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view.mas_leading).offset(15);
        make.top.equalTo(self.view.mas_top).offset(15);
        make.width.offset(44);
        make.height.offset(44);
    }];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
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
    
    self.helper = [[DBHelper alloc] init];
    
    self.allWordArray = [self.helper getWordWithChapter:self.chapterId];
    if (self.allWordArray.count > 0) {
        self.examWord = self.allWordArray[0];
    }

    [self examArray:self.examWord];
    
    self.checkImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gou"]];
    self.checkImage.hidden = YES;
    [self.view addSubview:self.checkImage];
    
    self.startView = [[CEStartView alloc] init];
    [self.view addSubview:self.startView];
    [self.startView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view.mas_leading).offset(15);
        make.centerY.equalTo(self.view.mas_centerY);
    }];
    
//    [self.startView updateStart:4];
}

- (void)nextWord{
    NSInteger index = [self.allWordArray indexOfObject:self.examWord];
    index += 1;
    if (index < self.allWordArray.count) {
        self.examWord = self.allWordArray[index];
        [self examArray:self.examWord];
        [self.wordCollection reloadData];
    }else{
        NSInteger startCount = self.errorCount / self.allWordArray.count ;
        [self.startView updateStart:5-startCount];
        [self showAlertInfo:5-startCount];
    }
}

- (void)examArray:(WordModel *)testWord{
    self.examWordArray = [[NSMutableArray alloc] init];
    NSMutableArray *wordArray = [[NSMutableArray alloc] initWithObjects:testWord, nil];
   
    do {
        int x = arc4random() % 20;
        WordModel *word = self.allWordArray[x];
        if (![wordArray containsObject:word]) {
            [wordArray addObject:word];
        }
    } while (wordArray.count < 4);
    
    while (self.examWordArray.count != wordArray.count) {
        //生成随机数
        int x =arc4random() % wordArray.count;
        id obj = wordArray[x];
        if (![self.examWordArray containsObject:obj]) {
            [self.examWordArray addObject:obj];
        }
    }
    
    [self calWidth];
    
    [self.wordCollection mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view.mas_centerY);
        make.width.offset(self.maxWidth);
        make.trailing.equalTo(self.view.mas_trailing).offset(-44);
        make.height.offset(44*4+20*3);
    }];
}

- (void)calWidth{
    self.maxWidth = 0;
    for (int i = 0; i < self.examWordArray.count ; i++ ) {
        WordModel *word = self.examWordArray[i];
        CGSize size = [Utils sizeWithString:word.word_english andFont:kFont(25) andMaxSize:CGSizeMake(SCREEN_WIDTH, 35)];
        if (size.width + 15 > self.maxWidth) {
            self.maxWidth = size.width + 15;
        }
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.examWordArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    WordModel *word = self.examWordArray[indexPath.row];
//    CGSize size = [Utils sizeWithString:word.word_english andFont:kFont(25) andMaxSize:CGSizeMake(SCREEN_WIDTH, 35)];
    return CGSizeMake(self.maxWidth, 44);
}

//定义每个Section的四边间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(1, 1, 1, 1);//分别为上、左、下、右
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WordCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WordCollectionCell" forIndexPath:indexPath];
    cell.lineFull = YES;
    cell.word = self.examWordArray[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    WordModel *mode = self.examWordArray[indexPath.row];
    [self checkResult:cell word:mode];
}

- (void)checkResult:(UICollectionViewCell *)collection word:(WordModel *)word{
    
    self.checkImage.hidden = NO;
    
    if ([word.word_english isEqualToString:self.examWord.word_english]) {
        [self.checkImage setImage:[UIImage imageNamed:@"gou"]];
        [self performSelector:@selector(hideCheckImage:) withObject:@{@"check":@"right"} afterDelay:1.0f];
    }else{
        [self.checkImage setImage:[UIImage imageNamed:@"cuo"]];
        self.errorCount += 1;
        [self performSelector:@selector(hideCheckImage:) withObject:@{@"check":@"error"} afterDelay:1.0f];
    }
    
    [self.checkImage mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(collection.mas_trailing);
        make.centerY.equalTo(collection.mas_centerY);
        make.height.offset(20);
        make.width.offset(20);
    }];
}

- (void)hideCheckImage:(id)obj{
    self.checkImage.hidden = YES;
    if ([obj[@"check"] isEqualToString:@"right"]) {
        [self nextWord];
    }
}

- (void)backBtnAction{
    [self dismissViewControllerAnimated:NO completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showAlertInfo:(NSInteger)score{
    NSString *message = [NSString stringWithFormat:@"您本次的测验成绩为%ld分，暂未达到开启故事的评级哦！您可以选择重新测试，或者付费来开启本章节的故事！",score];
    HDAlertView *alert = [[HDAlertView alloc] initWithTitle:@"测验小提示" message:message attributeMessage:nil btnArray:@[@"购买故事",@"重新测验"] alertClick:^(NSInteger index, NSString *text) {
        if ([text isEqualToString:@"重新测验"]) {
            [self restartTest];
        }
    }];
    [alert show];
}

- (void)restartTest{
    self.errorCount = 0;
    if (self.allWordArray.count > 0) {
        self.examWord = self.allWordArray[0];
    }
    [self examArray:self.examWord];
    [self.wordCollection reloadData];
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
