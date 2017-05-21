//
//  xiangqingViewController.m
//  Supercomments
//
//  Created by 王俊钢 on 2017/5/12.
//  Copyright © 2017年 wangjungang. All rights reserved.
//

#import "xiangqingViewController.h"
#import "firstCell.h"
#import "firstModel.h"
#import "detailsheadView.h"
#import "Timestr.h"
#import "loginViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "AppDelegate.h"
#import "YYPhotoGroupView.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import "SureWebViewController.h"
#import "keyboardView.h"
#import "headsectionCell.h"
#import "headModel.h"
@interface xiangqingViewController () <UITableViewDelegate, UITableViewDataSource,mycellVdelegate,UITextViewDelegate,myheadViewdelegate>
{
    CGFloat headheight;
    int pn;
}
@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) headsectionCell *headView;
@property (nonatomic, strong) NSMutableArray *usernamearr;
@property (nonatomic, strong) NSString *shifoudianzanstr;
@property (nonatomic, strong) NSString *objidstr;
@property (nonatomic, strong) NSString *weburlstr;
@property (nonatomic, strong) NSString *headimgstr;

@property (nonatomic, strong) headModel *hmodel;
@property (nonatomic, strong) NSDictionary *headdic;

@property (nonatomic,strong) keyboardView *keyView;
@property (nonatomic,strong) NSString *fromkeyboard;

@property (nonatomic,strong) NSString *namestr;
@property (nonatomic,strong) UIControl * overView;

@property (nonatomic,strong) UIView *bgview;
@property (nonatomic,assign) UIEdgeInsets insets;
@end

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
static NSString *xiangqingcell = @"xiagnqingcell";
static NSString *headsectioncell = @"headsectioncell";
@implementation xiangqingViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor wjColorFloat:@"333333"];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor wjColorFloat:@"333333"]}];
    self.title = @"详情";
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    [navigationBar setBackgroundImage:[[UIImage alloc] init]
                       forBarPosition:UIBarPositionAny
                           barMetrics:UIBarMetricsDefault];
   
    //此处使底部线条颜色为F5F5F5
    [navigationBar setShadowImage:[UIImage imageWithColor:[UIColor wjColorFloat:@"F5F5F5"]]];
    pn=1;
    self.insets = UIEdgeInsetsMake(0, 64, 0, 14);
    
    self.datasource = [NSMutableArray array];
    // 3.1.下拉刷新
    [self addHeader];
    // 3.2.上拉加载更多
    [self addFooter];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.keyView];

    [self bgviewadd];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
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

#pragma mark - 刷新控件

- (void)addHeader
{
    // 头部刷新控件
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshAction)];
    [self.tableView.mj_header beginRefreshing];
}

- (void)addFooter
{
    self.tableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshLoadMore)];
}

- (void)refreshAction {
    [self headerRefreshEndAction];
}

- (void)refreshLoadMore {
    [self footerRefreshEndAction];
}


-(void)footerRefreshEndAction
{
    pn ++;
    NSString *pnstr = [NSString stringWithFormat:@"%d",pn];
    NSString *strurl = [NSString stringWithFormat:xiangqin,self.detalisidstr,pnstr,[tokenstr tokenstrfrom]];
    [AFManager getReqURL:strurl block:^(id infor) {
        NSLog(@"info=---------------------%@",infor);
        NSDictionary *infodit =  [infor objectForKey:@"info"];
        //cell部分
       
        //评论部分
        NSArray *dicarr = [infodit objectForKey:@"all_comment"];
        for (int i = 0; i<dicarr.count; i++) {
            NSDictionary *dit = [dicarr objectAtIndex:i];
            firstModel *fmodel = [[firstModel alloc] init];
            fmodel.contentstr = [dit objectForKey:@"content"];
            fmodel.pinglunarr = [dit objectForKey:@"sonComment"];
            fmodel.namestr = [dit objectForKey:@"p_nickname"];
            fmodel.timestr = [dit objectForKey:@"ctime"];
            fmodel.imgurlstr = [dit objectForKey:@"headImg"];
            fmodel.idstr = [dit objectForKey:@"id"];
            fmodel.toidstr = [dit objectForKey:@"uid"];
            [self.datasource addObject:fmodel];
        }
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
        

    } errorblock:^(NSError *error) {
        [self.tableView.mj_footer endRefreshing];
        [MBProgressHUD showSuccess:@"没有网络"];
    }];

}

