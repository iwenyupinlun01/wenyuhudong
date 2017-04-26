//
//  loginViewController.m
//  Supercomments
//
//  Created by 王俊钢 on 2017/4/5.
//  Copyright © 2017年 wangjungang. All rights reserved.
//

#import "loginViewController.h"
#import "UILabel+YBAttributeTextTapAction.h"
#import "WXApi.h"
#import "AFNetworking.h"
#import "AppDelegate.h"

#import "YYPhotoGroupView.h"
@interface loginViewController ()<YBAttributeTapActionDelegate,WXApiDelegate,UIScrollViewDelegate>
@property (nonatomic,strong) UIImageView *logoimg;
@property (nonatomic,strong) UILabel *namelab;
@property (nonatomic,strong) UIButton *gobackbtn;
@property (nonatomic,strong) UIButton *loginbtn;
@property (nonatomic,strong) UIButton *zhijiebtn;
@property (nonatomic,strong) UILabel *aggrentlab;
@property (nonatomic,strong) UIImageView *xieyiimg;
//协议展示
@property (nonatomic,strong)UIScrollView * scrollView;
@property (nonatomic,strong)UIImageView *imageView;
@end

@implementation loginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:self.logoimg];
//    [self.view addSubview:self.namelab];
//    [self.view addSubview:self.loginbtn];
//    [self.view addSubview:self.zhijiebtn];
//    [self.view addSubview:self.aggrentlab];
//    
//    if ([self.jinru isEqualToString:@"jinru"]) {
//        [self.view addSubview:self.gobackbtn];
//    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WXLogin:) name:WXLoginSuccess object:@"dengluchenggong"];
    
    [self createView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.logoimg.frame = CGRectMake(283/2*WIDTH_SCALE, 264/2*HEIGHT_SCALE, (DEVICE_WIDTH/2-283/2*WIDTH_SCALE)*2, (DEVICE_WIDTH/2-283/2*WIDTH_SCALE)*2);
    self.namelab.frame = CGRectMake(100*WIDTH_SCALE,  264/2*HEIGHT_SCALE+(DEVICE_WIDTH/2-283/2*WIDTH_SCALE)*2, DEVICE_WIDTH-200*WIDTH_SCALE, 30);
    self.gobackbtn.frame = CGRectMake(DEVICE_WIDTH-60-50, 120, 60, 60);
    self.loginbtn.frame = CGRectMake(20*WIDTH_SCALE, DEVICE_HEIGHT-140*HEIGHT_SCALE, DEVICE_WIDTH-40*WIDTH_SCALE, 40*HEIGHT_SCALE);
    self.zhijiebtn.frame = CGRectMake(DEVICE_WIDTH-50*WIDTH_SCALE-20*WIDTH_SCALE, DEVICE_HEIGHT-24*WIDTH_SCALE-12*WIDTH_SCALE, 50*WIDTH_SCALE, 12*HEIGHT_SCALE);
    self.aggrentlab.frame = CGRectMake(20*WIDTH_SCALE, DEVICE_HEIGHT-24*HEIGHT_SCALE-12*HEIGHT_SCALE, 180*WIDTH_SCALE, 12*HEIGHT_SCALE);
}

#pragma mark - 实现方法

-(UIImageView *)logoimg
{
    if(!_logoimg)
    {
        _logoimg = [[UIImageView alloc] init];
        _logoimg.image = [UIImage imageNamed:@"矢量智能对象"];
    }
    return _logoimg;
}

-(UILabel *)namelab
{
    if(!_namelab)
    {
        _namelab = [[UILabel alloc] init];
        _namelab.text = @"今日牛评";
        _namelab.textAlignment = NSTextAlignmentCenter;
        _namelab.font = [UIFont systemFontOfSize:18*FX];
        
    }
    return _namelab;
}

