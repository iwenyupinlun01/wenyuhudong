//
//  xiangqingViewController.m
//  Supercomments
//
//  Created by 王俊钢 on 2017/5/12.
//  Copyright © 2017年 wangjungang. All rights reserved.
//

#import "xiangqingViewController.h"
#import "firstCell.h"
#import "firstModel.h"
@interface xiangqingViewController () <UITableViewDelegate, UITableViewDataSource,mycellVdelegate>
@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, strong) UITableView *tableView;

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
    
    self.datasource = [NSMutableArray array];
    [self loaddataformweb];
    [self.view addSubview:self.tableView];
}

#pragma mark - getters

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
    NSString *urlstr = @"http://np.iwenyu.cn/forum/index/detail.html?id=918&page=1&token=f054925590e54922f592f3b232924e70";
    [AFManager getReqURL:urlstr block:^(id infor) {
        NSDictionary *infodit = [infor objectForKey:@"info"];
        NSArray *dicarr = [infodit objectForKey:@"all_comment"];
        for (int i = 0; i<dicarr.count; i++) {
            NSDictionary *dit = [dicarr objectAtIndex:i];
            firstModel *fmodel = [[firstModel alloc] init];
            fmodel.contentstr = [dit objectForKey:@"content"];
            fmodel.pinglunarr = [dit objectForKey:@"sonComment"];
            [self.datasource addObject:fmodel];
        }
        [self.tableView reloadData];
    } errorblock:^(NSError *error) {
        
    }];

}


#pragma mark -UITableViewDataSource&&UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    firstCell *cell = [tableView dequeueReusableCellWithIdentifier:xiangqingcell];
    cell = [[firstCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:xiangqingcell];
    [cell setcelldata:self.datasource[indexPath.row]];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    firstCell * cell = [[firstCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:xiangqingcell];
    return [cell setcelldata:self.datasource[indexPath.row]];
    
}

-(void)myTabVClick:(UITableViewCell *)cell datadic:(NSDictionary *)dic
{
    NSLog(@"dic=======%@",dic);
}



#pragma mark - 实现方法

-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
