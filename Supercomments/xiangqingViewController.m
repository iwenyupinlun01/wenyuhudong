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
@interface xiangqingViewController () <UITableViewDelegate, UITableViewDataSource,mycellVdelegate,UITextViewDelegate>
{
    CGFloat headheight;
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

@property (nonatomic,strong) keyboardView *keyView;
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
    
    self.datasource = [NSMutableArray array];
    // 3.1.下拉刷新
    [self addHeader];
    // 3.2.上拉加载更多
    [self addFooter];
    [self.view addSubview:self.tableView];
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
    
}

-(void)headerRefreshEndAction
{
    NSString *urlstr = @"http://np.iwenyu.cn/forum/index/detail.html?id=918&page=1&token=f054925590e54922f592f3b232924e70";
    //NSString *urlstr = [NSString stringWithFormat:xiangqin,self.detalisidstr,@"1",[tokenstr tokenstrfrom]];
    
    [self.datasource removeAllObjects];
    
    [AFManager getReqURL:urlstr block:^(id infor) {
        NSDictionary *infodit = [infor objectForKey:@"info"];
        
        self.hmodel = [[headModel alloc] init];
        
        
        
        NSString *namestr = [infodit objectForKey:@"name"];
        NSString *timestr = [infodit objectForKey:@"create_time"];
        NSString *contentstr = [infodit objectForKey:@"content"];
        NSString *type = [infodit objectForKey:@"type"];
        NSString *platformstr = [infodit objectForKey:@"platform"];
        NSString *support_countstr = [infodit objectForKey:@"support_count"];

        self.headimgstr = [infodit objectForKey:@"images"];
        self.weburlstr = [infodit objectForKey:@"url"];
        
        NSString *small_imagestr = [infodit objectForKey:@"small_images"];
        _shifoudianzanstr = [infodit objectForKey:@"is_support"];
        
        self.headView = [[headsectionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:headsectioncell];
        
        if ([type isEqualToString:@"1"]) {
            self.headView.fromlab.text = [NSString stringWithFormat:@"%@%@%@",@"腾讯老司机已赞",support_countstr,@"次"];
        }
        else if ([type isEqualToString:@"2"]) {
            self.headView.fromlab.text = [NSString stringWithFormat:@"%@%@%@",@"网易老司机已赞",support_countstr,@"次"];
        }
        else if ([type isEqualToString:@"5"]) {
            self.headView.fromlab.text = [NSString stringWithFormat:@"%@%@%@%@",platformstr,@"已赞",support_countstr,@"次"];
        }
        else{
            self.headView.fromlab.text = [NSString stringWithFormat:@"%@%@%@",@"今日牛评老司机已赞",support_countstr,@"次"];
        }
        
        self.headView.dianzanbtn.zanlab.text = [NSString stringWithFormat:@"%@",[infodit objectForKey:@"support_num"]];
        self.headView.combtn.textlab.text = [NSString stringWithFormat:@"%@",[infodit objectForKey:@"reply_num"]];
        
        if ([_shifoudianzanstr isEqualToString:@"0"]) {
            self.headView.dianzanbtn.zanimg.image = [UIImage imageNamed:@"点赞-"];
            self.headView.dianzanbtn.zanlab.textColor = [UIColor wjColorFloat:@"C7C7CD"];
        }else
        {
            self.headView.dianzanbtn.zanimg.image = [UIImage imageNamed:@"点赞-拷贝"];
            self.headView.dianzanbtn.zanlab.textColor = [UIColor wjColorFloat:@"FF4444"];
        }

        self.headView.namelab.text = namestr;
        self.headView.timelab.text = [Timestr datetime:timestr];
        self.objidstr = [NSString stringWithFormat:@"%@",[infodit objectForKey:@"id"]];;
        self.headView.namelab.backgroundColor = [UIColor redColor];
        NSString *str1 = @" 标题: ";
        NSString *str2 = [infodit objectForKey:@"title"];
        NSMutableAttributedString *strbut = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",str1,str2]];
        [strbut addAttribute:NSForegroundColorAttributeName value:[UIColor wjColorFloat:@"333333"] range:NSMakeRange(0, str1.length)];
        [strbut addAttribute:NSForegroundColorAttributeName value:[UIColor wjColorFloat:@"576B95"] range:NSMakeRange(str1.length, str2.length)];
        self.headView.title.titlelab.attributedText = strbut;
        self.headView.contentlab.text = contentstr;
        self.headView.numberlab.text = [NSString stringWithFormat:@"%@%@",[infodit objectForKey:@"reply_num"],@"人评论"];
        
        if ([[infodit objectForKey:@"reply_num"] isEqualToString:@"0"]) {
            [self.headView.numberlab setHidden:YES];
            [self.headView.lineview setHidden:YES];
        }else
        {
            [self.headView.numberlab setHidden:NO];
            [self.headView.lineview setHidden:NO];
        }
        
        NSMutableArray * thumarray = [NSMutableArray array];
        thumarray = [infodit objectForKey:@"bookmark_user"];
        for (int i = 0; i<thumarray.count; i++) {
            NSDictionary *bookdic = [NSDictionary dictionary];
            bookdic = [thumarray objectAtIndex:i];
            NSString *usernamestr = [bookdic objectForKey:@"user_nickname"];
            [self.usernamearr addObject:usernamestr];
        }
        
        [self headfromcontentstr:contentstr andimageurl:small_imagestr andgoodarr:self.usernamearr];
        
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
            [self.datasource addObject:fmodel];
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    } errorblock:^(NSError *error) {
        [MBProgressHUD showSuccess:@""];
        [self.tableView.mj_header endRefreshing];
    }];
    
}

#pragma mark - getters

-(UITableView *)tableView
{
    if(!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT-64) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
    }
    return _tableView;
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


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat sectionHeaderHeight = headheight;//设置你footer高度
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
    
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
        _headView.selectionStyle = UITableViewCellSelectionStyleNone;
     
        return _headView;
    }else
    {
        firstCell *cell = [tableView dequeueReusableCellWithIdentifier:xiangqingcell];
        cell = [[firstCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:xiangqingcell];
        [cell setcelldata:self.datasource[indexPath.row]];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return headheight;
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
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"index");
}

