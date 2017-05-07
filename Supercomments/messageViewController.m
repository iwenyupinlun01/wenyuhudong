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
    
    [self.view addSubview:self.messagetable];
 
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
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self loaddatafromweb];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

#pragma mark - 实现方法

-(void)loaddatafromweb
{
  
    if ([tokenstr tokenstrfrom].length==0) {
        
    }else
    {
        [AFManager getReqURL:[NSString stringWithFormat:tongzhixianxishuliang,[tokenstr tokenstrfrom]] block:^(id infor) {
            NSLog(@"info---------%@",infor);
            if ([[infor objectForKey:@"code"] intValue]==1) {
                NSDictionary *dic = [infor objectForKey:@"info"];
                NSString *infor = [dic objectForKey:@"inform"];
                NSString *system_inform = [dic objectForKey:@"system_inform"];
                _num01 = infor;
                _num02 = system_inform;
            }
            
            NSLog(@"num01-------%@",_num02);
            UILabel *lab = [self.messagetable viewWithTag:201];
            UILabel *lab2 = [self.messagetable viewWithTag:202];
            if ([_num01 isEqualToString:@"0"]&&[_num02 isEqualToString:@"0"]) {
                lab.alpha = 0;
                lab2.alpha = 0;
                //两个都为0
            }
            else if ([_num01 isEqualToString:@"0"]&&![_num02 isEqualToString:@"0"])
            {
                lab.alpha = 0;
                lab2.alpha = 1;
                if ([_num02 intValue]>99) {
                    lab2.text = @"99+";
                }else
                {
                    lab2.text = _num02;
                }

            }
            else if (![_num01 isEqualToString:@"0"]&&[_num02 isEqualToString:@"0"])
            {
                lab.alpha = 1;
                lab2.alpha = 0;
                if ([_num01 intValue]>99) {
                    lab.text = @"99+";
                }else
                {
                    lab.text = _num01;
                }
                //lab.text = _num01;
            }
            else
            {
                lab.alpha = 1;
                lab2.alpha = 1;
                if ([_num02 intValue]>99) {
                    lab2.text = @"99+";
                }else
                {
                    lab2.text = _num02;
                }
                if ([_num01 intValue]>99) {
                    lab.text = @"99+";
                }else
                {
                    lab.text = _num01;
                }
            }
            [self.messagetable reloadData];
            
        } errorblock:^(NSError *error) {
            
        }];

    }
    
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
        //_messagetable.scrollEnabled = NO;
        [_messagetable setSeparatorColor:[UIColor wjColorFloat:@"F5F5F5"]];
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
    numlab.alpha = 0;
    numlab.font = [UIFont systemFontOfSize:10];
    [cell.contentView addSubview:numlab];
   
    if (indexPath.row==0) {
         numlab.tag = 201;
    }
    if (indexPath.row==1) {
         numlab.tag = 202;
    }
    [cell setSeparatorInset:UIEdgeInsetsZero];
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
