//
//  emptyerrorView.m
//  Supercomments
//
//  Created by 王俊钢 on 2017/5/8.
//  Copyright © 2017年 wangjungang. All rights reserved.
//

#import "emptyerrorView.h"

@interface emptyerrorView()
@property (nonatomic,strong) UIImageView *errorimage;
@end

@implementation emptyerrorView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.errorimage];
        [self setuplayout];
        
        UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [self addGestureRecognizer:tapGesturRecognizer];

    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
   
}

-(void)setuplayout
{
    __weak typeof(self) weakSelf = self;
    [self.errorimage mas_makeConstraints:^(MASConstraintMaker *make) {
        // 添加大小约束（make就是要添加约束的控件view）
        make.size.mas_equalTo(CGSizeMake(200*WIDTH_SCALE, 120*HEIGHT_SCALE));
        // 添加居中约束（居中方式与self相同）
        make.center.equalTo(weakSelf);
    }];
}

#pragma mark - getters

-(UIImageView *)errorimage
{
    if(!_errorimage)
    {
        _errorimage = [[UIImageView alloc] init];
        _errorimage.image = [UIImage imageNamed:@"加载失败-1"];
    }
    return _errorimage;
}

-(void)tapAction:(id)tap
{
    NSLog(@"点击了tapView");
    [self.delegate myview:self];
}


@end
