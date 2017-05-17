//
//  firstCell.h
//  Supercomments
//
//  Created by 王俊钢 on 2017/5/16.
//  Copyright © 2017年 wangjungang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class firstModel;

@protocol mycellVdelegate <NSObject>

-(void)myTabVClick:(UITableViewCell *)cell datadic:(NSDictionary *)dic;

@end
@interface firstCell : UITableViewCell
@property (nonatomic,strong) UILabel *contentlab;
@property (nonatomic,strong) UITableView *texttable;
@property (nonatomic,strong) UIImageView *iconimg;
@property (nonatomic,strong) UILabel *namelab;
@property (nonatomic,strong) UILabel *timelab;

-(CGFloat )setcelldata:(firstModel *)model;

@property (nonatomic,assign) CGFloat cellheight;
@property(assign,nonatomic)id<mycellVdelegate>delegate;
@end
