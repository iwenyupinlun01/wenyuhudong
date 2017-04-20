//
//  navViewController.m
//  Supercomments
//
//  Created by 王俊钢 on 2017/4/14.
//  Copyright © 2017年 wangjungang. All rights reserved.
//

#import "navViewController.h"

@interface navViewController ()

@end

@implementation navViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UIStatusBarStyle)preferredStatusBarStyle

{
    
    UIViewController* topVC = self.topViewController;
    
    return [topVC preferredStatusBarStyle];
    
}

@end
