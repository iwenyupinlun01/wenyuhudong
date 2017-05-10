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
#import "UIImageView+RotateImgV.h"
#import "LGSegment.h"
#import "XSNoDataView.h"
#import "emptyerrorView.h"
@interface newViewController ()<UITableViewDataSource,UITableViewDelegate,mycellVdelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,myviewdelegate>
/** 用于加载下一页的参数(页码) */
{
    int pn;
    double angle;
}
@property (nonatomic,strong) UITableView *newtable;
@property (nonatomic,strong) UIImageView *demoimg;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) NSMutableArray *dataarr;
@property (nonatomic,strong) newModel *nmodel;
@property (nonatomic,strong) NSMutableArray *imgarr;
@property (nonatomic,strong) NSString *panduan404str;
@property (nonatomic, assign) UIEdgeInsets insets;
@property (nonatomic,strong) UIButton *xuanzuanbtn;

@property (nonatomic,strong) newCell *cell;
@property (nonatomic,strong) XSNoDataView *dataView;
@property (nonatomic,strong) emptyerrorView *bgview;

@property (nonatomic, strong) Reachability *conn;
@end

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


    // 3.1.下拉刷新
    [self addHeader];
    // 3.2.上拉加载更多
    [self addFooter];
    self.insets = UIEdgeInsetsMake(0, 14, 0, 14);
    [self.view addSubview:self.newtable];
    
    [self.view addSubview:self.xuanzuanbtn];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(kvcdianzan:) name:@"shifoudiandankvo" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(kvcpinglun:) name:@"pinglunkvo" object:nil];

//    [self checkNetworkStatus];
    
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
    
    NSString *strurl = [NSString stringWithFormat:newVCload,@"1",@"1",[tokenstr tokenstrfrom]];
    
    __block NSString *netstr ;
    dispatch_group_t dispatchGroup = dispatch_group_create();
    dispatch_group_enter(dispatchGroup);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"第一个请求完成");
        AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
        [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            switch (status) {
                    //没有检测到网络
                case AFNetworkReachabilityStatusNotReachable:
                    NSLog(@"没有完网络");
                    netstr = @"404";
                    if (self.dataarr.count==0) {
                        [self.view addSubview:self.bgview];
                    }
                    break;
                case AFNetworkReachabilityStatusReachableViaWWAN:
                    NSLog(@"3g网络");
                    netstr = @"3g";
                    [self.bgview removeFromSuperview];
                    break;
                case AFNetworkReachabilityStatusReachableViaWiFi:
                    NSLog(@"wifi");
                    netstr = @"wifi";
                    [self.bgview removeFromSuperview];
                    break;
                default:
                    break;
            }
        }];
        // 开始监测
        [manager startMonitoring];
        dispatch_group_leave(dispatchGroup);
    });
    
    dispatch_group_enter(dispatchGroup);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"第二个请求完成");
        
        [ZBNetworkManager requestWithConfig:^(ZBURLRequest *request) {
            request.urlString=strurl;
            if ([netstr isEqualToString:@"404"]) {
                request.apiType = ZBRequestTypeOffline;
                
            }else
            {
                request.apiType = ZBRequestTypeRefresh;
            }
        } success:^(id responseObj, apiType type) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"infor=====%@",dict);
            NSLog(@"str====%@",strurl);
            [self.dataSource removeAllObjects];
            [self.dataarr removeAllObjects];
            [self.imgarr removeAllObjects];
            NSArray *dit = [dict objectForKey:@"info"];
            for (int i = 0; i<dit.count; i++) {
                NSDictionary *dicarr = [dit objectAtIndex:i];
                self.nmodel = [[newModel alloc] init];
                self.nmodel.contentstr = dicarr[@"content"];
                self.nmodel.timestr = dicarr[@"create_time"];
                self.nmodel.imgurlstr = dicarr[@"images"];
                self.nmodel.namestr = dicarr[@"name"];
                self.nmodel.dianzanstr = [NSString stringWithFormat:@"%@",dicarr[@"support_num"]];
                self.nmodel.pinglunstr = dicarr[@"reply_num"];
                self.nmodel.newidstr = dicarr[@"id"];
                self.nmodel.titlestr = dicarr[@"title"];
                self.nmodel.fromstr =dicarr[@"support_count"];
                self.nmodel.typestr = dicarr[@"type"];
                self.nmodel.sifoudianzanstr = [NSString stringWithFormat:@"%@",dicarr[@"is_support"]];
                self.nmodel.weburlstr = dicarr[@"url"];
                self.nmodel.ishot = [NSString stringWithFormat:@"%@",dicarr[@"is_hot"]];
                self.nmodel.platformstr = dicarr[@"platform"];
                self.nmodel.small_imagesstrl = dicarr[@"small_images"];
                self.nmodel.textheightstr = @"";
                
                [self.dataSource addObject:self.nmodel.contentstr];
                [self.dataarr addObject:self.nmodel];
                [self.imgarr addObject:self.nmodel.imgurlstr];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.newtable.mj_header endRefreshing];
                [self.newtable reloadData];
                [self.xuanzuanbtn stopRotate];
            });
        } failed:^(NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.newtable.mj_header endRefreshing];
                [self.xuanzuanbtn stopRotate];
                [MBProgressHUD showError:@"没有网络"];
                
            });
            [self checkNetworkStatus];
            
        }];

        dispatch_group_leave(dispatchGroup);
    });
    
    dispatch_group_notify(dispatchGroup, dispatch_get_main_queue(), ^(){
        NSLog(@"请求完成");
    });
    
}

