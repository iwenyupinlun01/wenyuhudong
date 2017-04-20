//
//  thumbView.h
//  Supercomments
//
//  Created by 王俊钢 on 2017/4/10.
//  Copyright © 2017年 wangjungang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UILabel+Category.h"
@interface thumbView : UIView
@property (nonatomic,strong) UIImageView *leftimg;

@property (nonatomic,strong) UILabel *thumblab;

@property (nonatomic,strong) NSMutableArray *thumarr;
@end