-(UIButton *)gobackbtn
{
    if(!_gobackbtn)
    {
        _gobackbtn = [[UIButton alloc] init];
        [_gobackbtn setImage:[UIImage imageNamed:@"矩形-228-拷贝"] forState:normal];
        [_gobackbtn addTarget:self action:@selector(gobackbtnclick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _gobackbtn;
}

-(UIButton *)loginbtn
{
    if(!_loginbtn)
    {
        _loginbtn = [[UIButton alloc] init];
        _loginbtn.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"矩形-1"]];
        [_loginbtn setTitle:@"微信登录" forState:normal];
        [_loginbtn setTitleColor:[UIColor whiteColor] forState:normal];
        [_loginbtn addTarget:self action:@selector(loginbtnclick) forControlEvents:UIControlEventTouchUpInside];
        _loginbtn.layer.masksToBounds = YES;
        _loginbtn.layer.cornerRadius = 20*HEIGHT_SCALE;
        
    }
    return _loginbtn;
}

-(UIButton *)zhijiebtn
{
    if(!_zhijiebtn)
    {
        _zhijiebtn = [[UIButton alloc] init];
        [_zhijiebtn addTarget:self action:@selector(gobackbtnclick) forControlEvents:UIControlEventTouchUpInside];
        [_zhijiebtn setTitle:@"直接使用" forState:normal];
        _zhijiebtn.titleLabel.textAlignment = NSTextAlignmentRight;
        [_zhijiebtn setTitleColor:[UIColor wjColorFloat:@"FF4444"] forState:normal];
        _zhijiebtn.titleLabel.font = [UIFont systemFontOfSize:12];
        //_zhijiebtn.backgroundColor = [UIColor greenColor];
        
    }
    return _zhijiebtn;
}

-(UIImageView *)xieyiimg
{
    if(!_xieyiimg)
    {
        _xieyiimg = [[UIImageView alloc] init];
        _xieyiimg.image = [UIImage imageNamed:@"牛评用户协议"];
    }
    return _xieyiimg;
}


-(UILabel *)aggrentlab
{
    if(!_aggrentlab)
    {
        _aggrentlab = [[UILabel alloc] init];
        NSString *str = @"登录即表示您同意用户协议";
        _aggrentlab.font = [UIFont systemFontOfSize:12];
        //创建NSMutableAttributedString
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:str];
        //设置字体和设置字体的范围
        [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(8
                                                                                                       , 4)];
        //添加文字颜色
        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor wjColorFloat:@"FF4444"] range:NSMakeRange(8, 4)];
        //添加下划线
        [attrStr addAttribute:NSUnderlineStyleAttributeName
                        value:[NSNumber numberWithInteger:NSUnderlineStyleSingle]
                        range:NSMakeRange(8, 4)];
        
        _aggrentlab.textColor = [UIColor wjColorFloat:@"CDCDC7"];
        _aggrentlab.attributedText = attrStr;
        
        [_aggrentlab sizeToFit];
        
        [_aggrentlab yb_addAttributeTapActionWithStrings:@[@"用户协议"] delegate:self];
        
        [_aggrentlab yb_addAttributeTapActionWithStrings:@[@"用户协议"] tapClicked:^(NSString *string, NSRange range, NSInteger index) {
            NSLog(@"122");
            [self tapAction];
        }];
        
    }
    return _aggrentlab;
}

#pragma mark - 实现方法

-(void)loginbtnclick
{
    
    [self weixinLogin];
    

}


-(void)gobackbtnclick
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)weixinLogin{
    if([WXApi isWXAppInstalled]){
        SendAuthReq *req = [[SendAuthReq alloc]init];
        req.scope = WX_SCOPE;
        req.state = WX_STATE; //可省，不影响功能
        
        [WXApi sendReq:req];
        
        
    }else{
        [self noLoginAlertController];
    }
}

-(void)WXLogin:(NSNotificationCenter *)center
{
    
    
    NSUserDefaults *userdefat = [NSUserDefaults standardUserDefaults];
    
    NSString *tokenkey = [userdefat objectForKey:@"access_token"];
    NSDictionary *dic = [userdefat objectForKey:@"userinfo"];
    NSString *nickname = [dic objectForKey:@"nickname"];
    NSString *path = [dic objectForKey:@"headimgurl"];
    NSString *openid = [dic objectForKey:@"openid"];
    
    
    NSLog(@"openid---------%@",openid);
    NSDictionary *para = @{@"login_type":@"quickLogin",@"openid":openid,@"token_key":tokenkey,@"nickname":nickname,@"type":@"4",@"path":path};
    
    [AFManager postReqURL:denglu reqBody:para block:^(id infor) {
        NSLog(@"infor---------%@",infor);
        if ([[infor objectForKey:@"code"] intValue]==1) {
            NSString *token = [infor objectForKey:@"token"];
            NSString *uid = [infor objectForKey:@"uid"];
            NSUserDefaults *userdefat = [NSUserDefaults standardUserDefaults];
            [userdefat setObject:token forKey:@"tokenuser"];
            [userdefat setObject:uid forKey:@"uid"];
            NSLog(@"tolen-------------%@",token);
            [userdefat synchronize];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else
        {
            NSLog(@"状态异常，请稍后再试");
        }
    }];
}

#pragma mark - 设置弹出提示语

- (void)noLoginAlertController {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请先安装微信客户端" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:actionConfirm];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)isLoginedAlertController{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您已经登陆了，请先退出登录" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:actionConfirm];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)tapAction{
    
}


-(void)createView
{
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64)];
    [self.view addSubview:_scrollView];
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 64)];
    _imageView.image = [UIImage imageNamed:@"牛评用户协议.jpg"];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_scrollView addSubview:_imageView];
    
    //设置内容大小
    _scrollView.contentSize = _imageView.frame.size;
    //设置代理为控制器
    _scrollView.delegate = self;
    //设置最小缩放比例
    _scrollView.minimumZoomScale = 1;
    //设置最大缩放比例
    _scrollView.maximumZoomScale = 2;
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapGesture:)];
    //设置手势点击数,双击：点2下
    tapGesture.numberOfTapsRequired=2;
    //    self.imageView.userInteractionEnabled = YES;
    [_scrollView addGestureRecognizer:tapGesture];
    //    [self.imageView addGestureRecognizer:tapGesture];
    
}

// Do any additional setup after loading the view, typically from a nib.
//放大缩小
-(void)handleTapGesture:(UIGestureRecognizer*)sender
{
    if(_scrollView.zoomScale > 1.0){
        [_scrollView setZoomScale:1.0 animated:YES];
    }else{
        [_scrollView setZoomScale:2.0 animated:YES];
    }
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    
    return _imageView;
}


@end
