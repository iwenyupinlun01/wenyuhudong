//
//  nicknameViewController.m
//  Supercomments
//
//  Created by 王俊钢 on 2017/4/6.
//  Copyright © 2017年 wangjungang. All rights reserved.
//

#import "nicknameViewController.h"
#import "nicknameCell.h"
@interface nicknameViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *nicktable;
@end
static NSString *nickcellidentfid = @"nickidentfid";
@implementation nicknameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor wjColorFloat:@"F5F5F5"];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor wjColorFloat:@"333333"];
    self.title = @"昵称";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(rightaction1)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor wjColorFloat:@"333333"];
    
    
    UITapGestureRecognizer *TapGestureTecognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide)];
    TapGestureTecognizer.cancelsTouchesInView=NO;
    [self.nicktable addGestureRecognizer:TapGestureTecognizer];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor wjColorFloat:@"333333"]}];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.nicktable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.nicktable];
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
#pragma mark - getters

-(UITableView *)nicktable
{
    if(!_nicktable)
    {
        _nicktable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT-64)];
        _nicktable.dataSource = self;
        _nicktable.delegate = self;
        _nicktable.backgroundColor = [UIColor wjColorFloat:@"F5F5F5"];
        _nicktable.scrollEnabled = NO;
    }
    return _nicktable;
}

#pragma mark -UITableViewDataSource&&UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    nicknameCell *cell = [tableView dequeueReusableCellWithIdentifier:nickcellidentfid];
    if (!cell) {
        cell = [[nicknameCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nickcellidentfid];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setSeparatorInset:UIEdgeInsetsZero];
    cell.nicknametext.tag = 100;
    cell.nicknametext.delegate = self;
    cell.nicknametext.text = self.nicknamestr;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60*HEIGHT_SCALE;
}

#pragma mark -UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - getters

-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightaction1
{
    NSLog(@"保存");
    //保存修改的用户名
    UITextField *text = [self.nicktable viewWithTag:100];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"usernamexiugai" object:text.text];
    NSUserDefaults *userdefat = [NSUserDefaults standardUserDefaults];
    [userdefat setObject:text.text forKey:@"namestr"];
    [userdefat synchronize];
}

-(void)keyboardHide
{
    UITextField *text = [self.nicktable viewWithTag:100];
    [text resignFirstResponder];
}

@end
