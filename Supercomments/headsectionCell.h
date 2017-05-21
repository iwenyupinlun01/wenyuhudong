//
//  headsectionCell.h
//  Supercomments
//
//  Created by 王俊钢 on 2017/5/18.
//  Copyright © 2017年 wangjungang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "titleView.h"
#import "zanBtn.h"
#import "commentsBtn.h"
#import "thumbView.h"
@class headViewModel;


@protocol myheadViewdelegate <NSObject>

-(void)myTabheadClick1:(UITableViewCell *)cell;
-(void)myTabheadClick2:(UITableViewCell *)cell;
-(void)myTabheadClick3:(UITableViewCell *)cell;
-(void)myTabheadClick4:(UITableViewCell *)cell;

@end

@interface headsectionCell : UITableViewCell
@property (nonatomic,strong) UILabel *namelab;
@property (nonatomic,strong) UILabel *fromlab;
@property (nonatomic,strong) UILabel *contentlab;
@property (nonatomic,strong) UILabel *numberlab;
@property (nonatomic,strong) titleView *title;
@property (nonatomic,strong) UILabel *timelab;
@property (nonatomic,strong) zanBtn *dianzanbtn;
@property (nonatomic,strong) commentsBtn *combtn;
@property (nonatomic,strong) UIButton *sharebtn;
@property (nonatomic,strong) UIImageView *headimg;
@property (nonatomic,strong) UILabel *thumlabel;

@property (nonatomic,strong) UIView *lineview;
-(CGFloat )setdata:(NSDictionary *)dic userarr:(NSMutableArray *)userarr;

@property(assign,nonatomic)id<myheadViewdelegate>delegate;

@end