#pragma mark - 实现方法

-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)shareclick
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


-(void)dianzanclick
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
                    self.headView.dianzanbtn.zanlab.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"spportNum"]];
                    
                    _shifoudianzanstr = @"1";
                    NSDictionary *dianzandic = @{@"dianzanindex":self.dianzanindex,@"diansanstr":self.shifoudianzanstr,@"dianzannum":self.headView.dianzanbtn.zanlab.text};
                    
                    if ([self.fromtypestr isEqualToString:@"newvc"]) {
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"shifoudiandankvo" object:dianzandic];
                    }else
                    {
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"shifoudiandankvo2" object:dianzandic];
                    }
                    
                    
                    NSMutableArray *zongzhuanarr = [NSMutableArray array];
                    [zongzhuanarr addObject:[tokenstr nicknamestrfrom]];
                    [zongzhuanarr addObjectsFromArray:self.usernamearr];
                    self.usernamearr = zongzhuanarr;
                    NSLog(@"headmarr-----%@",self.usernamearr);
                    
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
                    self.headView.dianzanbtn.zanlab.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"spportNum"]];
                    NSDictionary *dianzandic = @{@"dianzanindex":self.dianzanindex,@"diansanstr":self.shifoudianzanstr,@"dianzannum":self.headView.dianzanbtn.zanlab.text};
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
                    
                    [self.usernamearr removeObjectAtIndex:0];
                    
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

#pragma mark - 地址跳转方法

-(void)webimagego
{
    NSString *urlstr = self.weburlstr;
    NSLog(@"urlstr-------%@",urlstr);
    SureWebViewController *surevc = [[SureWebViewController alloc]init];
    surevc.url = urlstr;
    surevc.canDownRefresh = YES;
    [self.navigationController pushViewController:surevc animated:YES];
    
}

#pragma mark - 图片放大方法

- (void)tapAction2{
    YYPhotoGroupItem *item = [YYPhotoGroupItem new];
    item.thumbView         = self.headView.headimg;
    
    item.largeImageURL     = [NSURL URLWithString:self.headimgstr];
    YYPhotoGroupView *view = [[YYPhotoGroupView alloc] initWithGroupItems:@[item]];
    UIView *toView         = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    [view presentFromImageView:self.headView.headimg
                   toContainer:toView
                      animated:YES completion:nil];
    
}

#pragma mark - headfrom

