//
//  pinglunCell.h
//  Supercomments
//
//  Created by 王俊钢 on 2017/4/19.
//  Copyright © 2017年 wangjungang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class detailcellmodel;
@interface pinglunCell : UITableViewCell
@property (nonatomic,strong) UILabel *pinglunlab;
-(void)setcelldata:(detailcellmodel *)model;
+ (CGFloat)cellHeightWithText:(NSString *)text;
@end
