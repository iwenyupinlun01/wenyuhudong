//
//  thumbView.m
//  Supercomments
//
//  Created by 王俊钢 on 2017/4/10.
//  Copyright © 2017年 wangjungang. All rights reserved.
//
#define CREATE_BUTTON(X,Y,WIDTH,TITLE) [self addButtonWithX:X y:Y width:WIDTH title:TITLE]
#define UPDATEFRAME [self updateAviewFrame];
#import "thumbView.h"

@implementation thumbView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.thumblab];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
}

#pragma mark - getters


-(UILabel *)thumblab
{
    if(!_thumblab)
    {
        _thumblab = [[UILabel alloc] init];
        _thumblab.textColor = [UIColor wjColorFloat:@"CDCDC7"];
    }
    return _thumblab;
}






@end
