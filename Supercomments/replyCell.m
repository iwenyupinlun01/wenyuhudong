//
//  replyCell.m
//  Supercomments
//
//  Created by 王俊钢 on 2017/4/6.
//  Copyright © 2017年 wangjungang. All rights reserved.
//

#import "replyCell.h"
#import "replyModel.h"
#import "Timestr.h"
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

        [self.contentView addSubview:self.textlab];
        [self.contentView addSubview:self.timelab];
        [self.contentView addSubview:self.btn];
//        [self.contentView addSubview:self.rightlab];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.picimage.frame = CGRectMake(14*WIDTH_SCALE, 16*HEIGHT_SCALE, 36*WIDTH_SCALE, 36*WIDTH_SCALE);
    self.namelab.frame = CGRectMake(28*WIDTH_SCALE+36*WIDTH_SCALE, 20*HEIGHT_SCALE, 100*WIDTH_SCALE, 10*HEIGHT_SCALE);
    self.rightimage.frame = CGRectMake(DEVICE_WIDTH-14*WIDTH_SCALE-50*WIDTH_SCALE, 16*HEIGHT_SCALE, 50*WIDTH_SCALE, 50*WIDTH_SCALE);
    self.textlab.frame = CGRectMake(128/2*WIDTH_SCALE, 94/2*HEIGHT_SCALE-12*HEIGHT_SCALE, DEVICE_WIDTH-128/2*WIDTH_SCALE-148/2*WIDTH_SCALE, (248/2-94/2-44)*HEIGHT_SCALE);
    self.timelab.frame = CGRectMake(130/2*WIDTH_SCALE, self.frame.size.height-16*HEIGHT_SCALE-40/3*HEIGHT_SCALE+10*HEIGHT_SCALE, 80*WIDTH_SCALE, 15*HEIGHT_SCALE);
    self.btn.frame = CGRectMake(DEVICE_WIDTH-12*WIDTH_SCALE-40*WIDTH_SCALE, self.frame.size.height-16*HEIGHT_SCALE-40/3*HEIGHT_SCALE+10*HEIGHT_SCALE, 40*WIDTH_SCALE, 40/3*HEIGHT_SCALE);
    self.rightlab.frame = CGRectMake(DEVICE_WIDTH-14*WIDTH_SCALE-50*WIDTH_SCALE, 16*HEIGHT_SCALE, 50*WIDTH_SCALE, 50*WIDTH_SCALE);
    
}



-(void)setdata:(replyModel *)repmodel
{
    self.model = repmodel;
    [self.picimage sd_setImageWithURL:[NSURL URLWithString:repmodel.replyurl]];
    self.namelab.text = repmodel.replyname;
    self.textlab.text = repmodel.replytext;
    //self.timelab.text = repmodel.replytimestr;
    self.timelab.text = [Timestr datetime:repmodel.replytimestr];
    if ([repmodel.comment_img_type isEqualToString:@"word"]) {
        [self.contentView addSubview:self.rightlab];
        self.rightlab.text = repmodel.comment_imgstr;
    }else
    {
        [self.contentView addSubview:self.rightimage];
        [self.rightimage sd_setImageWithURL:[NSURL URLWithString:repmodel.comment_imgstr]];
    }
    
    if ([repmodel.is_checkstr isEqualToString:@"0"]) {
        //未读
        self.backgroundColor = [UIColor wjColorFloat:@"F1FFFC"];
    }else
    {
        //已读
        self.backgroundColor = [UIColor whiteColor];
    }
    
    
    
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
        //_picimage.backgroundColor = [UIColor greenColor];
    }
    return _picimage;
}

-(UILabel *)namelab
{
    if(!_namelab)
    {
        _namelab = [[UILabel alloc] init];
        //_namelab.text = @"大米饭饭";
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
       // _rightimage.backgroundColor = [UIColor orangeColor];
    }
    return _rightimage;
}

-(UILabel *)textlab
{
    if(!_textlab)
    {
        _textlab = [[UILabel alloc] init];
        _textlab.font = [UIFont systemFontOfSize:17];
        _textlab.numberOfLines = 0;//多行显示，计算高度
        [_textlab sizeToFit];
    }
    return _textlab;
}

-(UILabel *)timelab
{
    if(!_timelab)
    {
        _timelab = [[UILabel alloc] init];
        _timelab.textColor = [UIColor wjColorFloat:@"999999"];
        _timelab.font = [UIFont systemFontOfSize:11];
    }
    return _timelab;
}

-(UILabel *)rightlab
{
    if(!_rightlab)
    {
        _rightlab = [[UILabel alloc] init];
        _rightlab.numberOfLines = 0;
        _rightlab.backgroundColor = [UIColor wjColorFloat:@"E8E8E8"];
        _rightlab.font = [UIFont systemFontOfSize:14];
        _rightlab.textColor = [UIColor wjColorFloat:@"333333"];
        [_rightlab sizeToFit];
    }
    return _rightlab;
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
