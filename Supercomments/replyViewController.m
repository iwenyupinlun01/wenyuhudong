//
//  replyViewController.m
//  Supercomments
//
//  Created by 王俊钢 on 2017/4/6.
//  Copyright © 2017年 wangjungang. All rights reserved.
//

#import "replyViewController.h"
#import "replyCell.h"
#import "replyModel.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "detailsViewController.h"
@interface replyViewController ()<UITableViewDelegate,UITableViewDataSource,myTabVdelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
{
    int pn;
}
@property (nonatomic,strong) UITableView *replytable;
@property (nonatomic,strong) NSMutableArray *replyarr;
@property (nonatomic,strong) replyModel *rmodel;
@end
static NSString *replyidentfid = @"replyidentfid";
@implementation replyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor wjColorFloat:@"333333"];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    self.title = @"回复";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor wjColorFloat:@"333333"]}];
    pn=1;
    self.replyarr = [NSMutableArray array];
    

    //[self datafromweb];
    self.replytable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self.view addSubview:self.replytable];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    // 3.1.下拉刷新
    [self addHeader];
    // 3.2.上拉加载更多
    [self addFooter];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 刷新加载数据

- (void)addHeader
{
    // 头部刷新控件
    self.replytable.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshAction)];
    [self.replytable.mj_header beginRefreshing];
    
}

- (void)addFooter
{
    self.replytable.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshLoadMore)];
}
- (void)refreshAction {
    
    [self headerRefreshEndAction];
    
}
- (void)refreshLoadMore {
    
    [self footerRefreshEndAction];
    
}
- (void)headerRefreshEndAction
{
    [self.replyarr removeAllObjects];

    
    [AFManager getReqURL:[NSString stringWithFormat:xiaoxitongzhijk,[tokenstr tokenstrfrom],@"1"] block:^(id infor) {
        NSLog(@"infor------------%@",infor);
        if ([[infor objectForKey:@"code"] intValue]==1) {
            NSArray *ditarr = [infor objectForKey:@"info"];
            for (int i = 0; i<ditarr.count; i++) {
                NSDictionary *dit = [ditarr objectAtIndex:i];
                self.rmodel = [[replyModel alloc] init];
                self.rmodel.replyurl = dit[@"user_icon"];
                self.rmodel.replyname = dit[@"publisher_nickname"];
                self.rmodel.replytext = dit[@"comment_content"];
                self.rmodel.comment_img_type = dit[@"comment_img_type"];
                self.rmodel.comment_imgstr = dit[@"comment_img"];
                self.rmodel.replytimestr = dit[@"pubtime"];
                self.rmodel.obj_id = dit[@"object_id"];
                self.rmodel.is_checkstr = dit[@"is_check"];
                self.rmodel.replyidstr = dit[@"id"];
                [self.replyarr addObject:self.rmodel];
            }
        }
        else if ([[infor objectForKey:@"code"] intValue]==2)
        {
            NSLog(@"没有查询到任何数据");
        }
        [self.replytable.mj_header endRefreshing];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.replytable reloadData];
        });
    } errorblock:^(NSError *error) {
        [self.replytable.mj_header endRefreshing];
    }];

}

-(void)footerRefreshEndAction
{
    pn++;
 
    NSString *pnstr = [NSString stringWithFormat:@"%d",pn];
    [AFManager getReqURL:[NSString stringWithFormat:xiaoxitongzhijk,[tokenstr tokenstrfrom],pnstr] block:^(id infor) {
        NSLog(@"infor------------%@",infor);
        if ([[infor objectForKey:@"code"] intValue]==1) {
            NSArray *ditarr = [infor objectForKey:@"info"];
            for (int i = 0; i<ditarr.count; i++) {
                NSDictionary *dit = [ditarr objectAtIndex:i];
                self.rmodel = [[replyModel alloc] init];
                self.rmodel.replyurl = dit[@"user_icon"];
                self.rmodel.replyname = dit[@"publisher_nickname"];
                self.rmodel.replytext = dit[@"comment_content"];
                self.rmodel.comment_img_type = dit[@"comment_img_type"];
                self.rmodel.comment_imgstr = dit[@"comment_img"];
                self.rmodel.replytimestr = dit[@"pubtime"];
                self.rmodel.obj_id = dit[@"object_id"];
                self.rmodel.is_checkstr = dit[@"is_check"];
                self.rmodel.replyidstr = dit[@"id"];
                [self.replyarr addObject:self.rmodel];
            }
        }
        else if ([[infor objectForKey:@"code"] intValue]==2)
        {
            NSLog(@"没有查询到任何数据");
        }
        [self.replytable.mj_footer endRefreshing];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.replytable reloadData];
        });
    } errorblock:^(NSError *error) {
        [self.replytable.mj_footer endRefreshing];
    }];
}


#pragma mark - getters

-(UITableView *)replytable
{
    if(!_replytable)
    {
        _replytable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT-64)];
        _replytable.dataSource = self;
        _replytable.delegate = self;
        _replytable.emptyDataSetSource = self;
        _replytable.emptyDataSetDelegate = self;
    }
    return _replytable;
}

#pragma mark -UITableViewDataSource&&UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.replyarr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    replyCell *cell = [tableView dequeueReusableCellWithIdentifier:replyidentfid];
    if (!cell) {
        cell = [[replyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:replyidentfid];
    }
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setdata:self.replyarr[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 248/2*HEIGHT_SCALE-30*HEIGHT_SCALE;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        self.rmodel = self.replyarr[indexPath.row];
        NSString* objid =   self.rmodel.replyidstr;
        
        [AFManager getReqURL:[NSString stringWithFormat:shanchuxiaoxi,[tokenstr tokenstrfrom],@"1",objid] block:^(id infor) {
            NSLog(@"infor=====%@",infor);
            
            if ([[infor objectForKey:@"code"] intValue]==1) {
                [MBProgressHUD showSuccess:@"删除成功"];
                // 删除数据源的数据,self.cellData是你自己的数据
                [self.replyarr removeObjectAtIndex:indexPath.row];
                //删除列表中数据
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];

            }
            
        } errorblock:^(NSError *error) {
            
        }];
       
    }
    
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";//默认文字为 Delete
}

#pragma mark - 实现方法

-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)myTabVClick:(UITableViewCell *)cell
{
    NSIndexPath *index = [self.replytable indexPathForCell:cell];
    self.rmodel = self.replyarr[index.row];
    NSString *idstr = self.rmodel.obj_id;
    detailsViewController *detalsVC = [[detailsViewController alloc] init];
    detalsVC.detalisidstr = idstr;
    [self.navigationController pushViewController:detalsVC animated:YES];
    NSLog(@"333===%ld",index.row);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    self.rmodel = self.replyarr[indexPath.row];
    NSString *idstr = self.rmodel.obj_id;
    detailsViewController *detalsVC = [[detailsViewController alloc] init];
    detalsVC.detalisidstr = idstr;
    [self.navigationController pushViewController:detalsVC animated:YES];
    NSLog(@"%ld",(long)indexPath.row);
    
    [AFManager getReqURL:[NSString stringWithFormat:kanwanxiaoxi,[tokenstr tokenstrfrom],self.rmodel.replyidstr] block:^(id infor) {
        NSLog(@"infor-----%@",infor);
    } errorblock:^(NSError *error) {
        
    }];
}

#pragma mark - 加载失败

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"空的"];
}

@end
