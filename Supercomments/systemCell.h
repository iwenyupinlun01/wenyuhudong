//
//  systemCell.h
//  Supercomments
//
//  Created by 王俊钢 on 2017/4/6.
//  Copyright © 2017年 wangjungang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
@class xitongModel;
@interface systemCell : SWTableViewCell
- (void)layoutSubviewsWithText:(NSString *)text;

+ (CGFloat)cellHeightWithText:(NSString *)text;
-(void)setcelldata:(xitongModel *)model;
@property (nonatomic,strong)UILabel *contentLabel;
@property (nonatomic,strong)UILabel *timelabel;

@end
