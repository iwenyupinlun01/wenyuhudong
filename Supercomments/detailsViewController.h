//
//  detailsViewController.h
//  Supercomments
//
//  Created by 王俊钢 on 2017/4/8.
//  Copyright © 2017年 wangjungang. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface detailsViewController : UIViewController
@property (nonatomic,strong) NSString *detalisidstr;
@property (nonatomic,strong) NSString *dianzanindex;

//最新还是最热
@property (nonatomic,strong) NSString *fromtypestr;
@end
