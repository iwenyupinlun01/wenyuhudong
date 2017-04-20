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


@interface AppDelegate ()<WXApiDelegate>
///声明微信代理属性
//@property (nonatomic,assign)id<WXApiDelegate>wxDelegate;
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
    //navigationController.navigationBar.barTintColor = [UIColor wjColorFloat:@"008CCF"];
    [self.window makeKeyAndVisible];
    
    
    //向微信注册应用。
    //[WXApi registerApp:WXPatient_App_ID withDescription:@"Wechat"];
    [WXApi registerApp:@"wx133ee2b8bd5d3c7d"];
    
    
    
    
    
    return YES;
    
    //    /**
    //     可以在这里进行一个判断的设置，如果是app第一次启动就加载启动页，如果不是，则直接进入首页
    //     **/
    //    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) {
    //        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
    //        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
    //    }
    //    else{
    //        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
    //    }
    //
    //    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
    //        // 这里判断是否第一次
    //
    //        hDisplayView *hvc = [[hDisplayView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT)];
    //
    //        [self.window.rootViewController.view addSubview:hvc];
    //
    //        [UIView animateWithDuration:0.25 animations:^{
    //            hvc.frame = CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT);
    //
    //        }];
    //
    //    }
    // 启动图片延时: 2秒
    //[NSThread sleepForTimeInterval:2];
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
        
        [[NSNotificationCenter defaultCenter] postNotificationName:WXLoginSuccess object:@{@"code":aresp.code}];
        
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
                NSString *pathurlstr = [dict objectForKey:@"pathurlstr"];
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:dict forKey:@"userinfo"];
                [defaults setObject:namestr forKey:@"namestr"];
                [defaults setObject:pathurlstr forKey:@"pathurlstr"];
                
                [defaults synchronize];
                
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

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "edu.weixinLoginDemo" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"weixinLoginDemo" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"weixinLoginDemo.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}
@end
