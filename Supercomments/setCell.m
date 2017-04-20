//
//  setCell.m
//  Supercomments
//
//  Created by 王俊钢 on 2017/4/6.
//  Copyright © 2017年 wangjungang. All rights reserved.
//

#import "setCell.h"

@implementation setCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.rightlab];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.rightlab.frame = CGRectMake(DEVICE_WIDTH-80*WIDTH_SCALE, 15*HEIGHT_SCALE, 60*WIDTH_SCALE, 30*HEIGHT_SCALE);
}

#pragma mark - getters


-(UILabel *)rightlab
{
    if(!_rightlab)
    {
        _rightlab = [[UILabel alloc] init];
        _rightlab.textColor = [UIColor wjColorFloat:@"999999"];
        
    }
    return _rightlab;
}


@end
