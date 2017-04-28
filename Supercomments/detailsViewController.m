//
//  detailsViewController.m
//  Supercomments
//
//  Created by 王俊钢 on 2017/4/8.
//  Copyright © 2017年 wangjungang. All rights reserved.
//

#import "detailsViewController.h"
#import "detailsheadView.h"
#import "headModel.h"
#import "pinglunCell.h"
#import "detailcellmodel.h"
#import "sectionView.h"
#import "SureWebViewController.h"
#import "loginViewController.h"
#import "Timestr.h"
#import "keyboardView.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "AppDelegate.h"
@interface detailsViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,UIScrollViewDelegate>
{
    int pn;
}
@property (nonatomic,assign) CGFloat height01;
@property (nonatomic,assign) CGFloat pinglunhei;
@property (nonatomic,strong) NSIndexPath *selectedIndexPath;
@property (nonatomic,strong) detailsheadView *headview;
@property (nonatomic,strong) headModel *headm;
@property (nonatomic,strong) UITableView *maintable;
@property (nonatomic,strong) NSMutableArray *detalisarr;
@property (nonatomic,strong) detailcellmodel *detailsmodel;
@property (nonatomic,strong) NSMutableArray *cellcontarr;
@property (nonatomic,strong) NSMutableArray *sonCommentarr;
@property (nonatomic,strong) sectionView *secview;

@property (nonatomic,strong) keyboardView *keyView;

@property (nonatomic,strong) NSString *fromkeyboard;

@property (nonatomic,strong) NSMutableArray *usernamearr;
@end
static NSString *detailsidentfid = @"detailsidentfid";

NSMutableArray * ymDataArray;

@implementation detailsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor wjColorFloat:@"333333"];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor wjColorFloat:@"333333"]}];
    
    self.title = @"详情";
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    pn=1;
    self.cellcontarr = [NSMutableArray array];
    self.detalisarr = [NSMutableArray array];
    self.headm.thumarray = [NSMutableArray array];
    // 3.1.下拉刷新
    [self addHeader];
    // 3.2.上拉加载更多
    [self addFooter];
    [self.view addSubview:self.maintable];
    [self.view addSubview:self.keyView];
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

#pragma mark - 刷新控件

- (void)addHeader
{
    // 头部刷新控件
    self.maintable.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshAction)];
    [self.maintable.mj_header beginRefreshing];
}

- (void)addFooter
{
    self.maintable.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshLoadMore)];
}

- (void)refreshAction {
    
    [self headerRefreshEndAction];
    
}

- (void)refreshLoadMore {
    
    [self footerRefreshEndAction];
}

-(void)headerRefreshEndAction
{
    [self.cellcontarr removeAllObjects];
    [self.detalisarr removeAllObjects];
    [self.sonCommentarr removeAllObjects];
    NSString *strurl = [NSString stringWithFormat:xiangqin,self.detalisidstr,@"1",[tokenstr tokenstrfrom]];
    [AFManager getReqURL:strurl block:^(id infor) {
        self.headm = [[headModel alloc] init];
        NSLog(@"info=---------------------%@",infor);
        NSDictionary *dic =  [infor objectForKey:@"info"];
        //头部
        self.headm.namestr = [dic objectForKey:@"name"];
        self.headm.contactstr = [dic objectForKey:@"content"];
        self.headm.fromstr = [NSString stringWithFormat:@"%@%@%@",@"网易老司机已赞",[dic objectForKey:@"support_count"],@"次"];
        self.headm.imgurlstr = [dic objectForKey:@"images"];
        self.headm.weburlstr = [dic objectForKey:@"url"];
        self.headm.objectidstr = [dic objectForKey:@"id"];
        self.headm.timestr = [Timestr datetime:[dic objectForKey:@"create_time"]];
        self.headm.shifoudianzanstr = [dic objectForKey:@"is_support"];
        self.headview.namelab.text = self.headm.namestr;
        self.headview.timelab.text = self.headm.timestr;
        self.headview.fromlab.text = self.headm.fromstr;
        self.headview.numberlab.text = [NSString stringWithFormat:@"%@%@",[dic objectForKey:@"reply_num"],@"人评论"];
        self.headview.dianzanbtn.zanlab.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"support_num"]];
        self.headview.combtn.textlab.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"reply_num"]];
        self.headview.contentlab.text = [dic objectForKey:@"content"];
        self.headview.timelab.text = self.headm.timestr;
        
        NSString *tit = [dic objectForKey:@"title"];
        NSString *tit2 = [NSString stringWithFormat:@"%@%@",@"标题:",tit];
        self.headview.title.titlelab.text = tit2;
        if ([self.headm.shifoudianzanstr isEqualToString:@"0"]) {
            self.headview.dianzanbtn.zanimg.image = [UIImage imageNamed:@"点赞-"];
        }else
        {
            self.headview.dianzanbtn.zanimg.image = [UIImage imageNamed:@"点赞-拷贝"];
        }
        
        self.usernamearr = [NSMutableArray array];
       // NSMutableArray *bookarr = [NSMutableArray array];
        self.headm.thumarray = [NSMutableArray array];
        self.headm.thumarray = [dic objectForKey:@"bookmark_user"];
        for (int i = 0; i<self.headm.thumarray.count; i++) {
            NSDictionary *bookdic = [NSDictionary dictionary];
            bookdic = [self.headm.thumarray objectAtIndex:i];
            NSString *usernamestr = [bookdic objectForKey:@"user_nickname"];
            [self.usernamearr addObject:usernamestr];
        }
        
        //NSArray *goodArray = usernamearr;
        //NSArray *goodArray = @[@"one",@"呵呵哒",@"呵呵",@"李白",@"呵呵",@"呵呵",@"呵呵",@"呵呵哒",@"项目需求",@"呵呵",@"呵呵哒",@"项目需求",@"呵呵",@"呵呵哒",@"项目需求",@"呵呵",@"呵呵哒",@"项目需求",@"呵呵",@"呵呵哒",@"项目需求",@"呵呵",@"呵呵哒",@"项目需求",@"呵呵",@"呵呵哒",@"项目需求",@"呵呵",@"呵呵哒",@"项目需求",@"呵呵",@"呵呵哒",@"项目需求"];
        
        
        [self headfromcontentstr:self.headm.contactstr andimageurl:self.headm.imgurlstr andgoodarr:self.usernamearr];
        //cell部分
        
        //section
        NSMutableArray *dtrarr = [NSMutableArray array];
        dtrarr = [dic objectForKey:@"all_comment"];
        self.sonCommentarr = [NSMutableArray array];
        for (int i = 0; i<dtrarr.count; i++) {
            NSDictionary *dicarr = [dtrarr objectAtIndex:i];
            self.detailsmodel = [[detailcellmodel alloc] init];
            self.detailsmodel.namestr = [dicarr objectForKey:@"p_nickname"];
            self.detailsmodel.timestr = [dicarr objectForKey:@"ctime"];
            self.detailsmodel.contstr = [dicarr objectForKey:@"content"];
            self.detailsmodel.pingarr = [dicarr objectForKey:@"sonComment"];
            self.detailsmodel.imgurlstr = [dicarr objectForKey:@"headImg"];
            self.detailsmodel.idstr = [dicarr objectForKey:@"id"];
            self.detailsmodel.touidstr = [dicarr objectForKey:@"uid"];
            NSMutableArray *commarr = [NSMutableArray array];
            commarr = [dicarr objectForKey:@"sonComment"];
            [self.sonCommentarr addObject:self.detailsmodel.pingarr];
            [self.detalisarr addObject:self.detailsmodel];
        }
        
        [self.maintable.mj_header endRefreshing];
        [self.maintable reloadData];
    } errorblock:^(NSError *error) {
         [self.maintable.mj_header endRefreshing];
    }];
    
}