-(void)headerRefreshEndAction
{
    NSString *urlstr = [NSString stringWithFormat:xiangqin,self.detalisidstr,@"1",[tokenstr tokenstrfrom]];
    [self.datasource removeAllObjects];
    pn=1;
    [AFManager getReqURL:urlstr block:^(id infor) {
        NSDictionary *infodit = [infor objectForKey:@"info"];
        
        self.hmodel = [[headModel alloc] init];
        self.hmodel.namestr = [infodit objectForKey:@"name"];
        self.hmodel.timestr = [infodit objectForKey:@"create_time"];
        
        self.headdic = infodit;
        
        
        NSString *namestr = [infodit objectForKey:@"name"];
        self.namestr = namestr;
        
        self.headimgstr = [infodit objectForKey:@"images"];
        self.weburlstr = [infodit objectForKey:@"url"];
        _shifoudianzanstr = [infodit objectForKey:@"is_support"];
        
        self.usernamearr = [NSMutableArray array];
        
        NSMutableArray * thumarray = [NSMutableArray array];
        thumarray = [infodit objectForKey:@"bookmark_user"];
        for (int i = 0; i<thumarray.count; i++) {
            NSDictionary *bookdic = [NSDictionary dictionary];
            bookdic = [thumarray objectAtIndex:i];
            NSString *usernamestr = [bookdic objectForKey:@"user_nickname"];
            [self.usernamearr addObject:usernamestr];
        }
        
        //评论部分
        NSArray *dicarr = [infodit objectForKey:@"all_comment"];
        for (int i = 0; i<dicarr.count; i++) {
            NSDictionary *dit = [dicarr objectAtIndex:i];
            firstModel *fmodel = [[firstModel alloc] init];
            fmodel.contentstr = [dit objectForKey:@"content"];
            fmodel.pinglunarr = [dit objectForKey:@"sonComment"];
            fmodel.namestr = [dit objectForKey:@"p_nickname"];
            fmodel.timestr = [dit objectForKey:@"ctime"];
            fmodel.imgurlstr = [dit objectForKey:@"headImg"];
            fmodel.idstr = [dit objectForKey:@"id"];
            fmodel.toidstr = [dit objectForKey:@"uid"];
            [self.datasource addObject:fmodel];
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    } errorblock:^(NSError *error) {
        [MBProgressHUD showSuccess:@"没有网络"];
        [self.tableView.mj_header endRefreshing];
    }];
    
}

#pragma mark - getters

-(UITableView *)tableView
{
    if(!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT-64-58) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorColor = [UIColor wjColorFloat:@"F5F5F5"];
    }
    return _tableView;
}
-(UIControl *)overView
{
    if(!_overView)
    {
        _overView = [[UIControl alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _overView.backgroundColor=[UIColor colorWithWhite:0.6 alpha:0.3];
        [_overView addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _overView;
}

-(NSDictionary *)headdic
{
    if(!_headdic)
    {
        _headdic = [NSDictionary dictionary];
        
    }
    return _headdic;
}



-(NSMutableArray *)usernamearr
{
    if(!_usernamearr)
    {
        _usernamearr = [NSMutableArray array];
        
    }
    return _usernamearr;
}


-(keyboardView *)keyView
{
    if(!_keyView)
    {
        _keyView = [[keyboardView alloc] init];
        _keyView.frame = CGRectMake(0, DEVICE_HEIGHT-64-44-14, DEVICE_WIDTH, 44+14);
        //增加监听，当键盘出现或改变时收出消息
        _keyView.textview.delegate = self;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        
        
        //增加监听，当键退出时收出消息
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
        
        
        
        
        _keyView.textview.delegate = self;
        [_keyView.sendbtn addTarget:self action:@selector(sendbtnclick) forControlEvents:UIControlEventTouchUpInside];
        _keyView.backgroundColor = [UIColor whiteColor];
        _keyView.textview.backgroundColor = [UIColor whiteColor];
        _keyView.textview.customPlaceholder = @"写评论";
        _keyView.textview.customPlaceholderColor = [UIColor wjColorFloat:@"C7C7CD"];
    }
    return _keyView;
}

#pragma mark - 输入框方法


//当键盘出现或改变时调用

- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    [UIView animateWithDuration:[aNotification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        self.keyView.transform=CGAffineTransformMakeTranslation(0, -height);
        self.bgview.alpha = 0.6;
        self.bgview.frame = CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT-44-14-height);
        self.bgview.hidden = NO;
    } completion:^(BOOL finished) {
        
    }];
}

//当键退出时调用

- (void)keyboardWillHide:(NSNotification *)aNotification
{
    [UIView animateWithDuration:[aNotification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        //self.bgview.alpha = 0.0;
        self.keyView.transform=CGAffineTransformIdentity;
        self.bgview.hidden = YES;
        self.bgview.frame = CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT);
        self.bgview.alpha = 1;
    } completion:^(BOOL finished) {

        self.keyView.textview.text=@"";
        _fromkeyboard = @"";
        _keyView.textview.customPlaceholder = @"写评论";
        
    }];
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length==0) {
        [self.keyView.sendbtn setTitleColor:[UIColor  wjColorFloat:@"C7C7CD"] forState:normal];
        
    }else
    {
        [self.keyView.sendbtn setTitleColor:[UIColor wjColorFloat:@"576b95"] forState:normal];
        
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    _keyView.textview.customPlaceholder = [NSString stringWithFormat:@"%@%@",@"评论@",self.namestr];
}

-(void)bgviewadd
{
    //添加屏幕的蒙罩
    self.bgview = [[UIView alloc]initWithFrame:self.view.frame];
    self.bgview.backgroundColor = [UIColor blackColor];
    self.bgview.alpha = 0.0;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backgroundTapped:)];
    [self.bgview addGestureRecognizer:tap];
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.window addSubview:self.bgview];
    
}

