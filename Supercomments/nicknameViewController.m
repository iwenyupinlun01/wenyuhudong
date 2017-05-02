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

    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.nicktable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.nicktable];
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

-(UITableView *)nicktable
{
    if(!_nicktable)
    {
        _nicktable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT-64)];
        _nicktable.dataSource = self;
        _nicktable.delegate = self;
        _nicktable.backgroundColor = [UIColor wjColorFloat:@"F5F5F5"];
        //_nicktable.scrollEnabled = NO;
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
    
    [cell.nicknametext addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.nicknamestr = [tokenstr nicknamestrfrom];
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

- (void)textFieldDidChange:(UITextField *)textField
{
    UITextField *textname = [self.nicktable viewWithTag:100];
    if (textField == textname) {
        if (textField.text.length > 12) {
            textField.text = [textField.text substringToIndex:12];
        }
    }
}


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
    
    
    UITextField *textname = [self.nicktable viewWithTag:100];

        
        [AFManager postReqURL:xiugainicheng reqBody:@{@"token":[tokenstr tokenstrfrom],@"nickname":textname.text} block:^(id infor) {
            NSLog(@"infor-------%@",infor);
            if ([[infor objectForKey:@"code"] intValue]==-1) {
                [MBProgressHUD showSuccess:@"token失效"];
            }
            if ([[infor objectForKey:@"code"] intValue]==0) {
                [MBProgressHUD showSuccess:@"token错误"];
            }
            if ([[infor objectForKey:@"code"] intValue]==1) {
                [MBProgressHUD showSuccess:@"修改成功"];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"usernamexiugai" object:textname.text];
                NSUserDefaults *userdefat = [NSUserDefaults standardUserDefaults];
                [userdefat setObject:textname.text forKey:@"namestr"];
                [userdefat synchronize];
                [self.navigationController popViewControllerAnimated:YES];

            }
            if ([[infor objectForKey:@"code"] intValue]==3100) {
                [MBProgressHUD showSuccess:@"昵称格式不正确"];
            }if ([[infor objectForKey:@"code"] intValue]==3101) {
                [MBProgressHUD showSuccess:@"该昵称禁止注册"];
            }
            if ([[infor objectForKey:@"code"] intValue]==3102) {
                [MBProgressHUD showSuccess:@"该昵称已经被注册过了"];
            }
            if ([[infor objectForKey:@"code"] intValue]==3103) {
                [MBProgressHUD showSuccess:@"您没有进行任何修改"];
            }
            if ([[infor objectForKey:@"code"] intValue]==3104) {
                [MBProgressHUD showSuccess:@"系统繁忙，请您稍后再试"];
            }
            if ([[infor objectForKey:@"code"] intValue]==3105) {
                [MBProgressHUD showSuccess:@"昵称不能大于24个字符"];
            }
            if ([[infor objectForKey:@"code"] intValue]==3106) {
                [MBProgressHUD showSuccess:@"昵称不能小于4个字符"];
            }
        }];
}

-(void)keyboardHide
{
    UITextField *text = [self.nicktable viewWithTag:100];
    [text resignFirstResponder];
}

@end
