//
//  newViewController.m
//  Supercomments
//
//  Created by 王俊钢 on 2017/4/5.
//  Copyright © 2017年 wangjungang. All rights reserved.
//

#import "newViewController.h"
#import "newCell.h"
#import "detailsViewController.h"
#import "XWScanImage.h"
#import "newModel.h"
#import "YYPhotoGroupView.h"
#import "SureWebViewController.h"
#import "loginViewController.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
@interface newViewController ()<UITableViewDataSource,UITableViewDelegate,mycellVdelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
/** 用于加载下一页的参数(页码) */
{
    int pn;
}
@property (nonatomic,strong) UITableView *newtable;
@property (nonatomic,strong) UIImageView *demoimg;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) NSMutableArray *dataarr;
@property (nonatomic,strong) newModel *nmodel;
@property (nonatomic,strong) NSMutableArray *imgarr;
@property (strong, nonatomic) NSMutableArray<newModel *> * menus;

@property (nonatomic,strong) NSString *panduan404str;
@end
static NSString *newidentfid = @"newidentfid";
@implementation newViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.newtable.emptyDataSetSource = self;
    self.newtable.emptyDataSetDelegate = self;
    // 删除单元格分隔线的一个小技巧
    self.newtable.tableFooterView = [UIView new];
    pn=1;
    self.dataSource = [NSMutableArray array];
    self.dataarr = [NSMutableArray array];
    self.imgarr = [NSMutableArray array];
    self.panduan404str = @"0";
    // 3.1.下拉刷新
    [self addHeader];
    // 3.2.上拉加载更多
    [self addFooter];
    [self.view addSubview:self.newtable];
    
    [self xw_addNotificationForName:@"headdianzan" block:^(NSNotification *notification) {
        NSLog(@"收到通知：%@", notification.userInfo);
    }];
}

#pragma mark - 刷新控件

- (void)addHeader
{
    // 头部刷新控件
    self.newtable.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshAction)];
    [self.newtable.mj_header beginRefreshing];
}

- (void)addFooter
{
    self.newtable.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshLoadMore)];
}

- (void)refreshAction {
    
    [self headerRefreshEndAction];
    
}

- (void)refreshLoadMore {
    
    [self footerRefreshEndAction];
    
}

- (void)headerRefreshEndAction {
    
    [self.dataSource removeAllObjects];
    [self.dataarr removeAllObjects];
    [self.imgarr removeAllObjects];
    
    NSString *strurl = [NSString stringWithFormat:newVCload,@"1",@"1",[tokenstr tokenstrfrom]];
    [AFManager getReqURL:strurl block:^(id infor) {
        NSLog(@"infor=====%@",infor);
        NSLog(@"str====%@",strurl);
        NSArray *dit = [infor objectForKey:@"info"];
        for (int i = 0; i<dit.count; i++) {
            NSDictionary *dicarr = [dit objectAtIndex:i];
            self.nmodel = [[newModel alloc] init];
            self.nmodel.contentstr = dicarr[@"content"];
            self.nmodel.timestr = dicarr[@"create_time"];
            self.nmodel.imgurlstr = dicarr[@"images"];
            self.nmodel.namestr = dicarr[@"name"];
            self.nmodel.dianzanstr = dicarr[@"support_num"];
            self.nmodel.pinglunstr = dicarr[@"reply_num"];
            self.nmodel.newidstr = dicarr[@"id"];
            self.nmodel.titlestr = dicarr[@"title"];
            self.nmodel.fromstr =dicarr[@"support_count"];
            self.nmodel.typestr = dicarr[@"type"];
            self.nmodel.sifoudianzanstr = dicarr[@"is_support"];
            self.nmodel.weburlstr = dicarr[@"url"];
            self.nmodel.ishot = dicarr[@"is_hot"];
            [self.dataSource addObject:self.nmodel.contentstr];
            [self.dataarr addObject:self.nmodel];
            [self.imgarr addObject:self.nmodel.imgurlstr];
        }
        [self.newtable.mj_header endRefreshing];
        [self.newtable reloadData];
    } errorblock:^(NSError *error) {
         [self.newtable.mj_header endRefreshing];
        self.panduan404str = @"1";
    }];
    
}
- (void)footerRefreshEndAction {
    pn ++;
    NSString *pnstr = [NSString stringWithFormat:@"%d",pn];
    NSString *strurl = [NSString stringWithFormat:newVCload,pnstr,@"1",[tokenstr tokenstrfrom]];
    [AFManager getReqURL:strurl block:^(id infor) {
        NSLog(@"infor=====%@",infor);
        NSLog(@"str====%@",strurl);
        NSArray *dit = [infor objectForKey:@"info"];
        for (int i = 0; i<dit.count; i++) {
            NSDictionary *dicarr = [dit objectAtIndex:i];
            self.nmodel = [[newModel alloc] init];
            self.nmodel.contentstr = dicarr[@"content"];
            self.nmodel.timestr = dicarr[@"create_time"];
            self.nmodel.imgurlstr = dicarr[@"images"];
            self.nmodel.namestr = dicarr[@"name"];
            self.nmodel.dianzanstr = dicarr[@"support_num"];
            self.nmodel.pinglunstr = dicarr[@"reply_num"];
            self.nmodel.newidstr = dicarr[@"id"];
            self.nmodel.titlestr = dicarr[@"title"];
            self.nmodel.fromstr =dicarr[@"support_count"];
            self.nmodel.typestr = dicarr[@"type"];
            self.nmodel.sifoudianzanstr = dicarr[@"is_support"];
            self.nmodel.weburlstr = dicarr[@"url"];
            [self.dataSource addObject:self.nmodel.contentstr];
            [self.dataarr addObject:self.nmodel];
            [self.imgarr addObject:self.nmodel.imgurlstr];
        }
        [self.newtable.mj_footer endRefreshing];
        
        [self.newtable reloadData];
       
    } errorblock:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.newtable.frame = CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT-64);
    //[self headerRefreshEndAction];
}

