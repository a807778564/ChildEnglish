//
//  DBHelper.m
//  ChildEnglish
//
//  Created by huangrensheng on 2018/5/4.
//  Copyright © 2018年 huangrensheng. All rights reserved.
//

#import "DBHelper.h"
#import "FMDB.h"
#import "ChapterModel.h"
#import "WordModel.h"

@implementation DBHelper

//初始化数据库表
-(instancetype)init{
    
    if ([super init]) {
        FMDatabase *db = [self getBase];
        if ([db open]) {
            //章节
            NSString *createChapter = @"CREATE TABLE IF NOT EXISTS 't_chapter' ('chapter_id' integer PRIMARY KEY AUTOINCREMENT NOT NULL,'chapter_name' varchar(128),'chapter_study_count' integer(128) DEFAULT(0),'chapter_lock' integer(128) DEFAULT(0))";
            [db executeUpdate:createChapter];
            
            //故事
            NSString *createStory = @"CREATE TABLE IF NOT EXISTS 't_story' ('story_id' integer PRIMARY KEY AUTOINCREMENT NOT NULL, 'story_name' varchar(128),'story_lock' integer NOT NULL DEFAULT(0),'chapter_id' integer NOT NULL,FOREIGN KEY (chapter_id) REFERENCES t_chapter (chapter_id))";
            [db executeUpdate:createStory];
            
            //单词
            NSString *createWord = @"CREATE TABLE IF NOT EXISTS 't_word' ('word_id' integer PRIMARY KEY AUTOINCREMENT NOT NULL,'word_english' nvarchar(128),'word_chinese' nvarchar(128),'word_is_study' integer NOT NULL DEFAULT(0),'word_is_test' integer NOT NULL DEFAULT(0),'word_image' nvarchar(128) NOT NULL,'chapter_id' integer NOT NULL,FOREIGN KEY (chapter_id) REFERENCES t_chapter (chapter_id))";
            [db executeUpdate:createWord];
        }
    }
    return self;
}

/**
 *  获取数据库地址
 *
 *  @return 数据库地址
 */
-(NSString *)getDBPath
{
    NSString *dbPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSLog(@"dbPath : %@",dbPath);
    NSString *DBPath = [dbPath stringByAppendingPathComponent:@"chlidEnglish.db"];//成员列表数据库
    return DBPath;
}

/**
 *  获取数据库
 *
 *  @return 数据库
 */
-(FMDatabase *)getBase{
    
    NSString *dbPath = [self getDBPath];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];

    return db;
}

- (NSMutableArray *)getChapterArray{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    FMDatabase *db = [self getBase];
    FMResultSet *result= [[FMResultSet alloc] init];
    if ([db open]) {
        result = [db executeQuery:@"select chapter_id,chapter_name,chapter_study_count,chapter_lock from t_chapter"];
        while ([result next]) {
            ChapterModel *chapter = [[ChapterModel alloc] init];
            chapter.chapter_id = [result intForColumn:@"chapter_id"];
            chapter.chapter_study_count = [result intForColumn:@"chapter_study_count"];
            chapter.chapter_name = [result stringForColumn:@"chapter_name"];
            chapter.chapter_lock = [result intForColumn:@"chapter_lock"];
            [arr addObject:chapter];
        }
    }
    [db close];
    return arr;
}

- (NSMutableArray *)getWordWithChapter:(NSInteger)chapterId{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    FMDatabase *db = [self getBase];
    FMResultSet *result= [[FMResultSet alloc] init];
    if ([db open]) {
        NSString *sql = [NSString stringWithFormat:@"select word_id,word_english,word_chinese,word_is_study,word_is_test,word_image from t_word where chapter_id = %ld",chapterId];
        result = [db executeQuery:sql];
        while ([result next]) {
            WordModel *chapter = [[WordModel alloc] init];
            chapter.word_id = [result intForColumn:@"word_id"];
            chapter.word_english = [result stringForColumn:@"word_english"];
            chapter.word_chinese = [result stringForColumn:@"word_chinese"];
            chapter.word_is_study = [result intForColumn:@"word_is_study"];
            chapter.word_is_test = [result intForColumn:@"word_is_test"];
            chapter.word_image = [result stringForColumn:@"word_image"];
            [arr addObject:chapter];
        }
    }
    [db close];
    return arr;
}