-(void)footerRefreshEndAction
{
    pn ++;
    NSString *pnstr = [NSString stringWithFormat:@"%d",pn];
    NSString *strurl = [NSString stringWithFormat:xiangqin,self.detalisidstr,pnstr,[tokenstr tokenstrfrom]];
    [AFManager getReqURL:strurl block:^(id infor) {
        self.headm = [[headModel alloc] init];
        NSLog(@"info=---------------------%@",infor);
        NSDictionary *dic =  [infor objectForKey:@"info"];
        //cell部分
        NSMutableArray *dtrarr = [NSMutableArray array];
        dtrarr = [dic objectForKey:@"all_comment"];
        self.sonCommentarr = [NSMutableArray array];
        NSLog(@"all_comment=========%@",dtrarr);
        for (int i = 0; i<dtrarr.count; i++) {
            NSDictionary *dicarr = [dtrarr objectAtIndex:i];
            self.detailsmodel = [[detailcellmodel alloc] init];
            self.detailsmodel.namestr = [dicarr objectForKey:@"p_nickname"];
            self.detailsmodel.timestr = [dicarr objectForKey:@"ctime"];
            self.detailsmodel.contstr = [dicarr objectForKey:@"content"];
            self.detailsmodel.imgurlstr = [dicarr objectForKey:@"headImg"];
            self.detailsmodel.pingarr = [dicarr objectForKey:@"sonComment"];
            self.detailsmodel.idstr = [dicarr objectForKey:@"id"];
            self.detailsmodel.touidstr = [dicarr objectForKey:@"uid"];
            NSMutableArray *commarr = [NSMutableArray array];
            commarr = [dicarr objectForKey:@"sonComment"];
            [self.cellcontarr addObject:[NSString stringWithFormat:@"%lu",(unsigned long)commarr.count]];
            [self.sonCommentarr addObject:self.detailsmodel.pingarr];
            [self.detalisarr addObject:self.detailsmodel];
        }
        [self.maintable.mj_footer endRefreshing];
        [self.maintable reloadData];
    } errorblock:^(NSError *error) {
        [self.maintable.mj_footer endRefreshing];
    }];
}

#pragma mark - getters

-(detailsheadView *)headview
{
    if(!_headview)
    {
        _headview = [[detailsheadView alloc] init];
        //_headview.layer.masksToBounds = YES;
       // _headview.layer.borderWidth = 3;
        [_headview.sharebtn addTarget:self action:@selector(shareclick) forControlEvents:UIControlEventTouchUpInside];
        [_headview.dianzanbtn addTarget:self action:@selector(dianzanclick) forControlEvents:UIControlEventTouchUpInside];
        [_headview.combtn addTarget:self action:@selector(pinglunclick) forControlEvents:UIControlEventTouchUpInside];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(webimagego)];
        [_headview.title addGestureRecognizer:tap];
    }
    return _headview;
}

-(UITableView *)maintable
{
    if(!_maintable)
    {
        _maintable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT-64) style:UITableViewStylePlain];
        _maintable.dataSource = self;
        _maintable.delegate = self;
        _maintable.tableHeaderView = self.headview;
        _maintable.backgroundColor = [UIColor whiteColor];
        _maintable.emptyDataSetSource = self;
        _maintable.emptyDataSetDelegate = self;
        _maintable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _maintable;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.maintable)
    {
        CGFloat sectionHeaderHeight = 40;
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}

