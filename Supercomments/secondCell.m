//
//  secondCell.m
//  Supercomments
//
//  Created by 王俊钢 on 2017/5/16.
//  Copyright © 2017年 wangjungang. All rights reserved.
//

#import "secondCell.h"

@interface secondCell()
@property (nonatomic,strong) UIView *bgview;
@end


@implementation secondCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.bgview];
        [self.contentView addSubview:self.pinglunlab];
        [self setuplayout];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.bgview.frame = CGRectMake(61*WIDTH_SCALE, 0, DEVICE_WIDTH-64*WIDTH_SCALE-14*WIDTH_SCALE, self.frame.size.height);
}

-(void)setuplayout
{
    [self.pinglunlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(8*HEIGHT_SCALE);
        make.left.equalTo(self).with.offset(64*WIDTH_SCALE);
        make.right.equalTo(self).with.offset(-14*WIDTH_SCALE);
    }];
}

#pragma mark - getters

-(UILabel *)pinglunlab
{
    if(!_pinglunlab)
    {
        _pinglunlab = [[UILabel alloc] init];
        
    }
    return _pinglunlab;
}

-(UIView *)bgview
{
    if(!_bgview)
    {
        _bgview = [[UIView alloc] init];
        _bgview.backgroundColor = [UIColor wjColorFloat:@"F5F5F5"];
    }
    return _bgview;
}




@end
