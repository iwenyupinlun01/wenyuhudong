//
//  myinfoCell1.m
//  Supercomments
//
//  Created by 王俊钢 on 2017/4/6.
//  Copyright © 2017年 wangjungang. All rights reserved.
//

#import "myinfoCell1.h"

@implementation myinfoCell1

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.leftlab];
        [self.contentView addSubview:self.rightlab];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.leftlab.frame = CGRectMake(14*WIDTH_SCALE, 15*HEIGHT_SCALE, 80*WIDTH_SCALE, 30*HEIGHT_SCALE);
    self.rightlab.frame = CGRectMake(DEVICE_WIDTH/2, 15*HEIGHT_SCALE, DEVICE_WIDTH/2-34*WIDTH_SCALE, 30*HEIGHT_SCALE);
}

#pragma mark - getters

-(UILabel *)leftlab
{
    if(!_leftlab)
    {
        _leftlab = [[UILabel alloc] init];
        _leftlab.textColor = [UIColor wjColorFloat:@"5D5E5F"];
        _leftlab.text = @"昵称";
    }
    return _leftlab;
}

-(UILabel *)rightlab
{
    if(!_rightlab)
    {
        _rightlab = [[UILabel alloc] init];
        _rightlab.textColor =[UIColor wjColorFloat:@"5D5E5F"];
        //_rightlab.text = @"两袖清风";
        _rightlab.textAlignment = NSTextAlignmentRight;
    }
    return _rightlab;
}




@end
