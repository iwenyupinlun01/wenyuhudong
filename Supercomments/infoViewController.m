//
//  infoViewController.m
//  Supercomments
//
//  Created by 王俊钢 on 2017/4/5.
//  Copyright © 2017年 wangjungang. All rights reserved.
//

#import "infoViewController.h"
#import "infoCell.h"
#import "headView.h"
#import "messageViewController.h"
#import "feedbackViewController.h"
#import "setViewController.h"
#import "myinfoViewController.h"




@interface infoViewController ()<UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate>
@property (nonatomic,strong) UITableView *infotableview;
@property (nonatomic,strong) NSArray *imgarr;
@property (nonatomic,strong) NSArray *textarr;
@property (nonatomic,strong) headView *headview;
@property (nonatomic,strong) infoCell *cell;
@property (nonatomic, assign) UIEdgeInsets insets;
@end
static NSString *infocellidentfid = @"infocellidentfid";

@implementation infoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor wjColorFloat:@"333333"];
    self.title = @"个人中心";
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor wjColorFloat:@"333333"]}];
    
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.infotableview.tableFooterView = [UIView new];
    [self loaddatafromweb];
    self.insets = UIEdgeInsetsMake(0, 64, 0, 14);
    [self.view addSubview:self.infotableview];
}
-(void)viewWillAppear:(BOOL)animated{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
  
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self loaddatafromweb];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loaddatafromweb
{
    NSString *path = [tokenstr userimgstrfrom];
    NSLog(@"path-%@",path);
    [_headview.infoimg sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"头像默认图"]];
    _headview.namelab.text = [tokenstr nicknamestrfrom];
    if ([tokenstr tokenstrfrom].length==0) {
        
    }else
    {

        [CLNetworkingManager getNetworkRequestWithUrlString:[NSString stringWithFormat:tongzhixianxishuliang,[tokenstr tokenstrfrom]] parameters:nil isCache:YES succeed:^(id data) {
            NSLog(@"info---------%@",data);
            NSString *inforstr = [[NSString alloc] init];
            NSString *system_inform = [[NSString alloc] init];
            if ([[data objectForKey:@"code"] intValue]==1) {
                
                if ([[data objectForKey:@"info"] isKindOfClass:[NSDictionary class]]) {
                    NSLog(@"属于字典类型");
                    NSDictionary *dic = [data objectForKey:@"info"];
                    inforstr = [dic objectForKey:@"inform"];
                    system_inform = [dic objectForKey:@"system_inform"];
                }else
                {
                    
                    NSLog(@"不属于字典类型");
                    
                }
            }
            
            UILabel *namelab = [self.infotableview viewWithTag:100];
            if ([inforstr isEqualToString:@"0"]&&[system_inform isEqualToString:@"0"]) {
                
                namelab.alpha = 0;
                NSString *textstr = [NSString stringWithFormat:@"%d",[inforstr intValue]+[system_inform intValue]];
                if ([textstr intValue]>99) {
                    namelab.text = @"99+";
                }else
                {
                    namelab.text = textstr;
                }
                _cell.numlab.text = textstr;
                [self.infotableview reloadData];
            }
            else
            {
                NSLog(@"提示操作");
                namelab.alpha = 1;
                NSString *textstr = [NSString stringWithFormat:@"%d",[inforstr intValue]+[system_inform intValue]];
                
                if ([textstr intValue]>99) {
                    namelab.text = @"99+";
                }else
                {
                    namelab.text = textstr;
                }
                // namelab.text = textstr;
                _cell.numlab.text = textstr;
                //[_cell addSubview:namelab];
                [self.infotableview reloadData];
            }
        } fail:^(NSError *error) {
            
        }];

        
        
    }
    
}
#pragma mark - getters

-(UITableView *)infotableview
{
    if(!_infotableview)
    {
        _infotableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT) style:UITableViewStylePlain];
        _infotableview.dataSource = self;
        _infotableview.delegate = self;
        _infotableview.tableHeaderView = self.headview;
        _infotableview.separatorColor = [UIColor wjColorFloat:@"F5F5F5"];
        _infotableview.backgroundColor = [UIColor whiteColor];
    }
    return _infotableview;
}

-(NSArray *)imgarr
{
    if(!_imgarr)
    {
        _imgarr = [[NSArray alloc] init];
        _imgarr = @[@"矩形-39",@"帮助与反馈",@"设置"];
    }
    return _imgarr;
}

-(NSArray *)textarr
{
    if(!_textarr)
    {
        _textarr = [[NSArray alloc] init];
        _textarr = @[@"消息通知",@"意见反馈",@"设置"];
    }
    return _textarr;
}

-(headView *)headview
{
    if(!_headview)
    {
        _headview = [[headView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 142)];
        _headview.backgroundColor = [UIColor wjColorFloat:@"F5F5F5"];
        _headview.infoimg.userInteractionEnabled = YES;//打开用户交互
        //初始化一个手势
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        //为图片添加手势
        [ _headview.infoimg addGestureRecognizer:singleTap];
    }
    return _headview;
}

#pragma mark -UITableViewDataSource&&UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    _cell = [tableView dequeueReusableCellWithIdentifier:infocellidentfid];
    if (!_cell) {
        _cell = [[infoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:infocellidentfid];
    }
    if (indexPath.row==0) {
        [_cell.contentView addSubview:_cell.numlab];
        _cell.numlab.tag = 100;
        _cell.leftimg.frame = CGRectMake(14*WIDTH_SCALE, 18*HEIGHT_SCALE, 20*WIDTH_SCALE, 22*WIDTH_SCALE);
        
    }
    if (indexPath.row==1) {
        _cell.leftimg.frame = CGRectMake(14*WIDTH_SCALE, 20*HEIGHT_SCALE, 21*WIDTH_SCALE, 21*WIDTH_SCALE);
    }
    if (indexPath.row==2) {
        _cell.leftimg.frame = CGRectMake(14*WIDTH_SCALE, 20*HEIGHT_SCALE, 21*WIDTH_SCALE, 21*WIDTH_SCALE);
    }
    //_cell.numlab.alpha = 0;
    [_cell setSeparatorInset:UIEdgeInsetsZero];
    _cell.leftimg.image = [UIImage imageNamed:self.imgarr[indexPath.row]];
    _cell.textlab.text = self.textarr[indexPath.row];
    //_cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    // _cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return _cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60*HEIGHT_SCALE;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        if ([tokenstr tokenstrfrom].length==0) {
            [MBProgressHUD showSuccess:@"请先登录"];
        }else
        {
            messageViewController *messagevc = [[messageViewController alloc] init];
            [self.navigationController pushViewController:messagevc animated:YES];
        }
    }
    if (indexPath.row==1) {
        if ([tokenstr tokenstrfrom].length==0) {
            [MBProgressHUD showSuccess:@"请先登录"];
        }else
        {
            feedbackViewController *feedbackvc = [[feedbackViewController alloc] init];
            [self.navigationController pushViewController:feedbackvc animated:YES];
        }
    }
    if (indexPath.row==2) {
        setViewController *setvc = [[setViewController alloc]init];
        [self.navigationController pushViewController:setvc animated:YES];
    }
}

#pragma mark - 实现方法

-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)gestureRecognizer {
    
    myinfoViewController *myinfovc = [[myinfoViewController alloc] init];
    [self.navigationController pushViewController:myinfovc animated:YES];
}
#pragma mark 用于将cell分割线补全
-(void)viewDidLayoutSubviews {
    if ([self.infotableview respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.infotableview setSeparatorInset:self.insets];
    }
    if ([self.infotableview respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.infotableview setLayoutMargins:self.insets];
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
