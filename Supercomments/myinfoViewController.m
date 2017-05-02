//
//  myinfoViewController.m
//  Supercomments
//
//  Created by 王俊钢 on 2017/4/6.
//  Copyright © 2017年 wangjungang. All rights reserved.
//

#import "myinfoViewController.h"
#import "myinfoCell0.h"
#import "myinfoCell1.h"
#import "nicknameViewController.h"
@interface myinfoViewController ()<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    MBProgressHUD *HUD;
}
@property (nonatomic,strong) UITableView *myinfotable;

@property (nonatomic,strong) UIButton *sentbtn;
@property (nonatomic,strong) UIImageView *demoimg;
@end

static NSString *myinfoidentfid0 = @"myidentfid0";
static NSString *myinfoidentfid1 = @"myidentfid1";

@implementation myinfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor wjColorFloat:@"333333"];
    
    self.title = @"个人中心";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor wjColorFloat:@"333333"]}];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    self.myinfotable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    [self.view addSubview:self.myinfotable];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(nameasd:) name:@"usernamexiugai" object:nil];
    
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

#pragma mark - getters

-(UIImageView *)demoimg
{
    if(!_demoimg)
    {
        _demoimg = [[UIImageView alloc] initWithFrame:CGRectMake(30, 90, 100, 100)];
        _demoimg.image = [UIImage imageNamed:@"矢量智能对象"];
    }
    return _demoimg;
}

-(UIButton *)sentbtn
{
    if(!_sentbtn)
    {
        _sentbtn = [[UIButton alloc] initWithFrame:CGRectMake(50, 250, 100, 40)];
        [_sentbtn setTitle:@"发送" forState:normal];
        [_sentbtn setTitleColor:[UIColor blackColor] forState:normal];
        [_sentbtn addTarget:self action:@selector(sentbtnclick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sentbtn;
}

-(void)sentbtnclick
{
    UIImage *originImage = [UIImage imageNamed:@"启动页"];
    NSData *data = UIImageJPEGRepresentation(originImage, 1.0f);
    NSString *base64str = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSLog(@"base64str-------%@",base64str);
    [AFManager postReqURL:touxiang reqBody:@{@"token":[tokenstr tokenstrfrom],@"str":base64str} block:^(id infor) {
        NSLog(@"infor-------%@",infor);
    }];
}


-(UITableView *)myinfotable
{
    if(!_myinfotable)
    {
        _myinfotable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT-64)];
        _myinfotable.dataSource = self;
        _myinfotable.delegate = self;
        _myinfotable.scrollEnabled = NO;
    }
    return _myinfotable;
}

#pragma mark -UITableViewDataSource&&UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        myinfoCell0 *cell = [tableView dequeueReusableCellWithIdentifier:myinfoidentfid0];
        if (!cell) {
            cell = [[myinfoCell0 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myinfoidentfid0];
        }
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setSeparatorInset:UIEdgeInsetsZero];
        cell.infoimage.tag = 200;
        
//        NSUserDefaults *userdefat = [NSUserDefaults standardUserDefaults];
//        NSString *path2 = [userdefat objectForKey:@"pathurlstr"];
        NSString *path = [tokenstr userimgstrfrom];
        NSLog(@"path-%@",path);

        [cell.infoimage sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"头像默认图"]];
        return cell;
        
    }
    if (indexPath.row==1) {
        myinfoCell1 *cell = [tableView dequeueReusableCellWithIdentifier:myinfoidentfid1];
        if (!cell) {
            cell = [[myinfoCell1 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myinfoidentfid1];
        }
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setSeparatorInset:UIEdgeInsetsZero];
        cell.rightlab.tag = 201;
        NSUserDefaults *userdefat = [NSUserDefaults standardUserDefaults];
        NSString *nickname = [userdefat objectForKey:@"namestr"];
        cell.rightlab.text = nickname;
        return cell;
    }
    return  nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60*HEIGHT_SCALE;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        [self changeIcon];
    }
    if (indexPath.row==1) {
        nicknameViewController *nicknamevc = [[nicknameViewController alloc] init];
        [self.navigationController pushViewController:nicknamevc animated:YES];
    }
}

#pragma mark - 实现方法

-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 选择图片

- (void)changeIcon
{
    UIAlertController *alertController;
    
    __block NSUInteger blockSourceType = 0;
    
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        //支持访问相机与相册情况
        alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请选择图片" preferredStyle:    UIAlertControllerStyleActionSheet];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"从相册中选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSLog(@"点击从相册中选取");
            //相册
            blockSourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            
            imagePickerController.delegate = self;
            
            imagePickerController.allowsEditing = YES;
            
            imagePickerController.sourceType = blockSourceType;
            
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSLog(@"点击拍照");
            //相机
            blockSourceType = UIImagePickerControllerSourceTypeCamera;
            
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            
            imagePickerController.delegate = self;
            
            imagePickerController.allowsEditing = YES;
            
            imagePickerController.sourceType = blockSourceType;
            
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            NSLog(@"点击取消");
            // 取消
            return;
        }]];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else
    {
        //只支持访问相册情况
        alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请选择图片" preferredStyle:UIAlertControllerStyleActionSheet];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"从相册中选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSLog(@"点击从相册中选取");
            //相册
            blockSourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            
            imagePickerController.delegate = self;
            
            imagePickerController.allowsEditing = YES;
            
            imagePickerController.sourceType = blockSourceType;
            
            [self presentViewController:imagePickerController animated:YES completion:^{
                
            }];
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            NSLog(@"点击取消");
            // 取消
            return;
        }]];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

#pragma mark - 选择图片后,回调选择

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    UIImageView *picimage = [self.myinfotable viewWithTag:200];
    picimage.image = image;
    [self.myinfotable reloadData];
    
    
    UIImage *originImage = image;
    NSData *data = UIImageJPEGRepresentation(originImage, 1.0f);
    NSString *base64str = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSLog(@"base64str-------%@",base64str);
    
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.dimBackground = YES;
    HUD.labelText = @"请稍等";
    //显示对话框
    [HUD showAnimated:YES whileExecutingBlock:^{
        //对话框显示时需要执行的操作
        [AFManager postReqURL:touxiang reqBody:@{@"token":[tokenstr tokenstrfrom],@"str":base64str} block:^(id infor) {
            NSLog(@"infor-------%@",infor);
            if ([[infor objectForKey:@"code"] intValue]==1) {
                NSString *urlstr = [infor objectForKey:@"newIcon"];
                NSUserDefaults *defat = [NSUserDefaults standardUserDefaults];
                [defat setObject:urlstr forKey:@"pathurlstr"];
                [defat synchronize];
                [self.myinfotable reloadData];
            }
        }];
        
    } completionBlock:^{
        //操作执行完后取消对话框
        [HUD removeFromSuperview];
        HUD = nil;
    }];
}

-(void)nameasd:(NSNotification *)notifocation
{
    NSString *name = (NSString *)[notifocation object];
    UILabel *namelab = [self.myinfotable viewWithTag:201];
    namelab.text = name;
    [self.myinfotable reloadData];
}

- (void)dealloc{
    //[super dealloc];
    // 移除当前对象监听的事件
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
@end
