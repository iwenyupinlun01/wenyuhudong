//
//  detailsViewController.m
//  Supercomments
//
//  Created by 王俊钢 on 2017/4/8.
//  Copyright © 2017年 wangjungang. All rights reserved.
//

#import "detailsViewController.h"
#import "detaolsCell.h"
#import "detailsheadView.h"


#include "YMTextData.h"
#import "YMReplyInputView.h"

#import "headModel.h"
#import "pinglunCell.h"
#import "detailcellmodel.h"

#import "sectionView.h"
#import "SureWebViewController.h"
#import "loginViewController.h"
#import "YcKeyBoardView.h"
#import "Timestr.h"
#import "keyboardView.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
@interface detailsViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
{
    int pn;
}

@property (nonatomic,assign) CGFloat height01;
@property (nonatomic,assign) CGFloat pinglunhei;
@property (nonatomic,strong) NSIndexPath *selectedIndexPath;
@property (nonatomic,strong) detailsheadView *headview;
@property (nonatomic,strong) YMReplyInputView *replyView;
@property (nonatomic,strong) headModel *headm;
@property (nonatomic,strong) UITableView *maintable;
@property (nonatomic,strong) NSMutableArray *detalisarr;
@property (nonatomic,strong) detailcellmodel *detailsmodel;
@property (nonatomic,strong) NSMutableArray *cellcontarr;
@property (nonatomic,strong) NSMutableArray *sonCommentarr;
@property (nonatomic,strong) sectionView *secview;

@property (nonatomic,strong) keyboardView *keyView;

