//
//  homeViewController.m
//  Supercomments
//
//  Created by 王俊钢 on 2017/4/5.
//  Copyright © 2017年 wangjungang. All rights reserved.
//

#import "homeViewController.h"
#import "LGSegment.h"

#import "infoViewController.h"
#import "newViewController.h"
#import "hotViewController.h"
#import "loginViewController.h"
#import <SDWebImage/UIButton+WebCache.h>
//Segment高度

#define LG_segmentH 44

@interface homeViewController ()<UIScrollViewDelegate,SegmentDelegate>
@property (nonatomic, strong) UIScrollView *contentScrollView;
@property(nonatomic,strong)NSMutableArray *buttonList;
@property (nonatomic, weak) LGSegment *segment;
@property(nonatomic,weak)CALayer *LGLayer;
@property (nonatomic,strong) UIButton *infobtn;
@property (nonatomic,strong) UIButton *searchbtn;

@property (nonatomic,strong) UIImageView *bgimg;

@property (nonatomic,strong) NSString *denglustr;

@end

@implementation homeViewController


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    
    [self islogin];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:NO];

}

-(void)islogin
{
    
    NSUserDefaults *userdefat = [NSUserDefaults standardUserDefaults];
    NSString *tokenkey = [userdefat objectForKey:@"tokenuser"];
    NSLog(@"tokenkey===========%@",tokenkey);
    
    [AFManager getReqURL:[NSString stringWithFormat:loginbool,tokenkey] block:^(id infor) {
        NSLog(@"infor=%@",infor);
        if ([[infor objectForKey:@"code"]intValue]==0) {
            NSLog(@"未登录");
            self.denglustr = @"";
            [self.infobtn sd_setImageWithURL:[NSURL URLWithString:@""] forState:normal placeholderImage:[UIImage imageNamed:@"未登录"]];
        }else
        {
            NSLog(@"已经登陆");
            self.denglustr = @"denglu";
            NSDictionary *dic = [infor objectForKey:@"info"];
            //NSString *urlstr = [dic objectForKey:@"headPath"];
            NSString *urlstr = @"http://www.qqbody.com/uploads/allimg/201401/09-045302_580.jpg";

            [self.infobtn sd_setImageWithURL:[NSURL URLWithString:urlstr] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"未登录"]];
            //[self.infobtn sd_setImageWithURL:[NSURL URLWithString:urlstr] forState:normal];
        }
        
    } errorblock:^(NSError *error) {
        
    }];
}

- (NSMutableArray *)buttonList
{
    if (!_buttonList)
    {
        _buttonList = [NSMutableArray array];
    }
    return _buttonList;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.view addSubview:self.bgimg];
    
    //加载Segment
    [self setSegment];
    //加载ViewController
    [self addChildViewController];
    //加载ScrollView
    [self setContentScrollView];
    
    [self.view addSubview:self.infobtn];
    //[self.view addSubview:self.searchbtn];
}

-(void)setSegment {
    
    [self buttonList];
    //初始化
    LGSegment *segment = [[LGSegment alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, LG_segmentH)];
    segment.delegate = self;
    
    self.segment = segment;
    [self.view addSubview:segment];
    [self.buttonList addObject:segment.buttonList];
    self.LGLayer = segment.LGLayer;
    
}
//加载ScrollView
-(void)setContentScrollView {
    
    UIScrollView *sv = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, DEVICE_HEIGHT-44)];
    [self.view addSubview:sv];
    sv.bounces = NO;
    sv.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    sv.contentOffset = CGPointMake(0, 0);
    sv.pagingEnabled = YES;
    sv.showsHorizontalScrollIndicator = NO;
    sv.scrollEnabled = YES;
    sv.userInteractionEnabled = YES;
    sv.delegate = self;
    
    for (int i=0; i<self.childViewControllers.count; i++) {
        UIViewController * vc = self.childViewControllers[i];
        vc.view.frame = CGRectMake(i * DEVICE_WIDTH, 0, DEVICE_WIDTH, DEVICE_HEIGHT-40);
        [sv addSubview:vc.view];
        
    }
    sv.contentSize = CGSizeMake(2 * DEVICE_WIDTH, 0);
    self.contentScrollView = sv;
}

//加载2个ViewController

-(void)addChildViewController{
    
    newViewController * vc1 = [[newViewController alloc]init];
    //vc1.view.backgroundColor= [UIColor colorWithRed:80.0/255 green:227.0/255 blue:194.0/255 alpha:100];
    [self addChildViewController:vc1];
    hotViewController * vc2 = [[hotViewController alloc]init];
    //vc2.view.backgroundColor= [UIColor colorWithRed:0.0/255 green:167.0/255 blue:210.0/255 alpha:100];
    [self addChildViewController:vc2];
}

#pragma mark - UIScrollViewDelegate

//实现LGSegment代理方法

-(void)scrollToPage:(int)Page {
    CGPoint offset = self.contentScrollView.contentOffset;
    offset.x = self.view.frame.size.width * Page;
    [UIView animateWithDuration:0.3 animations:^{
        self.contentScrollView.contentOffset = offset;
    }];
}

// 只要滚动UIScrollView就会调用

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetX = scrollView.contentOffset.x;
    [self.segment moveToOffsetX:offsetX];
}

#pragma mark - getters

-(UIButton *)infobtn
{
    if(!_infobtn)
    {
        _infobtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 25, 30, 30)];
        //_infobtn.backgroundColor = [UIColor greenColor];
        _infobtn.layer.masksToBounds = YES;
        _infobtn.layer.cornerRadius = 15;
        
        [_infobtn addTarget:self action:@selector(infoclick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _infobtn;
}

-(UIButton *)searchbtn
{
    if(!_searchbtn)
    {
        _searchbtn = [[UIButton alloc] initWithFrame:CGRectMake(DEVICE_WIDTH-40, 29, 20, 20)];
        [_searchbtn setImage:[UIImage imageNamed:@"放大镜"] forState:normal];
    }
    return _searchbtn;
}

-(UIImageView *)bgimg
{
    if(!_bgimg)
    {
        _bgimg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 64)];
        _bgimg.image = [UIImage imageNamed:@"矩形-1"];
    }
    return _bgimg;
}

-(void)infoclick
{
    if (self.denglustr.length!=0) {
        infoViewController *infovc = [[infoViewController alloc] init];
        [self.navigationController pushViewController:infovc animated:YES];

    }else
    {
        loginViewController *loginvc = [[loginViewController alloc] init];
        
        [self presentViewController:loginvc animated:YES completion:^{
            
        }];
    }


}

@end