- (void)footerRefreshEndAction {
    pn ++;
    NSString *pnstr = [NSString stringWithFormat:@"%d",pn];
    NSString *strurl = [NSString stringWithFormat:newVCload,pnstr,@"1",[tokenstr tokenstrfrom]];
    
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
            self.nmodel.platformstr = dicarr[@"platform"];
            self.nmodel.small_imagesstrl = dicarr[@"small_images"];
            [self.dataSource addObject:self.nmodel.contentstr];
            [self.dataarr addObject:self.nmodel];
            [self.imgarr addObject:self.nmodel.imgurlstr];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.newtable.mj_footer endRefreshing];
            [self.newtable reloadData];

        });
        
        } fail:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.newtable.mj_footer endRefreshing];
            [MBProgressHUD showError:@"没有网络"];
        });

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
        _newtable.rowHeight = UITableViewAutomaticDimension;
        _newtable.separatorColor = [UIColor wjColorFloat:@"F5F5F5"];
        _newtable.estimatedRowHeight = 200;
    }
    return _newtable;
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
    dispatch_group_t dispatchGroup = dispatch_group_create();
    dispatch_group_enter(dispatchGroup);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"第一个请求完成");
         [_newtable setContentOffset:CGPointMake(0,0) animated:NO];
        //[self.newtable  scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
        dispatch_group_leave(dispatchGroup);
    });
    dispatch_group_enter(dispatchGroup);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"第二个请求完成");
        [self.xuanzuanbtn rotate360DegreeWithImageView];
        [self.newtable.mj_header beginRefreshing];
        dispatch_group_leave(dispatchGroup);
    });
}

