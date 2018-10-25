//
//  StoryPlayUtil.m
//  ChildEnglish
//
//  Created by huangrensheng on 2018/5/26.
//  Copyright © 2018年 huangrensheng. All rights reserved.
//

#import "StoryPlayUtil.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface StoryPlayUtil()<AVAudioPlayerDelegate>
@property (nonatomic , strong) AVAudioPlayer *player;
@end

@implementation StoryPlayUtil

- (instancetype)initWithStoryName:(NSString *)name{
    if ([super init]) {
        //得到音频资源的路径
        NSString *newPath = [[NSBundle mainBundle] pathForResource:name ofType:@"mp3" inDirectory:@"Story"];
        //由于使用音频路径的时候为NSURL类型，所以我们需要将文件路径转换为NSURL类型
        NSURL *newurl = [NSURL fileURLWithPath:newPath];
    
        AVAudioSession * session = [AVAudioSession sharedInstance];
        [session setActive:YES error:nil];
        [session setCategory:AVAudioSessionCategoryPlayback error:nil];
        
        NSError *error = nil;
        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:newurl error:&error];
        self.player.delegate = self;
        //设置声音的大小
        self.player.volume = 1;//范围为（0到1）；
        //设置循环次数，如果为负数，就是无限循环
        self.player.numberOfLoops =-1;
        //设置播放进度
        self.player.currentTime = 0;
        //准备播放
        [self.player prepareToPlay];
        
        [self.player play];
    }
    return self;
}
@end