#pragma mark - getters

-(UIImageView *)demoimg
{
    if(!_demoimg)
    {
        _demoimg = [[UIImageView alloc] init];
    }
    return _demoimg;
}

-(UITableView *)newtable
{
    if(!_newtable)
    {
        _newtable = [[UITableView alloc] init];
        _newtable.dataSource = self;
        _newtable.delegate = self;
    }
    return _newtable;
}

#pragma mark -UITableViewDataSource&&UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *imgstr = [NSString stringWithFormat:@"%@",self.imgarr[indexPath.row]];
    NSString *contaststr = [NSString stringWithFormat:@"%@",self.dataSource[indexPath.row]];
    
    if (imgstr.length==0) {
        return [newCell cellHeightWithText:self.dataSource[indexPath.row]]+(16+16+4+20+16+16+10)*HEIGHT_SCALE;
    }
    else if(contaststr.length==0&&imgstr.length!=0)
    {
        return (16+16+4+20+16+16+196+10)*HEIGHT_SCALE;
    }
    else
    {
         return [newCell cellHeightWithText:self.dataSource[indexPath.row]]+(16+16+4+20+16+16+14+196+10)*HEIGHT_SCALE;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataarr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    newCell *cell = [tableView dequeueReusableCellWithIdentifier:newidentfid];
//    if (!cell) {
        cell = [[newCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:newidentfid];
//    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    
    [cell setcelldata:self.dataarr[indexPath.row]];
    //self.nmodel = self.dataarr[indexPath.row];
    return cell;
}

- (NSString *)p_textAtIndexPath:(NSIndexPath *)indexPath{
    
    return [self.dataSource objectAtIndex:indexPath.row];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.nmodel = [[newModel alloc] init];
    self.nmodel = self.dataarr[indexPath.row];
    NSString *str = self.nmodel.newidstr;
    NSLog(@"str======%@",str);
    detailsViewController *detailsvc = [[detailsViewController alloc] init];
    detailsvc.detalisidstr = str;
    [self.navigationController pushViewController:detailsvc animated:YES];
    
}

//点赞
-(void)myTabVClick1:(UITableViewCell *)cell
{
    NSIndexPath *index = [self.newtable indexPathForCell:cell];
    NSLog(@"333===%ld   点赞",index.row);
    
    
    self.nmodel = [[newModel alloc] init];
    self.nmodel = self.dataarr[index.row];
    
    NSString *dianzanstr = self.nmodel.sifoudianzanstr;
    NSLog(@"dianzanstr--------%@",dianzanstr);
    
    if ([dianzanstr isEqualToString:@"0"]) {
        
        if ([tokenstr tokenstrfrom].length==0) {
            loginViewController *loginvc = [[loginViewController alloc] init];
            loginvc.jinru = @"jinru";
            [self presentViewController:loginvc animated:YES completion:nil];
            NSLog(@"请登陆");
        }
        else
        {
            //点赞
            self.nmodel.sifoudianzanstr = @"1";
            NSDictionary *reqdic = @{@"token":[tokenstr tokenstrfrom],@"object_id":self.nmodel.newidstr,@"status":@"1",@"type":@"1"};
            
            [AFManager postReqURL:qudianzan reqBody:reqdic block:^(id infor) {
                NSLog(@"infor-------%@",infor);
                NSString *code = [infor objectForKey:@"code"];
                if ([code intValue]==1) {
                    [MBProgressHUD showSuccess:@"点赞"];
                    NSLog(@"成功");
                    self.nmodel = [[newModel alloc] init];
                    self.nmodel = self.dataarr[index.row];
                    
                    NSDictionary *dic = [infor objectForKey:@"info"];
                    self.nmodel.dianzanstr = [dic objectForKey:@"spportNum"];
                    dispatch_async(dispatch_get_main_queue(), ^{
                          [self.newtable reloadData];
                    });
                }
                else if ([code intValue]==0)
                {
                    [MBProgressHUD showSuccess:@"token错误"];
                    NSLog(@"token错误");
                }
                else if ([code intValue]==4)
                {
                    [MBProgressHUD showSuccess:@"抱歉您的账户被暂时限制了，无法进行此操作"];
                    NSLog(@"抱歉您的账户被暂时限制了，无法进行此操作");
                }else if ([code intValue]==2100)
                {
                    [MBProgressHUD showSuccess:@"该牛评不存在或者被冻结"];
                    NSLog(@"该牛评不存在或者被冻结");
                }
                else
                {
                    [MBProgressHUD showSuccess:@"系统繁忙，请稍后再试"];
                    NSLog(@"系统繁忙，请稍后再试");
                }

            }];

            [self.newtable reloadData];
        }
        
    }
    else
    {
        if ([tokenstr tokenstrfrom].length==0) {
            NSLog(@"请登陆");
            loginViewController *loginvc = [[loginViewController alloc] init];
            loginvc.jinru = @"jinru";
            [self presentViewController:loginvc animated:YES completion:nil];
        }
        else
        {
            //取消点赞
            self.nmodel.sifoudianzanstr = @"0";
            NSDictionary *reqdic = @{@"token":[tokenstr tokenstrfrom],@"object_id":self.nmodel.newidstr,@"status":@"0",@"type":@"1"};
            [AFManager postReqURL:qudianzan reqBody:reqdic block:^(id infor) {
                NSLog(@"infor-------%@",infor);
                NSString *code = [infor objectForKey:@"code"];
                if ([code intValue]==1) {
                    [MBProgressHUD showSuccess:@"取消点赞"];
                    NSLog(@"成功");
                    
                    self.nmodel = [[newModel alloc] init];
                    self.nmodel = self.dataarr[index.row];
                    NSDictionary *dic = [infor objectForKey:@"info"];
                    self.nmodel.dianzanstr = [dic objectForKey:@"spportNum"];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.newtable reloadData];
                    });
                }
                else if ([code intValue]==0)
                {
                    [MBProgressHUD showSuccess:@"token错误"];
                    NSLog(@"token错误");
                }
                else if ([code intValue]==4)
                {
                    [MBProgressHUD showSuccess:@"抱歉您的账户被暂时限制了，无法进行此操作"];
                    NSLog(@"抱歉您的账户被暂时限制了，无法进行此操作");
                }else if ([code intValue]==2100)
                {
                    [MBProgressHUD showSuccess:@"该牛评不存在或者被冻结"];
                    NSLog(@"该牛评不存在或者被冻结");
                }
                else
                {
                    [MBProgressHUD showSuccess:@"系统繁忙，请稍后再试"];
                    NSLog(@"系统繁忙，请稍后再试");
                }
            }];
        
            [self.newtable reloadData];
        }
    }
}