#pragma mark -UITableViewDataSource&&UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    newModel *homeModel=self.dataarr[indexPath.row];
    return homeModel.cellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataarr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    newCell *cell = [tableView dequeueReusableCellWithIdentifier:newidentfid];
    cell = [[newCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:newidentfid];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    [cell setSeparatorInset:UIEdgeInsetsZero];
    
    NSString *numstr = [NSString stringWithFormat:@"%lu",(unsigned long)self.dataarr.count];
    if (![strisNull isNullToString:numstr]) {
        [cell setcelldata:self.dataarr[indexPath.row]];
    }
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
    detailsvc.fromtypestr = @"newvc";
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
            NSDictionary *reqdic = @{@"token":[tokenstr tokenstrfrom],@"object_id":self.nmodel.newidstr,@"status":@"1",@"type":@"1"};
            [CLNetworkingManager postNetworkRequestWithUrlString:qudianzan parameters:reqdic isCache:NO succeed:^(id data) {
                NSLog(@"infor-------%@",data);
                NSString *code = [data objectForKey:@"code"];
                if ([code intValue]==1) {
                    [MBProgressHUD showSuccess:@"点赞+1"];
                    self.nmodel.sifoudianzanstr = @"1";
                    NSLog(@"成功");
                    self.nmodel = [[newModel alloc] init];
                    self.nmodel = self.dataarr[index.row];
                    NSDictionary *dic = [data objectForKey:@"info"];
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
            } fail:^(NSError *error) {
                [MBProgressHUD showSuccess:@"没有网络"];
            }];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.newtable reloadData];
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
            NSDictionary *reqdic = @{@"token":[tokenstr tokenstrfrom],@"object_id":self.nmodel.newidstr,@"status":@"0",@"type":@"1"};
            [CLNetworkingManager postNetworkRequestWithUrlString:qudianzan parameters:reqdic isCache:NO succeed:^(id data) {
                NSLog(@"infor-------%@",data);
                NSString *code = [data objectForKey:@"code"];
                if ([code intValue]==1) {
                    self.nmodel.sifoudianzanstr = @"0";
                    [MBProgressHUD showSuccess:@"取消点赞"];
                    NSLog(@"成功");
                    self.nmodel = [[newModel alloc] init];
                    self.nmodel = self.dataarr[index.row];
                    NSDictionary *dic = [data objectForKey:@"info"];
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
            } fail:^(NSError *error) {
                [MBProgressHUD showSuccess:@"没有网络"];
            }];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.newtable reloadData];
            });
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
    detailsvc.fromtypestr = @"newvc";
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

#pragma mark - kvo

-(void)kvcdianzan:(NSNotification *)notifocation
{
    NSDictionary *dic = [notifocation object];
    //    NSString *dianzanstr = (NSString *)[notifocation object];
    NSLog(@"dianzanstr---------%@",dic);
    NSInteger index = [[dic objectForKey:@"dianzanindex"] intValue];
    if (self.dataarr.count==0) {
        self.nmodel = [[newModel alloc] init];
        self.nmodel.sifoudianzanstr = [dic objectForKey:@"diansanstr"];
        self.nmodel.dianzanstr = [dic objectForKey:@"dianzannum"];
        [self.dataarr addObject:self.nmodel];
    }else
    {
        self.nmodel = self.dataarr[index];
        self.nmodel.sifoudianzanstr = [dic objectForKey:@"diansanstr"];
        self.nmodel.dianzanstr = [dic objectForKey:@"dianzannum"];
        [self.dataarr replaceObjectAtIndex:index withObject:self.nmodel];
    }
    
    [self.newtable reloadData];
}

-(void)kvcpinglun:(NSNotification *)notifocation
{
    NSDictionary *dic = [notifocation object];
    NSLog(@"dianzanstr---------%@",dic);
    NSInteger index = [[dic objectForKey:@"dianzanindex"] intValue];
    self.nmodel = self.dataarr[index];
    self.nmodel.pinglunstr = [dic objectForKey:@"pinglunstr"];
    [self.newtable reloadData];
}

- (void)dealloc{
    //[super dealloc];
    // 移除当前对象监听的事件
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

#pragma mark - 加载失败
//
//- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
//    return [UIImage imageNamed:@"空的"];
//}
//
//- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view
//{
//    [self addHeader];
//}

#pragma mark 用于将cell分割线补全

-(void)viewDidLayoutSubviews {
    if ([self.newtable respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.newtable setSeparatorInset:self.insets];
    }
    if ([self.newtable respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.newtable setLayoutMargins:self.insets];
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

#pragma mark - 404页面

-(emptyerrorView *)bgview
{
    if(!_bgview)
    {
        _bgview = [[emptyerrorView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT-64)];
        _bgview.delegate = self;
        _bgview.backgroundColor = [UIColor whiteColor];
    }
    return _bgview;
}

-(void)myview:(UIView *)myview
{
    [self.bgview removeFromSuperview];
    [self.newtable.mj_header beginRefreshing];
}

//网络监测

- (void)checkNetworkStatus {
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
                //没有检测到网络
            case AFNetworkReachabilityStatusNotReachable:
                if (self.dataarr.count==0) {
                    [self.view addSubview:self.bgview];
                }
                break;
            default:
                break;
        }
    }];
    // 开始监测
    [manager startMonitoring];
}




@end

