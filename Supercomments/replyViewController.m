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
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
@interface replyViewController ()<UITableViewDelegate,UITableViewDataSource,myTabVdelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
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
    self.replytable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
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
    
    [AFManager getReqURL:[NSString stringWithFormat:xiaoxitongzhijk,@"d277155062b89da9c09c53f4975d9f6d",@"1"] block:^(id infor) {
        NSLog(@"infor------------%@",infor);
        if ([[infor objectForKey:@"code"] intValue]==1) {
            NSArray *ditarr = [infor objectForKey:@"info"];
            for (int i = 0; i<ditarr.count; i++) {
                NSDictionary *dit = [ditarr objectAtIndex:i];
                self.rmodel = [[replyModel alloc] init];
                self.rmodel.replyurl = dit[@"user_icon"];
                self.rmodel.replyname = dit[@"publisher_nickname"];
                self.rmodel.replytext = dit[@"comment_content"];
                self.rmodel.comment_img_type = dit[@"comment_img_type"];
                self.rmodel.comment_imgstr = dit[@"comment_img"];
                self.rmodel.replytimestr = dit[@"pubtime"];
                self.rmodel.obj_id = dit[@"object_id"];
                self.rmodel.is_checkstr = dit[@"is_check"];
                [self.replyarr addObject:self.rmodel];
            }
        }
        else if ([[infor objectForKey:@"code"] intValue]==2)
        {
            NSLog(@"没有查询到任何数据");
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.replytable reloadData];
        });
    } errorblock:^(NSError *error) {
        
    }];
    
}

#pragma mark - getters

-(UITableView *)replytable
{
    if(!_replytable)
    {
        _replytable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT-64)];
        _replytable.dataSource = self;
        _replytable.delegate = self;
        _replytable.emptyDataSetSource = self;
        _replytable.emptyDataSetDelegate = self;
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

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // 删除数据源的数据,self.cellData是你自己的数据
        [self.replyarr removeObjectAtIndex:indexPath.row];
         //删除列表中数据
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";//默认文字为 Delete
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

#pragma mark - 加载失败

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"加载失败"];
}
@end
