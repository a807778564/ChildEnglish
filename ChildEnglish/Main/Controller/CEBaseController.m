//
//  CEBaseController.m
//  ChildEnglish
//
//  Created by huangrensheng on 2019/4/17.
//  Copyright © 2019 huangrensheng. All rights reserved.
//

#import "CEBaseController.h"

@interface CEBaseController ()
@property (nonatomic , strong) UIImageView *backImage;
@end

@implementation CEBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.backImage = [[UIImageView alloc] init];
    [self.view addSubview:self.backImage];
    [self.backImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    // Do any additional setup after loading the view.
}

- (void)setBackImageName:(NSString *)imageName {
    [self.backImage setImage:[UIImage imageNamed:imageName]];
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
