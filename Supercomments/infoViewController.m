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

@interface infoViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *infotableview;
@property (nonatomic,strong) NSArray *imgarr;
@property (nonatomic,strong) NSArray *textarr;
@property (nonatomic,strong) headView *headview;

@property (nonatomic,strong) infoCell *cell;
@end
static NSString *infocellidentfid = @"infocellidentfid";

@implementation infoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor wjColorFloat:@"333333"];
    self.title = @"个人";
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor wjColorFloat:@"333333"]}];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.view addSubview:self.infotableview];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.navigationController.navigationBar.barTintColor = [UIColor wjColorFloat:@"F5F5F5"];
    [self loaddatafromweb];
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

-(void)loaddatafromweb
{
    if ([tokenstr tokenstrfrom].length==0) {
        
    }else
    {
        [AFManager getReqURL:[NSString stringWithFormat:tongzhixianxishuliang,[tokenstr tokenstrfrom]] block:^(id infor) {
            NSLog(@"info---------%@",infor);
            NSString *inforstr = [[NSString alloc] init];
            NSString *system_inform = [[NSString alloc] init];
            if ([[infor objectForKey:@"code"] intValue]==1) {
                NSDictionary *dic = [infor objectForKey:@"info"];
                inforstr = [dic objectForKey:@"inform"];
                system_inform = [dic objectForKey:@"system_inform"];
            }
            
            UILabel *namelab = [self.infotableview viewWithTag:100];
            if ([inforstr isEqualToString:@"0"]&&[system_inform isEqualToString:@"0"]) {
                
                namelab.alpha = 0;
                NSString *textstr = [NSString stringWithFormat:@"%d",[inforstr intValue]+[system_inform intValue]];
                namelab.text = textstr;
                
                [self.infotableview reloadData];
            }
            else
            {
                NSLog(@"提示操作");
                namelab.alpha = 1;
                NSString *textstr = [NSString stringWithFormat:@"%d",[inforstr intValue]+[system_inform intValue]];
                namelab.text = textstr;
                _cell.numlab.text = textstr;
                //[_cell addSubview:namelab];
                [self.infotableview reloadData];
            }
            
        } errorblock:^(NSError *error) {
            
        }];

    }
    
}
#pragma mark - getters

-(UITableView *)infotableview
{
    if(!_infotableview)
    {
        _infotableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT) style:UITableViewStyleGrouped];
        _infotableview.dataSource = self;
        _infotableview.delegate = self;
        _infotableview.tableHeaderView = self.headview;
        //_infotableview.scrollEnabled = NO;
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
        _headview = [[headView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 140)];
        _headview.backgroundColor = [UIColor wjColorFloat:@"F5F5F5"];
        _headview.infoimg.userInteractionEnabled = YES;//打开用户交互
        //初始化一个手势
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        //为图片添加手势

        NSString *path = [tokenstr userimgstrfrom];
        NSLog(@"path-%@",path);
        [_headview.infoimg sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"头像默认图"]];
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
       
    }
    //_cell.numlab.alpha = 0;
    _cell.leftimg.image = [UIImage imageNamed:self.imgarr[indexPath.row]];
    _cell.textlab.text = self.textarr[indexPath.row];
    _cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    _cell.selectionStyle = UITableViewCellSelectionStyleNone;
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

@end
