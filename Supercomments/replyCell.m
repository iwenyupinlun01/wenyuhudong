//
//  replyCell.m
//  Supercomments
//
//  Created by 王俊钢 on 2017/4/6.
//  Copyright © 2017年 wangjungang. All rights reserved.
//

#import "replyCell.h"
#import "replyModel.h"

@interface replyCell()
@property (nonatomic,strong) replyModel *model;
@end

@implementation replyCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.picimage];
        [self.contentView addSubview:self.namelab];
        [self.contentView addSubview:self.rightimage];
        [self.contentView addSubview:self.textlab];
        [self.contentView addSubview:self.timelab];
        [self.contentView addSubview:self.btn];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.picimage.frame = CGRectMake(14*WIDTH_SCALE, 16*HEIGHT_SCALE, 36*WIDTH_SCALE, 36*WIDTH_SCALE);
    self.namelab.frame = CGRectMake(28*WIDTH_SCALE+36*WIDTH_SCALE, 20*HEIGHT_SCALE, 100*WIDTH_SCALE, 10*HEIGHT_SCALE);
    self.rightimage.frame = CGRectMake(DEVICE_WIDTH-14*WIDTH_SCALE-50*WIDTH_SCALE, 16*HEIGHT_SCALE, 50*WIDTH_SCALE, 50*WIDTH_SCALE);
    self.textlab.frame = CGRectMake(128/2*WIDTH_SCALE, 94/2*HEIGHT_SCALE, DEVICE_WIDTH-128/2*WIDTH_SCALE-148/2*WIDTH_SCALE, (248/2-94/2-44)*HEIGHT_SCALE);
    self.timelab.frame = CGRectMake(130/2*WIDTH_SCALE, (self.frame.size.height-16-15)*HEIGHT_SCALE, 80*WIDTH_SCALE, 15*HEIGHT_SCALE);
    self.btn.frame = CGRectMake(DEVICE_WIDTH-12*WIDTH_SCALE-40*WIDTH_SCALE, self.frame.size.height-16*HEIGHT_SCALE-40/3*HEIGHT_SCALE, 40*WIDTH_SCALE, 40/3*HEIGHT_SCALE);
    
    
}

-(void)setdata:(replyModel *)repmodel
{
    self.model = repmodel;
    [self.picimage sd_setImageWithURL:[NSURL URLWithString:repmodel.replyurl]];
    self.namelab.text = repmodel.replyname;
    self.textlab.text = repmodel.replytext;
    self.timelab.text = repmodel.replytimestr;
    [self.rightimage sd_setImageWithURL:[NSURL URLWithString:repmodel.replyrighturl]];
    [self layoutIfNeeded];
}

#pragma mark - getters

-(UIImageView *)picimage
{
    if(!_picimage)
    {
        _picimage = [[UIImageView alloc] init];
        _picimage.layer.masksToBounds =YES;
        _picimage.layer.cornerRadius = 18*WIDTH_SCALE;
        _picimage.backgroundColor = [UIColor greenColor];
    }
    return _picimage;
}

-(UILabel *)namelab
{
    if(!_namelab)
    {
        _namelab = [[UILabel alloc] init];
        _namelab.text = @"大米饭饭";
        _namelab.font = [UIFont systemFontOfSize:13];
        _namelab.textColor = [UIColor wjColorFloat:@"455F8E"];
    }
    return _namelab;
}

-(UIImageView *)rightimage
{
    if(!_rightimage)
    {
        _rightimage = [[UIImageView alloc]init];
        _rightimage.backgroundColor = [UIColor orangeColor];
    }
    return _rightimage;
}

-(UILabel *)textlab
{
    if(!_textlab)
    {
        _textlab = [[UILabel alloc] init];
        NSString *str = @"无尽火域，炎帝执掌，无尽火域，炎帝执掌，无尽火域，炎帝执掌，无尽火域，炎帝执掌，无尽火域，炎帝执掌，";
        //_textlab.backgroundColor = [UIColor redColor];
        _textlab.font = [UIFont systemFontOfSize:13];
        _textlab.numberOfLines = 0;//多行显示，计算高度
        _textlab.text = str;
        [_textlab sizeToFit];
    }
    return _textlab;
}

-(UILabel *)timelab
{
    if(!_timelab)
    {
        _timelab = [[UILabel alloc] init];
        _timelab.text = @"13:40";
        _timelab.textColor = [UIColor wjColorFloat:@"999999"];
        _timelab.font = [UIFont systemFontOfSize:11];
    }
    return _timelab;
}

-(setbtn *)btn
{
    if(!_btn)
    {
        _btn = [[setbtn alloc] init];
        [_btn addTarget:self action:@selector(test:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn;
}

//按钮事件
-(void)test:(UIButton *)sender
{
    //    NSLog(@"%d",sender.tag);
    //实现代码块
    //    if (self.btnClick) {
    //        self.btnClick();
    //    }
    
    [self.delegate myTabVClick:self];
    
}



@end
