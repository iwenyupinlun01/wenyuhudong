//
//  xiangqingViewController.m
//  Supercomments
//
//  Created by 王俊钢 on 2017/5/12.
//  Copyright © 2017年 wangjungang. All rights reserved.
//

#import "xiangqingViewController.h"
#import "HYBTestCell.h"
#import "HYBTestModel.h"
#import "HYBCommentModel.h"
#import "UITableViewCell+HYBMasonryAutoCellHeight.h"
@interface xiangqingViewController () <UITableViewDelegate, UITableViewDataSource, HYBTestCellDelegate>
@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *pinglunarr;
@end

static NSString *xiangqingcell = @"xiagnqingcell";

@implementation xiangqingViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor wjColorFloat:@"333333"];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor wjColorFloat:@"333333"]}];
    self.title = @"详情";
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    [navigationBar setBackgroundImage:[[UIImage alloc] init]
                       forBarPosition:UIBarPositionAny
                           barMetrics:UIBarMetricsDefault];
    
    self.pinglunarr = [NSMutableArray array];
    [self loaddataformweb];
    
    [self.view addSubview:self.tableView];
}


-(UITableView *)tableView
{
    if(!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT-64)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}



-(void)loaddataformweb
{
//    for (NSUInteger i = 0; i < 100; ++i) {
//        HYBTestModel *testModel = [[HYBTestModel alloc] init];
//        testModel.title = @"标哥的技术博客";
//        testModel.desc = @"由标哥的技术博客出品，学习如何在cell中嵌套使用tableview并自动计算行高。同时演示如何通过HYBMasonryAutoCellHeight自动计算行高，关注博客：http://www.henishuo.com";
//        testModel.headImage = @"head";
//        testModel.uid = [NSString stringWithFormat:@"testModel%ld", i + 1];
//        NSUInteger randCount = arc4random() % 10 + 1;
//        for (NSUInteger j = 0; j < randCount; ++j) {
//            HYBCommentModel *model = [[HYBCommentModel alloc] init];
//            model.name = @"标哥";
//            model.reply = @"标哥的";
//            model.comment = @"可以试试HYBMasonryAutoCellHeight这个扩展，自动计算行高的";
//            model.cid = [NSString stringWithFormat:@"commonModel%ld", j + 1];
//            [testModel.commentModels addObject:model];
//        }
//        [self.datasource addObject:testModel];
//    }
//
//    [_tableView reloadData];
    
    
    NSString *urlstr = @"http://np.iwenyu.cn/forum/index/detail.html?id=918&page=1&token=3958956e3fd31dd65b111ad33fb94eec";
    [AFManager getReqURL:urlstr block:^(id infor) {
        NSDictionary *infodit = [infor objectForKey:@"info"];
        NSArray *dicarr = [infodit objectForKey:@"all_comment"];
        for (int i = 0; i<dicarr.count; i++) {
            NSDictionary *dit = [dicarr objectAtIndex:i];
            HYBTestModel *testModel = [[HYBTestModel alloc] init];
            testModel.desc = [dit objectForKey:@"content"];
            testModel.uid = @"111";
            testModel.headImage = @"jead";
            testModel.title = @"name";
            
            
            self.pinglunarr = [dit objectForKey:@"sonComment"];
            
            for (int j = 0; j<_pinglunarr.count; j++) {
                NSDictionary *dit = [_pinglunarr objectAtIndex:j];
                HYBCommentModel *model = [[HYBCommentModel alloc] init];
                model.name = [dit objectForKey:@"s_nickname"];
                model.reply = [dit objectForKey:@"s_to_nickname"];
                model.comment = [dit objectForKey:@"content"];
                model.cid = [NSString stringWithFormat:@"commonModel%d", j + 1];
                [testModel.commentModels addObject:model];
            }

            
            
            
//            for (NSUInteger j = 0; j < 12; ++j) {
//                HYBCommentModel *model = [[HYBCommentModel alloc] init];
//                model.name = @"标哥";
//                model.reply = @"标哥的";
//                model.comment = @"可以试试HYBMasonryAutoCellHeight这个扩展，自动计算行高的";
//                model.cid = [NSString stringWithFormat:@"commonModel%ld", j + 1];
//                [testModel.commentModels addObject:model];
//            }
            
            [self.datasource addObject:testModel];
        }
        [self.tableView reloadData];
    } errorblock:^(NSError *error) {
        
    }];

}

- (NSMutableArray *)datasource {
    if (_datasource == nil) {
        _datasource = [[NSMutableArray alloc] init];
    }
    return _datasource;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HYBTestCell *cell = [tableView dequeueReusableCellWithIdentifier:xiangqingcell];
//    if (!cell) {
        cell = [[HYBTestCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:xiangqingcell];
        cell.delegate = self;
//    }
    HYBTestModel *model = [self.datasource objectAtIndex:indexPath.row];
    [cell configCellWithModel:model indexPath:indexPath];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datasource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    HYBTestModel *model = [self.datasource objectAtIndex:indexPath.row];
    
    CGFloat h = [HYBTestCell hyb_heightForTableView:tableView config:^(UITableViewCell *sourceCell) {
        HYBTestCell *cell = (HYBTestCell *)sourceCell;
        [cell configCellWithModel:model indexPath:indexPath];
    } cache:^NSDictionary *{
        NSDictionary *cache = @{kHYBCacheUniqueKey : model.uid,
                                kHYBCacheStateKey  : @"",
                                kHYBRecalculateForStateKey : @(model.shouldUpdateCache)};
        model.shouldUpdateCache = NO;
        return cache;
    }];
    
    return h;
}

#pragma mark - HYBTestCellDelegate

- (void)reloadCellHeightForModel:(HYBTestModel *)model atIndexPath:(NSIndexPath *)indexPath {
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}


#pragma mark - 实现方法

-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
