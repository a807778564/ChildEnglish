//
//  WordModel.h
//  ChildEnglish
//
//  Created by huangrensheng on 2018/5/17.
//  Copyright © 2018年 huangrensheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WordModel : NSObject
@property (nonatomic , assign) NSInteger word_id;
@property (nonatomic , strong) NSString  *word_english;
@property (nonatomic , strong) NSString  *word_chinese;
@property (nonatomic , assign) NSInteger word_is_study;
@property (nonatomic , assign) NSInteger word_is_test;
@property (nonatomic , strong) NSString  *word_image;
@property (nonatomic , assign) NSInteger chapter_id;
@end