- (NSInteger)updateWordIsStudy:(NSInteger)wordId{
    NSInteger update = 0;
    FMDatabase *db = [self getBase];
    if ([db open]) {
        NSString *sql = [NSString stringWithFormat:@"update t_word set word_is_study = 1 where word_id = %ld",wordId];
        update = [db executeUpdate:sql];
    }
    [db close];
    return update;
}

- (NSInteger)selectUnStudyCountWithChapterId:(NSInteger)chapterId{
    NSInteger count = 0;
    FMDatabase *db = [self getBase];
    FMResultSet *result= [[FMResultSet alloc] init];
    if ([db open]) {
        NSString *sql = [NSString stringWithFormat:@"select count(*) from t_word where word_is_study = 1 and chapter_id = %ld",chapterId];
        result = [db executeQuery:sql];
        if ([result next]) {
            count = [result intForColumnIndex:0];
        }
    }
    [db close];
    return count;
}

- (NSString *)selectStoryNameWithChapterId:(NSInteger)chapterId{
    NSString *name = @"";
    FMDatabase *db = [self getBase];
    FMResultSet *result= [[FMResultSet alloc] init];
    if ([db open]) {
        NSString *sql = [NSString stringWithFormat:@"select story_name from t_story where chapter_id = %ld",chapterId];
        result = [db executeQuery:sql];
        if ([result next]) {
            name = [result stringForColumn:@"story_name"];
        }
    }
    [db close];
    return name;
}

- (NSInteger)getChapterCount{
    NSInteger count = 0;
    FMDatabase *db = [self getBase];
    FMResultSet *result= [[FMResultSet alloc] init];
    if ([db open]) {
        result = [db executeQuery:@"select count(*) from t_chapter"];
        if ([result next]) {
            count = [result intForColumnIndex:0];
        }
    }
    [db close];
    return count;
}

- (NSInteger)getStoryCount{
    NSInteger count = 0;
    FMDatabase *db = [self getBase];
    FMResultSet *result= [[FMResultSet alloc] init];
    if ([db open]) {
        result = [db executeQuery:@"select count(*) from t_story"];
        if ([result next]) {
            count = [result intForColumnIndex:0];
        }
    }
    [db close];
    return count;
}

- (NSInteger)getWordCount{
    NSInteger count = 0;
    FMDatabase *db = [self getBase];
    FMResultSet *result= [[FMResultSet alloc] init];
    if ([db open]) {
        result = [db executeQuery:@"select count(*) from t_word"];
        if ([result next]) {
            count = [result intForColumnIndex:0];
        }
    }
    [db close];
    return count;
}

