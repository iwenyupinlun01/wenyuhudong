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
@interface detailsViewController ()<UITableViewDataSource,UITableViewDelegate>
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
    
    self.cellcontarr = [NSMutableArray array];
    self.detalisarr = [NSMutableArray array];

    //self.cellcontarr = [NSMutableArray arrayWithObjects:@"2", nil];
    
    [self loadhead];

    [self.view addSubview:self.maintable];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}


-(void)loadhead
{
    
    NSString *strurl = [NSString stringWithFormat:xiangqin,self.detalisidstr,@"1",@""];
    [AFManager getReqURL:strurl block:^(id infor) {
        self.headm = [[headModel alloc] init];
        NSLog(@"info=---------------------%@",infor);
        NSDictionary *dic =  [infor objectForKey:@"info"];
        
        self.headm.namestr = [dic objectForKey:@"name"];
        self.headm.contactstr = [dic objectForKey:@"content"];
        self.headm.timestr = [dic objectForKey:@"create_time"];
        self.headm.fromstr = [NSString stringWithFormat:@"%@%@%@",@"网易老司机已赞",[dic objectForKey:@"support_count"],@"次"];
        self.headm.imgurlstr = [dic objectForKey:@"images"];
        //self.headm.imgurlstr = @"111";
        
        self.headview.namelab.text = self.headm.namestr;
        self.headview.timelab.text = self.headm.timestr;
        self.headview.fromlab.text = self.headm.fromstr;
        self.headview.contentlab.text = [dic objectForKey:@"content"];
        self.headview.title.titlelab.text =[dic objectForKey:@"title"];
        
        
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
        

        
        if (self.headm.contactstr.length!=0&&self.headm.imgurlstr.length!=0) {
            CGSize textSize = [self.headview.contentlab setText:self.headview.contentlab.text lines:QSTextDefaultLines andLineSpacing:QSTextLineSpacing constrainedToSize:CGSizeMake(DEVICE_WIDTH - 28*WIDTH_SCALE,MAXFLOAT)];
            self.headview.contentlab.frame = CGRectMake(14*WIDTH_SCALE,  30*HEIGHT_SCALE+14*HEIGHT_SCALE, textSize.width, textSize.height);
            [self.headview.headimg sd_setImageWithURL:[NSURL URLWithString:self.headm.imgurlstr]];
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
            
            [self.headview.headimg sd_setImageWithURL:[NSURL URLWithString:self.headm.imgurlstr]];
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
        NSMutableArray *sonCommentarr = [NSMutableArray array];
        
        NSMutableArray *dtrarr = [NSMutableArray array];
        dtrarr = [dic objectForKey:@"all_comment"];
        
        NSLog(@"all_comment=========%@",dtrarr);
        for (int i = 0; i<dtrarr.count; i++) {
            NSDictionary *dicarr = [dtrarr objectAtIndex:i];
            self.detailsmodel = [[detailcellmodel alloc] init];
            self.detailsmodel.namestr = [dicarr objectForKey:@"p_nickname"];
            self.detailsmodel.timestr = [dicarr objectForKey:@"ctime"];
            self.detailsmodel.contstr = [dicarr objectForKey:@"content"];
            self.detailsmodel.pingarr = [dicarr objectForKey:@"sonComment"];
            
          
            NSDictionary *sonCommentdic = [NSDictionary dictionary];
            NSMutableArray *commarr = [NSMutableArray array];
            commarr = [dicarr objectForKey:@"sonComment"];
            for (int j = 0; j<commarr.count; j++) {
                sonCommentdic = [commarr objectAtIndex:j];
                NSString *content = [sonCommentdic objectForKey:@"content"];
                NSString *s_nickname = [sonCommentdic objectForKey:@"s_nickname"];
                NSString *s_to_nickname = [sonCommentdic objectForKey:@"s_to_nickname"];
                
                [sonCommentarr addObject:content];
                
            }
            [self.cellcontarr addObject:[NSString stringWithFormat:@"%lu",(unsigned long)commarr.count]];
            self.detailsmodel.pingluncontarr = self.cellcontarr;
            
            
            [self.detalisarr addObject:self.detailsmodel];
            
        }
        
        
        
        NSLog(@"pinglunarr==========%@",self.detailsmodel.pingluncontarr);
        
        
        
        
    [self.maintable reloadData];
    } errorblock:^(NSError *error) {
        
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
        
    }
    return _headview;
}


-(UITableView *)maintable
{
    if(!_maintable)
    {
        _maintable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT-64)];
        _maintable.dataSource = self;
        _maintable.delegate = self;
        _maintable.tableHeaderView = self.headview;
        
    }
    return _maintable;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==self.maintable) {
        return self.detalisarr.count;
    }

    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==self.maintable) {
        detaolsCell *cell = [tableView dequeueReusableCellWithIdentifier:detailsidentfid];
        if (!cell) {
            cell = [[detaolsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:detailsidentfid];
        }
//        cell.pingluntable.dataSource = self;
//        cell.pingluntable.delegate = self;
        
        [cell setcelldata:self.detalisarr[indexPath.row]];
        _height01 = cell.hei;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else
    {
//        pinglunCell *cell = [tableView dequeueReusableCellWithIdentifier:pinglunidentfid];
//        if (!cell) {
//            cell = [[pinglunCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:pinglunidentfid];
//        }
//        cell.backgroundColor = [UIColor wjColorFloat:@"F4F5F6"];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        
//        cell.textLabel.text = @"赵客缦胡缨⑵，吴钩霜雪明⑶。银鞍照白马，飒沓如流星⑷。赵客缦胡缨⑵，吴钩霜雪明⑶。银鞍照白马，飒沓如流星⑷赵客缦胡缨⑵，吴钩霜雪明⑶。银鞍照白马，飒沓如流星⑷赵客缦胡缨⑵，吴钩霜雪明⑶。银鞍照白马，飒沓如流星⑷";
//        
//       // cell.textLabel.text = self.detailsmodel.pingarr[indexPath.row];
//        cell.textLabel.numberOfLines = 0;
//        cell.textLabel.font = [UIFont systemFontOfSize:14*FX];
//        CGSize textSize = [cell.textLabel setText:cell.textLabel.text lines:QSTextDefaultLines andLineSpacing:QSTextLineSpacing constrainedToSize:CGSizeMake(DEVICE_WIDTH-64,MAXFLOAT)];
//        cell.textLabel.frame = CGRectMake(0, 0, textSize.width, textSize.height);
//        _pinglunhei = textSize.height;
//        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==self.maintable) {
        
        return 400;
    }
//    else
//    {
//        return _pinglunhei;
//    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==self.maintable) {
        
    }else
    {
        NSLog(@"跳转评论");
    }
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

@end
