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
@interface replyViewController ()<UITableViewDelegate,UITableViewDataSource,myTabVdelegate>
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

    self.replyarr = [NSMutableArray array];
    
    [self datafromweb];
//    self.messagetable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
//    [self.view addSubview:self.messagetable];
    self.navigationController.navigationBar.barTintColor = [UIColor wjColorFloat:@"F5F5F5"];
    [self.view addSubview:self.replytable];
    
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
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

-(void)datafromweb
{
    
    for (int i = 0; i<10; i++) {
        self.rmodel = [[replyModel alloc] init];
        self.rmodel.replyurl = @"";
        self.rmodel.replyname = @"今日牛评";
        self.rmodel.replytext = @"赵客曼胡樱，吴钩霜雪明，银鞍照白马，飒沓如流星";
        self.rmodel.replyrighturl = @"";
        self.rmodel.replytimestr = @"12:30";
        
        [self.replyarr addObject:self.rmodel];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.replytable reloadData];
    });
}

#pragma mark - getters

-(UITableView *)replytable
{
    if(!_replytable)
    {
        _replytable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT-64)];
        _replytable.dataSource = self;
        _replytable.delegate = self;
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
    return 248/2*HEIGHT_SCALE;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

#pragma mark - 实现方法

-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)myTabVClick:(UITableViewCell *)cell
{
    NSIndexPath *index = [self.replytable indexPathForCell:cell];
    
    NSLog(@"333===%ld",index.row);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSLog(@"%ld",(long)indexPath.row);
}

@end
