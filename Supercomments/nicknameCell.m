//
//  nicknameCell.m
//  Supercomments
//
//  Created by 王俊钢 on 2017/4/6.
//  Copyright © 2017年 wangjungang. All rights reserved.
//

#import "nicknameCell.h"

@implementation nicknameCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.nicknametext];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.nicknametext.frame = CGRectMake(10*WIDTH_SCALE, 5*HEIGHT_SCALE, DEVICE_WIDTH-20*WIDTH_SCALE, 50*HEIGHT_SCALE);
}

#pragma mark - getters


-(UITextField *)nicknametext
{
    if(!_nicknametext)
    {
        _nicknametext = [[UITextField alloc] init];
        _nicknametext.clearButtonMode = UITextFieldViewModeWhileEditing;
        _nicknametext.font = [UIFont systemFontOfSize:15];
    }
    return _nicknametext;
}



@end
