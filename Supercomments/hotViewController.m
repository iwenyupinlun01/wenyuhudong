//
//  hotViewController.m
//  Supercomments
//
//  Created by 王俊钢 on 2017/4/5.
//  Copyright © 2017年 wangjungang. All rights reserved.
//

#import "hotViewController.h"
#import "hotCell.h"
#import "detailsViewController.h"
#import "XWScanImage.h"
#import "hotModel.h"
#import "YYPhotoGroupView.h"
#import "SureWebViewController.h"
#import "loginViewController.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "UIImageView+RotateImgV.h"
@interface hotViewController ()<UITableViewDataSource,UITableViewDelegate,mycellVdelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
/** 用于加载下一页的参数(页码) */
{
    int pn;
}

@property (nonatomic,strong) UITableView *hottable;
@property (nonatomic,strong) UIImageView *demoimg;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) NSMutableArray *dataarr;
@property (nonatomic,strong) hotModel *hmodel;
@property (nonatomic,strong) NSMutableArray *imgarr;


@property (nonatomic, assign) UIEdgeInsets insets;

@property (nonatomic,strong) UIButton *xuanzuanbtn;
@end

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
    self.insets = UIEdgeInsetsMake(0, 14, 0, 14);
    [self.view addSubview:self.hottable];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(kvcdianzan:) name:@"shifoudiandankvo2" object:nil];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(kvcpinglun:) name:@"pinglunkvo2" object:nil];
    
    [self.view addSubview:self.xuanzuanbtn];
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
    

    
    NSString *strurl = [NSString stringWithFormat:newVCload,@"1",@"2",[tokenstr tokenstrfrom]];
    
    
    [CLNetworkingManager getNetworkRequestWithUrlString:strurl parameters:nil isCache:YES succeed:^(id data) {
        
        [self.dataSource removeAllObjects];
        [self.dataarr removeAllObjects];
        [self.imgarr removeAllObjects];
        
        NSLog(@"infor=====%@",data);
        NSLog(@"str====%@",strurl);
        NSArray *dit = [data objectForKey:@"info"];
        for (int i = 0; i<dit.count; i++) {
            NSDictionary *dicarr = [dit objectAtIndex:i];
            self.hmodel = [[hotModel alloc] init];
            self.hmodel.contentstr = dicarr[@"content"];
            self.hmodel.timestr = dicarr[@"create_time"];
            self.hmodel.imgurlstr = dicarr[@"images"];
            self.hmodel.namestr = dicarr[@"name"];
            self.hmodel.dianzanstr = dicarr[@"support_num"];
            self.hmodel.pinglunstr = dicarr[@"reply_num"];
            self.hmodel.newidstr = dicarr[@"id"];
            self.hmodel.titlestr = dicarr[@"title"];
            self.hmodel.fromstr =dicarr[@"support_count"];
            self.hmodel.typestr = dicarr[@"type"];
            self.hmodel.sifoudianzanstr = dicarr[@"is_support"];
            self.hmodel.weburlstr = dicarr[@"url"];
            self.hmodel.ishot = dicarr[@"is_hot"];
            self.hmodel.platformstr = dicarr[@"platform"];
            self.hmodel.small_imagesstrl = dicarr[@"small_images"];
            [self.dataSource addObject:self.hmodel.contentstr];
            [self.dataarr addObject:self.hmodel];
            [self.imgarr addObject:self.hmodel.imgurlstr];
        }
        [self.hottable.mj_header endRefreshing];
        [self.hottable reloadData];
        [self.xuanzuanbtn stopRotate];
    } fail:^(NSError *error) {
        [self.hottable.mj_header endRefreshing];
        // self.panduan404str = @"1";
        [MBProgressHUD showError:@"没有网络"];
        [self.xuanzuanbtn stopRotate];
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
            self.hmodel = [[hotModel alloc] init];
            self.hmodel.contentstr = dicarr[@"content"];
            self.hmodel.timestr = dicarr[@"create_time"];
            self.hmodel.imgurlstr = dicarr[@"images"];
            self.hmodel.namestr = dicarr[@"name"];
            self.hmodel.dianzanstr = dicarr[@"support_num"];
            self.hmodel.pinglunstr = dicarr[@"reply_num"];
            self.hmodel.newidstr = dicarr[@"id"];
            self.hmodel.titlestr = dicarr[@"title"];
            self.hmodel.fromstr =dicarr[@"support_count"];
            self.hmodel.typestr = dicarr[@"type"];
            self.hmodel.sifoudianzanstr = dicarr[@"is_support"];
            self.hmodel.weburlstr = dicarr[@"url"];
            self.hmodel.ishot = dicarr[@"is_hot"];
            self.hmodel.platformstr = dicarr[@"platform"];
            self.hmodel.small_imagesstrl = dicarr[@"small_images"];
            [self.dataSource addObject:self.hmodel.contentstr];
            [self.dataarr addObject:self.hmodel];
            [self.imgarr addObject:self.hmodel.imgurlstr];
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
        _hottable.separatorColor = [UIColor wjColorFloat:@"F5F5F5"];
    }
    return _hottable;
}
-(UIButton *)xuanzuanbtn
{
    if(!_xuanzuanbtn)
    {
        _xuanzuanbtn = [[UIButton alloc] init];
        _xuanzuanbtn.frame = CGRectMake(DEVICE_WIDTH-24*WIDTH_SCALE-32*WIDTH_SCALE, DEVICE_HEIGHT-64-32*WIDTH_SCALE-74*HEIGHT_SCALE, 44*WIDTH_SCALE, 44*WIDTH_SCALE);
        [_xuanzuanbtn setImage:[UIImage imageNamed:@"矩形-36"] forState:normal];
        [_xuanzuanbtn addTarget:self action:@selector(xuanzhuanbtnclick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _xuanzuanbtn;
}

#pragma mark - 回到顶部

-(void)xuanzhuanbtnclick
{
    [_hottable setContentOffset:CGPointMake(0,0) animated:NO];
    
    [CLNetworkingManager clearCaches];
    [self.xuanzuanbtn rotate360DegreeWithImageView];
    [self.hottable.mj_header beginRefreshing];
    
    [self.dataSource removeAllObjects];
    [self.dataarr removeAllObjects];
    [self.imgarr removeAllObjects];
   // [self.textheiarr removeAllObjects];
    NSString *strurl = [NSString stringWithFormat:newVCload,@"1",@"2",[tokenstr tokenstrfrom]];
    
    
    [AFManager getReqURL:strurl block:^(id infor) {
        NSLog(@"infor=====%@",infor);
        NSLog(@"str====%@",strurl);
        NSArray *dit = [infor objectForKey:@"info"];
        for (int i = 0; i<dit.count; i++) {
            NSDictionary *dicarr = [dit objectAtIndex:i];
            self.hmodel = [[hotModel alloc] init];
            self.hmodel.contentstr = dicarr[@"content"];
            self.hmodel.timestr = dicarr[@"create_time"];
            self.hmodel.imgurlstr = dicarr[@"images"];
            self.hmodel.namestr = dicarr[@"name"];
            self.hmodel.dianzanstr = [NSString stringWithFormat:@"%@",dicarr[@"support_num"]];
            self.hmodel.pinglunstr = dicarr[@"reply_num"];
            self.hmodel.newidstr = dicarr[@"id"];
            self.hmodel.titlestr = dicarr[@"title"];
            self.hmodel.fromstr =dicarr[@"support_count"];
            self.hmodel.typestr = dicarr[@"type"];
            self.hmodel.sifoudianzanstr = [NSString stringWithFormat:@"%@",dicarr[@"is_support"]];
            self.hmodel.weburlstr = dicarr[@"url"];
            self.hmodel.ishot = [NSString stringWithFormat:@"%@",dicarr[@"is_hot"]];
            self.hmodel.platformstr = dicarr[@"platform"];
            self.hmodel.small_imagesstrl = dicarr[@"small_images"];
            self.hmodel.textheightstr = @"";
            
            [self.dataSource addObject:self.hmodel.contentstr];
            [self.dataarr addObject:self.hmodel];
            [self.imgarr addObject:self.hmodel.imgurlstr];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.hottable.mj_header endRefreshing];
            [self.hottable reloadData];
            [self.xuanzuanbtn stopRotate];
        });
        
    } errorblock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.hottable.mj_header endRefreshing];
            [self.xuanzuanbtn stopRotate];
            [MBProgressHUD showError:@"没有网络"];
            
        });
        
    }];
}