-(void)backgroundTapped:(UIGestureRecognizer *)tgp
{
    [self.keyView.textview resignFirstResponder];
    NSLog(@"空白处");
}

#pragma mark - UITextViewDelegate

//将要结束/退出编辑模式

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    NSLog(@"退出编辑模式");
    
    return YES;
}

//发送按钮

-(void)sendbtnclick
{
    if ([self isNullToString:self.keyView.textview.text])
    {
        [self.keyView.textview resignFirstResponder];
    }
    else
    {
        [self.keyView.textview resignFirstResponder];
        //三级评论
        if ([_fromkeyboard isEqualToString:@"cellpinglun"]) {
            
            
            if ([tokenstr tokenstrfrom].length!=0&&self.keyView.touidstr.length!=0&&self.objidstr.length!=0&&self.keyView.pidstr.length!=0&&self.keyView.textview.text.length!=0) {
                
                NSDictionary *para = @{@"token":[tokenstr tokenstrfrom],@"to_uid":self.keyView.touidstr,@"object_id":self.objidstr,@"content":self.keyView.textview.text,@"pid":self.keyView.pidstr};
                [CLNetworkingManager postCacheRequestWithUrlString:pinglunhuifu parameters:para cacheTime:NO succeed:^(id data) {
                    NSLog(@"data-------%@",data);
                    if ([[data objectForKey:@"code"] intValue]==1) {
                        NSString *pinglunnum = [data objectForKey:@"comment_num"];
                        //self.headview.combtn.textlab.text = pinglunnum;
                        
                        [self headerRefreshEndAction];
                        
                        
                        NSDictionary *dianzandic = @{@"dianzanindex":self.dianzanindex,@"pinglunstr":pinglunnum};
                        if ([self.fromtypestr isEqualToString:@"newvc"]) {
                            [[NSNotificationCenter defaultCenter]postNotificationName:@"pinglunkvo" object:dianzandic];
                        }else
                        {
                            [[NSNotificationCenter defaultCenter]postNotificationName:@"pinglunkvo2" object:dianzandic];
                        }
                        
                        [MBProgressHUD showSuccess:@"评论成功"];
                    }
                } fail:^(NSError *error) {
                    [MBProgressHUD showSuccess:@"没有网络"];
                }];
                
                
            }
            
            
            
            
        }else if([_fromkeyboard isEqualToString:@"section"])
        {
            //二级评论
            
            firstModel *fmodel  = self.datasource[self.keyView.secindex];
            NSString *pidstr = fmodel.idstr;
            NSString *uidstr = fmodel.toidstr;
            
            
            if ([tokenstr tokenstrfrom].length!=0&&uidstr.length!=0&&self.objidstr.length!=0&&pidstr.length!=0&&self.keyView.textview.text.length!=0) {
                
                //网络请求
                NSDictionary *para = @{@"token":[tokenstr tokenstrfrom],@"to_uid":uidstr,@"object_id":self.objidstr,@"content":self.keyView.textview.text,@"pid":pidstr};
                
                [CLNetworkingManager postCacheRequestWithUrlString:pinglunhuifu parameters:para cacheTime:NO succeed:^(id data) {
                    NSLog(@"data-------%@",data);
                    if ([[data objectForKey:@"code"] intValue]==1) {
                        NSString *pinglunnum = [data objectForKey:@"comment_num"];
                        //self.headview.combtn.textlab.text = pinglunnum;
                        [self headerRefreshEndAction];
                        
                        [MBProgressHUD showSuccess:@"评论成功"];
                        
                        NSDictionary *dianzandic = @{@"dianzanindex":self.dianzanindex,@"pinglunstr":pinglunnum};
                        if ([self.fromtypestr isEqualToString:@"newvc"]) {
                            [[NSNotificationCenter defaultCenter]postNotificationName:@"pinglunkvo" object:dianzandic];
                        }else
                        {
                            [[NSNotificationCenter defaultCenter]postNotificationName:@"pinglunkvo2" object:dianzandic];
                        }
                    }
                    
                } fail:^(NSError *error) {
                    [MBProgressHUD showSuccess:@"没有网络"];
                }];
            }
            
        }
        else
        {
            //一级评论
           // self.detailsmodel = [[detailcellmodel alloc] init];
            
            if ([tokenstr tokenstrfrom].length!=0&&self.objidstr.length!=0&&self.keyView.textview.text.length!=0) {
                //网络请求
                NSDictionary *para = @{@"token":[tokenstr tokenstrfrom],@"to_uid":@"0",@"object_id":self.objidstr,@"content":self.keyView.textview.text,@"pid":@"0"};
                
                [CLNetworkingManager postCacheRequestWithUrlString:pinglunhuifu parameters:para cacheTime:NO succeed:^(id data) {
                    NSLog(@"data-------%@",data);
                    if ([[data objectForKey:@"code"] intValue]==1) {
                        NSString *pinglunnum = [data objectForKey:@"comment_num"];
                        //self.headview.combtn.textlab.text = pinglunnum;
                        [self headerRefreshEndAction];
                        
                        [MBProgressHUD showSuccess:@"评论成功"];
                        NSDictionary *dianzandic = @{@"dianzanindex":self.dianzanindex,@"pinglunstr":pinglunnum};
                        if ([self.fromtypestr isEqualToString:@"newvc"]) {
                            [[NSNotificationCenter defaultCenter]postNotificationName:@"pinglunkvo" object:dianzandic];
                        }else
                        {
                            [[NSNotificationCenter defaultCenter]postNotificationName:@"pinglunkvo2" object:dianzandic];
                        }
                    }
                    
                } fail:^(NSError *error) {
                    [MBProgressHUD showSuccess:@"没有网络"];
                }];
                
            }
        }
    }
    
}

