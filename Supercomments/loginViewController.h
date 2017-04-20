//
//  loginViewController.h
//  Supercomments
//
//  Created by 王俊钢 on 2017/4/5.
//  Copyright © 2017年 wangjungang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface loginViewController : UIViewController
/** 通过block去执行AppDelegate中的weixinLoginByRequestForUserInfo方法 */
@property (copy, nonatomic) void (^weixinLoginByRequestForUserInfo)();
@end
