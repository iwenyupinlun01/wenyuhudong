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
@property (nonatomic,strong) NSString *imgurlstr;

@property (nonatomic,strong) NSString *idstr;
@property (nonatomic,strong) NSString *touidstr;

@property (nonatomic,strong) NSMutableArray *pingarr;

@property (nonatomic,strong) NSMutableArray *name01arr;
@property (nonatomic,strong) NSMutableArray *name02arr;
@property (nonatomic,strong) NSMutableArray *idarr01;
@property (nonatomic,strong) NSMutableArray *idarr02;

@property (nonatomic,assign) CGFloat sectionhei;

//单元格的高度
@property (nonatomic,assign) CGFloat cellHeight;
@end