//响应return

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"])
    {           //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        NSLog(@"return");
        [textView resignFirstResponder];
        
        if ([self isNullToString:textView.text])
        {
            [textView resignFirstResponder];
        }
        else
        {
            //三级评论
            if ([_fromkeyboard isEqualToString:@"cellpinglun"]) {
                if ([tokenstr tokenstrfrom].length!=0&&self.keyView.touidstr.length!=0&&self.objidstr.length!=0&&self.keyView.pidstr.length!=0&&self.keyView.textview.text.length!=0) {
                    
                    NSDictionary *para = @{@"token":[tokenstr tokenstrfrom],@"to_uid":self.keyView.touidstr,@"object_id":self.objidstr,@"content":self.keyView.textview.text,@"pid":self.keyView.pidstr};
                    [CLNetworkingManager postCacheRequestWithUrlString:pinglunhuifu parameters:para cacheTime:NO succeed:^(id data) {
                        NSLog(@"data-------%@",data);
                        if ([[data objectForKey:@"code"] intValue]==1) {
                            NSString *pinglunnum = [data objectForKey:@"comment_num"];
                            //self.headview.combtn.textlab.text = pinglunnum;
                            
                            [self headerRefreshEndAction];
                            
                            NSDictionary *dianzandic = @{@"dianzanindex":self.dianzanindex,@"pinglunstr":pinglunnum};
                            if ([self.fromtypestr isEqualToString:@"newvc"]) {
                                [[NSNotificationCenter defaultCenter]postNotificationName:@"pinglunkvo" object:dianzandic];
                            }else
                            {
                                [[NSNotificationCenter defaultCenter]postNotificationName:@"pinglunkvo2" object:dianzandic];
                            }
                            
                            [MBProgressHUD showSuccess:@"评论成功"];
                        }
                    } fail:^(NSError *error) {
                        [MBProgressHUD showSuccess:@"没有网络"];
                    }];
                }
                
            }else if([_fromkeyboard isEqualToString:@"section"])
            {
                //二级评论
                firstModel *fmodel  = self.datasource[self.keyView.secindex];
                NSString *pidstr = fmodel.idstr;
                NSString *uidstr = fmodel.toidstr;
                
                if ([tokenstr tokenstrfrom].length!=0&&uidstr.length!=0&&self.objidstr.length!=0&&pidstr.length!=0&&self.keyView.textview.text.length!=0) {
                    
                    //网络请求
                    NSDictionary *para = @{@"token":[tokenstr tokenstrfrom],@"to_uid":uidstr,@"object_id":self.objidstr,@"content":self.keyView.textview.text,@"pid":pidstr};
                    
                    [CLNetworkingManager postCacheRequestWithUrlString:pinglunhuifu parameters:para cacheTime:NO succeed:^(id data) {
                        NSLog(@"data-------%@",data);
                        if ([[data objectForKey:@"code"] intValue]==1) {
                            NSString *pinglunnum = [data objectForKey:@"comment_num"];
//                            self.headview.combtn.textlab.text = pinglunnum;
                            [self headerRefreshEndAction];
                            
                            [MBProgressHUD showSuccess:@"评论成功"];
                            
                            NSDictionary *dianzandic = @{@"dianzanindex":self.dianzanindex,@"pinglunstr":pinglunnum};
                            if ([self.fromtypestr isEqualToString:@"newvc"]) {
                                [[NSNotificationCenter defaultCenter]postNotificationName:@"pinglunkvo" object:dianzandic];
                            }else
                            {
                                [[NSNotificationCenter defaultCenter]postNotificationName:@"pinglunkvo2" object:dianzandic];
                            }
                        }
                        
                    } fail:^(NSError *error) {
                        [MBProgressHUD showSuccess:@"没有网络"];
                    }];
                }
                
                
            }
            else
            {
                //一级评论
                //self.hmodel = [[detailcellmodel alloc] init];
                if ([tokenstr tokenstrfrom].length!=0&&self.objidstr.length!=0&&self.keyView.textview.text.length!=0) {
                    //网络请求
                    NSDictionary *para = @{@"token":[tokenstr tokenstrfrom],@"to_uid":@"0",@"object_id":self.objidstr,@"content":self.keyView.textview.text,@"pid":@"0"};
                    [CLNetworkingManager postCacheRequestWithUrlString:pinglunhuifu parameters:para cacheTime:NO succeed:^(id data) {
                        NSLog(@"data-------%@",data);
                        if ([[data objectForKey:@"code"] intValue]==1) {
                            NSString *pinglunnum = [data objectForKey:@"comment_num"];
//                            self.headview.combtn.textlab.text = pinglunnum;
                            [self headerRefreshEndAction];
                            
                            [MBProgressHUD showSuccess:@"评论成功"];
                            NSDictionary *dianzandic = @{@"dianzanindex":self.dianzanindex,@"pinglunstr":pinglunnum};
                            if ([self.fromtypestr isEqualToString:@"newvc"]) {
                                [[NSNotificationCenter defaultCenter]postNotificationName:@"pinglunkvo" object:dianzandic];
                            }else
                            {
                                [[NSNotificationCenter defaultCenter]postNotificationName:@"pinglunkvo2" object:dianzandic];
                            }
                        }
                        
                    } fail:^(NSError *error) {
                        [MBProgressHUD showSuccess:@"没有网络"];
                    }];
                    
                }
            }
            
        }
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    return YES;
}