@property (nonatomic,strong) NSString *fromkeyboard;
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
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barTintColor = [UIColor wjColorFloat:@"F5F5F5"];
    
    pn=1;
    self.cellcontarr = [NSMutableArray array];
    self.detalisarr = [NSMutableArray array];
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
        //self.headm.timestr = [self datetime:[dic objectForKey:@"create_time"]];
        self.headm.timestr = [Timestr datetime:[dic objectForKey:@"create_time"]];
        self.headm.shifoudianzanstr = [dic objectForKey:@"is_support"];
        self.headview.namelab.text = self.headm.namestr;
        self.headview.timelab.text = self.headm.timestr;
        self.headview.fromlab.text = self.headm.fromstr;
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
        
        NSMutableArray *usernamearr = [NSMutableArray array];
        NSMutableArray *bookarr = [NSMutableArray array];
        
        bookarr = [dic objectForKey:@"bookmark_user"];
        for (int i = 0; i<bookarr.count; i++) {
            NSDictionary *bookdic = [NSDictionary dictionary];
            bookdic = [bookarr objectAtIndex:i];
            NSString *usernamestr = [bookdic objectForKey:@"user_nickname"];
            [usernamearr addObject:usernamestr];
        }
        
        NSArray *goodArray = usernamearr;
        NSString *goodTotalString = [goodArray componentsJoinedByString:@", "];
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
        if (goodArray.count==0) {
            [self.headview.thumlabel setHidden:YES];
        }else
        {
            [self.headview.thumlabel setHidden:NO];
        }
        
        if (self.headm.contactstr.length!=0&&self.headm.imgurlstr.length!=0) {
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
            
            [self.headview.thumlabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.headview).with.offset(14*WIDTH_SCALE);
                make.right.equalTo(self.headview).with.offset(-14*WIDTH_SCALE);
                make.top.equalTo(self.headview.timelab).with.offset(33*HEIGHT_SCALE);
                
            }];
            [self.headview.sharebtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.headview).with.offset(-14*WIDTH_SCALE);
                make.top.equalTo(self.headview.title).with.offset(15*HEIGHT_SCALE+20*HEIGHT_SCALE);
            }];
            _headview.frame = CGRectMake(0, 0, DEVICE_WIDTH, textSize.height+420*HEIGHT_SCALE);
        }
        else if (self.headm.contactstr.length==0&&self.headm.imgurlstr.length!=0)
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
            
            
            [self.headview.thumlabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.headview).with.offset(14*WIDTH_SCALE);
                make.right.equalTo(self.headview).with.offset(-14*WIDTH_SCALE);
                make.top.equalTo(self.headview.timelab).with.offset(33*HEIGHT_SCALE);
                
            }];
            [self.headview.sharebtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.headview).with.offset(-14*WIDTH_SCALE);
                make.top.equalTo(self.headview.title).with.offset(15*HEIGHT_SCALE+20*HEIGHT_SCALE);
            }];
            _headview.frame = CGRectMake(0, 0, DEVICE_WIDTH, 410*HEIGHT_SCALE);
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
            
            
            [self.headview.thumlabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.headview).with.offset(14*WIDTH_SCALE);
                make.right.equalTo(self.headview).with.offset(-14*WIDTH_SCALE);
                make.top.equalTo(self.headview.timelab).with.offset(33*HEIGHT_SCALE);
                
            }];
            [self.headview.sharebtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.headview).with.offset(-14*WIDTH_SCALE);
                make.top.equalTo(self.headview.title).with.offset(15*HEIGHT_SCALE+20*HEIGHT_SCALE);
            }];
            _headview.frame = CGRectMake(0, 0, DEVICE_WIDTH, textSize.height+200*HEIGHT_SCALE);
        }
        
        //cell部分
        
        //section
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
            self.detailsmodel.pingarr = [dicarr objectForKey:@"sonComment"];
            self.detailsmodel.imgurlstr = [dicarr objectForKey:@"headImg"];
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
            NSMutableArray *commarr = [NSMutableArray array];
            commarr = [dicarr objectForKey:@"sonComment"];
            [self.cellcontarr addObject:[NSString stringWithFormat:@"%lu",(unsigned long)commarr.count]];
            [self.sonCommentarr addObject:self.detailsmodel.pingarr];
            [self.detalisarr addObject:self.detailsmodel];
        }
        
        NSLog(@"pinglunarr==========%@",self.cellcontarr);
        
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
        _headview.layer.masksToBounds = YES;
        _headview.layer.borderWidth = 0.3;
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
        _maintable = [[UITableView alloc] initWithFrame:CGRectMake(0, -40, DEVICE_WIDTH, DEVICE_HEIGHT-24) style:UITableViewStyleGrouped];
        _maintable.dataSource = self;
        _maintable.delegate = self;
        _maintable.tableHeaderView = self.headview;
        _maintable.backgroundColor = [UIColor whiteColor];
        
        _maintable.emptyDataSetSource = self;
        _maintable.emptyDataSetDelegate = self;
        
    }
    return _maintable;
}

