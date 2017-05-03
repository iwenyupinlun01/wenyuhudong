//
//  hotViewController.m
//  Supercomments
//
//  Created by 王俊钢 on 2017/4/5.
//  Copyright © 2017年 wangjungang. All rights reserved.
//

#import "hotViewController.h"
#import "newCell.h"
#import "detailsViewController.h"
#import "XWScanImage.h"
#import "newModel.h"
#import "YYPhotoGroupView.h"
#import "SureWebViewController.h"
#import "loginViewController.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
@interface hotViewController ()<UITableViewDataSource,UITableViewDelegate,mycellVdelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
/** 用于加载下一页的参数(页码) */
{
    int pn;
}

@property (nonatomic,strong) UITableView *hottable;
@property (nonatomic,strong) UIImageView *demoimg;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) NSMutableArray *dataarr;
@property (nonatomic,strong) newModel *nmodel;
@property (nonatomic,strong) NSMutableArray *imgarr;
@property (strong, nonatomic) NSMutableArray<newModel *> * menus;

@end
static NSString *hotidentfid = @"hotidentfid";
@implementation hotViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.hottable.emptyDataSetSource = self;
    self.hottable.emptyDataSetDelegate = self;
    // 删除单元格分隔线的一个小技巧
    self.hottable.tableFooterView = [UIView new];
    pn=1;
    self.dataSource = [NSMutableArray array];
    self.dataarr = [NSMutableArray array];
    self.imgarr = [NSMutableArray array];
    // 3.1.下拉刷新
    [self addHeader];
    // 3.2.上拉加载更多
    [self addFooter];
    [self.view addSubview:self.hottable];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(kvcdianzan:) name:@"shifoudiandankvo" object:nil];
}

#pragma mark - 刷新控件

- (void)addHeader
{
    // 头部刷新控件
    self.hottable.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshAction)];
    [self.hottable.mj_header beginRefreshing];
}

- (void)addFooter
{
    self.hottable.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshLoadMore)];
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
    
    NSString *strurl = [NSString stringWithFormat:newVCload,@"1",@"2",[tokenstr tokenstrfrom]];
    
    [CLNetworkingManager getNetworkRequestWithUrlString:strurl parameters:nil isCache:YES succeed:^(id data) {
        NSLog(@"infor=====%@",data);
        NSLog(@"str====%@",strurl);
        NSArray *dit = [data objectForKey:@"info"];
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
        [self.hottable.mj_header endRefreshing];
        [self.hottable reloadData];
    } fail:^(NSError *error) {
        [self.hottable.mj_header endRefreshing];
       // self.panduan404str = @"1";
        [MBProgressHUD showError:@"没有网络"];
    }];
    
}
- (void)footerRefreshEndAction {
    pn ++;
    NSString *pnstr = [NSString stringWithFormat:@"%d",pn];
    NSString *strurl = [NSString stringWithFormat:newVCload,pnstr,@"2",[tokenstr tokenstrfrom]];
    
    [CLNetworkingManager getNetworkRequestWithUrlString:strurl parameters:nil isCache:YES succeed:^(id data) {
        NSLog(@"infor=====%@",data);
        NSLog(@"str====%@",strurl);
        NSArray *dit = [data objectForKey:@"info"];
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
        [self.hottable.mj_footer endRefreshing];
        [self.hottable reloadData];
    } fail:^(NSError *error) {
        [self.hottable.mj_footer endRefreshing];
       // self.panduan404str = @"1";
        [MBProgressHUD showError:@"没有网络"];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.hottable.frame = CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT-64);
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

-(UITableView *)hottable
{
    if(!_hottable)
    {
        _hottable = [[UITableView alloc] init];
        _hottable.dataSource = self;
        _hottable.delegate = self;
    }
    return _hottable;
}

#pragma mark -UITableViewDataSource&&UITableViewDelegate


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *imgstr = [NSString stringWithFormat:@"%@",self.imgarr[indexPath.row]];
    NSString *contaststr = [NSString stringWithFormat:@"%@",self.dataSource[indexPath.row]];
    
    if (imgstr.length==0) {
        return [newCell cellHeightWithText:self.dataSource[indexPath.row]]+(16+16+4+20+16+16+8+16)*HEIGHT_SCALE;
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
    newCell *cell = [tableView dequeueReusableCellWithIdentifier:hotidentfid];
    //    if (!cell) {
    cell = [[newCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:hotidentfid];
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
    detailsvc.dianzanindex = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    [self.navigationController pushViewController:detailsvc animated:YES];
    
}

//点赞
-(void)myTabVClick1:(UITableViewCell *)cell
{
    NSIndexPath *index = [self.hottable indexPathForCell:cell];
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
                        [self.hottable reloadData];
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
            
            [self.hottable reloadData];
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
                        [self.hottable reloadData];
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
            
            [self.hottable reloadData];
        }
    }
}

//回复

-(void)myTabVClick2:(UITableViewCell *)cell
{
    NSIndexPath *index = [self.hottable indexPathForCell:cell];
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
    NSIndexPath *index = [self.hottable indexPathForCell:cell];
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

#pragma mark - kvo

-(void)kvcdianzan:(NSNotification *)notifocation
{
    NSDictionary *dic = [notifocation object];
    //NSString *dianzanstr = (NSString *)[notifocation object];
    NSLog(@"dianzanstr---------%@",dic);
    NSInteger index = [[dic objectForKey:@"dianzanindex"] intValue];
    self.nmodel = self.dataarr[index];
    self.nmodel.sifoudianzanstr = [dic objectForKey:@"diansanstr"];
    [self.dataarr replaceObjectAtIndex:index withObject:self.nmodel];
    [self.hottable reloadData];
}

- (void)dealloc{
    //[super dealloc];
    // 移除当前对象监听的事件
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}


#pragma mark - 加载失败

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"空的"];
}
- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view
{
    [self addHeader];
}

@end
