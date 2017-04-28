//
//  setViewController.m
//  Supercomments
//
//  Created by 王俊钢 on 2017/4/6.
//  Copyright © 2017年 wangjungang. All rights reserved.
//

#import "setViewController.h"
#import "setCell.h"
#import "aboutViewController.h"
#import "SZKCleanCache.h"
#import "loginViewController.h"
#import "homeViewController.h"
@interface setViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *settableview;
@property (nonatomic,strong) UIButton *gobackbtn;
@end
static NSString *setidentfid0 = @"setidentfid0";
static NSString *setidentfid1 = @"setidentfid1";
@implementation setViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor wjColorFloat:@"333333"];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    self.title = @"设置";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor wjColorFloat:@"333333"]}];
    self.navigationController.navigationBar.barTintColor = [UIColor wjColorFloat:@"F5F5F5"];
    self.settableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.settableview];
    [self.view addSubview:self.gobackbtn];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated{
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.gobackbtn.frame = CGRectMake(30*WIDTH_SCALE, DEVICE_HEIGHT/2-20*HEIGHT_SCALE, DEVICE_WIDTH-60*WIDTH_SCALE, 40*HEIGHT_SCALE);
}

-(void)viewWillDisappear:(BOOL)animated

{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

#pragma mark - getters

-(UITableView *)settableview
{
    if(!_settableview)
    {
        _settableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT-64)];
        _settableview.scrollEnabled = NO;
        _settableview.dataSource = self;
        _settableview.delegate = self;
        
    }
    return _settableview;
}

-(UIButton *)gobackbtn
{
    if(!_gobackbtn)
    {
        _gobackbtn = [[UIButton alloc] init];
        [_gobackbtn setTitle:@"退出当前帐号" forState:normal];
        [_gobackbtn addTarget:self action:@selector(gobackbtnclick) forControlEvents:UIControlEventTouchUpInside];
        _gobackbtn.backgroundColor = [UIColor wjColorFloat:@"DA3850"];
        [_gobackbtn setTitleColor:[UIColor wjColorFloat:@"FFFFFF"] forState:normal];
        _gobackbtn.layer.masksToBounds = YES;
        _gobackbtn.layer.cornerRadius = 20*HEIGHT_SCALE;
    }
    return _gobackbtn;
}


#pragma mark -UITableViewDataSource&&UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        setCell *cell = [tableView dequeueReusableCellWithIdentifier:setidentfid0];
        if (!cell) {
            cell = [[setCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:setidentfid0];
        }
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setSeparatorInset:UIEdgeInsetsZero];
        cell.textLabel.text = @"清理缓存";
        cell.textLabel.textColor = [UIColor wjColorFloat:@"333333"];
        NSString *str = [NSString stringWithFormat:@"%.2fM",[SZKCleanCache folderSizeAtPath]];
        cell.rightlab.text = str;
        return cell;
    }
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:setidentfid1];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:setidentfid1];
        }
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setSeparatorInset:UIEdgeInsetsZero];
        cell.backgroundColor = [UIColor wjColorFloat:@"FEFFFF"];
        if (indexPath.row==1) {
            cell.textLabel.text = @"去评分";
            cell.textLabel.textColor = [UIColor wjColorFloat:@"333333"];
        }
        if (indexPath.row==2) {
            cell.textLabel.text = @"关于";
            cell.textLabel.textColor = [UIColor wjColorFloat:@"333333"];
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60*HEIGHT_SCALE;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        //输出缓存大小 m
        NSLog(@"%.2fM",[SZKCleanCache folderSizeAtPath]);
        
        //清楚缓存
        [SZKCleanCache cleanCache:^{
            NSLog(@"清除成功");
            [self.settableview reloadData];
        }];
    }
    if (indexPath.row==1) {
                
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/1227372692"] options:@{} completionHandler:nil];
    }
    if (indexPath.row==2) {
        aboutViewController *aboutvc = [[aboutViewController alloc] init];
        [self.navigationController pushViewController:aboutvc animated:YES];
    }
}
#pragma mark - 实现方法

-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)gobackbtnclick
{
    NSLog(@"退出当前帐号");
    
    UIAlertController *control = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要退出登录吗" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action0 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        homeViewController *viewCtl = self.navigationController.viewControllers[0];
        
        [self.navigationController popToViewController:viewCtl animated:YES];

    }];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [CLNetworkingManager postNetworkRequestWithUrlString:tuichudenglu parameters:@{@"token":[tokenstr tokenstrfrom]} isCache:YES succeed:^(id data) {
            NSLog(@"data===%@",data);
            if ([[data objectForKey:@"code"] intValue]==1) {
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults removeObjectForKey:@"tokenuser"];
                [defaults removeObjectForKey:@"access_token"];
                [defaults removeObjectForKey:@"namestr"];
                [defaults removeObjectForKey:@"pathurlstr"];
            }
            else if([[data objectForKey:@"code"] intValue]==-2)
            {
                [MBProgressHUD showSuccess:@"必需要登陆才能操作"];
            }
            else if([[data objectForKey:@"code"] intValue]==0)
            {
                [MBProgressHUD showSuccess:@"token错误"];
            }else
            {
                [MBProgressHUD showSuccess:@"系统繁忙，请您稍后重试"];

            }
            
        } fail:^(NSError *error) {
            
        }];
        loginViewController *logvc = [[loginViewController alloc] init];
        [self presentViewController:logvc animated:YES completion:nil];
    }];
    [control addAction:action0];
    [control addAction:action1];
    [self presentViewController:control animated:YES completion:nil];
    
    
}
@end