#pragma mark -UITableViewDataSource&&UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }else
    {
        return self.datasource.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        _headView = [tableView dequeueReusableCellWithIdentifier:headsectioncell];
        _headView = [[headsectionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:headsectioncell];
        _headView.delegate = self;
   
        _headView.selectionStyle = UITableViewCellSelectionStyleNone;
        [_headView setdata:self.headdic userarr:self.usernamearr];
        return _headView;
    }else
    {
        firstCell *cell = [tableView dequeueReusableCellWithIdentifier:xiangqingcell];
        cell = [[firstCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:xiangqingcell];
        [cell setcelldata:self.datasource[indexPath.row]];
        cell.delegate = self;
        //[cell setSeparatorInset:UIEdgeInsetsZero];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        headsectionCell *cell = [[headsectionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:headsectioncell];

        return [cell setdata:self.headdic userarr:self.usernamearr];
    }else
    {
        firstCell * cell = [[firstCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:xiangqingcell];
        return [cell setcelldata:self.datasource[indexPath.row]];
    }
    return 0;
    
}

-(void)myTabVClick:(UITableViewCell *)cell datadic:(NSDictionary *)dic
{
    NSLog(@"dic=======%@",dic);
    if ([tokenstr tokenstrfrom].length==0) {
        NSLog(@"请登陆");
        loginViewController *logvc = [[loginViewController alloc] init];
        logvc.jinru = @"jinru";
        [self presentViewController:logvc animated:YES completion:^{
            
        }];
    }
    else
    {
        self.fromkeyboard = @"cellpinglun";
        [self.keyView.textview becomeFirstResponder];
        
        self.keyView.nickname = [dic objectForKey:@"s_nickname"];
        self.keyView.tonickname = [dic objectForKey:@"s_to_nickname"];
        self.keyView.pidstr = [dic objectForKey:@"pid"];
        self.keyView.touidstr = [dic objectForKey:@"uid"];
        _keyView.textview.customPlaceholder = [NSString stringWithFormat:@"%@%@",@"回复@",self.keyView.nickname];
        
    }

}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1) {
        
        if ([tokenstr tokenstrfrom].length==0) {
            NSLog(@"请登陆");
            loginViewController *logvc = [[loginViewController alloc] init];
            logvc.jinru = @"jinru";
            [self presentViewController:logvc animated:YES completion:^{
                
            }];
        }
        else
        {
            [self.keyView.textview becomeFirstResponder];
            self.fromkeyboard = @"section";
            self.keyView.secindex = indexPath.row;
            
            firstModel *fmodel =self.datasource[self.keyView.secindex];
            NSString *tonickname = fmodel.namestr;
            _keyView.textview.customPlaceholder = [NSString stringWithFormat:@"%@%@",@"回复@",tonickname];
        }

    }
}

