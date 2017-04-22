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
@interface detailsViewController ()<UITableViewDataSource,UITableViewDelegate>
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


- (void)addHeader
{
    
    // 头部刷新控件
    self.maintable.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshAction)];
    [self.maintable.mj_header beginRefreshing];
    
}

- (void)addFooter
{
    self.maintable.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshLoadMore)];
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
    NSLog(@"token--------%@",token);
    
    NSString *strurl = [NSString stringWithFormat:xiangqin,self.detalisidstr,@"1",tokenstr];
    
    [AFManager getReqURL:strurl block:^(id infor) {
        self.headm = [[headModel alloc] init];
        NSLog(@"info=---------------------%@",infor);
        NSDictionary *dic =  [infor objectForKey:@"info"];
        
        //头部
        self.headm.namestr = [dic objectForKey:@"name"];
        self.headm.contactstr = [dic objectForKey:@"content"];
        self.headm.timestr = [dic objectForKey:@"create_time"];
        self.headm.fromstr = [NSString stringWithFormat:@"%@%@%@",@"网易老司机已赞",[dic objectForKey:@"support_count"],@"次"];
        self.headm.imgurlstr = [dic objectForKey:@"images"];
        self.headm.weburlstr = [dic objectForKey:@"url"];
        //self.headm.imgurlstr = @"111";
        
        self.headview.namelab.text = self.headm.namestr;
        self.headview.timelab.text = self.headm.timestr;
        self.headview.fromlab.text = self.headm.fromstr;
     
        
        self.headview.contentlab.text = [dic objectForKey:@"content"];
        NSString *tit = [dic objectForKey:@"title"];
        NSString *tit2 = [NSString stringWithFormat:@"%@%@",@"标题:",tit];
        self.headview.title.titlelab.text = tit2;
        
        
        NSMutableArray *usernamearr = [NSMutableArray array];
        NSMutableArray *bookarr = [NSMutableArray array];
        
        bookarr = [dic objectForKey:@"bookmark_user"];
        for (int i = 0; i<bookarr.count; i++) {
            NSDictionary *bookdic = [NSDictionary dictionary];
            bookdic = [bookarr objectAtIndex:i];
            NSString *usernamestr = [bookdic objectForKey:@"user_nickname"];
            [usernamearr addObject:usernamestr];
        }
        
        NSLog(@"usermanearr========%@",usernamearr);
        
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
            
           // NSString *urlstr = @"http://www.qqbody.com/uploads/allimg/201401/09-045302_580.jpg";
         
            self.detailsmodel.imgurlstr = [dicarr objectForKey:@"headImg"];
            
            
            NSMutableArray *commarr = [NSMutableArray array];
            commarr = [dicarr objectForKey:@"sonComment"];
            [self.cellcontarr addObject:[NSString stringWithFormat:@"%lu",(unsigned long)commarr.count]];
            
            [self.sonCommentarr addObject:self.detailsmodel.pingarr];

            [self.detalisarr addObject:self.detailsmodel];
            

        }
        
         NSLog(@"pinglunarr==========%@",self.cellcontarr);
        
        [self.maintable.mj_header endRefreshing];
        [self.maintable reloadData];
    } errorblock:^(NSError *error) {
         [self.maintable.mj_header endRefreshing];
    }];
    
}

-(void)footerRefreshEndAction
{
    pn ++;
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
    NSLog(@"token--------%@",token);
    
    NSString *pnstr = [NSString stringWithFormat:@"%d",pn];
    NSString *strurl = [NSString stringWithFormat:xiangqin,self.detalisidstr,pnstr,tokenstr];
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
        _headview.layer.borderWidth = 1;
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
        
    }
    return _maintable;
}

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
   // NSString *str3 = [_detailsmodel.pingarr[indexPath.row]objectForKey:@"s_to_nickname"];
    

    NSString *str2 = @"回复";

    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@%@",str1,str2,str4]];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0,str1.length)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(str1.length,str2.length)];
    
//    [str addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(str1.length+str2.length,str3.length)];
//    [str addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(str1.length+str2.length+str3.length,str4.length)];
    
    
    
    NSString *anotherString=[str string];
    
    NSLog(@"str===============%@",str);
    
    cell.pinglunlab.attributedText = str;
    CGSize textSize = [cell.pinglunlab setText:anotherString lines:QSTextDefaultLines2 andLineSpacing:QSTextLineSpacing constrainedToSize:CGSizeMake(DEVICE_WIDTH,MAXFLOAT)];
    cell.pinglunlab.frame = CGRectMake(128/2*WIDTH_SCALE,  8*HEIGHT_SCALE, DEVICE_WIDTH -64*WIDTH_SCALE-14*WIDTH_SCALE, textSize.height);
    cell.pinglunlab.font = [UIFont systemFontOfSize:14*FX];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.detalisarr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    _detailsmodel  = self.detalisarr[indexPath.section];
    // 取车第indexPath.row这行对应的品牌名称
    NSString *car = [_detailsmodel.pingarr[indexPath.row] objectForKey:@"content"];
    return [pinglunCell cellHeightWithText:car] + 16*HEIGHT_SCALE;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"点击cell");
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
}

-(void)pinglunclick
{
    NSLog(@"评论");
}

-(void)webimagego
{
    NSString *urlstr = self.headm.weburlstr;
    NSLog(@"urlstr-------%@",urlstr);
    SureWebViewController *surevc = [[SureWebViewController alloc]init];
    surevc.url = urlstr;
    surevc.canDownRefresh = YES;
    [self.navigationController pushViewController:surevc animated:YES];
    
}

@end
