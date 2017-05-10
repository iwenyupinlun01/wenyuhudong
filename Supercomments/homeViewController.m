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
#import "TimeInterval.h"
//Segment高度

#define LG_segmentH 44

@interface homeViewController ()<UIScrollViewDelegate,SegmentDelegate>
@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic,strong)NSMutableArray *buttonList;
@property (nonatomic, weak) LGSegment *segment;
@property (nonatomic,weak)CALayer *LGLayer;
@property (nonatomic,strong) UIButton *infobtn;
@property (nonatomic,strong) UIButton *searchbtn;
@property (nonatomic,strong) UIView *xiaohongdianview;
@property (nonatomic,strong) UIImageView *bgimg;

@property (nonatomic,strong) NSString *denglustr;

@property (nonatomic,strong) UIView *pointview;

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
   
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:NO];

}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self islogin];
    [self tokentihuanfrom];
    [self loaddatafromweb];
}

-(UIView *)pointview
{
    if(!_pointview)
    {
        _pointview = [[UIView alloc] init];
        
    }
    return _pointview;
}



//判断登陆是否过期

-(BOOL)shijianjisuan
{
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    NSString *timestr = [userdefault objectForKey:@"islogin"];
    NSLog(@"timestr------%@",timestr);
    if ([TimeInterval datetime:timestr]) {
        NSLog(@"123");
        //没有过期
        return YES;
        
    }else
    {   //登陆过期
        return NO;
    }
}

-(void)islogin
{

    [CLNetworkingManager getNetworkRequestWithUrlString:[NSString stringWithFormat:loginbool,[tokenstr tokenstrfrom]] parameters:nil isCache:YES succeed:^(id data) {
        
        NSLog(@"infor=%@",data);
        if ([[data objectForKey:@"is_login"]intValue]!=1) {
            NSLog(@"未登录");
            self.denglustr = @"";
            [self.infobtn sd_setImageWithURL:[NSURL URLWithString:@""] forState:normal placeholderImage:[UIImage imageNamed:@"未登录"]];
            
            [self.xiaohongdianview removeFromSuperview];
            
        }else
        {
            NSLog(@"已经登陆");
            if ([[data objectForKey:@"info"] isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dic = [data objectForKey:@"info"];
                NSString *path = [dic objectForKey:@"headPath"];
                NSString *namestr = [dic objectForKey:@"nickname"];
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:path forKey:@"pathurlstr"];
                [defaults setObject:namestr forKey:@"namestr"];
                [defaults synchronize];
            }
            
            if ([self shijianjisuan]) {
                //没有过期
                self.denglustr = @"denglu";
                NSString *urlstr = [tokenstr userimgstrfrom];
                [self.infobtn sd_setImageWithURL:[NSURL URLWithString:urlstr] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"头像默认图"]];
                
            }else
            {
                //登陆过期
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults removeObjectForKey:@"tokenuser"];
                [defaults removeObjectForKey:@"access_token"];
                [defaults removeObjectForKey:@"namestr"];
                [defaults removeObjectForKey:@"pathurlstr"];
                
            }
        }
        
    } fail:^(NSError *error) {
        NSString *urlstr = [tokenstr userimgstrfrom];
        [self.infobtn sd_setImageWithURL:[NSURL URLWithString:urlstr] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"头像默认图"]];
    }];
    
}

-(void)loaddatafromweb
{
    NSString *tokenstr2 = [tokenstr tokenstrfrom];
    NSLog(@"%@",tokenstr2);
    
    if ([tokenstr tokenstrfrom].length!=0) {
        
        NSString *urlstr = [NSString stringWithFormat:tongzhixianxishuliang,[tokenstr tokenstrfrom]];
        
        [CLNetworkingManager getNetworkRequestWithUrlString:urlstr parameters:nil isCache:YES succeed:^(id data) {
            NSLog(@"info---------%@",data);
            NSString *inforstr = [[NSString alloc] init];
            NSString *system_inform = [[NSString alloc] init];
            if ([[data objectForKey:@"code"] intValue]==1) {

                
                if ([[data objectForKey:@"info"] isKindOfClass:[NSDictionary class]]) {
                    NSLog(@"属于字典类型");
                    NSDictionary *dic = [data objectForKey:@"info"];
                    inforstr = [dic objectForKey:@"inform"];
                    system_inform = [dic objectForKey:@"system_inform"];
                    NSUserDefaults *sharedefat = [NSUserDefaults standardUserDefaults];
                    [sharedefat setObject:inforstr forKey:@"inforstr"];
                    [sharedefat setObject:system_inform forKey:@"system_inform"];
                    [sharedefat synchronize];
                }else
                {
                    
                    NSLog(@"不属于字典类型");
                    
                }
              
            }
            if ([inforstr isEqualToString:@"0"]&&[system_inform isEqualToString:@"0"]) {
                [self.xiaohongdianview setHidden:YES];
            }
            else
            {
                [self.view addSubview:self.xiaohongdianview];
            }
            
        } fail:^(NSError *error) {
            
        }];
  
        

    }else
    {

    }
}

-(void)tokentihuanfrom
{
    [CLNetworkingManager postNetworkRequestWithUrlString:tokentihuan parameters:@{@"token":[tokenstr tokenstrfrom]} isCache:NO succeed:^(id data) {
        NSLog(@"data===%@",data);
        if ([[data objectForKey:@"code"] intValue]==1) {
            NSString *newtoken = [data objectForKey:@"token"];
            if ([newtoken isEqualToString:[tokenstr tokenstrfrom]]) {
                NSLog(@"相同");
            }else
            {
                NSLog(@"不同，替换");
                NSUserDefaults *userdefat = [NSUserDefaults standardUserDefaults];
                [userdefat setObject:newtoken forKey:@"tokenuser"];
                [userdefat synchronize];
            }
        }
        
    } fail:^(NSError *error) {
        
        //[MBProgressHUD showSuccess:@"服务器故障"];
    }];
}

#pragma mark - getteres

-(UIView *)xiaohongdianview
{
    if(!_xiaohongdianview)
    {
        _xiaohongdianview = [[UIView alloc] initWithFrame:CGRectMake(42, 24, 8, 8)];
        _xiaohongdianview.backgroundColor = [UIColor  redColor];
        _xiaohongdianview.layer.masksToBounds = YES;
        _xiaohongdianview.layer.cornerRadius = 4;
    }
    return _xiaohongdianview;
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
   // [self.segment.LGLayer setHidden:YES];
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
        _infobtn = [[UIButton alloc] initWithFrame:CGRectMake(14, 24, 36, 36)];
        _infobtn.layer.masksToBounds = YES;
        _infobtn.layer.cornerRadius = 18;
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
    if ([tokenstr tokenstrfrom].length!=0) {
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
