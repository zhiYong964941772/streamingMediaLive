//
//  LAIHomeViewController.m
//  流媒体
//
//  Created by huazhan Huang on 2017/5/26.
//  Copyright © 2017年 zhiYong_lai. All rights reserved.
//

#import "LAIHomeViewController.h"
#import "LAIHomeViewModel.h"
#import "LAILiveTableViewListViewController.h"
#import "LAIVideoCaptureViewController.h"
@interface LAIHomeViewController ()
@property(nonatomic,strong)LAIHomeViewModel *viewModel;

@end

@implementation LAIHomeViewController
- (LAIHomeViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [[LAIHomeViewModel alloc]init];
        [_viewModel.liveCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
            if (x) {
                [self pushLiveViewControllerWith:x];
            }
        }];
        [_viewModel.collectCommand.executionSignals subscribeNext:^(id x) {
            if ([x isEqualToString:SUCCESS]) {
                [self pushVideoCapture];
            }
        }];
    }
    return _viewModel;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
    self.view.backgroundColor = [UIColor whiteColor];
}
- (void)creatUI{
    UIButton *liveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [liveBtn setTitle:@"直播" forState:UIControlStateNormal];
    [liveBtn setTitleColor:BASECOLORL(140, 140, 140) forState:UIControlStateNormal];
    [liveBtn setBackgroundColor:[UIColor darkTextColor]];
    liveBtn.layer.shadowColor = [UIColor redColor].CGColor;
    liveBtn.layer.shadowOpacity = 1.0;
    liveBtn.layer.shadowRadius = 4.0f;
    liveBtn.layer.shadowOffset = CGSizeMake(4, 4);
    [[liveBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self.viewModel.liveCommand execute:nil];
    }];
    [self.view addSubview:liveBtn];
    
    UIButton *collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [collectBtn setTitle:@"采集" forState:UIControlStateNormal];
    [collectBtn setTitleColor:BASECOLORL(140, 140, 140) forState:UIControlStateNormal];
    [collectBtn setBackgroundColor:[UIColor darkTextColor]];
    collectBtn.layer.shadowColor = [UIColor redColor].CGColor;
    collectBtn.layer.shadowOpacity = 1.0;
    collectBtn.layer.shadowRadius = 4.0f;
    collectBtn.layer.shadowOffset = CGSizeMake(4, 4);
    [[collectBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self.viewModel.collectCommand execute:nil];
    }];

    [self.view addSubview:collectBtn];
    
    [liveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.centerY.mas_equalTo(self.view.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH*0.5,40));
    }];
    [collectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(liveBtn.mas_bottom).with.offset(40);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH*0.5,40));
    }];
}
#pragma mark -- 跳转到直播列表
- (void)pushLiveViewControllerWith:(id)x{
    LAILiveTableViewListViewController *listVC = [[LAILiveTableViewListViewController alloc]initWithLiveListData:x];
    [self.navigationController pushViewController:listVC animated:YES];
}
#pragma mark --跳转到采集视图
- (void)pushVideoCapture{
    LAIVideoCaptureViewController *videoCaptureVC = [[LAIVideoCaptureViewController alloc]init];
    [self.navigationController pushViewController:videoCaptureVC animated:YES];
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
