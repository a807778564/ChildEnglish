//
//  ChapterModel.h
//  ChildEnglish
//
//  Created by huangrensheng on 2018/5/14.
//  Copyright © 2018年 huangrensheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChapterModel : NSObject
@property (nonatomic , strong) NSString *chapter_name;
@property (nonatomic , assign) NSInteger chapter_id;
@property (nonatomic , assign) NSInteger chapter_study_count;
@property (nonatomic , assign) NSInteger chapter_lock;
@end
