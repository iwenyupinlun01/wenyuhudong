//
//  feedbackViewController.m
//  Supercomments
//
//  Created by 王俊钢 on 2017/4/6.
//  Copyright © 2017年 wangjungang. All rights reserved.
//

#import "feedbackViewController.h"
#import "WJGtextView.h"
@interface feedbackViewController ()<UITextViewDelegate>
@property (nonatomic,strong) WJGtextView *feedtext;
@end

@implementation feedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor wjColorFloat:@"333333"];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    self.title = @"意见反馈";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor wjColorFloat:@"333333"]}];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(rightaction)];
    
    UITapGestureRecognizer *TapGestureTecognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide)];
    TapGestureTecognizer.cancelsTouchesInView=NO;
    [self.view addGestureRecognizer:TapGestureTecognizer];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    [self.view addSubview:self.feedtext];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.feedtext.frame = CGRectMake(14*WIDTH_SCALE, 20*HEIGHT_SCALE, DEVICE_WIDTH-28*WIDTH_SCALE, 280*HEIGHT_SCALE);
}

-(void)viewWillDisappear:(BOOL)animated

{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}


#pragma mark - getters


-(WJGtextView *)feedtext
{
    if(!_feedtext)
    {
        _feedtext = [[WJGtextView alloc] init];
        _feedtext.customPlaceholder = @"有什么想对我说的话就统统发过来吧";
        _feedtext.customPlaceholderColor = [UIColor wjColorFloat:@"C7C7CD"];
        _feedtext.delegate = self;
    }
    return _feedtext;
}

#pragma mark - 实现方法

-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightaction
{
    NSLog(@"提交");
}

-(void)keyboardHide
{
    [self.feedtext resignFirstResponder];
}
@end
