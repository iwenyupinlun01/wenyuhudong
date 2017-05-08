//
//  hotCell.h
//  Supercomments
//
//  Created by 王俊钢 on 2017/5/8.
//  Copyright © 2017年 wangjungang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
#import "commentsBtn.h"
#import "zanBtn.h"
#import "titleView.h"
#import "YYKit.h"

@class hotModel;

//创建一个代理
@protocol mycellVdelegate <NSObject>

-(void)myTabVClick1:(UITableViewCell *)cell;
-(void)myTabVClick2:(UITableViewCell *)cell;
-(void)myTabVClick3:(UITableViewCell *)cell;
@end
static NSString *hotidentfid = @"hotidentfid";
@interface hotCell : UITableViewCell
@property (nonatomic,strong) UILabel *namelab;
@property (nonatomic,strong) UILabel *fromlab;
@property (nonatomic,strong) UILabel *contentlab;
@property (nonatomic,strong) titleView *tiview;
@property (nonatomic,strong) UILabel *timelab;
@property (nonatomic,strong) commentsBtn *commbtn;
@property (nonatomic,strong) zanBtn *zbtn;
@property (nonatomic,strong) UIImageView *reimg;
@property (nonatomic,strong) NSString *heightstr;
@property (nonatomic,strong) UILabel *timelab2;
@property (nonatomic,strong) UIImageView *infoimg;
@property (nonatomic,assign) CGFloat texthei;
@property(assign,nonatomic)id<mycellVdelegate>delegate;

-(CGFloat)setcelldata:(hotModel *)model;
@end
