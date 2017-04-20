//
//  commentsBtn.m
//  Supercomments
//
//  Created by 王俊钢 on 2017/4/8.
//  Copyright © 2017年 wangjungang. All rights reserved.
//

#import "commentsBtn.h"

@interface commentsBtn()
@property (nonatomic,strong) UIImageView *leftimg;

@end

@implementation commentsBtn

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.leftimg];
        [self addSubview:self.textlab];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.leftimg.frame = CGRectMake(5*WIDTH_SCALE, 2*HEIGHT_SCALE, 18*WIDTH_SCALE, 18*WIDTH_SCALE);
    self.textlab.frame = CGRectMake(25*WIDTH_SCALE, 2*HEIGHT_SCALE, 20*WIDTH_SCALE, 20*HEIGHT_SCALE);
    
}

#pragma mark - getters

-(UIImageView *)leftimg
{
    if(!_leftimg)
    {
        _leftimg = [[UIImageView alloc] init];
        _leftimg.image = [UIImage imageNamed:@"评"];
    }
    return _leftimg;
}


-(UILabel *)textlab
{
    if(!_textlab)
    {
        _textlab = [[UILabel alloc] init];
        _textlab.textColor = [UIColor wjColorFloat:@"C7C7CD"];
        _textlab.text = @"12";
        _textlab.textAlignment = NSTextAlignmentRight;
        _textlab.font = [UIFont systemFontOfSize:13];
    }
    return _textlab;
}




@end
