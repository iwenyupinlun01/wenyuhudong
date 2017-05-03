//
//  keyboardView.h
//  Supercomments
//
//  Created by 王俊钢 on 2017/4/24.
//  Copyright © 2017年 wangjungang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WJGtextView.h"
@interface keyboardView : UIView
@property (nonatomic,strong) WJGtextView *textview;

@property (nonatomic,strong) UIButton *sendbtn;

@property (nonatomic,assign) NSInteger index;
@property (nonatomic,strong) NSString *nickname;
@property (nonatomic,strong) NSString *tonickname;

@property (nonatomic,strong) NSString *pidstr;
@property (nonatomic,strong) NSString *touidstr;
@property (nonatomic,assign) NSInteger secindex;

@property (nonatomic,strong) UIView *bgview;
@end

