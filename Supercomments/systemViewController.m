//
//  systemViewController.m
//  Supercomments
//
//  Created by 王俊钢 on 2017/4/6.
//  Copyright © 2017年 wangjungang. All rights reserved.
//

#import "systemViewController.h"
#import "systemCell.h"
#import "UIColor+BgColor.h"
#import "xitongModel.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
@interface systemViewController ()<UITableViewDataSource,UITableViewDelegate,SWTableViewCellDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
{
    int pn;
}
@property (nonatomic,strong) UITableView *systemtableview;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) xitongModel *ximodel;
@property (nonatomic,strong) NSMutableArray *xitongarr;

@end
static NSString * const kShowTextCellReuseIdentifier = @"QSShowTextCell";
@implementation systemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor wjColorFloat:@"333333"];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    self.title = @"系统通知";

    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor wjColorFloat:@"333333"]}];
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    pn=1;
    self.dataSource = [NSMutableArray array];
    self.xitongarr = [NSMutableArray array];
    //[self loaddatafromweb];
    
    // 3.1.下拉刷新
    [self addHeader];
    // 3.2.上拉加载更多
    [self addFooter];
    
    [self.view addSubview:self.systemtableview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 刷新加载数据

- (void)addHeader
{
    // 头部刷新控件
    self.systemtableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshAction)];
    [self.systemtableview.mj_header beginRefreshing];
    
}

- (void)addFooter
{
    self.systemtableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshLoadMore)];
}
- (void)refreshAction {
    
    [self headerRefreshEndAction];
    
}
- (void)refreshLoadMore {
    
    [self footerRefreshEndAction];
    
}
- (void)headerRefreshEndAction
{
    
    [self.dataSource removeAllObjects];
    [self.xitongarr removeAllObjects];
    NSString *tokenstr = [[NSString alloc] init];
    NSUserDefaults *userdefat = [NSUserDefaults standardUserDefaults];
    NSString *token = [userdefat objectForKey:@"tokenuser"];
    if (token.length==0) {
        tokenstr = @"";
    }
    else
    {
        tokenstr = token;
    }
    NSLog(@"token--------%@",tokenstr);
    [AFManager getReqURL:[NSString stringWithFormat:xitongtongzhi,tokenstr,@"1"] block:^(id infor) {
        NSLog(@"info-------%@",infor);
        if ([[infor objectForKey:@"code"] intValue]==1)
        {
            NSArray *dit = [infor objectForKey:@"info"];
            for (int i = 0; i<dit.count; i++)
            {
                NSDictionary *dicarr = [dit objectAtIndex:i];
                self.ximodel = [[xitongModel alloc] init];
                self.ximodel.puttimestr = dicarr[@"pubtime"];
                self.ximodel.idstr = dicarr[@"id"];
                
                NSString *concent = dicarr[@"inform_content"];
                [self.dataSource addObject:concent];
                
                [self.xitongarr addObject:self.ximodel];
                
            }
        }
        [self.systemtableview.mj_header endRefreshing];
        [self.systemtableview reloadData];
    } errorblock:^(NSError *error) {
        [self.systemtableview.mj_header endRefreshing];
    }];

}

-(void)footerRefreshEndAction
{
    NSString *tokenstr = [[NSString alloc] init];
    NSUserDefaults *userdefat = [NSUserDefaults standardUserDefaults];
    NSString *token = [userdefat objectForKey:@"tokenuser"];
    if (token.length==0) {
        tokenstr = @"";
    }
    else
    {
        tokenstr = token;
    }
    NSLog(@"token--------%@",tokenstr);
    pn++;
    NSString *pnstr = [NSString stringWithFormat:@"%d",pn];
    [AFManager getReqURL:[NSString stringWithFormat:xitongtongzhi,tokenstr,pnstr] block:^(id infor) {
        NSLog(@"info-------%@",infor);
        if ([[infor objectForKey:@"code"] intValue]==1)
        {
            NSArray *dit = [infor objectForKey:@"info"];
            for (int i = 0; i<dit.count; i++)
            {
                NSDictionary *dicarr = [dit objectAtIndex:i];
                self.ximodel = [[xitongModel alloc] init];
                self.ximodel.puttimestr = dicarr[@"pubtime"];
                self.ximodel.idstr = dicarr[@"id"];
                
                NSString *concent = dicarr[@"inform_content"];
                [self.dataSource addObject:concent];
                
                [self.xitongarr addObject:self.ximodel];
                
            }
        }
        [self.systemtableview.mj_footer endRefreshing];
        [self.systemtableview reloadData];
    } errorblock:^(NSError *error) {
        [self.systemtableview.mj_footer endRefreshing];
    }];
 
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.systemtableview.frame = CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT-64);
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    [AFManager getReqURL:[NSString stringWithFormat:jiemianyingcang,[tokenstr tokenstrfrom],@"2"] block:^(id infor) {
        NSLog(@"infor-------%@",infor);
        
    } errorblock:^(NSError *error) {
        
    }];
}