-(keyboardView *)keyView
{
    if(!_keyView)
    {
        _keyView = [[keyboardView alloc] init];
        _keyView.frame = CGRectMake(0, DEVICE_HEIGHT-64, DEVICE_WIDTH, 44);
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
    //self.secview.layer.borderWidth = 1;
    
    
   // self.secview.userInteractionEnabled = YES;//打开用户交互
    //初始化一个手势
//    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableviewaction:andheadsection:)];
//    //为图片添加手势
//    [self.secview addGestureRecognizer:singleTap];
    
    
    
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
    UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(0, 14, DEVICE_WIDTH, 0.3)];
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
            NSString *dianzanstr = self.headm.shifoudianzanstr;
            NSDictionary *reqdic = @{@"token":[tokenstr tokenstrfrom],@"object_id":self.detalisidstr,@"status":dianzanstr,@"type":@"1"};
            [CLNetworkingManager postNetworkRequestWithUrlString:qudianzan parameters:reqdic isCache:YES succeed:^(id data) {
                NSLog(@"data===%@",data);
                NSString *codestr = [data objectForKey:@"code"];
                if ([codestr intValue]==1) {
                    [MBProgressHUD showSuccess:@"成功"];
                    NSLog(@"成功");
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
            self.headview.dianzanbtn.zanimg.image = [UIImage imageNamed:@"点赞-拷贝"];
            self.headm.shifoudianzanstr = @"1";
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
            
            NSString *dianzanstr = self.headm.shifoudianzanstr;
            self.headview.dianzanbtn.zanimg.image = [UIImage imageNamed:@"点赞-拷贝"];
            NSDictionary *reqdic = @{@"token":[tokenstr tokenstrfrom],@"object_id":self.detalisidstr,@"status":dianzanstr,@"type":@"1"};
            
            [CLNetworkingManager postNetworkRequestWithUrlString:qudianzan parameters:reqdic isCache:YES succeed:^(id data) {
                NSLog(@"data===%@",data);
                NSString *codestr = [data objectForKey:@"code"];
                if ([codestr intValue]==1) {
                    [MBProgressHUD showSuccess:@"成功"];
                    NSLog(@"成功");
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
            
            self.headm.shifoudianzanstr = @"0";
            self.headview.dianzanbtn.zanimg.image = [UIImage imageNamed:@"点赞-"];
            [self.maintable reloadData];
            
        }

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
        // 重新加载section
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
        self.fromkeyboard = @"cellpinglun";
        [self.keyView.textview becomeFirstResponder];
        self.keyView.index = indexPath.section;
        self.detailsmodel  = self.detalisarr[indexPath.section];
        self.keyView.nickname = [_detailsmodel.pingarr[indexPath.row]objectForKey:@"s_nickname"];
        self.keyView.tonickname = [_detailsmodel.pingarr[indexPath.row]objectForKey:@"s_to_nickname"];
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
        self.keyView.transform=CGAffineTransformMakeTranslation(0, -height-44);
        
    }];
}

//当键退出时调用

- (void)keyboardWillHide:(NSNotification *)aNotification
{
    [UIView animateWithDuration:[aNotification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        
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

//响应return

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        NSLog(@"return");
        [textView resignFirstResponder];
        
        if ([self isNullToString:textView.text]) {
            [textView resignFirstResponder];
        }
        else
        {
            if ([_fromkeyboard isEqualToString:@"cellpinglun"]) {
                self.detailsmodel  = self.detalisarr[self.keyView.index];
                NSMutableArray *mutaArray = [[NSMutableArray alloc] init];
                [mutaArray addObjectsFromArray:self.detailsmodel.pingarr];
                NSDictionary *dit = @{@"content":self.keyView.textview.text,@"s_nickname":@"me",@"s_to_nickname":self.keyView.nickname};
                [mutaArray addObject:dit];
                self.detailsmodel.pingarr = mutaArray;
                [self.maintable reloadData];
            }else if([_fromkeyboard isEqualToString:@"zhupinglun"])
            {
                self.detailsmodel = [[detailcellmodel alloc] init];
                NSMutableArray *mutaArray = [[NSMutableArray alloc] init];
                [mutaArray addObjectsFromArray:self.detalisarr];
                
                NSString *name = @"me";
                NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
                NSTimeInterval a=[dat timeIntervalSince1970];
                NSString *timeString = [NSString stringWithFormat:@"%f", a];
                NSString *time = [Timestr datetime:timeString];
                NSString *content = self.keyView.textview.text;
                NSString *imageurl = @"";
                self.detailsmodel.namestr = name;
                self.detailsmodel.timestr = time;
                self.detailsmodel.contstr = content;
                self.detailsmodel.imgurlstr = imageurl;
                [mutaArray addObject:self.detailsmodel];
                self.detalisarr = mutaArray;
                [self.maintable reloadData];
                
            }else
            {
                self.detailsmodel  = self.detalisarr[self.keyView.secindex];
                NSMutableArray *mutaArray = [[NSMutableArray alloc] init];
                [mutaArray addObjectsFromArray:self.detailsmodel.pingarr];
                NSString *tonickname = self.detailsmodel.namestr;
                NSDictionary *dit = @{@"content":self.keyView.textview.text,@"s_nickname":@"me",@"s_to_nickname":tonickname};
                [mutaArray addObject:dit];
                self.detailsmodel.pingarr = mutaArray;
                [self.maintable reloadData];
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

#pragma mark - 加载失败

//- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
//    return [UIImage imageNamed:@"加载失败"];
//}
@end
