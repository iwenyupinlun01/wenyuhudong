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
#import "setCell2.h"

@implementation UIImage (ColorImage)

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end


@interface setViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *settableview;
@property (nonatomic,strong) UIButton *gobackbtn;
@end
static NSString *setidentfid0 = @"setidentfid0";
static NSString *setidentfid1 = @"setidentfid1";
static NSString *setidentfid2 = @"setidentfid2";
static NSString *setidentfid3 = @"setidentfid3";

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
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.settableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.settableview];
    
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    [navigationBar setBackgroundImage:[[UIImage alloc] init]
                       forBarPosition:UIBarPositionAny
                           barMetrics:UIBarMetricsDefault];
    //此处使底部线条颜色为F5F5F5
    [navigationBar setShadowImage:[UIImage imageWithColor:[UIColor wjColorFloat:@"F5F5F5"]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
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
        _settableview.dataSource = self;
        _settableview.delegate = self;
        [_settableview setSeparatorColor:[UIColor wjColorFloat:@"F5F5F5"]];
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
    return 4;
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
    else if (indexPath.row==1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:setidentfid1];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:setidentfid1];
        }
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setSeparatorInset:UIEdgeInsetsZero];
        cell.backgroundColor = [UIColor wjColorFloat:@"FEFFFF"];
        cell.textLabel.text = @"去评分";
        cell.textLabel.textColor = [UIColor wjColorFloat:@"333333"];
        return cell;
    }
    else if (indexPath.row==2) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:setidentfid2];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:setidentfid2];
        }
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setSeparatorInset:UIEdgeInsetsZero];
        cell.backgroundColor = [UIColor wjColorFloat:@"FEFFFF"];
        cell.textLabel.text = @"关于";
        cell.textLabel.textColor = [UIColor wjColorFloat:@"333333"];
        return cell;
    }
    else {
        setCell2 *cell = [tableView dequeueReusableCellWithIdentifier:setidentfid3];
        cell = [[setCell2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:setidentfid3];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setSeparatorInset:UIEdgeInsetsZero];
        [cell.gobackbtn addTarget:self action:@selector(gobackbtnclick) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        return 60*HEIGHT_SCALE;
    }
    if (indexPath.row==1) {
        return 60*HEIGHT_SCALE;
    }
    if (indexPath.row==2) {
        return 60*HEIGHT_SCALE;
    }
    if (indexPath.row==3) {
        return 160*HEIGHT_SCALE;
    }
    return 0;
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
                
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id1227372692"] options:@{} completionHandler:nil];
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
        
       
    }];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [CLNetworkingManager postNetworkRequestWithUrlString:tuichudenglu parameters:@{@"token":[tokenstr tokenstrfrom]} isCache:NO succeed:^(id data) {
            NSLog(@"data===%@",data);
            if ([[data objectForKey:@"code"] intValue]==1) {
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults removeObjectForKey:@"tokenuser"];
                [defaults removeObjectForKey:@"access_token"];
                [defaults removeObjectForKey:@"namestr"];
                [defaults removeObjectForKey:@"pathurlstr"];
                
                [MBProgressHUD showSuccess:@"退出成功"];
                homeViewController *viewCtl = self.navigationController.viewControllers[0];
                [self.navigationController popToViewController:viewCtl animated:YES];
                
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
    }];
    [control addAction:action0];
    [control addAction:action1];
    [self presentViewController:control animated:YES completion:nil];
    
    
}
@end
