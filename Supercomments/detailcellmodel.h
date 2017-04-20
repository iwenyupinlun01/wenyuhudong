//
//  detailcellmodel.h
//  Supercomments
//
//  Created by 王俊钢 on 2017/4/19.
//  Copyright © 2017年 wangjungang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface detailcellmodel : NSObject
@property (nonatomic,strong) NSString *namestr;
@property (nonatomic,strong) NSString *timestr;
@property (nonatomic,strong) NSString *contstr;

@property (nonatomic,strong) NSMutableArray *pingarr;

@property (nonatomic,strong) NSMutableArray *pingluncontarr;
@end
