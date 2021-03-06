//
//  AppDelegate.m
//  Supercomments
//
//  Created by 王俊钢 on 2017/4/5.
//  Copyright © 2017年 wangjungang. All rights reserved.
//

#import "AppDelegate.h"
#import "homeViewController.h"
#import "navViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

//微信SDK头文件
#import "WXApi.h"

//新浪微博SDK头文件
#import "WeiboSDK.h"
//新浪微博SDK需要在项目Build Settings中的Other Linker Flags添加"-ObjC"

#import "hDisplayView.h"

#import "AFNetworking.h"
//友盟统计
#import "UMMobClick/MobClick.h"
//bugly
#import <Bugly/Bugly.h>

//runime防止崩溃系统
#import "AvoidCrash.h"
#import "NSArray+AvoidCrash.h"

@interface AppDelegate ()<WXApiDelegate>
///声明微信代理属性
//@property (nonatomic,assign)id<WXApiDelegate>wxDelegate;

@property (nonatomic,strong) NSString *typestr;
@property (strong, nonatomic) UIView *lunchView;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.window.backgroundColor = [UIColor whiteColor];
    homeViewController *homevc = [[homeViewController alloc] init];
    navViewController *navigationController=[[navViewController alloc] initWithRootViewController:homevc];
    self.window.rootViewController=navigationController;
    navigationController.navigationBar.barStyle = UIBarStyleDefault;
    navigationController.navigationBar.translucent = NO;
    navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    self.typestr = @"0";
    
    
    //友盟
    UMConfigInstance.appKey = @"59117a7f4544cb6533000e47";
    UMConfigInstance.channelId = @"App Store";
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
    
    //Bugly
    [Bugly startWithAppId:@"7de265060f"];
    
    //向微信注册应用。
    
    [WXApi registerApp:@"wx133ee2b8bd5d3c7d"];
    
    [ShareSDK registerApp:@"1d0c68ab95d2c"
     
     //第二个参数（分享平台集合）
          activePlatforms:@[
                            @(SSDKPlatformSubTypeWechatSession),
                            @(SSDKPlatformSubTypeWechatTimeline),]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
                 //微信
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
                 
             default:
                 break;
         }
         
     }
     //
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
              switch (platformType)
              {
                      //腾讯微信权限类型authType:SSO + Web授权
                  case SSDKPlatformTypeWechat:
                      [appInfo SSDKSetupWeChatByAppId:@"wx133ee2b8bd5d3c7d"
                                            appSecret:@"a905fbeb82b080c8c643360a062f2531"];
                      break;
                  default:
                      break;
              }
          }];
    
    
    /**
     可以在这里进行一个判断的设置，如果是app第一次启动就加载启动页，如果不是，则直接进入首页
     **/
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
    }
    else{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
    }
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
        // 这里判断是否第一次
        
        hDisplayView *hvc = [[hDisplayView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT)];
        
        [self.window.rootViewController.view addSubview:hvc];
        
        [UIView animateWithDuration:0.25 animations:^{
            hvc.frame = CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT);
            
        }];
        
    }
    // 启动图片延时: 2秒
    //[NSThread sleepForTimeInterval:2];
    if ([self.typestr isEqualToString:@"0"]) {
        [NSThread sleepForTimeInterval:2];
        
    }else
    {
        [NSThread sleepForTimeInterval:0];
        return NO;
    }
    
    
    //启动防止崩溃功能
    [AvoidCrash becomeEffective];
    
    //监听通知:AvoidCrashNotification, 获取AvoidCrash捕获的崩溃日志的详细信息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dealwithCrashMessage:) name:AvoidCrashNotification object:nil];
    return YES;
}

-(void)onReq:(BaseReq *)req{
    
    NSLog(@"huidiao");
    
}

//微信代理方法
- (void)onResp:(BaseResp *)resp
{
    
    SendAuthResp *aresp = (SendAuthResp *)resp;
    if(aresp.errCode== 0 ||aresp.errCode==nil)
    {
        NSString *code = aresp.code;
        [self getWeiXinOpenId:code];
    }
}

//通过code获取access_token，openid，unionid

- (void)getWeiXinOpenId:(NSString *)code{
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",WXPatient_App_ID,WXPatient_App_Secret,code];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        if (data){
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSString *openID = dic[@"openid"];
            NSString *unionid = dic[@"unionid"];
            NSLog(@"openid---------%@",openID);
            NSLog(@"unid===========%@",unionid);
            NSString *access_token = dic[@"access_token"];
            NSLog(@"token---------------%@",access_token);
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:access_token forKey:@"access_token"];
            [defaults setObject:openID forKey:@"openid"];
            [defaults synchronize];
            NSLog(@"%@",[defaults objectForKey:@"access_token"]);
            AFHTTPSessionManager *manage = [AFHTTPSessionManager manager];
            manage.responseSerializer = [AFHTTPResponseSerializer serializer];
            [manage GET:@"https://api.weixin.qq.com/sns/userinfo" parameters:@{@"openid":openID, @"access_token":access_token} progress:^(NSProgress * _Nonnull downloadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                NSLog(@"%@",dict);
                //        {
                //            city = "xxx";
                //            country = xxx;
                //            headimgurl = “http://wx.qlogo.cn/mmopen/xxxxxxx/0”;
                //            language = "zh_CN";
                //            nickname = xxx;
                //            openid = xxxxxxxxxxxxxxxxxxx; //授权用户唯一标识
                //            privilege =     (
                //            );
                //            province = "xxx";
                //            sex = 0;
                //            unionid = xxxxxxxxxxxxxxxxxx;
                //        }
                NSString *namestr = [dict objectForKey:@"nickname"];
                NSString *pathurlstr = [dict objectForKey:@"headimgurl"];
                [defaults setObject:dict forKey:@"userinfo"];
                [defaults setObject:namestr forKey:@"namestr"];
                [defaults setObject:pathurlstr forKey:@"pathurlstr"];
                [defaults synchronize];
                
                self.typestr = @"1";
                
                [[NSNotificationCenter defaultCenter] postNotificationName:WXLoginSuccess object:@"dengluchenggong"];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"userinfo error-->%@", error.localizedDescription);
            }];
        }
    });
    
}




- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary*)options{
    
    [WXApi handleOpenURL:url delegate:self];
    return true;
}
// 这个方法是用于从微信返回第三方App
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    return [WXApi handleOpenURL:url delegate:self];
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [WXApi handleOpenURL:url delegate:self];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    NSLog(@"home");
    [AFManager getReqURL:[NSString stringWithFormat:jiemianyingcang,[tokenstr tokenstrfrom],@"1"] block:^(id infor) {
        NSLog(@"infor-------%@",infor);
        
    } errorblock:^(NSError *error) {
        
    }];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [self saveContext];
}

- (void)dealwithCrashMessage:(NSNotification *)note {
    //不论在哪个线程中导致的crash，这里都是在主线程
    
    //注意:所有的信息都在userInfo中
    //你可以在这里收集相应的崩溃信息进行相应的处理(比如传到自己服务器)
    NSLog(@"\n\n在AppDelegate中 方法:dealwithCrashMessage打印\n\n\n\n\n%@\n\n\n\n",note.userInfo);
}

@end