-(void)headfromcontentstr:(NSString *)content andimageurl:(NSString *)urlstr andgoodarr:(NSArray *)thumarr
{
    self.headView.namelab.text = @"text";
    
    if (thumarr.count<=12) {
        NSString *goodTotalString2 = [thumarr componentsJoinedByString:@", "];
        NSString *goodTotalString = [NSString stringWithFormat:@"%@%@%lu%@",goodTotalString2,@" ",(unsigned long)thumarr.count,@"人已赞"];
        NSMutableAttributedString *newGoodString = [[NSMutableAttributedString alloc] initWithString:goodTotalString];
        [newGoodString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, goodTotalString.length)];
        //设置行距 实际开发中间距为0太丑了，根据项目需求自己把握
        NSMutableParagraphStyle *paragraphstyle = [[NSMutableParagraphStyle alloc] init];
        paragraphstyle.lineSpacing = 3;
        [newGoodString addAttribute:NSParagraphStyleAttributeName value:paragraphstyle range:NSMakeRange(0, goodTotalString.length)];
        // 添加图片
        NSTextAttachment *attch = [[NSTextAttachment alloc] init];
        // 图片
        attch.image = [UIImage imageNamed:@"详情页点赞-提示"];
        // 设置图片大小
        attch.bounds = CGRectMake(0, 0, 14*WIDTH_SCALE, 14*WIDTH_SCALE);
        // 创建带有图片的富文本
        NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
        [newGoodString insertAttributedString:string atIndex:0];
        
        NSMutableAttributedString
        * attStr = [[NSMutableAttributedString alloc]initWithString:@" "];
        [newGoodString insertAttributedString:attStr atIndex:1];
        
        self.headView.thumlabel.attributedText = newGoodString;
        self.headView.thumlabel.numberOfLines = 0;
        //设置UILable自适
        self.headView.thumlabel.lineBreakMode = NSLineBreakByCharWrapping;
        [self.headView.thumlabel sizeToFit];
        
    }else
    {
        NSArray *smallArray = [thumarr subarrayWithRange:NSMakeRange(0, 12)];
        NSString *goodTotalString2 = [smallArray componentsJoinedByString:@", "];
        NSString *goodTotalString = [NSString stringWithFormat:@"%@%@%@%lu%@",goodTotalString2,@"等",@" ",(unsigned long)thumarr.count,@"人已赞"];
        NSMutableAttributedString *newGoodString = [[NSMutableAttributedString alloc] initWithString:goodTotalString];
        [newGoodString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, goodTotalString.length)];
        //设置行距 实际开发中间距为0太丑了，根据项目需求自己把握
        NSMutableParagraphStyle *paragraphstyle = [[NSMutableParagraphStyle alloc] init];
        paragraphstyle.lineSpacing = 3;
        [newGoodString addAttribute:NSParagraphStyleAttributeName value:paragraphstyle range:NSMakeRange(0, goodTotalString.length)];
        // 添加图片
        NSTextAttachment *attch = [[NSTextAttachment alloc] init];
        // 图片
        attch.image = [UIImage imageNamed:@"详情页点赞-提示"];
        // 设置图片大小
        attch.bounds = CGRectMake(0, 0, 14*WIDTH_SCALE, 14*WIDTH_SCALE);
        // 创建带有图片的富文本
        NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
        [newGoodString insertAttributedString:string atIndex:0];
        NSMutableAttributedString
        * attStr = [[NSMutableAttributedString alloc]initWithString:@" "];
        [newGoodString insertAttributedString:attStr atIndex:1];
        self.headView.thumlabel.attributedText = newGoodString;
        self.headView.thumlabel.numberOfLines = 0;
        //设置UILable自适
        self.headView.thumlabel.lineBreakMode = NSLineBreakByCharWrapping;
        [self.headView.thumlabel sizeToFit];
        
    }
    
    if (thumarr.count==0) {
        [self.headView.thumlabel setHidden:YES];
        
        if (content.length!=0&&urlstr.length!=0) {
            CGSize textSize = [self.headView.contentlab setText:self.headView.contentlab.text lines:QSTextDefaultLines andLineSpacing:QSTextLineSpacing constrainedToSize:CGSizeMake(DEVICE_WIDTH - 28*WIDTH_SCALE,MAXFLOAT)];
            
            self.headView.contentlab.frame = CGRectMake(14*WIDTH_SCALE,  24*HEIGHT_SCALE+14*HEIGHT_SCALE, textSize.width, textSize.height);
            [self.headView.headimg sd_setImageWithURL:[NSURL URLWithString:urlstr] placeholderImage:[UIImage imageNamed:@"默认图"]];
            [self.headView.headimg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.headView.contentlab.mas_bottom).with.offset(12*HEIGHT_SCALE);
                make.left.equalTo(self.headView).with.offset(14*WIDTH_SCALE);
                make.right.equalTo(self.headView).with.offset(-14*WIDTH_SCALE);
                make.height.mas_equalTo(192*HEIGHT_SCALE);
            }];
            [self.headView.title mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.headView).with.offset(14*WIDTH_SCALE);
                make.right.equalTo(self.headView).with.offset(-14*WIDTH_SCALE);
                make.top.equalTo(self.headView.headimg.mas_bottom).with.offset(2*HEIGHT_SCALE);
                make.height.mas_equalTo(20*HEIGHT_SCALE);
            }];
            [self.headView.timelab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.headView).with.offset(14*WIDTH_SCALE);
                make.top.equalTo(self.headView.title).with.offset(45*HEIGHT_SCALE);
            }];
            
            
            [self.headView.thumlabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.headView).with.offset(14*WIDTH_SCALE);
                make.right.equalTo(self.headView).with.offset(-14*WIDTH_SCALE);
                make.top.equalTo(self.headView.timelab).with.offset(33*HEIGHT_SCALE);
            }];
            [self.headView.sharebtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.headView).with.offset(-14*WIDTH_SCALE);
                make.top.equalTo(self.headView.title).with.offset(22*HEIGHT_SCALE+20*HEIGHT_SCALE);
            }];
            [self.headView.combtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.headView).with.offset(-70*WIDTH_SCALE);
                make.top.equalTo(self.headView.title).with.offset(22*HEIGHT_SCALE+20*HEIGHT_SCALE);
                [self.headView.combtn.textlab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.headView.title).with.offset(45*HEIGHT_SCALE);
                    make.right.equalTo(self.headView.sharebtn).with.offset(-40*WIDTH_SCALE);
                    make.height.mas_equalTo(20*HEIGHT_SCALE);
                }];
                [self.headView.combtn.leftimg mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.headView.title).with.offset(45*HEIGHT_SCALE);
                    make.right.equalTo(self.headView.combtn.textlab.mas_left).with.offset(-4*WIDTH_SCALE);
                    make.height.mas_equalTo(16*WIDTH_SCALE);
                    make.width.mas_equalTo(16*WIDTH_SCALE);
                }];
                
            }];
            [self.headView.dianzanbtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.headView.combtn).with.offset(-50*WIDTH_SCALE);
                make.top.equalTo(self.headView.title).with.offset(22*HEIGHT_SCALE+20*HEIGHT_SCALE);
                make.width.mas_equalTo(64*WIDTH_SCALE);
                [self.headView.dianzanbtn.zanlab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.headView.title).with.offset(45*HEIGHT_SCALE);
                    make.right.equalTo(self.headView.combtn.leftimg).with.offset(-40*WIDTH_SCALE);
                    make.height.mas_equalTo(20*HEIGHT_SCALE);
                }];
                [self.headView.dianzanbtn.zanimg mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.headView.title).with.offset(45*HEIGHT_SCALE);
                    make.right.equalTo(self.headView.dianzanbtn.zanlab.mas_left).with.offset(-4*WIDTH_SCALE);
                    make.height.mas_equalTo(16*WIDTH_SCALE);
                    make.width.mas_equalTo(16*WIDTH_SCALE);
                }];
            }];
            
            _headView.frame = CGRectMake(0, 0, DEVICE_WIDTH, textSize.height+340*HEIGHT_SCALE);
            headheight = _headView.frame.size.height;
            
        }
        else if (content.length==0&&urlstr.length!=0)
        {
            [self.headView.headimg sd_setImageWithURL:[NSURL URLWithString:urlstr] placeholderImage:[UIImage imageNamed:@"默认图"]];
            [self.headView.headimg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.headView.namelab.mas_bottom).with.offset(14*HEIGHT_SCALE);
                make.left.equalTo(self.headView).with.offset(14*WIDTH_SCALE);
                make.right.equalTo(self.headView).with.offset(-14*WIDTH_SCALE);
                make.height.mas_equalTo(192*HEIGHT_SCALE);
            }];
            [self.headView.title mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.headView).with.offset(14*WIDTH_SCALE);
                make.right.equalTo(self.headView).with.offset(-14*WIDTH_SCALE);
                make.top.equalTo(self.headView.headimg.mas_bottom).with.offset(2*HEIGHT_SCALE);
                make.height.mas_equalTo(20*HEIGHT_SCALE);
            }];
            [self.headView.timelab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.headView).with.offset(14*WIDTH_SCALE);
                make.top.equalTo(self.headView.title).with.offset(45*HEIGHT_SCALE);
            }];
            [self.headView.sharebtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.headView).with.offset(-14*WIDTH_SCALE);
                make.top.equalTo(self.headView.title).with.offset(22*HEIGHT_SCALE+20*HEIGHT_SCALE);
            }];
            [self.headView.combtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.headView).with.offset(-70*WIDTH_SCALE);
                make.top.equalTo(self.headView.title).with.offset(22*HEIGHT_SCALE+20*HEIGHT_SCALE);
                [self.headView.combtn.textlab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.headView.title).with.offset(45*HEIGHT_SCALE);
                    make.right.equalTo(self.headView.sharebtn).with.offset(-40*WIDTH_SCALE);
                    make.height.mas_equalTo(20*HEIGHT_SCALE);
                }];
                [self.headView.combtn.leftimg mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.headView.title).with.offset(45*HEIGHT_SCALE);
                    make.right.equalTo(self.headView.combtn.textlab.mas_left).with.offset(-4*WIDTH_SCALE);
                    make.height.mas_equalTo(16*WIDTH_SCALE);
                    make.width.mas_equalTo(16*WIDTH_SCALE);
                }];
                
            }];
            [self.headView.dianzanbtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.headView.combtn).with.offset(-50*WIDTH_SCALE);
                make.top.equalTo(self.headView.title).with.offset(22*HEIGHT_SCALE+20*HEIGHT_SCALE);
                make.width.mas_equalTo(64*WIDTH_SCALE);
                [self.headView.dianzanbtn.zanlab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.headView.title).with.offset(45*HEIGHT_SCALE);
                    make.right.equalTo(self.headView.combtn.leftimg).with.offset(-40*WIDTH_SCALE);
                    make.height.mas_equalTo(20*HEIGHT_SCALE);
                }];
                [self.headView.dianzanbtn.zanimg mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.headView.title).with.offset(45*HEIGHT_SCALE);
                    make.right.equalTo(self.headView.dianzanbtn.zanlab.mas_left).with.offset(-4*WIDTH_SCALE);
                    make.height.mas_equalTo(16*WIDTH_SCALE);
                    make.width.mas_equalTo(16*WIDTH_SCALE);
                }];
            }];
            
            _headView.frame = CGRectMake(0, 0, DEVICE_WIDTH, 380*HEIGHT_SCALE);
            headheight = _headView.frame.size.height;

        }else
        {
            
            CGSize textSize = [self.headView.contentlab setText:self.headView.contentlab.text lines:QSTextDefaultLines andLineSpacing:QSTextLineSpacing constrainedToSize:CGSizeMake(DEVICE_WIDTH - 28*WIDTH_SCALE,MAXFLOAT)];
            self.headView.contentlab.frame = CGRectMake(14*WIDTH_SCALE,  24*HEIGHT_SCALE+14*HEIGHT_SCALE, textSize.width, textSize.height);
            
            [self.headView.title mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.headView).with.offset(14*WIDTH_SCALE);
                make.right.equalTo(self.headView).with.offset(-14*WIDTH_SCALE);
                make.top.equalTo(self.headView.contentlab.mas_bottom).with.offset(2*HEIGHT_SCALE);
                make.height.mas_equalTo(20*HEIGHT_SCALE);
            }];
            [self.headView.timelab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.headView).with.offset(14*WIDTH_SCALE);
                make.top.equalTo(self.headView.title).with.offset(45*HEIGHT_SCALE);
            }];
            
            [self.headView.thumlabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.headView).with.offset(14*WIDTH_SCALE);
                make.right.equalTo(self.headView).with.offset(-14*WIDTH_SCALE);
                make.top.equalTo(self.headView.timelab).with.offset(33*HEIGHT_SCALE);
                
            }];
            [self.headView.sharebtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.headView).with.offset(-14*WIDTH_SCALE);
                make.top.equalTo(self.headView.title).with.offset(22*HEIGHT_SCALE+20*HEIGHT_SCALE);
            }];
            [self.headView.combtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.headView).with.offset(-70*WIDTH_SCALE);
                make.top.equalTo(self.headView.title).with.offset(22*HEIGHT_SCALE+20*HEIGHT_SCALE);
                [self.headView.combtn.textlab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.headView.title).with.offset(45*HEIGHT_SCALE);
                    make.right.equalTo(self.headView.sharebtn).with.offset(-40*WIDTH_SCALE);
                    make.height.mas_equalTo(20*HEIGHT_SCALE);
                }];
                [self.headView.combtn.leftimg mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.headView.title).with.offset(45*HEIGHT_SCALE);
                    make.right.equalTo(self.headView.combtn.textlab.mas_left).with.offset(-4*WIDTH_SCALE);
                    make.height.mas_equalTo(16*WIDTH_SCALE);
                    make.width.mas_equalTo(16*WIDTH_SCALE);
                }];
                
            }];
            [self.headView.dianzanbtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.headView.combtn).with.offset(-50*WIDTH_SCALE);
                make.top.equalTo(self.headView.title).with.offset(22*HEIGHT_SCALE+20*HEIGHT_SCALE);
                make.width.mas_equalTo(64*WIDTH_SCALE);
                [self.headView.dianzanbtn.zanlab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.headView.title).with.offset(45*HEIGHT_SCALE);
                    make.right.equalTo(self.headView.combtn.leftimg).with.offset(-40*WIDTH_SCALE);
                    make.height.mas_equalTo(20*HEIGHT_SCALE);
                }];
                [self.headView.dianzanbtn.zanimg mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.headView.title).with.offset(45*HEIGHT_SCALE);
                    make.right.equalTo(self.headView.dianzanbtn.zanlab.mas_left).with.offset(-4*WIDTH_SCALE);
                    make.height.mas_equalTo(16*WIDTH_SCALE);
                    make.width.mas_equalTo(16*WIDTH_SCALE);
                }];
            }];
            
            _headView.frame = CGRectMake(0, 0, DEVICE_WIDTH, textSize.height+160*HEIGHT_SCALE);
            headheight = _headView.frame.size.height;
    }
        
    }else
    {
        [self.headView.thumlabel setHidden:NO];
        if (content.length!=0&&urlstr.length!=0) {
            CGSize textSize = [self.headView.contentlab setText:self.headView.contentlab.text lines:QSTextDefaultLines andLineSpacing:QSTextLineSpacing constrainedToSize:CGSizeMake(DEVICE_WIDTH - 28*WIDTH_SCALE,MAXFLOAT)];
            CGSize textsize2= [self.headView.thumlabel.text boundingRectWithSize:CGSizeMake(DEVICE_WIDTH-28*WIDTH_SCALE, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
            
            self.headView.contentlab.frame = CGRectMake(14*WIDTH_SCALE,  24*HEIGHT_SCALE+14*HEIGHT_SCALE, textSize.width, textSize.height);
            
            [self.headView.headimg sd_setImageWithURL:[NSURL URLWithString:urlstr] placeholderImage:[UIImage imageNamed:@"默认图"]];
            
            [self.headView.headimg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.headView).with.offset(14*WIDTH_SCALE);
                make.right.equalTo(self.headView).with.offset(-14*WIDTH_SCALE);
                make.top.equalTo(self.headView.contentlab.mas_bottom).with.offset(12*HEIGHT_SCALE);
                make.height.mas_equalTo(192*WIDTH_SCALE);
            }];
            
            [self.headView.title mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.headView).with.offset(14*WIDTH_SCALE);
                make.right.equalTo(self.headView).with.offset(-14*WIDTH_SCALE);
                make.top.equalTo(self.headView.headimg.mas_bottom).with.offset(2*HEIGHT_SCALE);
                make.height.mas_equalTo(20*HEIGHT_SCALE);
            }];
            
            [self.headView.timelab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.headView).with.offset(14*WIDTH_SCALE);
                make.top.equalTo(self.headView.title).with.offset(45*HEIGHT_SCALE);
                
            }];
            
            [self.headView.thumlabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.headView).with.offset(14*WIDTH_SCALE);
                make.right.equalTo(self.headView).with.offset(-14*WIDTH_SCALE);
                make.top.equalTo(self.headView.timelab).with.offset(33*HEIGHT_SCALE);
            }];
            
            [self.headView.sharebtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.headView).with.offset(-14*WIDTH_SCALE);
                make.top.equalTo(self.headView.title).with.offset(22*HEIGHT_SCALE+20*HEIGHT_SCALE);
            }];
            
            [self.headView.combtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.headView).with.offset(-70*WIDTH_SCALE);
                make.top.equalTo(self.headView.title).with.offset(22*HEIGHT_SCALE+20*HEIGHT_SCALE);
                [self.headView.combtn.textlab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.headView.title).with.offset(45*HEIGHT_SCALE);
                    make.right.equalTo(self.headView.sharebtn).with.offset(-40*WIDTH_SCALE);
                    make.height.mas_equalTo(20*HEIGHT_SCALE);
                }];
                [self.headView.combtn.leftimg mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.headView.title).with.offset(45*HEIGHT_SCALE);
                    make.right.equalTo(self.headView.combtn.textlab.mas_left).with.offset(-4*WIDTH_SCALE);
                    make.height.mas_equalTo(16*WIDTH_SCALE);
                    make.width.mas_equalTo(16*WIDTH_SCALE);
                }];
                
            }];
            [self.headView.dianzanbtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.headView.combtn).with.offset(-50*WIDTH_SCALE);
                make.top.equalTo(self.headView.title).with.offset(22*HEIGHT_SCALE+20*HEIGHT_SCALE);
                make.width.mas_equalTo(64*WIDTH_SCALE);
                [self.headView.dianzanbtn.zanlab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.headView.title).with.offset(45*HEIGHT_SCALE);
                    make.right.equalTo(self.headView.combtn.leftimg).with.offset(-40*WIDTH_SCALE);
                    make.height.mas_equalTo(20*HEIGHT_SCALE);
                }];
                [self.headView.dianzanbtn.zanimg mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.headView.title).with.offset(45*HEIGHT_SCALE);
                    make.right.equalTo(self.headView.dianzanbtn.zanlab.mas_left).with.offset(-4*WIDTH_SCALE);
                    make.height.mas_equalTo(16*WIDTH_SCALE);
                    make.width.mas_equalTo(16*WIDTH_SCALE);
                }];
            }];
            
            _headView.frame = CGRectMake(0, 0, DEVICE_WIDTH, textSize.height+380*HEIGHT_SCALE+textsize2.height);
            headheight = _headView.frame.size.height;

        }
        else if (content.length==0&&urlstr.length!=0)
        {
            CGSize textsize2= [self.headView.thumlabel.text boundingRectWithSize:CGSizeMake(DEVICE_WIDTH-28*WIDTH_SCALE, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
            
            [self.headView.headimg sd_setImageWithURL:[NSURL URLWithString:urlstr] placeholderImage:[UIImage imageNamed:@"默认图"]];
            
            [self.headView.headimg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.headView).with.offset(14*WIDTH_SCALE);
                make.right.equalTo(self.headView).with.offset(-14*WIDTH_SCALE);
                make.top.equalTo(self.headView.namelab.mas_bottom).with.offset(12*HEIGHT_SCALE);
                make.height.mas_equalTo(192*WIDTH_SCALE);
            }];
            
            [self.headView.title mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.headView).with.offset(14*WIDTH_SCALE);
                make.right.equalTo(self.headView).with.offset(-14*WIDTH_SCALE);
                make.top.equalTo(self.headView.headimg.mas_bottom).with.offset(2*HEIGHT_SCALE);
                make.height.mas_equalTo(20*HEIGHT_SCALE);
            }];
            
            [self.headView.timelab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.headView).with.offset(14*WIDTH_SCALE);
                make.top.equalTo(self.headView.title).with.offset(45*HEIGHT_SCALE);
                
            }];
            
            [self.headView.thumlabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.headView).with.offset(14*WIDTH_SCALE);
                make.right.equalTo(self.headView).with.offset(-14*WIDTH_SCALE);
                make.top.equalTo(self.headView.timelab).with.offset(33*HEIGHT_SCALE);
                
            }];
            [self.headView.sharebtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.headView).with.offset(-14*WIDTH_SCALE);
                make.top.equalTo(self.headView.title).with.offset(42*HEIGHT_SCALE);
            }];
            [self.headView.combtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.headView).with.offset(-70*WIDTH_SCALE);
                make.top.equalTo(self.headView.title).with.offset(22*HEIGHT_SCALE+20*HEIGHT_SCALE);
                [self.headView.combtn.textlab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.headView.title).with.offset(45*HEIGHT_SCALE);
                    make.right.equalTo(self.headView.sharebtn).with.offset(-40*WIDTH_SCALE);
                    make.height.mas_equalTo(20*HEIGHT_SCALE);
                }];
                [self.headView.combtn.leftimg mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.headView.title).with.offset(45*HEIGHT_SCALE);
                    make.right.equalTo(self.headView.combtn.textlab.mas_left).with.offset(-4*WIDTH_SCALE);
                    make.height.mas_equalTo(16*WIDTH_SCALE);
                    make.width.mas_equalTo(16*WIDTH_SCALE);
                }];
                
            }];
            [self.headView.dianzanbtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.headView.combtn).with.offset(-50*WIDTH_SCALE);
                make.top.equalTo(self.headView.title).with.offset(22*HEIGHT_SCALE+20*HEIGHT_SCALE);
                make.width.mas_equalTo(64*WIDTH_SCALE);
                [self.headView.dianzanbtn.zanlab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.headView.title).with.offset(45*HEIGHT_SCALE);
                    make.right.equalTo(self.headView.combtn.leftimg).with.offset(-40*WIDTH_SCALE);
                    make.height.mas_equalTo(20*HEIGHT_SCALE);
                    
                }];
                [self.headView.dianzanbtn.zanimg mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.headView.title).with.offset(45*HEIGHT_SCALE);
                    make.right.equalTo(self.headView.dianzanbtn.zanlab.mas_left).with.offset(-4*WIDTH_SCALE);
                    make.height.mas_equalTo(16*WIDTH_SCALE);
                    make.width.mas_equalTo(16*WIDTH_SCALE);
                }];
            }];
            _headView.frame = CGRectMake(0, 0, DEVICE_WIDTH, 400*HEIGHT_SCALE+textsize2.height);
            headheight = _headView.frame.size.height;
            
        }else
        {
            CGSize textSize = [self.headView.contentlab setText:self.headView.contentlab.text lines:QSTextDefaultLines andLineSpacing:QSTextLineSpacing constrainedToSize:CGSizeMake(DEVICE_WIDTH - 28*WIDTH_SCALE,MAXFLOAT)];
            CGSize textsize2= [self.headView.thumlabel.text boundingRectWithSize:CGSizeMake(DEVICE_WIDTH-28*WIDTH_SCALE, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
            self.headView.contentlab.frame = CGRectMake(14*WIDTH_SCALE,  24*HEIGHT_SCALE+14*HEIGHT_SCALE, textSize.width, textSize.height);
            [self.headView.title mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.headView).with.offset(14*WIDTH_SCALE);
                make.right.equalTo(self.headView).with.offset(-14*WIDTH_SCALE);
                make.height.mas_equalTo(20*HEIGHT_SCALE);
                make.top.equalTo(self.headView.contentlab.mas_bottom).with.offset(2*HEIGHT_SCALE);
            }];
            [self.headView.timelab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.headView).with.offset(14*WIDTH_SCALE);
                make.top.equalTo(self.headView.title).with.offset(45*HEIGHT_SCALE);
            }];
            [self.headView.thumlabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.headView).with.offset(14*WIDTH_SCALE);
                make.right.equalTo(self.headView).with.offset(-14*WIDTH_SCALE);
                make.top.equalTo(self.headView.timelab).with.offset(33*HEIGHT_SCALE);
            }];
            [self.headView.sharebtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.headView).with.offset(-14*WIDTH_SCALE);
                make.top.equalTo(self.headView.title).with.offset(22*HEIGHT_SCALE+20*HEIGHT_SCALE);
            }];
            [self.headView.combtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.headView).with.offset(-70*WIDTH_SCALE);
                make.top.equalTo(self.headView.title).with.offset(22*HEIGHT_SCALE+20*HEIGHT_SCALE);
                [self.headView.combtn.textlab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.headView.title).with.offset(45*HEIGHT_SCALE);
                    make.right.equalTo(self.headView.sharebtn).with.offset(-40*WIDTH_SCALE);
                    make.height.mas_equalTo(20*HEIGHT_SCALE);
                }];
                [self.headView.combtn.leftimg mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.headView.title).with.offset(45*HEIGHT_SCALE);
                    make.right.equalTo(self.headView.combtn.textlab.mas_left).with.offset(-4*WIDTH_SCALE);
                    make.height.mas_equalTo(16*WIDTH_SCALE);
                    make.width.mas_equalTo(16*WIDTH_SCALE);
                }];
                
            }];
            [self.headView.dianzanbtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.headView.combtn).with.offset(-50*WIDTH_SCALE);
                make.top.equalTo(self.headView.title).with.offset(22*HEIGHT_SCALE+20*HEIGHT_SCALE);
                make.width.mas_equalTo(64*WIDTH_SCALE);
                [self.headView.dianzanbtn.zanlab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.headView.title).with.offset(45*HEIGHT_SCALE);
                    make.right.equalTo(self.headView.combtn.leftimg).with.offset(-40*WIDTH_SCALE);
                    make.height.mas_equalTo(20*HEIGHT_SCALE);
                }];
                [self.headView.dianzanbtn.zanimg mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.headView.title).with.offset(45*HEIGHT_SCALE);
                    make.right.equalTo(self.headView.dianzanbtn.zanlab.mas_left).with.offset(-4*WIDTH_SCALE);
                    make.height.mas_equalTo(16*WIDTH_SCALE);
                    make.width.mas_equalTo(16*WIDTH_SCALE);
                }];
            }];
            _headView.frame = CGRectMake(0, 0, DEVICE_WIDTH, textSize.height+180*HEIGHT_SCALE+textsize2.height);
            headheight = _headView.frame.size.height;
            
        }
    }
}


@end
