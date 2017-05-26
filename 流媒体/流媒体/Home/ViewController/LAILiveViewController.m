//
//  LAILiveViewController.m
//  流媒体
//
//  Created by huazhan Huang on 2017/5/26.
//  Copyright © 2017年 zhiYong_lai. All rights reserved.
//

#import "LAILiveViewController.h"
#import <IJKMediaFramework/IJKMediaFramework.h>
@interface LAILiveViewController ()
{
    IJKFFMoviePlayerController *_player;
    NSString *_liveUrl;
   
}
@end

@implementation LAILiveViewController
- (instancetype)initWithLiveUrl:(NSString *)liveUrl{
    self = [super init];
    if (self) {
        _liveUrl = liveUrl;
    }
    return self;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL *url = [NSURL URLWithString:_liveUrl];

    _player = [[IJKFFMoviePlayerController alloc]initWithContentURL:url withOptions:nil];
    [_player prepareToPlay];
    
    _player.view.frame = self.view.bounds;
    [self.view insertSubview:_player.view atIndex:1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_player pause];
    [_player stop];
    [_player shutdown];
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
