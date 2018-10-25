//
//  DBHelper.h
//  ChildEnglish
//
//  Created by huangrensheng on 2018/5/4.
//  Copyright © 2018年 huangrensheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBHelper : NSObject
- (void)initData;
//获取章节列表
- (NSMutableArray *)getChapterArray;

/**
 获取单词列表
 @param chapterId 章节id
 @return 单词列表
 */
- (NSMutableArray *)getWordWithChapter:(NSInteger)chapterId;

/**
 更新单词的学习状态
 @param wordId 单词id
 @return 是否更新成功
 */
- (NSInteger)updateWordIsStudy:(NSInteger)wordId;


/**
 获取未学习的单词数量
 @param chapterId 章节id
 @return 未学习的单词数量
 */
- (NSInteger)selectUnStudyCountWithChapterId:(NSInteger)chapterId;


/**
 获取故事名称
 @param chapterId 章节名称
 @return 故事名
 */
- (NSString *)selectStoryNameWithChapterId:(NSInteger)chapterId;
@end