-(keyboardView *)keyView
{
    if(!_keyView)
    {
        _keyView = [[keyboardView alloc] init];
        //_keyView.backgroundColor = [UIColor greenColor];
        _keyView.frame = CGRectMake(0, DEVICE_HEIGHT-64-44, DEVICE_WIDTH, 44);
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
        
        [_keyView.sendbtn addTarget:self action:@selector(sendbtnclick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _keyView;
}

#pragma mark - UITableViewDataSource && UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    self.detailsmodel = self.detalisarr[section];
    return self.detailsmodel.pingarr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    pinglunCell *cell = [tableView dequeueReusableCellWithIdentifier:detailsidentfid];
    if (!cell) {
        cell = [[pinglunCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:detailsidentfid];
    }
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    _detailsmodel  = self.detalisarr[indexPath.section];
    
    // 取第indexPath.row这行对应的品牌名称
    NSString *str4 = [_detailsmodel.pingarr[indexPath.row] objectForKey:@"content"];
    NSString *str1 = [_detailsmodel.pingarr[indexPath.row]objectForKey:@"s_nickname"];
    NSString *str3 = [_detailsmodel.pingarr[indexPath.row]objectForKey:@"s_to_nickname"];
    NSString *str2 = @"回复: ";
    
    
    if ([self isNullToString:str3]) {
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@%@",str1,str2,str4]];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor wjColorFloat:@"CDCDC7"] range:NSMakeRange(0,str1.length)];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor wjColorFloat:@"333333"] range:NSMakeRange(str1.length,str2.length)];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor wjColorFloat:@"333333"] range:NSMakeRange(str1.length+str2.length, str4.length)];
        NSLog(@"str===============%@",str);
        CGSize size = [str boundingRectWithSize:CGSizeMake(DEVICE_WIDTH -64*WIDTH_SCALE-14*WIDTH_SCALE, 0) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        cell.pinglunlab.attributedText = str;
        cell.pinglunlab.frame = CGRectMake(128/2*WIDTH_SCALE,  8*HEIGHT_SCALE, DEVICE_WIDTH -64*WIDTH_SCALE-14*WIDTH_SCALE, size.height);
        cell.pinglunlab.font = [UIFont systemFontOfSize:14*FX];
    }
    else
    {
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@%@%@",str1,str2,str3,str4]];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor wjColorFloat:@"CDCDC7"] range:NSMakeRange(0,str1.length)];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor wjColorFloat:@"333333"] range:NSMakeRange(str1.length,str2.length)];
        
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor wjColorFloat:@"CDCDC7"] range:NSMakeRange(str1.length+str2.length,str3.length)];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor wjColorFloat:@"333333"] range:NSMakeRange(str1.length+str2.length+str3.length,str4.length)];
        NSLog(@"str===============%@",str);
        CGSize size = [str boundingRectWithSize:CGSizeMake(DEVICE_WIDTH -64*WIDTH_SCALE-14*WIDTH_SCALE, 0) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        cell.pinglunlab.attributedText = str;
        cell.pinglunlab.frame = CGRectMake(128/2*WIDTH_SCALE,  8*HEIGHT_SCALE, DEVICE_WIDTH -64*WIDTH_SCALE-14*WIDTH_SCALE, size.height);
        cell.pinglunlab.font = [UIFont systemFontOfSize:14*FX];
    }
    cell.pinglunlab.numberOfLines = 0;
    [cell.pinglunlab sizeToFit];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.detalisarr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    _detailsmodel  = self.detalisarr[indexPath.section];
    // 取车第indexPath.row这行对应的名称
    
    NSString *str4 = [_detailsmodel.pingarr[indexPath.row] objectForKey:@"content"];
    NSString *str1 = [_detailsmodel.pingarr[indexPath.row]objectForKey:@"s_nickname"];
    NSString *str3 = [_detailsmodel.pingarr[indexPath.row]objectForKey:@"s_to_nickname"];
    NSString *str2 = @"回复: ";
    
    if ([self isNullToString:str3]) {
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@%@",str1,str2,str4]];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor wjColorFloat:@"CDCDC7"] range:NSMakeRange(0,str1.length)];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor wjColorFloat:@"333333"] range:NSMakeRange(str1.length,str2.length)];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor wjColorFloat:@"333333"] range:NSMakeRange(str1.length+str2.length, str4.length)];
        CGSize size = [str boundingRectWithSize:CGSizeMake(DEVICE_WIDTH -64*WIDTH_SCALE-14*WIDTH_SCALE, 0) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        return size.height + 16*HEIGHT_SCALE;
    }
    else
    {
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@%@%@",str1,str2,str3,str4]];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor wjColorFloat:@"CDCDC7"] range:NSMakeRange(0,str1.length)];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor wjColorFloat:@"333333"] range:NSMakeRange(str1.length,str2.length)];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor wjColorFloat:@"CDCDC7"] range:NSMakeRange(str1.length+str2.length,str3.length)];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor wjColorFloat:@"333333"] range:NSMakeRange(str1.length+str2.length+str3.length,str4.length)];
        CGSize size = [str boundingRectWithSize:CGSizeMake(DEVICE_WIDTH -64*WIDTH_SCALE-14*WIDTH_SCALE, 0) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        return size.height + 16*HEIGHT_SCALE;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    self.detailsmodel = self.detalisarr[section];
    return  [sectionView cellHeightWithText:self.detailsmodel.contstr]+70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 14;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    self.secview = [[sectionView alloc] init];
    self.secview.backgroundColor = [UIColor whiteColor];
    [self.secview setcelldata:self.detalisarr[section]];
    self.secview.layer.masksToBounds = YES;

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, self.view.frame.size.width, 54)];
    [button setTag:section+1];
    button.backgroundColor = [UIColor whiteColor];
    // 设置Image
    button.alpha = 0.1;
    
    // 设置偏移量
    CGFloat imageOriginX = button.imageView.frame.origin.x;
    CGFloat imageWidth = button.imageView.frame.size.width;
    CGFloat titleOriginX = button.titleLabel.frame.origin.x;
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, -titleOriginX+imageWidth + 20, 0, titleOriginX-imageWidth-20)];
    button.imageEdgeInsets = UIEdgeInsetsMake(0, -imageOriginX + 10, 0, imageOriginX -  10);
    // 添加点击事件
    [button addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
    [_secview addSubview:button];
    
    return _secview;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 14)];
    view.backgroundColor = [UIColor whiteColor];
    UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(0, 13, DEVICE_WIDTH, 0.7)];
    lineview.backgroundColor = [UIColor wjColorFloat:@"C7C7CD"];
    [view addSubview:lineview];
    return view;
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
    NSArray* imageArray = @[[UIImage imageNamed:@"牛评"]];
    
    //（注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    if (imageArray) {
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:@"分享内容"
                                         images:imageArray
                                            url:[NSURL URLWithString:@"http://mob.com"]
                                          title:@"分享标题"
                                           type:SSDKContentTypeAuto];
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
    
    if ([self.headm.shifoudianzanstr isEqualToString:@"0"]) {
       
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
                    self.headview.dianzanbtn.zanimg.image = [UIImage imageNamed:@"点赞-拷贝"];
                    [MBProgressHUD showSuccess:@"点赞"];
                    NSLog(@"成功");
                    
                    self.headm.shifoudianzanstr = @"1";
                    [self.usernamearr addObject:[tokenstr nicknamestrfrom]];
                    
                    NSLog(@"headmarr-----%@",self.usernamearr);
                    
                    dispatch_async(dispatch_get_main_queue(), ^
                        {
                            // 更UI
                            [self headfromcontentstr:self.headm.contactstr andimageurl:self.headm.imgurlstr andgoodarr:self.usernamearr];
                        });
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

            
          
            [self.maintable reloadData];
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
                    self.headm.shifoudianzanstr = @"0";
                    self.headview.dianzanbtn.zanimg.image = [UIImage imageNamed:@"点赞-"];
                    [MBProgressHUD showSuccess:@"取消点赞"];
                    NSLog(@"成功");
                    [self.usernamearr removeObjectAtIndex:self.usernamearr.count-1];
                    dispatch_async(dispatch_get_main_queue(), ^
                    {
                                       // 更UI
                         [self headfromcontentstr:self.headm.contactstr andimageurl:self.headm.imgurlstr andgoodarr:self.usernamearr];
                    });
                  
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
                
            }];
            
        }
        
            [self.maintable reloadData];
            
        }
    }