#pragma mark -UITableViewDataSource&&UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    hotModel *homeModel=self.dataarr[indexPath.row];
    return homeModel.cellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataarr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    hotCell *cell = [tableView dequeueReusableCellWithIdentifier:hotidentfid];
    cell = [[hotCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:hotidentfid];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    NSString *numstr = [NSString stringWithFormat:@"%lu",(unsigned long)self.dataarr.count];
    if (![strisNull isNullToString:numstr]) {
        [cell setcelldata:self.dataarr[indexPath.row]];
    }
    //[cell setcelldata:self.dataarr[indexPath.row]];
    
    return cell;
}

- (NSString *)p_textAtIndexPath:(NSIndexPath *)indexPath{
    
    return [self.dataSource objectAtIndex:indexPath.row];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.hmodel = [[hotModel alloc] init];
    self.hmodel = self.dataarr[indexPath.row];
    NSString *str = self.hmodel.newidstr;
    NSLog(@"str======%@",str);
    detailsViewController *detailsvc = [[detailsViewController alloc] init];
    detailsvc.detalisidstr = str;
    detailsvc.fromtypestr = @"hotvc";
    detailsvc.dianzanindex = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    [self.navigationController pushViewController:detailsvc animated:YES];
}

//点赞
-(void)myTabVClick1:(UITableViewCell *)cell
{
    NSIndexPath *index = [self.hottable indexPathForCell:cell];
    NSLog(@"333===%ld   点赞",index.row);
    self.hmodel = [[hotModel alloc] init];
    self.hmodel = self.dataarr[index.row];
    NSString *dianzanstr = self.hmodel.sifoudianzanstr;
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
            NSDictionary *reqdic = @{@"token":[tokenstr tokenstrfrom],@"object_id":self.hmodel.newidstr,@"status":@"1",@"type":@"1"};
            
            [CLNetworkingManager postNetworkRequestWithUrlString:qudianzan parameters:reqdic isCache:NO succeed:^(id data) {
                NSLog(@"infor-------%@",data);
                NSString *code = [data objectForKey:@"code"];
                if ([code intValue]==1) {
                    self.hmodel.sifoudianzanstr = @"1";
                    [MBProgressHUD showSuccess:@"点赞+1"];
                    NSLog(@"成功");
                    self.hmodel = [[hotModel alloc] init];
                    self.hmodel = self.dataarr[index.row];
                    NSDictionary *dic = [data objectForKey:@"info"];
                    self.hmodel.dianzanstr = [dic objectForKey:@"spportNum"];
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

            } fail:^(NSError *error) {
                [MBProgressHUD showSuccess:@"没有网络"];
            }];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.hottable reloadData];
            });
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
            self.hmodel.sifoudianzanstr = @"0";
            NSDictionary *reqdic = @{@"token":[tokenstr tokenstrfrom],@"object_id":self.hmodel.newidstr,@"status":@"0",@"type":@"1"};
            [CLNetworkingManager postNetworkRequestWithUrlString:qudianzan parameters:reqdic isCache:NO succeed:^(id data) {
                NSLog(@"infor-------%@",data);
                NSString *code = [data objectForKey:@"code"];
                if ([code intValue]==1) {
                    [MBProgressHUD showSuccess:@"取消点赞"];
                    NSLog(@"成功");
                    self.hmodel = [[hotModel alloc] init];
                    self.hmodel = self.dataarr[index.row];
                    NSDictionary *dic = [data objectForKey:@"info"];
                    self.hmodel.dianzanstr = [dic objectForKey:@"spportNum"];
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
            } fail:^(NSError *error) {
                [MBProgressHUD showSuccess:@"没有网络"];
            }];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.hottable reloadData];
            });
            
        }
    }
}

