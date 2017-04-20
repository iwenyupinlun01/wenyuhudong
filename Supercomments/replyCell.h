//
//  replyCell.h
//  Supercomments
//
//  Created by 王俊钢 on 2017/4/6.
//  Copyright © 2017年 wangjungang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "setbtn.h"
@class replyModel;

//创建一个代理
@protocol myTabVdelegate <NSObject>

-(void)myTabVClick:(UITableViewCell *)cell;

@end

@interface replyCell : UITableViewCell
@property (nonatomic,strong) UIImageView *picimage;
@property (nonatomic,strong) UILabel *namelab;
@property (nonatomic,strong) UIImageView *rightimage;
@property (nonatomic,strong) UILabel *textlab;
@property (nonatomic,strong) UILabel *timelab;
@property (nonatomic,strong) setbtn *btn;
@property(assign,nonatomic)id<myTabVdelegate>delegate;


-(void)setdata:(replyModel *)repmodel;
@end
