//
//  messageViewController.m
//  Supercomments
//
//  Created by 王俊钢 on 2017/4/6.
//  Copyright © 2017年 wangjungang. All rights reserved.
//

#import "messageViewController.h"
#import "systemViewController.h"
#import "replyViewController.h"
@interface messageViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *messagetable;
@property (nonatomic,strong) NSArray *messagearr;

@property (nonatomic,strong) NSString *num01;
@property (nonatomic,strong) NSString *num02;
@end

static NSString *messageidentfid = @"messageidentfid";

@implementation messageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor wjColorFloat:@"333333"];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    self.title = @"消息通知";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor wjColorFloat:@"333333"]}];
    self.messagetable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self loaddatafromweb];
    [self.view addSubview:self.messagetable];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
}

-(void)viewWillDisappear:(BOOL)animated

{
    
    [super viewWillDisappear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
}

#pragma mark - 实现方法

-(void)loaddatafromweb
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
    
    [AFManager getReqURL:[NSString stringWithFormat:tongzhixianxishuliang,tokenstr] block:^(id infor) {
        NSLog(@"info---------%@",infor);
        if ([[infor objectForKey:@"code"] intValue]==1) {
            NSDictionary *dic = [infor objectForKey:@"info"];
            NSString *infor = [dic objectForKey:@"inform"];
            NSString *system_inform = [dic objectForKey:@"system_inform"];
            _num01 = infor;
            _num02 = system_inform;
        }
        
        NSLog(@"num01-------%@",_num02);
        [self.messagetable reloadData];
    } errorblock:^(NSError *error) {
        
    }];
}


#pragma mark - getters


-(NSArray *)messagearr
{
    if(!_messagearr)
    {
        _messagearr = [[NSArray alloc] init];
        _messagearr = @[@"回复",@"系统通知"];
    }
    return _messagearr;
}



-(UITableView *)messagetable
{
    if(!_messagetable)
    {
        _messagetable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT-64)];
        _messagetable.dataSource = self;
        _messagetable.delegate = self;
        _messagetable.scrollEnabled = NO;
        
    }
    return _messagetable;
}

#pragma mark -UITableViewDataSource&&UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:messageidentfid];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:messageidentfid];
    }
    UILabel *numlab = [[UILabel alloc] init];
    numlab.frame = CGRectMake(DEVICE_WIDTH-60, 20, 20, 20);
    numlab.backgroundColor = [UIColor redColor];
    numlab.textAlignment = NSTextAlignmentCenter;
    numlab.layer.masksToBounds = YES;
    numlab.layer.cornerRadius = 10;
    numlab.textColor = [UIColor whiteColor];
    
    if (indexPath.row==0) {
        numlab.text = _num01;
        if ([_num01 isEqualToString:@"0"]) {
            
        }else
        {
            [cell.contentView addSubview:numlab];
        }
    }
    if (indexPath.row==1) {
        numlab.text = _num02;
        if ([_num02 isEqualToString:@"0"]) {
            
        }else
        {
           [cell.contentView addSubview:numlab];
        }
    }
    
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.messagearr[indexPath.row];
    cell.textLabel.textColor = [UIColor wjColorFloat:@"333333"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60*HEIGHT_SCALE;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        replyViewController *replyvc = [[replyViewController alloc] init];
        [self.navigationController pushViewController:replyvc animated:YES];
    }
    if (indexPath.row==1) {
        systemViewController *systemvc = [[systemViewController alloc] init];
        [self.navigationController pushViewController:systemvc animated:YES];
    }
}
#pragma mark - 实现方法

-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}



@end
