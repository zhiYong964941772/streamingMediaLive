//
//  LAILiveTableViewListViewController.m
//  流媒体
//
//  Created by huazhan Huang on 2017/5/26.
//  Copyright © 2017年 zhiYong_lai. All rights reserved.
//

#import "LAILiveTableViewListViewController.h"
#import "LAILiveViewController.h"
#import "LAIHomeModel.h"
#import "LAILiveModel.h"
@interface LAILiveTableViewListViewController ()
{
    NSMutableArray *_listArr;
}
@end

@implementation LAILiveTableViewListViewController
- (instancetype)initWithLiveListData:(NSMutableArray*)listData{
    self = [super init];
    if (self) {
        _listArr = listData;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"直播列表";
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return (_listArr)?_listArr.count:0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *const identifier = @"liveCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    LAIHomeModel *model = _listArr[indexPath.row];
    cell.textLabel.text = model.creator.nick;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LAIHomeModel *model = _listArr[indexPath.row];
    LAILiveViewController *liveVC = [[LAILiveViewController alloc]initWithLiveUrl:model.stream_addr];
    [self.navigationController pushViewController:liveVC animated:YES];
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
