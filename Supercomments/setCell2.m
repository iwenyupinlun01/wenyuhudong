//
//  setCell2.m
//  Supercomments
//
//  Created by 王俊钢 on 2017/5/7.
//  Copyright © 2017年 wangjungang. All rights reserved.
//

#import "setCell2.h"

@implementation setCell2

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.gobackbtn];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.gobackbtn.frame = CGRectMake(30*WIDTH_SCALE, 120*HEIGHT_SCALE, DEVICE_WIDTH-60*WIDTH_SCALE, 40*HEIGHT_SCALE);
}

-(UIButton *)gobackbtn
{
    if(!_gobackbtn)
    {
        _gobackbtn = [[UIButton alloc] init];
        [_gobackbtn setTitle:@"退出当前帐号" forState:normal];
        _gobackbtn.backgroundColor = [UIColor wjColorFloat:@"DA3850"];
        [_gobackbtn setTitleColor:[UIColor wjColorFloat:@"FFFFFF"] forState:normal];
        _gobackbtn.layer.masksToBounds = YES;
        _gobackbtn.layer.cornerRadius = 20*HEIGHT_SCALE;
    }
    return _gobackbtn;
}



@end
