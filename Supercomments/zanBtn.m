//
//  zanBtn.m
//  Supercomments
//
//  Created by 王俊钢 on 2017/4/8.
//  Copyright © 2017年 wangjungang. All rights reserved.
//

#import "zanBtn.h"

@interface zanBtn()

@end

@implementation zanBtn

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //self.backgroundColor = [UIColor redColor];
        [self addSubview:self.zanimg];
        [self addSubview:self.zanlab];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];

}



#pragma mark - getters

-(UIImageView *)zanimg
{
    if(!_zanimg)
    {
        _zanimg = [[UIImageView alloc]init];
    }
    return _zanimg;
}

-(UILabel *)zanlab
{
    if(!_zanlab)
    {
        _zanlab = [[UILabel alloc] init];

        _zanlab.textAlignment = NSTextAlignmentRight;
        _zanlab.font = [UIFont systemFontOfSize:13*FX];
        
    }
    return _zanlab;
}
@end
