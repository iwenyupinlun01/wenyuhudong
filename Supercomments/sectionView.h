//
//  sectionView.h
//  Supercomments
//
//  Created by 王俊钢 on 2017/4/11.
//  Copyright © 2017年 wangjungang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class detailcellmodel;




@interface sectionView : UIView
@property (nonatomic,assign) CGFloat hei;

@property (nonatomic,strong) UIImageView *picimg;
@property (nonatomic,strong) UILabel *namelab;
@property (nonatomic,strong) UILabel *timelab;
@property (nonatomic,strong) UILabel *contentlab;


-(void)setcelldata:(detailcellmodel*)model;
+ (CGFloat)cellHeightWithText:(NSString *)text;
@end
