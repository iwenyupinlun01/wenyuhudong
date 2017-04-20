//
//  systemViewController.m
//  Supercomments
//
//  Created by 王俊钢 on 2017/4/6.
//  Copyright © 2017年 wangjungang. All rights reserved.
//

#import "systemViewController.h"
#import "systemCell.h"
#import "UIColor+BgColor.h"
@interface systemViewController ()<UITableViewDataSource,UITableViewDelegate,SWTableViewCellDelegate>
@property (nonatomic,strong) UITableView *systemtableview;
@property (nonatomic,strong)NSMutableArray *dataSource;
@end
static NSString * const kShowTextCellReuseIdentifier = @"QSShowTextCell";
@implementation systemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor wjColorFloat:@"333333"];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    self.title = @"系统通知";
//    self.messagetable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
//    [self.view addSubview:self.messagetable];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor wjColorFloat:@"333333"]}];

    self.navigationController.navigationBar.barTintColor = [UIColor wjColorFloat:@"F5F5F5"];
    
    self.dataSource = [[NSMutableArray alloc]initWithObjects:
                       @"1)我是一只小小小鸟,2)我是一只小小小鸟",
                       @"1)我是一只小小小鸟,2)我是一只小小小鸟,3)我是一只小小小鸟,4)我是一只小小小鸟,5)我是一只小小小鸟,6)我是一只小小小鸟。",
                       @"1)我是一只小小小鸟,2)我是一只小小小鸟,3)我是一只小小小鸟,4)我是一只小小小鸟,5)我是一只小小小鸟,6)我是一只小小小鸟,7)我是一只小小小鸟,8)我是一只小小小鸟,9)我是一只小小小鸟。",
                       @"1)我是一只小小小鸟,2)我是一只小小小鸟,3)我是一只小小小鸟,4)我是一只小小小鸟,5)我是一只小小小鸟,6)我是一只小小小鸟,7)我是一只小小小鸟,8)我是一只小小小鸟,9)我是一只小小小鸟。10)我是一只小小小鸟,11)我是一只小小小鸟,12)我是一只小小小鸟。",nil];
    
    [self.view addSubview:self.systemtableview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated{
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
   
    self.systemtableview.frame = CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT-64);

}

-(void)viewWillDisappear:(BOOL)animated

{
    
    [super viewWillDisappear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
}
#pragma mark - getters

-(UITableView *)systemtableview
{
    if(!_systemtableview)
    {
        _systemtableview = [[UITableView alloc]init];
        _systemtableview.dataSource = self;
        _systemtableview.delegate = self;
        _systemtableview.backgroundColor = [UIColor clearColor];
    }
    return _systemtableview;
}

#pragma mark -UITableViewDataSource&&UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [systemCell cellHeightWithText:[self p_textAtIndexPath:indexPath]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.dataSource count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return 0.01f;
    }
    return 10.00f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    systemCell *cell = [tableView dequeueReusableCellWithIdentifier:kShowTextCellReuseIdentifier];
    if (!cell) {
        
        cell = [[systemCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kShowTextCellReuseIdentifier];
        cell.rightUtilityButtons = [self rightButtons];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell layoutSubviewsWithText:[self p_textAtIndexPath:indexPath]];
    return cell;
}

- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]
                                                title:@"More"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:@"Delete"];
    return rightUtilityButtons;
}

- (NSArray *)leftButtons
{
    NSMutableArray *leftUtilityButtons = [NSMutableArray new];
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.07 green:0.75f blue:0.16f alpha:1.0]
                                                icon:[UIImage imageNamed:@"check.png"]];
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:1.0f blue:0.35f alpha:1.0]
                                                icon:[UIImage imageNamed:@"clock.png"]];
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188f alpha:1.0]
                                                icon:[UIImage imageNamed:@"cross.png"]];
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.55f green:0.27f blue:0.07f alpha:1.0]
                                                icon:[UIImage imageNamed:@"list.png"]];
    return leftUtilityButtons;
}


#pragma mark - SWTableViewDelegate

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
            NSLog(@"check button was pressed");
            break;
        case 1:
            NSLog(@"clock button was pressed");
            break;
        case 2:
            NSLog(@"cross button was pressed");
            break;
        case 3:
            NSLog(@"list button was pressed");
        default:
            break;
    }
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0:{
            NSLog(@"More button was pressed");
            UIAlertView *alertTest = [[UIAlertView alloc] initWithTitle:@"Hello" message:@"More more more" delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles: nil];
            [alertTest show];
            
            [cell hideUtilityButtonsAnimated:YES];
        }
            break;
        case 1:
        {
            // Delete button was pressed
            NSIndexPath *cellIndexPath = [self.systemtableview indexPathForCell:cell];
            [self p_removeTextAtIndexPath:cellIndexPath];
            [self.systemtableview deleteRowsAtIndexPaths:@[cellIndexPath]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
            
            
            break;
        }
        default:
            break;
    }
}

- (NSString *)p_textAtIndexPath:(NSIndexPath *)indexPath{
    
    return [self.dataSource objectAtIndex:indexPath.row];
}

- (void)p_removeTextAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"row = %ld,section = %ld",indexPath.row,indexPath.section);
    [self.dataSource removeObjectAtIndex:indexPath.row];
}

#pragma mark - 实现方法

-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
