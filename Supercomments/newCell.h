//
//  newCell.h
//  Supercomments
//
//  Created by 王俊钢 on 2017/4/7.
//  Copyright © 2017年 wangjungang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
#import "commentsBtn.h"
#import "zanBtn.h"
#import "titleView.h"

@class newModel;
//创建一个代理
@protocol mycellVdelegate <NSObject>

-(void)myTabVClick1:(UITableViewCell *)cell;
-(void)myTabVClick2:(UITableViewCell *)cell;

@end


@interface newCell : SWTableViewCell

@property (nonatomic,strong) UILabel *namelab;
@property (nonatomic,strong) UILabel *fromlab;
@property (nonatomic,strong) UILabel *contentlab;
@property (nonatomic,strong) titleView *tiview;
@property (nonatomic,strong) UILabel *timelab;
@property (nonatomic,strong) commentsBtn *commbtn;
@property (nonatomic,strong) zanBtn *zbtn;

@property (nonatomic,strong) NSString *heightstr;

@property (nonatomic,strong) UIImageView *infoimg;

@property(assign,nonatomic)id<mycellVdelegate>delegate;


-(void)setcelldata:(newModel *)model;

//- (void)layoutSubviewsWithText:(NSString *)text;

+ (CGFloat)cellHeightWithText:(NSString *)text;


@end