#pragma mark - getters

-(UITableView *)systemtableview
{
    if(!_systemtableview)
    {
        _systemtableview = [[UITableView alloc]init];
        _systemtableview.dataSource = self;
        _systemtableview.delegate = self;
        _systemtableview.backgroundColor = [UIColor clearColor];
        _systemtableview.emptyDataSetSource = self;
        _systemtableview.emptyDataSetDelegate = self;
    }
    return _systemtableview;
}

#pragma mark -UITableViewDataSource&&UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [systemCell cellHeightWithText:[self p_textAtIndexPath:indexPath]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.dataSource count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return 0.01f;
    }
    return 10.00f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    systemCell *cell = [tableView dequeueReusableCellWithIdentifier:kShowTextCellReuseIdentifier];
    if (!cell) {
        
        cell = [[systemCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kShowTextCellReuseIdentifier];
        cell.rightUtilityButtons = [self rightButtons];
        [cell setcelldata:self.xitongarr[indexPath.row]];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell layoutSubviewsWithText:[self p_textAtIndexPath:indexPath]];
    return cell;
}

- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:@"Delete"];
    return rightUtilityButtons;
}

- (NSArray *)leftButtons
{
    NSMutableArray *leftUtilityButtons = [NSMutableArray new];
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.07 green:0.75f blue:0.16f alpha:1.0]
                                                icon:[UIImage imageNamed:@"check.png"]];
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:1.0f blue:0.35f alpha:1.0]
                                                icon:[UIImage imageNamed:@"clock.png"]];
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188f alpha:1.0]
                                                icon:[UIImage imageNamed:@"cross.png"]];
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.55f green:0.27f blue:0.07f alpha:1.0]
                                                icon:[UIImage imageNamed:@"list.png"]];
    return leftUtilityButtons;
}


#pragma mark - SWTableViewDelegate

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
            NSLog(@"check button was pressed");
            break;
        case 1:
            NSLog(@"clock button was pressed");
            break;
        case 2:
            NSLog(@"cross button was pressed");
            break;
        case 3:
            NSLog(@"list button was pressed");
        default:
            break;
    }
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0:{
            NSIndexPath *cellIndexPath = [self.systemtableview indexPathForCell:cell];
            NSInteger row = cellIndexPath.row;
            self.ximodel = [self.xitongarr objectAtIndex:row];
            
            NSString *idstr = self.ximodel.idstr;
            NSLog(@"idstr========%@",idstr);
            
            
            [self p_removeTextAtIndexPath:cellIndexPath];
            [self.xitongarr removeObject:cellIndexPath];
            [self.systemtableview deleteRowsAtIndexPaths:@[cellIndexPath]
                                        withRowAnimation:UITableViewRowAnimationAutomatic];
            
            [self.systemtableview reloadData];
            
            NSString *tokenstr = [[NSString alloc] init];
            NSUserDefaults *userdefat = [NSUserDefaults standardUserDefaults];
            NSString *token = [userdefat objectForKey:@"tokenuser"];
            if (token.length==0) {
                tokenstr = @"";
            }
            else
            {
                tokenstr = token;
            }
            NSLog(@"token--------%@",tokenstr);
            
            [AFManager getReqURL:[NSString stringWithFormat:shanchuxiaoxi,tokenstr,@"2",idstr] block:^(id infor) {
                NSLog(@"infor-----%@",infor);
                if ([[infor objectForKey:@"code"]intValue]==1) {
                    [MBProgressHUD showSuccess:@"删除成功"];
                }
            } errorblock:^(NSError *error) {
                [MBProgressHUD showSuccess:@"网络繁忙"];
            }];

        }
            break;
        default:
            break;
    }
}

- (NSString *)p_textAtIndexPath:(NSIndexPath *)indexPath{
    
    return [self.dataSource objectAtIndex:indexPath.row];
}

- (void)p_removeTextAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"row = %ld,section = %ld",indexPath.row,indexPath.section);
    [self.dataSource removeObjectAtIndex:indexPath.row];
}

#pragma mark - 实现方法

-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 加载失败

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"空的"];
}
@end