#pragma mark - 评论方法
//一级评论
-(void)pinglunclick
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
        self.maintable.alpha = 0.4;
        self.fromkeyboard = @"zhupinglun";
        [self.keyView.textview becomeFirstResponder];
    }

}
//二级评论
- (void)buttonPress:(UIButton *)sender {
  

    if ([tokenstr tokenstrfrom].length==0) {
        NSLog(@"请登陆");
        loginViewController *logvc = [[loginViewController alloc] init];
        logvc.jinru = @"jinru";
        [self presentViewController:logvc animated:YES completion:^{
            
        }];
    }
    else
    {
        self.maintable.alpha = 0.4;
        NSLog(@"index==%ld",(long)sender.tag);
        [self.keyView.textview becomeFirstResponder];
        self.fromkeyboard = @"section";
        self.keyView.secindex = (long)sender.tag-1;
        
    }
}
//三级评论
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([tokenstr tokenstrfrom].length==0) {
        NSLog(@"请登陆");
        loginViewController *logvc = [[loginViewController alloc] init];
        logvc.jinru = @"jinru";
        [self presentViewController:logvc animated:YES completion:^{
            
        }];
    }
    else
    {
        self.maintable.alpha = 0.4;
        self.fromkeyboard = @"cellpinglun";
        [self.keyView.textview becomeFirstResponder];
        self.keyView.index = indexPath.section;
        self.detailsmodel  = self.detalisarr[indexPath.section];
        self.keyView.nickname = [_detailsmodel.pingarr[indexPath.row]objectForKey:@"s_nickname"];
        self.keyView.tonickname = [_detailsmodel.pingarr[indexPath.row]objectForKey:@"s_to_nickname"];
        self.keyView.pidstr = [_detailsmodel.pingarr[indexPath.row]objectForKey:@"pid"];
        self.keyView.touidstr = [_detailsmodel.pingarr[indexPath.row]objectForKey:@"to_uid"];
        
    }
    NSLog(@"点击cell");
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
        self.maintable.alpha = 0.4;
        
    }];
}

//当键退出时调用