//回复

-(void)myTabVClick2:(UITableViewCell *)cell
{
    NSIndexPath *index = [self.hottable indexPathForCell:cell];
    NSLog(@"333===%ld   回复",index.row);
    self.hmodel = [[hotModel alloc] init];
    self.hmodel = self.dataarr[index.row];
    NSString *str = self.hmodel.newidstr;
    NSLog(@"str======%@",str);
    detailsViewController *detailsvc = [[detailsViewController alloc] init];
    detailsvc.detalisidstr = str;
    detailsvc.fromtypestr = @"hotvc";
    [self.navigationController pushViewController:detailsvc animated:YES];
    
}

//跳转网页

-(void)myTabVClick3:(UITableViewCell *)cell
{
    NSIndexPath *index = [self.hottable indexPathForCell:cell];
    NSLog(@"333===%ld   跳转网页",index.row);
    self.hmodel = [[hotModel alloc] init];
    self.hmodel = self.dataarr[index.row];
    NSString *urlstr = self.hmodel.weburlstr;
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
    NSLog(@"dianzanstr---------%@",dic);
    NSInteger index = [[dic objectForKey:@"dianzanindex"] intValue];
    if (self.dataarr.count==0) {
        self.hmodel = [[hotModel alloc] init];
        self.hmodel.sifoudianzanstr = [dic objectForKey:@"diansanstr"];
        self.hmodel.dianzanstr = [dic objectForKey:@"dianzannum"];
        [self.dataarr addObject:self.hmodel];
    }else
    {
        self.hmodel = self.dataarr[index];
        self.hmodel.sifoudianzanstr = [dic objectForKey:@"diansanstr"];
        self.hmodel.dianzanstr = [dic objectForKey:@"dianzannum"];
        [self.dataarr replaceObjectAtIndex:index withObject:self.hmodel];
    }

    [self.hottable reloadData];
}

-(void)kvcpinglun:(NSNotification *)notifocation
{
    NSDictionary *dic = [notifocation object];
    NSLog(@"dianzanstr---------%@",dic);
    NSInteger index = [[dic objectForKey:@"dianzanindex"] intValue];
    self.hmodel = self.dataarr[index];
    self.hmodel.pinglunstr = [dic objectForKey:@"pinglunstr"];
    [self.hottable reloadData];
    
}

- (void)dealloc{
    //[super dealloc];
    // 移除当前对象监听的事件
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

#pragma mark - 加载失败

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"加载失败-1"];
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view
{
    [self addHeader];
}

#pragma mark 用于将cell分割线补全
-(void)viewDidLayoutSubviews {
    if ([self.hottable respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.hottable setSeparatorInset:self.insets];
    }
    if ([self.hottable respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.hottable setLayoutMargins:self.insets];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:self.insets];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:self.insets];
    }
}


@end