-(void)myTabheadClick1:(UITableViewCell *)cell
{
    NSLog(@"点赞");
    if ([_shifoudianzanstr isEqualToString:@"0"]) {
        
        if ([tokenstr tokenstrfrom].length==0) {
            NSLog(@"请登陆");
            loginViewController *loginvc = [[loginViewController alloc] init];
            loginvc.jinru = @"jinru";
            [self presentViewController:loginvc animated:YES completion:nil];
        }else
        {
            //点赞
            
            NSDictionary *reqdic = @{@"token":[tokenstr tokenstrfrom],@"object_id":self.detalisidstr,@"status":@"1",@"type":@"1"};
            [AFManager postReqURL:qudianzan reqBody:reqdic block:^(id infor) {
                NSLog(@"infor=====%@",infor);
                NSString *codestr = [infor objectForKey:@"code"];
                if ([codestr intValue]==1) {
                    self.headView.dianzanbtn.zanimg.image = [UIImage imageNamed:@"点赞-拷贝"];
                    self.headView.dianzanbtn.zanlab.textColor = [UIColor wjColorFloat:@"FF4444"];
                    [MBProgressHUD showSuccess:@"点赞+1"];
                    NSLog(@"成功");
                    
                    NSDictionary *dic = [infor objectForKey:@"info"];
                    
                    NSString *dianzannumtext = [NSString stringWithFormat:@"%@",[dic objectForKey:@"spportNum"]];
                    
                    _shifoudianzanstr = @"1";
                    
                    NSDictionary *dianzandic = @{@"dianzanindex":self.dianzanindex,@"diansanstr":self.shifoudianzanstr,@"dianzannum":dianzannumtext};

                    if ([self.fromtypestr isEqualToString:@"newvc"]) {
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"shifoudiandankvo" object:dianzandic];
                    }else
                    {
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"shifoudiandankvo2" object:dianzandic];
                    }
                    
                    

                    
                    [self headerRefreshEndAction];
                    
                }
                else if ([codestr intValue]==0)
                {
                    [MBProgressHUD showSuccess:@"token错误"];
                    NSLog(@"token错误");
                }
                else if ([codestr intValue]==4)
                {
                    [MBProgressHUD showSuccess:@"抱歉您的账户被暂时限制了，无法进行此操作"];
                    NSLog(@"抱歉您的账户被暂时限制了，无法进行此操作");
                }else if ([codestr intValue]==2100)
                {
                    [MBProgressHUD showSuccess:@"该牛评不存在或者被冻结"];
                    NSLog(@"该牛评不存在或者被冻结");
                }
                else
                {
                    [MBProgressHUD showSuccess:@"系统繁忙，请稍后再试"];
                    NSLog(@"系统繁忙，请稍后再试");
                }
                
            }];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
        
    }else
    {
        if ([tokenstr tokenstrfrom].length==0) {
            NSLog(@"请登陆");
            loginViewController *loginvc = [[loginViewController alloc] init];
            loginvc.jinru = @"jinru";
            [self presentViewController:loginvc animated:YES completion:nil];
        }else
        {
            //取消点赞
            NSDictionary *reqdic = @{@"token":[tokenstr tokenstrfrom],@"object_id":self.detalisidstr,@"status":@"0",@"type":@"1"};
            
            [CLNetworkingManager postNetworkRequestWithUrlString:qudianzan parameters:reqdic isCache:NO succeed:^(id data) {
                NSLog(@"data===%@",data);
                NSString *codestr = [data objectForKey:@"code"];
                if ([codestr intValue]==1) {
                    self.shifoudianzanstr = @"0";
                    NSDictionary *dic = [data objectForKey:@"info"];
                    NSString *dianzannumtext = [NSString stringWithFormat:@"%@",[dic objectForKey:@"spportNum"]];
                    NSDictionary *dianzandic = @{@"dianzanindex":self.dianzanindex,@"diansanstr":self.shifoudianzanstr,@"dianzannum":dianzannumtext};
                    if ([self.fromtypestr isEqualToString:@"newvc"]) {
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"shifoudiandankvo" object:dianzandic];
                    }else
                    {
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"shifoudiandankvo2" object:dianzandic];
                    }
                    self.headView.dianzanbtn.zanimg.image = [UIImage imageNamed:@"点赞-"];
                    self.headView.dianzanbtn.zanlab.textColor = [UIColor wjColorFloat:@"C7C7CD"];
                    [MBProgressHUD showSuccess:@"取消点赞"];
                    NSLog(@"成功");
                    
                    [self headerRefreshEndAction];
                    
                }
                else if ([codestr intValue]==0)
                {
                    [MBProgressHUD showSuccess:@"token错误"];
                    NSLog(@"token错误");
                }
                else if ([codestr intValue]==4)
                {
                    [MBProgressHUD showSuccess:@"抱歉您的账户被暂时限制了，无法进行此操作"];
                    NSLog(@"抱歉您的账户被暂时限制了，无法进行此操作");
                }else if ([codestr intValue]==2100)
                {
                    [MBProgressHUD showSuccess:@"该牛评不存在或者被冻结"];
                    NSLog(@"该牛评不存在或者被冻结");
                }
                else
                {
                    [MBProgressHUD showSuccess:@"系统繁忙，请稍后再试"];
                    NSLog(@"系统繁忙，请稍后再试");
                }
                
            } fail:^(NSError *error) {
                [MBProgressHUD showSuccess:@"没有网络"];
            }];
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           [self.tableView reloadData];
                       });
    }

}
-(void)myTabheadClick2:(UITableViewCell *)cell
{
    NSLog(@"评论");
    if ([tokenstr tokenstrfrom].length==0) {
        NSLog(@"请登陆");
        loginViewController *logvc = [[loginViewController alloc] init];
        logvc.jinru = @"jinru";
        [self presentViewController:logvc animated:YES completion:^{
            
        }];
    }
    else
    {
        self.fromkeyboard = @"zhupinglun";
        _keyView.textview.customPlaceholder = [NSString stringWithFormat:@"%@%@",@"评论@", self.namestr];
        [self.keyView.textview becomeFirstResponder];
    }
    
}
-(void)myTabheadClick3:(UITableViewCell *)cell
{
    NSLog(@"分享");
    //1、创建分享参数
    //NSArray* imageArray = @[[UIImage imageNamed:@"牛评分享下载.jpg"]];
    NSString *urlstr = @"http://www.np.iwenyu.cn/Public/images/share.jpg";
    
    NSArray* imageArray = @[[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlstr]]]];
    
    //（注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    if (imageArray) {
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        //        [shareParams SSDKSetupShareParamsByText:@"分享内容"
        //                                         images:imageArray
        //                                            url:[NSURL URLWithString:@"http://mob.com"]
        //                                          title:@"分享标题"
        //                                           type:SSDKContentTypeAuto];
        
        [shareParams SSDKSetupShareParamsByText:@"" images:imageArray url:[NSURL URLWithString:@""] title:@"" type:SSDKContentTypeImage];
        
        
        //有的平台要客户端分享需要加此方法，例如微博
        [shareParams SSDKEnableUseClientShare];
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                                 items:nil
                           shareParams:shareParams
                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                       
                       switch (state) {
                           case SSDKResponseStateSuccess:
                           {
                               UIAlertController *control = [UIAlertController alertControllerWithTitle:@"分享成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
                               UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                   
                               }];
                               [control addAction:action];
                               [self presentViewController:control animated:YES completion:nil];
                               break;
                           }
                           case SSDKResponseStateFail:
                           {
                               UIAlertController *control = [UIAlertController alertControllerWithTitle:@"您还没有安装微信" message:nil preferredStyle:UIAlertControllerStyleAlert];
                               UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                   
                               }];
                               [control addAction:action];
                               [self presentViewController:control animated:YES completion:nil];
                               break;
                           }
                           default:
                               break;
                       }
                   }
         ];}

}
-(void)myTabheadClick4:(UITableViewCell *)cell
{
    NSLog(@"title");
    NSString *urlstr = self.weburlstr;
    NSLog(@"urlstr-------%@",urlstr);
    SureWebViewController *surevc = [[SureWebViewController alloc]init];
    surevc.url = urlstr;
    surevc.canDownRefresh = YES;
    [self.navigationController pushViewController:surevc animated:YES];
}
#pragma mark - 实现方法

-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}




#pragma mark - 判断字符串为空

- (BOOL )isNullToString:(id)string
{
    if ([string isEqual:@"NULL"] || [string isKindOfClass:[NSNull class]] || [string isEqual:[NSNull null]] || [string isEqual:NULL] || [[string class] isSubclassOfClass:[NSNull class]] || string == nil || string == NULL || [string isKindOfClass:[NSNull class]] || [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0 || [string isEqualToString:@"<null>"] || [string isEqualToString:@"(null)"])
    {
        return YES;
        
    }else
    {
        
        return NO;
    }
}
#pragma mark 用于将cell分割线补全

-(void)viewDidLayoutSubviews {
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:self.insets];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.tableView setLayoutMargins:self.insets];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:self.insets];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:self.insets];
    }
}

@end