- (void)keyboardWillHide:(NSNotification *)aNotification
{
    [UIView animateWithDuration:[aNotification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        self.maintable.alpha = 1;
        self.keyView.transform=CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
        self.keyView.textview.text=@"";
        //[self.keyView removeFromSuperview];
    }];
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
        //三级评论
        if ([_fromkeyboard isEqualToString:@"cellpinglun"]) {
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *namestr = [defaults objectForKey:@"namestr"];
            
            self.detailsmodel  = self.detalisarr[self.keyView.index];
            NSMutableArray *mutaArray = [[NSMutableArray alloc] init];
            [mutaArray addObjectsFromArray:self.detailsmodel.pingarr];
            NSDictionary *dit = @{@"content":self.keyView.textview.text,@"s_nickname":namestr,@"s_to_nickname":self.keyView.nickname};
            [mutaArray addObject:dit];
            self.detailsmodel.pingarr = mutaArray;
            [self.maintable reloadData];
            
            //网络请求
            NSDictionary *para = @{@"token":[tokenstr tokenstrfrom],@"to_uid":self.keyView.touidstr,@"object_id":self.headm.objectidstr,@"content":self.keyView.textview.text,@"pid":self.keyView.pidstr};
            
            [CLNetworkingManager postCacheRequestWithUrlString:pinglunhuifu parameters:para cacheTime:YES succeed:^(id data) {
                NSLog(@"data-------%@",data);
                
            } fail:^(NSError *error) {
                
            }];
            
        }else if([_fromkeyboard isEqualToString:@"section"])
        {
            //二级评论
            self.detailsmodel  = self.detalisarr[self.keyView.secindex];
            NSString *pidstr = self.detailsmodel.idstr;
            NSString *uidstr = self.detailsmodel.touidstr;
            
            NSMutableArray *mutaArray = [[NSMutableArray alloc] init];
            [mutaArray addObjectsFromArray:self.detailsmodel.pingarr];
            NSString *tonickname = self.detailsmodel.namestr;
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *namestr = [defaults objectForKey:@"namestr"];
            NSDictionary *dit = @{@"content":self.keyView.textview.text,@"s_nickname":namestr,@"s_to_nickname":tonickname};
            [mutaArray addObject:dit];
            self.detailsmodel.pingarr = mutaArray;
            [self.maintable reloadData];
            
            //网络请求
            NSDictionary *para = @{@"token":[tokenstr tokenstrfrom],@"to_uid":uidstr,@"object_id":self.headm.objectidstr,@"content":self.keyView.textview.text,@"pid":pidstr};
            
            [CLNetworkingManager postCacheRequestWithUrlString:pinglunhuifu parameters:para cacheTime:YES succeed:^(id data) {
                NSLog(@"data-------%@",data);
                
            } fail:^(NSError *error) {
                
            }];
        }
        else
        {
            //                一级评论
            self.detailsmodel = [[detailcellmodel alloc] init];
            NSMutableArray *mutaArray = [[NSMutableArray alloc] init];
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *namestr = [defaults objectForKey:@"namestr"];
            NSString *name = namestr;
            NSString *nowtime = [Timestr getNowTimestamp];
            NSString *content = self.keyView.textview.text;
            NSString *imageurl = @"";
            self.detailsmodel.namestr = name;
            self.detailsmodel.timestr = nowtime;
            self.detailsmodel.contstr = content;
            self.detailsmodel.imgurlstr = imageurl;
            [mutaArray addObject:self.detailsmodel];
            [mutaArray addObjectsFromArray:self.detalisarr];
            self.detalisarr = mutaArray;
            
            [self.maintable reloadData];
            
            //网络请求
            NSDictionary *para = @{@"token":[tokenstr tokenstrfrom],@"to_uid":@"0",@"object_id":self.headm.objectidstr,@"content":self.keyView.textview.text,@"pid":@"0"};
            
            [CLNetworkingManager postCacheRequestWithUrlString:pinglunhuifu parameters:para cacheTime:YES succeed:^(id data) {
                NSLog(@"data-------%@",data);
                
            } fail:^(NSError *error) {
                
            }];
            
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
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                NSString *namestr = [defaults objectForKey:@"namestr"];
                
                self.detailsmodel  = self.detalisarr[self.keyView.index];
                NSMutableArray *mutaArray = [[NSMutableArray alloc] init];
                [mutaArray addObjectsFromArray:self.detailsmodel.pingarr];
                NSDictionary *dit = @{@"content":self.keyView.textview.text,@"s_nickname":namestr,@"s_to_nickname":self.keyView.nickname};
                [mutaArray addObject:dit];
                self.detailsmodel.pingarr = mutaArray;
                [self.maintable reloadData];
                
                //网络请求
                NSDictionary *para = @{@"token":[tokenstr tokenstrfrom],@"to_uid":self.keyView.touidstr,@"object_id":self.headm.objectidstr,@"content":self.keyView.textview.text,@"pid":self.keyView.pidstr};
                
                [CLNetworkingManager postCacheRequestWithUrlString:pinglunhuifu parameters:para cacheTime:YES succeed:^(id data) {
                    NSLog(@"data-------%@",data);
                    
                } fail:^(NSError *error) {
                    
                }];
                
            }else if([_fromkeyboard isEqualToString:@"section"])
            {
                //二级评论
                self.detailsmodel  = self.detalisarr[self.keyView.secindex];
                NSString *pidstr = self.detailsmodel.idstr;
                NSString *uidstr = self.detailsmodel.touidstr;
                
                NSMutableArray *mutaArray = [[NSMutableArray alloc] init];
                [mutaArray addObjectsFromArray:self.detailsmodel.pingarr];
                NSString *tonickname = self.detailsmodel.namestr;
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                NSString *namestr = [defaults objectForKey:@"namestr"];
                NSDictionary *dit = @{@"content":self.keyView.textview.text,@"s_nickname":namestr,@"s_to_nickname":tonickname};
                [mutaArray addObject:dit];
                self.detailsmodel.pingarr = mutaArray;
                [self.maintable reloadData];
                
                //网络请求
                NSDictionary *para = @{@"token":[tokenstr tokenstrfrom],@"to_uid":uidstr,@"object_id":self.headm.objectidstr,@"content":self.keyView.textview.text,@"pid":pidstr};
                
                [CLNetworkingManager postCacheRequestWithUrlString:pinglunhuifu parameters:para cacheTime:YES succeed:^(id data) {
                    NSLog(@"data-------%@",data);
                    
                } fail:^(NSError *error) {
                    
                }];
            }
            else
            {
//                一级评论
                self.detailsmodel = [[detailcellmodel alloc] init];
                NSMutableArray *mutaArray = [[NSMutableArray alloc] init];
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                NSString *namestr = [defaults objectForKey:@"namestr"];
                NSString *name = namestr;
                NSString *nowtime = [Timestr getNowTimestamp];
                NSString *content = self.keyView.textview.text;
                NSString *imageurl = @"";
                self.detailsmodel.namestr = name;
                self.detailsmodel.timestr = nowtime;
                self.detailsmodel.contstr = content;
                self.detailsmodel.imgurlstr = imageurl;
                [mutaArray addObject:self.detailsmodel];
                [mutaArray addObjectsFromArray:self.detalisarr];
                self.detalisarr = mutaArray;
                
                [self.maintable reloadData];
                
                //网络请求
                NSDictionary *para = @{@"token":[tokenstr tokenstrfrom],@"to_uid":@"0",@"object_id":self.headm.objectidstr,@"content":self.keyView.textview.text,@"pid":@"0"};
                
                [CLNetworkingManager postCacheRequestWithUrlString:pinglunhuifu parameters:para cacheTime:YES succeed:^(id data) {
                    NSLog(@"data-------%@",data);
                    
                } fail:^(NSError *error) {
                    
                }];

            }
        }
    
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    return YES;

}


