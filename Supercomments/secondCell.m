//
//  secondCell.m
//  Supercomments
//
//  Created by 王俊钢 on 2017/5/16.
//  Copyright © 2017年 wangjungang. All rights reserved.
//

#import "secondCell.h"




@implementation secondCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.pinglunlab];
        [self setuplayout];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
}


-(void)setuplayout
{
    [self.pinglunlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(8*HEIGHT_SCALE);
        make.left.equalTo(self).with.offset(64*WIDTH_SCALE);
        make.right.equalTo(self).with.offset(-14*WIDTH_SCALE);
        //make.bottom.equalTo(self).with.offset(-8*HEIGHT_SCALE);
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



@end