- (void)initData{
    NSString *chapterSql = @"INSERT INTO t_chapter('chapter_name') values ('水果');INSERT INTO t_chapter('chapter_name') values ('人物');INSERT INTO t_chapter('chapter_name') values ('器官');INSERT INTO t_chapter('chapter_name') values ('文具');INSERT INTO t_chapter('chapter_name') values ('颜色');INSERT INTO t_chapter('chapter_name') values ('日用');INSERT INTO t_chapter('chapter_name') values ('食物');INSERT INTO t_chapter('chapter_name') values ('动物');INSERT INTO t_chapter('chapter_name') values ('衣物');INSERT INTO t_chapter('chapter_name') values ('天气')";
    
    NSString *storySql = @"INSERT INTO t_story('story_name','chapter_id') values ('001刺猬人汉斯',1);INSERT INTO t_story('story_name','chapter_id') values ('002三个愿望',2);INSERT INTO t_story('story_name','chapter_id') values ('003两个蛤蟆的故事',3);INSERT INTO t_story('story_name','chapter_id') values ('004六个仆人',4);INSERT INTO t_story('story_name','chapter_id') values ('005黑白新娘',5);INSERT INTO t_story('story_name','chapter_id') values ('006铁汉斯的故事',6);INSERT INTO t_story('story_name','chapter_id') values ('007三个黑公主',7);INSERT INTO t_story('story_name','chapter_id') values ('008三个儿子',8);INSERT INTO t_story('story_name','chapter_id') values ('009布拉克尔的姑娘',9);INSERT INTO t_story('story_name','chapter_id') values ('010小羊和小鱼',10)";
    
    NSString *wordSql = @"INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('apple','苹果','image_','1');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('banana','香蕉','image_','1');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('melon','西瓜','image_','1');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('orange','橘子','image_','1');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('grape','葡萄','image_','1');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('peach','桃子','image_','1');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('tomato','西红柿','image_','1');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('strawberry','草莓','image_','1');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('pear','梨','image_','1');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('holly','樱桃','image_','1');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('pineapple','菠萝','image_','1');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('waxberry','杨梅','image_','1');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('carambola','杨桃','image_','1');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('mango','芒果','image_','1');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('megranate','石榴','image_','1');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('litchi','荔枝','image_','1');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('cantaloupe','哈密瓜','image_','1');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('kiwifruit','猕猴桃','image_','1');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('pawpaw','木瓜','image_','1');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('lemon','柠檬','image_','1');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('father','爸爸','image_','2');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('mother','妈妈','image_','2');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('grandfather','爷爷','image_','2');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('grandmather','奶奶','image_','2');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('brother','兄弟','image_','2');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('sisters','姐妹','image_','2');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('uncle','叔叔','image_','2');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('aunt','婶婶','image_','2');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('boy','男孩','image_','2');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('girl','女孩','image_','2');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('singer','歌手','image_','2');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('doctor','医生','image_','2');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('nurse','护士','image_','2');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('police','警察','image_','2');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('cook','厨师','image_','2');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('waitress','服务员','image_','2');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('attorney','律师','image_','2');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('driver','司机','image_','2');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('teacher','老师','image_','2');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('barber','理发师','image_','2');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('header','头部','image_','3');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('eye','眼睛','image_','3');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('nose','鼻子','image_','3');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('mouth','嘴巴','image_','3');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('teeth','牙齿','image_','3');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('longue','舌头','image_','3');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('neck','脖子','image_','3');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('arm','手臂','image_','3');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('hand','手','image_','3');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('body','身体','image_','3');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('ear','耳朵','image_','3');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('face','脸','image_','3');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('finger','手指','image_','3');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('heart','心','image_','3');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('liver','肝','image_','3');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('stomach','胃','image_','3');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('leg','大腿','image_','3');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('toe','脚趾','image_','3');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('knee','膝盖','image_','3');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('foot','脚','image_','3');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('schoolbag','书包','image_','4');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('book','书','image_','4');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('calculator','计算器','image_','4');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('desk','书桌','image_','4');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('pencil','铅笔','image_','4');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('eraser','橡皮','image_','4');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('ruler','尺子','image_','4');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('pen','钢笔','image_','4');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('compass','圆规','image_','4');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('ball pen','圆珠笔','image_','4');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('chalk','粉笔','image_','4');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('blackboard','黑板','image_','4');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('floder','文件夹','image_','4');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('penknife','小刀','image_','4');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('crayon','蜡笔','image_','4');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('color pen','水彩笔','image_','4');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('correction liquid','修改液','image_','4');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('writing case','文具盒','image_','4');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('writing book','写字本','image_','4');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('drawing book','绘画本','image_','4');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('red','红色','image_','5');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('yellow','黄色','image_','5');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('blue','蓝色','image_','5');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('green','绿色','image_','5');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('cyan','青色','image_','5');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('orange','橙色','image_','5');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('violet','紫色','image_','5');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('black','黑色','image_','5');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('white','白色','image_','5');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('gray','灰色','image_','5');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('brown','棕色','image_','5');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('pink','粉色','image_','5');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('clear','无色','image_','5');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('magenta','品红','image_','5');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('lightgray','浅灰','image_','5');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('darkgray','暗灰','image_','5');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('sky blue','天蓝','image_','5');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('deep blue','深蓝','image_','5');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('dark green','深绿','image_','5');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('light red','浅红','image_','5');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('toothbrush','牙刷','image_','6');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('toothpaste','牙膏','image_','6');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('washbasin','脸盆','image_','6');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('dishcloth','抹布','image_','6');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('lamp bulb','灯泡','image_','6');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('trash','垃圾桶','image_','6');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('box','盒子','image_','6');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('fan','电扇','image_','6');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('fork','餐叉','image_','6');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('glass','眼镜','image_','6');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('spoon','勺子','image_','6');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('washing powder','洗衣粉','image_','6');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('washing liquid','洗衣液','image_','6');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('cleaning agent','清洁剂','image_','6');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('toilet paper','卫生纸','image_','6');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('water heater','热水器','image_','6');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('soap','肥皂','image_','6');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('comb','梳子','image_','6');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('hair drier','吹风机','image_','6');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('lamp','灯','image_','6');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('bread','面包','image_','7');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('milk','牛奶','image_','7');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('rice','大米','image_','7');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('dumplings','饺子','image_','7');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('noodle','面条','image_','7');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('chocolates','巧克力','image_','7');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('cake','蛋糕','image_','7');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('wheat','小麦','image_','7');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('hamburger','汉堡','image_','7');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('cola','可乐','image_','7');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('fries','薯条','image_','7');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('congee','粥','image_','7');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('cabbage','白菜','image_','7');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('spinach','菠菜','image_','7');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('onion','洋葱','image_','7');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('garlic','大蒜','image_','7');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('pepper','辣椒','image_','7');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('eggplant','茄子','image_','7');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('potato','马铃薯','image_','7');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('beans','豆角','image_','7');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('pig','猪','image_','8');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('dog','狗','image_','8');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('cat','猫','image_','8');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('mouse','老鼠','image_','8');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('cattle','牛','image_','8');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('tiger','老虎','image_','8');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('rabbit','兔','image_','8');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('monkey','猴','image_','8');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('chicken','鸡','image_','8');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('dragon','龙','image_','8');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('snake','蛇','image_','8');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('horse','马','image_','8');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('sheep','羊','image_','8');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('duck','鸭子','image_','8');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('fish','鱼','image_','8');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('shrimp','虾','image_','8');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('crab','螃蟹','image_','8');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('shell','贝壳','image_','8');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('ant','蚂蚁','image_','8');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('cicadas','蝉','image_','8');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('shirt','衬衫','image_','9');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('sweater','毛衣','image_','9');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('necktie','领带','image_','9');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('cap','帽子','image_','9');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('glove','手套','image_','9');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('suit','西装','image_','9');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('coat','外套','image_','9');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('trousers','裤子','image_','9');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('socks','袜子','image_','9');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('shoes','鞋子','image_','9');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('sandals','凉鞋','image_','9');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('skirt','裙子','image_','9');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('jeans','牛仔裤','image_','9');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('belt','皮带','image_','9');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('wallet','钱包','image_','9');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('watch','手表','image_','9');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('vest','背心','image_','9');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('leather shoes','皮鞋','image_','9');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('short sleeve','短袖','image_','9');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('slipper','拖鞋','image_','9');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('sunny day','晴天','image_','10');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('cloudy day','阴天','image_','10');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('fog day','雾天','image_','10');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('rainy day','雨天','image_','10');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('lightning','闪电','image_','10');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('windy','刮风','image_','10');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('sand dust','沙尘暴','image_','10');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('smog','雾霾','image_','10');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('tornado','龙卷风','image_','10');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('snow','下雪','image_','10');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('hail','冰雹','image_','10');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('cloudy','多云','image_','10');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('frost','霜降','image_','10');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('spring','春天','image_','10');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('summer','夏天','image_','10');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('fall','秋天','image_','10');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('winter','冬天','image_','10');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('desert','沙漠','image_','10');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('oasis','绿洲','image_','10');INSERT INTO t_word ('word_english','word_chinese','word_image','chapter_id') VALUES ('swamps','沼泽','image_','10')";
    
    FMDatabase *db = [self getBase];
    
    if ([db open]) {
        if ([self getChapterCount] <= 0) {
            for (NSString *chapter in [chapterSql componentsSeparatedByString:@";"]) {
                [db executeUpdate:chapter];
            }
        }
        if ([self getStoryCount] <= 0) {
            for (NSString *story in [storySql componentsSeparatedByString:@";"]) {
                [db executeUpdate:story];
            }
        }
        if ([self getWordCount] <= 0) {
            for (NSString *word in [wordSql componentsSeparatedByString:@";"]) {
                [db executeUpdate:word];
            }
        }
    }
    [db close];
}

@end