#pragma mark - 图片放大方法

-(void)webimagego
{
    NSString *urlstr = self.headm.weburlstr;
    NSLog(@"urlstr-------%@",urlstr);
    SureWebViewController *surevc = [[SureWebViewController alloc]init];
    surevc.url = urlstr;
    surevc.canDownRefresh = YES;
    [self.navigationController pushViewController:surevc animated:YES];
    
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

#pragma mark - headfrom

-(void)headfromcontentstr:(NSString *)content andimageurl:(NSString *)urlstr andgoodarr:(NSArray *)thumarr
{
    if (thumarr.count<=12) {
        NSString *goodTotalString2 = [thumarr componentsJoinedByString:@", "];
        NSString *goodTotalString = [NSString stringWithFormat:@"%@%lu%@",goodTotalString2,(unsigned long)thumarr.count,@"人已赞"];
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
        self.headview.thumlabel.attributedText = newGoodString;
        self.headview.thumlabel.numberOfLines = 0;
        //设置UILable自适
        self.headview.thumlabel.lineBreakMode = NSLineBreakByCharWrapping;
        [self.headview.thumlabel sizeToFit];
        
    }else
    {
        NSArray *smallArray = [thumarr subarrayWithRange:NSMakeRange(0, 12)];
        NSString *goodTotalString2 = [smallArray componentsJoinedByString:@", "];
        NSString *goodTotalString = [NSString stringWithFormat:@"%@%@%lu%@",goodTotalString2,@"等",(unsigned long)thumarr.count,@"人已赞"];
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
        self.headview.thumlabel.attributedText = newGoodString;
        self.headview.thumlabel.numberOfLines = 0;
        //设置UILable自适
        self.headview.thumlabel.lineBreakMode = NSLineBreakByCharWrapping;
        [self.headview.thumlabel sizeToFit];
        
    }

    
    
    
    
    
    
    if (thumarr.count==0) {
        [self.headview.thumlabel setHidden:YES];
        if (content.length!=0&&urlstr.length!=0) {
            CGSize textSize = [self.headview.contentlab setText:self.headview.contentlab.text lines:QSTextDefaultLines andLineSpacing:QSTextLineSpacing constrainedToSize:CGSizeMake(DEVICE_WIDTH - 28*WIDTH_SCALE,MAXFLOAT)];
            
            self.headview.contentlab.frame = CGRectMake(14*WIDTH_SCALE,  30*HEIGHT_SCALE+14*HEIGHT_SCALE, textSize.width, textSize.height);
            [self.headview.headimg sd_setImageWithURL:[NSURL URLWithString:self.headm.imgurlstr] placeholderImage:[UIImage imageNamed:@"默认图"]];
            self.headview.headimg.frame =CGRectMake(14*WIDTH_SCALE, 30*HEIGHT_SCALE+textSize.height*HEIGHT_SCALE+14*HEIGHT_SCALE+14*HEIGHT_SCALE, DEVICE_WIDTH-28*WIDTH_SCALE, 200*HEIGHT_SCALE);
            self.headview.title.frame = CGRectMake(14*WIDTH_SCALE,  30*HEIGHT_SCALE+textSize.height*HEIGHT_SCALE+14*HEIGHT_SCALE+200*HEIGHT_SCALE+4*HEIGHT_SCALE+14*HEIGHT_SCALE, DEVICE_WIDTH-28*WIDTH_SCALE, 20*HEIGHT_SCALE);
            self.headview.timelab.frame = CGRectMake(14*WIDTH_SCALE, 30*HEIGHT_SCALE+textSize.height*HEIGHT_SCALE+14*HEIGHT_SCALE+200*HEIGHT_SCALE+4*HEIGHT_SCALE+14*HEIGHT_SCALE+14*HEIGHT_SCALE+14*HEIGHT_SCALE+14*HEIGHT_SCALE, 100*WIDTH_SCALE, 12*HEIGHT_SCALE);
            [self.headview.combtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.headview).with.offset(-70*WIDTH_SCALE);
                make.top.equalTo(self.headview.title).with.offset(15*HEIGHT_SCALE+20*HEIGHT_SCALE);
            }];
            [self.headview.dianzanbtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.headview).with.offset(-140*WIDTH_SCALE);
                make.top.equalTo(self.headview.title).with.offset(15*HEIGHT_SCALE+20*HEIGHT_SCALE);
            }];
            [self.headview.sharebtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.headview).with.offset(-14*WIDTH_SCALE);
                make.top.equalTo(self.headview.title).with.offset(15*HEIGHT_SCALE+20*HEIGHT_SCALE);
            }];
            
            _headview.frame = CGRectMake(0, 0, DEVICE_WIDTH, textSize.height+380*HEIGHT_SCALE);
        }
        else if (content.length==0&&urlstr.length!=0)
        {
            [self.headview.headimg sd_setImageWithURL:[NSURL URLWithString:self.headm.imgurlstr] placeholderImage:[UIImage imageNamed:@"默认图"]];
            self.headview.headimg.frame =CGRectMake(14*WIDTH_SCALE, 30*HEIGHT_SCALE+14*HEIGHT_SCALE, DEVICE_WIDTH-28*WIDTH_SCALE, 200*HEIGHT_SCALE);
            self.headview.title.frame = CGRectMake(14*WIDTH_SCALE,  30*HEIGHT_SCALE+200*HEIGHT_SCALE+4*HEIGHT_SCALE+14*HEIGHT_SCALE, DEVICE_WIDTH-28*WIDTH_SCALE, 20*HEIGHT_SCALE);
            self.headview.timelab.frame = CGRectMake(14*WIDTH_SCALE, 30*HEIGHT_SCALE+200*HEIGHT_SCALE+4*HEIGHT_SCALE+14*HEIGHT_SCALE+14*HEIGHT_SCALE+14*HEIGHT_SCALE+14*HEIGHT_SCALE, 100*WIDTH_SCALE, 12*HEIGHT_SCALE);
            [self.headview.combtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.headview).with.offset(-70*WIDTH_SCALE);
                make.top.equalTo(self.headview.title).with.offset(15*HEIGHT_SCALE+20*HEIGHT_SCALE);
            }];
            [self.headview.dianzanbtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.headview).with.offset(-140*WIDTH_SCALE);
                make.top.equalTo(self.headview.title).with.offset(15*HEIGHT_SCALE+20*HEIGHT_SCALE);
            }];
            [self.headview.sharebtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.headview).with.offset(-14*WIDTH_SCALE);
                make.top.equalTo(self.headview.title).with.offset(15*HEIGHT_SCALE+20*HEIGHT_SCALE);
            }];
            _headview.frame = CGRectMake(0, 0, DEVICE_WIDTH, 380*HEIGHT_SCALE);
            //_maintable.frame = CGRectMake(0, -40, DEVICE_WIDTH, DEVICE_HEIGHT-24);
        }else
        {
            CGSize textSize = [self.headview.contentlab setText:self.headview.contentlab.text lines:QSTextDefaultLines andLineSpacing:QSTextLineSpacing constrainedToSize:CGSizeMake(DEVICE_WIDTH - 28*WIDTH_SCALE,MAXFLOAT)];
            self.headview.contentlab.frame = CGRectMake(14*WIDTH_SCALE,  30*HEIGHT_SCALE+14*HEIGHT_SCALE, textSize.width, textSize.height);
            self.headview.title.frame = CGRectMake(14*WIDTH_SCALE,  30*HEIGHT_SCALE+textSize.height*HEIGHT_SCALE+4*HEIGHT_SCALE+14*HEIGHT_SCALE, DEVICE_WIDTH-28*WIDTH_SCALE, 20*HEIGHT_SCALE);
            self.headview.timelab.frame = CGRectMake(14*WIDTH_SCALE, 30*HEIGHT_SCALE+textSize.height*HEIGHT_SCALE+4*HEIGHT_SCALE+14*HEIGHT_SCALE+14*HEIGHT_SCALE+14*HEIGHT_SCALE+14*HEIGHT_SCALE, 100*WIDTH_SCALE, 12*HEIGHT_SCALE);
            [self.headview.combtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.headview).with.offset(-70*WIDTH_SCALE);
                make.top.equalTo(self.headview.title).with.offset(15*HEIGHT_SCALE+20*HEIGHT_SCALE);
            }];
            [self.headview.dianzanbtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.headview).with.offset(-140*WIDTH_SCALE);
                make.top.equalTo(self.headview.title).with.offset(15*HEIGHT_SCALE+20*HEIGHT_SCALE);
            }];
            [self.headview.sharebtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.headview).with.offset(-14*WIDTH_SCALE);
                make.top.equalTo(self.headview.title).with.offset(15*HEIGHT_SCALE+20*HEIGHT_SCALE);
            }];
            _headview.frame = CGRectMake(0, 0, DEVICE_WIDTH, textSize.height+160*HEIGHT_SCALE);
        }

    }else
    {
        [self.headview.thumlabel setHidden:NO];
        if (content.length!=0&&urlstr.length!=0) {
            CGSize textSize = [self.headview.contentlab setText:self.headview.contentlab.text lines:QSTextDefaultLines andLineSpacing:QSTextLineSpacing constrainedToSize:CGSizeMake(DEVICE_WIDTH - 28*WIDTH_SCALE,MAXFLOAT)];
            CGSize textsize2= [self.headview.thumlabel.text boundingRectWithSize:CGSizeMake(DEVICE_WIDTH-28*WIDTH_SCALE, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
            
            self.headview.contentlab.frame = CGRectMake(14*WIDTH_SCALE,  30*HEIGHT_SCALE+14*HEIGHT_SCALE, textSize.width, textSize.height);
            [self.headview.headimg sd_setImageWithURL:[NSURL URLWithString:self.headm.imgurlstr] placeholderImage:[UIImage imageNamed:@"默认图"]];
            self.headview.headimg.frame =CGRectMake(14*WIDTH_SCALE, 30*HEIGHT_SCALE+textSize.height*HEIGHT_SCALE+14*HEIGHT_SCALE+14*HEIGHT_SCALE, DEVICE_WIDTH-28*WIDTH_SCALE, 200*HEIGHT_SCALE);
            self.headview.title.frame = CGRectMake(14*WIDTH_SCALE,  30*HEIGHT_SCALE+textSize.height*HEIGHT_SCALE+14*HEIGHT_SCALE+200*HEIGHT_SCALE+4*HEIGHT_SCALE+14*HEIGHT_SCALE, DEVICE_WIDTH-28*WIDTH_SCALE, 20*HEIGHT_SCALE);
            self.headview.timelab.frame = CGRectMake(14*WIDTH_SCALE, 30*HEIGHT_SCALE+textSize.height*HEIGHT_SCALE+14*HEIGHT_SCALE+200*HEIGHT_SCALE+4*HEIGHT_SCALE+14*HEIGHT_SCALE+14*HEIGHT_SCALE+14*HEIGHT_SCALE+14*HEIGHT_SCALE, 100*WIDTH_SCALE, 12*HEIGHT_SCALE);
            [self.headview.combtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.headview).with.offset(-70*WIDTH_SCALE);
                make.top.equalTo(self.headview.title).with.offset(15*HEIGHT_SCALE+20*HEIGHT_SCALE);
            }];
            [self.headview.dianzanbtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.headview).with.offset(-140*WIDTH_SCALE);
                make.top.equalTo(self.headview.title).with.offset(15*HEIGHT_SCALE+20*HEIGHT_SCALE);
            }];
            [self.headview.thumlabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.headview).with.offset(14*WIDTH_SCALE);
                make.right.equalTo(self.headview).with.offset(-14*WIDTH_SCALE);
                make.top.equalTo(self.headview.timelab).with.offset(33*HEIGHT_SCALE);
                
            }];
            [self.headview.sharebtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.headview).with.offset(-14*WIDTH_SCALE);
                make.top.equalTo(self.headview.title).with.offset(15*HEIGHT_SCALE+20*HEIGHT_SCALE);
            }];
            _headview.frame = CGRectMake(0, 0, DEVICE_WIDTH, textSize.height+400*HEIGHT_SCALE+textsize2.height);
        }
        else if (content.length==0&&urlstr.length!=0)
        {
            CGSize textsize2= [self.headview.thumlabel.text boundingRectWithSize:CGSizeMake(DEVICE_WIDTH-28*WIDTH_SCALE, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
            [self.headview.headimg sd_setImageWithURL:[NSURL URLWithString:self.headm.imgurlstr] placeholderImage:[UIImage imageNamed:@"默认图"]];
            self.headview.headimg.frame =CGRectMake(14*WIDTH_SCALE, 30*HEIGHT_SCALE+14*HEIGHT_SCALE, DEVICE_WIDTH-28*WIDTH_SCALE, 200*HEIGHT_SCALE);
            self.headview.title.frame = CGRectMake(14*WIDTH_SCALE,  30*HEIGHT_SCALE+200*HEIGHT_SCALE+4*HEIGHT_SCALE+14*HEIGHT_SCALE, DEVICE_WIDTH-28*WIDTH_SCALE, 20*HEIGHT_SCALE);
            self.headview.timelab.frame = CGRectMake(14*WIDTH_SCALE, 30*HEIGHT_SCALE+200*HEIGHT_SCALE+4*HEIGHT_SCALE+14*HEIGHT_SCALE+14*HEIGHT_SCALE+14*HEIGHT_SCALE+14*HEIGHT_SCALE, 100*WIDTH_SCALE, 12*HEIGHT_SCALE);
            [self.headview.combtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.headview).with.offset(-70*WIDTH_SCALE);
                make.top.equalTo(self.headview.title).with.offset(15*HEIGHT_SCALE+20*HEIGHT_SCALE);
            }];
            [self.headview.dianzanbtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.headview).with.offset(-140*WIDTH_SCALE);
                make.top.equalTo(self.headview.title).with.offset(15*HEIGHT_SCALE+20*HEIGHT_SCALE);
            }];
            [self.headview.thumlabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.headview).with.offset(14*WIDTH_SCALE);
                make.right.equalTo(self.headview).with.offset(-14*WIDTH_SCALE);
                make.top.equalTo(self.headview.timelab).with.offset(33*HEIGHT_SCALE);
                
            }];
            [self.headview.sharebtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.headview).with.offset(-14*WIDTH_SCALE);
                make.top.equalTo(self.headview.title).with.offset(15*HEIGHT_SCALE+20*HEIGHT_SCALE);
            }];
            _headview.frame = CGRectMake(0, 0, DEVICE_WIDTH, 400*HEIGHT_SCALE+textsize2.height);
        }else
        {
            CGSize textSize = [self.headview.contentlab setText:self.headview.contentlab.text lines:QSTextDefaultLines andLineSpacing:QSTextLineSpacing constrainedToSize:CGSizeMake(DEVICE_WIDTH - 28*WIDTH_SCALE,MAXFLOAT)];
            CGSize textsize2= [self.headview.thumlabel.text boundingRectWithSize:CGSizeMake(DEVICE_WIDTH-28*WIDTH_SCALE, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
            self.headview.contentlab.frame = CGRectMake(14*WIDTH_SCALE,  30*HEIGHT_SCALE+14*HEIGHT_SCALE, textSize.width, textSize.height);
            self.headview.title.frame = CGRectMake(14*WIDTH_SCALE,  30*HEIGHT_SCALE+textSize.height*HEIGHT_SCALE+4*HEIGHT_SCALE+14*HEIGHT_SCALE, DEVICE_WIDTH-28*WIDTH_SCALE, 20*HEIGHT_SCALE);
            self.headview.timelab.frame = CGRectMake(14*WIDTH_SCALE, 30*HEIGHT_SCALE+textSize.height*HEIGHT_SCALE+4*HEIGHT_SCALE+14*HEIGHT_SCALE+14*HEIGHT_SCALE+14*HEIGHT_SCALE+14*HEIGHT_SCALE, 100*WIDTH_SCALE, 12*HEIGHT_SCALE);
            [self.headview.combtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.headview).with.offset(-70*WIDTH_SCALE);
                make.top.equalTo(self.headview.title).with.offset(15*HEIGHT_SCALE+20*HEIGHT_SCALE);
            }];
            [self.headview.dianzanbtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.headview).with.offset(-140*WIDTH_SCALE);
                make.top.equalTo(self.headview.title).with.offset(15*HEIGHT_SCALE+20*HEIGHT_SCALE);
            }];
            [self.headview.thumlabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.headview).with.offset(14*WIDTH_SCALE);
                make.right.equalTo(self.headview).with.offset(-14*WIDTH_SCALE);
                make.top.equalTo(self.headview.timelab).with.offset(33*HEIGHT_SCALE);
                
            }];
            [self.headview.sharebtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.headview).with.offset(-14*WIDTH_SCALE);
                make.top.equalTo(self.headview.title).with.offset(15*HEIGHT_SCALE+20*HEIGHT_SCALE);
            }];
            _headview.frame = CGRectMake(0, 0, DEVICE_WIDTH, textSize.height+200*HEIGHT_SCALE+textsize2.height);
        }

    }
    
}

@end