//回复

-(void)myTabVClick2:(UITableViewCell *)cell
{
    NSIndexPath *index = [self.newtable indexPathForCell:cell];
    NSLog(@"333===%ld   回复",index.row);
    self.nmodel = [[newModel alloc] init];
    self.nmodel = self.dataarr[index.row];
    NSString *str = self.nmodel.newidstr;
    NSLog(@"str======%@",str);
    detailsViewController *detailsvc = [[detailsViewController alloc] init];
    detailsvc.detalisidstr = str;
    [self.navigationController pushViewController:detailsvc animated:YES];
    
}

//跳转网页
-(void)myTabVClick3:(UITableViewCell *)cell
{
    NSIndexPath *index = [self.newtable indexPathForCell:cell];
    NSLog(@"333===%ld   跳转网页",index.row);
    self.nmodel = [[newModel alloc] init];
    self.nmodel = self.dataarr[index.row];
    NSString *urlstr = self.nmodel.weburlstr;
    NSLog(@"urlstr------%@",urlstr);
    SureWebViewController *surevc = [[SureWebViewController alloc]init];
    surevc.url = urlstr;
    surevc.canDownRefresh = YES;
    [self.navigationController pushViewController:surevc animated:YES];
}

#pragma mark - 加载失败

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    if ([_panduan404str isEqualToString:@"1"]) {
        return [UIImage imageNamed:@"加载失败"];
    }else
    {
        return [UIImage imageNamed:@"空的"];
    }
    return nil;
}

//- (UIImage *)buttonImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state{
//    return [UIImage imageNamed:@"加载按钮"];
//}



- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button
{
    NSLog(@"重新加载");
    [self addHeader];
}
- (void)emptyDataSetDidTapButton:(UIScrollView *)scrollView{
    // Do something
    
}
    
@end
