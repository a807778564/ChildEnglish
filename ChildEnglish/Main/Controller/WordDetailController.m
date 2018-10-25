//
//  WordDetailController.m
//  ChildEnglish
//
//  Created by huangrensheng on 2018/5/16.
//  Copyright © 2018年 huangrensheng. All rights reserved.
//

#import "WordDetailController.h"
#import "WordModel.h"
#import "WordCollectionCell.h"
#import <AVFoundation/AVSpeechSynthesis.h>
#import "StoryPlayUtil.h"
#import "ExamController.h"

@interface WordDetailController ()<UICollectionViewDelegate,UICollectionViewDataSource,AVSpeechSynthesizerDelegate>
@property (nonatomic , strong) UIButton *backBtn;
@property (nonatomic , strong) UICollectionView *wordCollection;
@property (nonatomic , strong) NSMutableArray *wordArray;
@property (nonatomic , strong) AVSpeechSynthesizer *wordPlay;
@property (nonatomic , strong) NSString *word_chinese;
@property (nonatomic , strong) WordCollectionCell *clickCell;
@property (nonatomic , strong) DBHelper *helper;
@property (nonatomic , strong) StoryPlayUtil *story;
@property (nonatomic , strong) WordCollectionCell *centerCell;
@end

@implementation WordDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.helper = [[DBHelper alloc] init];
    
    self.backBtn = [UIButton instanceWithFrame:CGRectZero title:@"返回" titleColor:[UIColor blackColor] font:kFont(14)];
    [self.backBtn addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backBtn];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view.mas_leading).offset(15);
        make.top.equalTo(self.view.mas_top).offset(15);
        make.width.offset(44);
        make.height.offset(44);
    }];
    
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
    
    UIButton *playBtn = [UIButton instanceWithFrame:CGRectZero title:@"play" titleColor:[UIColor blackColor] font:kFont(14)];
    [playBtn addTarget:self action:@selector(playStory) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:playBtn];
    [playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top);
        make.width.offset(44);
        make.height.offset(44);
    }];
    
    self.wordArray = [self.helper getWordWithChapter:self.chapterId];
    
    
    
    
    WordModel *word = self.wordArray[0];
    CGSize size = [Utils sizeWithString:word.word_english andFont:kFont(75) andMaxSize:CGSizeMake(SCREEN_WIDTH, 60)];
    self.centerCell = [[WordCollectionCell alloc] initWithFrame:CGRectMake(0, 0, size.width + 15, 90)];
    self.centerCell.canDraw = YES;
    self.centerCell.word = word;
    [self.view addSubview:self.centerCell];
    [self.centerCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY);
        make.height.offset(90);
        make.width.offset(size.width + 15);
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.wordArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WordModel *word = self.wordArray[indexPath.row];
    CGSize size = [Utils sizeWithString:word.word_english andFont:kFont(25) andMaxSize:CGSizeMake(SCREEN_WIDTH, 35)];
    return CGSizeMake(size.width + 15, size.height);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WordCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WordCollectionCell" forIndexPath:indexPath];
    cell.word = self.wordArray[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.word_chinese.length > 0 || [@"zh-CN" isEqualToString:self.word_chinese]) {
        return;
    }
    self.clickCell = (WordCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    self.clickCell.contentView.backgroundColor = RGBA(245, 245, 245, 1);
    
    WordModel *word = self.wordArray[indexPath.row];
    word.word_is_study = [self.helper updateWordIsStudy:word.word_id];
    [self.wordArray replaceObjectAtIndex:indexPath.row withObject:word];
    
    self.word_chinese = word.word_chinese;
    [self playWord:word.word_english wordType:@"en-US"];
    
    [self updateCenterWord:word];
}

- (void)speechSynthesizer:(AVSpeechSynthesizer*)synthesizer didStartSpeechUtterance:(AVSpeechUtterance*)utterance{
   
}

- (void)speechSynthesizer:(AVSpeechSynthesizer*)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance*)utterance{
    if ([@"zh-CN" isEqualToString:self.word_chinese]) {
        self.word_chinese = nil;
        self.clickCell.contentView.backgroundColor = [UIColor whiteColor];
        self.clickCell = nil;
        [self.wordCollection reloadData];
        return;
    }
    [self playWord:self.word_chinese wordType:@"zh-CN"];
    self.word_chinese = @"zh-CN";
}

- (void)playWord:(NSString *)wordString wordType:(NSString *)type{
    if (!self.wordPlay) {
        self.wordPlay = [[AVSpeechSynthesizer alloc] init];
        self.wordPlay.delegate = self;
    }
    AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc] initWithString:wordString];//需要转换的文字
    utterance.rate = 0.45;// 设置语速，范围0-1，注意0最慢，1最快；
    AVSpeechSynthesisVoice*voice = [AVSpeechSynthesisVoice voiceWithLanguage:type];
    utterance.voice= voice;
    [self.wordPlay speakUtterance:utterance];//开始
}

- (void)backBtnAction{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)playStory{
    ExamController *wordExam = [[ExamController alloc] init];
    wordExam.chapterId = self.chapterId;
    [self presentViewController:wordExam animated:NO completion:nil];
//    NSString *name = [self.helper selectStoryNameWithChapterId:self.chapterId];
//    self.story = [[StoryPlayUtil alloc] initWithStoryName:name];
}

- (void)updateCenterWord:(WordModel *)word{
    CGSize size = [Utils sizeWithString:word.word_english andFont:kFont(75) andMaxSize:CGSizeMake(SCREEN_WIDTH, 60)];
    self.centerCell.word = word;
    [self.centerCell mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.offset(size.width + 15);
    }];
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
