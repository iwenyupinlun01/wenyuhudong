//
//  hotCell.m
//  Supercomments
//
//  Created by 王俊钢 on 2017/5/8.
//  Copyright © 2017年 wangjungang. All rights reserved.
//

#import "hotCell.h"
#import "UILabel+MultipleLines.h"
#import "hotModel.h"
#import "YYPhotoGroupView.h"
#import "Timestr.h"
#import "YYKit.h"
#import "XWScanImage.h"

@interface hotCell()
@property (nonatomic,strong) hotModel *hmodel;
@end

@implementation hotCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.namelab];
        [self.contentView addSubview:self.fromlab];
        [self.contentView addSubview:self.contentlab];
        [self.contentView addSubview:self.tiview];
        [self.contentView addSubview:self.commbtn];
        [self.contentView addSubview:self.zbtn];;
        [self.contentView addSubview:self.infoimg];
        [self.contentView addSubview:self.reimg];
        [self.contentView addSubview:self.timelab];
        [self.contentView addSubview:self.timelab2];
        [self setupmas];
    }
    return self;
}

-(void)setupmas
{
    __weak typeof (self) weakSelf = self;
    [_namelab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(14*WIDTH_SCALE);
        make.height.mas_equalTo(15*HEIGHT_SCALE);
        make.width.mas_equalTo( DEVICE_WIDTH/2-14*WIDTH_SCALE);
        make.top.equalTo(weakSelf).with.offset(16*HEIGHT_SCALE);
    }];
    [_fromlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf).with.offset(-14*WIDTH_SCALE);
        make.top.equalTo(weakSelf).with.offset(16*HEIGHT_SCALE);
        make.width.mas_equalTo(185*WIDTH_SCALE);
        make.height.mas_equalTo(14*HEIGHT_SCALE);
        
    }];
    
    [_contentlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(14*WIDTH_SCALE);
        make.right.equalTo(self).with.offset(-14*WIDTH_SCALE);
        make.top.equalTo(self.namelab.mas_bottom).with.offset(8*HEIGHT_SCALE);
        
    }];
    
    [_infoimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf).with.offset(-14*WIDTH_SCALE);
        make.left.equalTo(weakSelf).with.offset(14*WIDTH_SCALE);
        make.height.mas_equalTo(192*HEIGHT_SCALE);
        make.top.equalTo(weakSelf.contentlab.mas_bottom).with.offset(8*HEIGHT_SCALE);
    }];
    
    [_tiview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(14*WIDTH_SCALE);
        make.right.equalTo(self).with.offset(-14*WIDTH_SCALE);
        make.height.mas_equalTo(20*HEIGHT_SCALE);
        make.top.equalTo(self.infoimg.mas_bottom).with.offset(2*HEIGHT_SCALE);
    }];
    
}

#pragma mark - getters

-(UILabel *)namelab
{
    if(!_namelab)
    {
        _namelab = [[UILabel alloc] init];
        _namelab.textColor = [UIColor wjColorFloat:@"666666"];
        _namelab.font = [UIFont systemFontOfSize:14*FX];
    }
    return _namelab;
}

-(UILabel *)fromlab
{
    if(!_fromlab)
    {
        _fromlab = [[UILabel alloc] init];
        _fromlab.textColor = [UIColor wjColorFloat:@"C7C7CD"];
        _fromlab.font = [UIFont systemFontOfSize:12*FX];
        _fromlab.textAlignment = NSTextAlignmentRight;
    }
    return _fromlab;
}

-(UILabel *)contentlab
{
    if(!_contentlab)
    {
        _contentlab = [[UILabel alloc] init];
        _contentlab.textColor = [UIColor wjColorFloat:@"333333"];
    }
    return _contentlab;
}

-(UILabel *)timelab
{
    if(!_timelab)
    {
        _timelab = [[UILabel alloc] init];
        _timelab.textColor = [UIColor wjColorFloat:@"C7C7CD"];
        _timelab.font = [UIFont systemFontOfSize:12*FX];
        
    }
    return _timelab;
}

-(UILabel *)timelab2
{
    if(!_timelab2)
    {
        _timelab2 = [[UILabel alloc] init];
        _timelab2.textColor = [UIColor wjColorFloat:@"C7C7CD"];
        _timelab2.font = [UIFont systemFontOfSize:12*FX];
    }
    return _timelab2;
}

-(UIImageView *)reimg
{
    if(!_reimg)
    {
        _reimg = [[UIImageView alloc] init];
        _reimg.image = [UIImage imageNamed:@"牛评"];
    }
    return _reimg;
}

-(commentsBtn *)commbtn
{
    if(!_commbtn)
    {
        _commbtn = [[commentsBtn alloc] init];
        [_commbtn addTarget:self action:@selector(test2:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commbtn;
}

-(zanBtn *)zbtn
{
    if(!_zbtn)
    {
        _zbtn = [[zanBtn alloc] init];
        [_zbtn addTarget:self action:@selector(test:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _zbtn;
}

-(titleView *)tiview
{
    if(!_tiview)
    {
        _tiview = [[titleView alloc] init];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Actiondo)];
        [_tiview addGestureRecognizer:tapGesture];
    }
    return _tiview;
}

-(UIImageView *)infoimg
{
    if(!_infoimg)
    {
        _infoimg = [[UIImageView alloc] init];
        _infoimg.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [_infoimg addGestureRecognizer:tap];
    }
    return _infoimg;
}


-(CGFloat)setcelldata:(hotModel *)model
{
    CGFloat imghei ;
    
    self.hmodel = model;
    
    self.namelab.text = model.namestr;
    
    NSString *str1 = @" 标题: ";
    NSString *str2 = model.titlestr;
    NSMutableAttributedString *strbut = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",str1,str2]];
    [strbut addAttribute:NSForegroundColorAttributeName value:[UIColor wjColorFloat:@"333333"] range:NSMakeRange(0, str1.length)];
    [strbut addAttribute:NSForegroundColorAttributeName value:[UIColor wjColorFloat:@"576B95"] range:NSMakeRange(str1.length, str2.length)];
    self.tiview.titlelab.attributedText = strbut;
    self.timelab.text = [Timestr datetime:model.timestr];
    self.timelab2.text = [Timestr datetime:model.timestr];
    
    self.contentlab.numberOfLines = 0;
    self.contentlab.lineBreakMode = NSLineBreakByTruncatingTail;
    self.contentlab.text = model.contentstr;
    [self.contentlab setText:model.contentstr lines:4 andLineSpacing:4 constrainedToSize:CGSizeMake(DEVICE_WIDTH-28*WIDTH_SCALE, 0)];
    
    [self.contentlab sizeToFit];
    self.texthei = self.contentlab.frame.size.height;
    
    [self.contentlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.texthei);
    }];
    if (model.contentstr.length!=0&&model.imgurlstr.length!=0) {
        [self.infoimg sd_setImageWithURL:[NSURL URLWithString:model.small_imagesstrl] placeholderImage:[UIImage imageNamed:@"默认图"]];
        
        [self.contentlab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(self.texthei);
        }];
        imghei = 194*HEIGHT_SCALE;
    }else if (model.contentstr.length==0&&model.imgurlstr.length!=0)
    {
        [self.infoimg sd_setImageWithURL:[NSURL URLWithString:model.small_imagesstrl] placeholderImage:[UIImage imageNamed:@"默认图"]];
        [self.infoimg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.namelab.mas_bottom).with.offset(9*HEIGHT_SCALE);
        }];
        [self.tiview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.infoimg.mas_bottom).with.offset(2*HEIGHT_SCALE);
        }];
        imghei = 194*HEIGHT_SCALE;
    }else
    {
        [self.tiview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentlab.mas_bottom).with.offset(2*HEIGHT_SCALE);
        }];
        imghei = 0;
    }
    if ([model.sifoudianzanstr isEqualToString:@"0"]) {
        self.zbtn.zanimg.image = [UIImage imageNamed:@"点赞-"];
        self.zbtn.zanlab.textColor = [UIColor wjColorFloat:@"C7C7CD"];
    }
    else
    {
        self.zbtn.zanimg.image = [UIImage imageNamed:@"点赞-拷贝"];
        self.zbtn.zanlab.textColor = [UIColor wjColorFloat:@"FF4444"];
    }
    if ([model.typestr isEqualToString:@"1"]) {
        self.fromlab.text = [NSString stringWithFormat:@"%@%@%@",@"腾讯老司机已赞",model.fromstr,@"次"];
    }else if ([model.typestr isEqualToString:@"2"])
    {
        self.fromlab.text = [NSString stringWithFormat:@"%@%@%@",@"网易老司机已赞",model.fromstr,@"次"];
        
    }
    else if ([model.typestr isEqualToString:@"5"])
    {
        self.fromlab.text = [NSString stringWithFormat:@"%@%@%@%@",model.platformstr,@"已赞",model.fromstr,@"次"];
    }
    else
    {
        self.fromlab.text = [NSString stringWithFormat:@"%@%@%@",@"今日牛评老司机已赞",model.fromstr,@"次"];
    }
    if ([model.ishot isEqualToString:@"1"]) {
        
        [_reimg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(14*WIDTH_SCALE);
            make.height.mas_equalTo(16*HEIGHT_SCALE);
            make.width.mas_equalTo(24*WIDTH_SCALE);
            make.top.equalTo(self.tiview.mas_bottom).with.offset(20*HEIGHT_SCALE);
        }];
        
        [_timelab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.reimg.mas_right).with.offset(4*WIDTH_SCALE);
            make.top.equalTo(self.tiview.mas_bottom).with.offset(18*HEIGHT_SCALE);
            make.height.mas_equalTo(20*HEIGHT_SCALE);
        }];
        
    }else
    {
        [_timelab2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.tiview.mas_bottom).with.offset(18*HEIGHT_SCALE);
            make.left.equalTo(self).with.offset(14*WIDTH_SCALE);
            make.height.mas_equalTo(20*HEIGHT_SCALE);
        }];
    }
    
    
    if ([model.dianzanstr intValue]>999) {
        self.zbtn.zanlab.text = @"999+";
    }else
    {
        self.zbtn.zanlab.text = model.dianzanstr;
    }
    if ([model.pinglunstr intValue]>999) {
        self.commbtn.textlab.text = @"999+";
    }else
    {
        self.commbtn.textlab.text = model.pinglunstr;
    }
    
    [self.commbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tiview.mas_bottom).with.offset(20*HEIGHT_SCALE);
        make.right.equalTo(self).with.offset(-14*WIDTH_SCALE);
        make.height.mas_equalTo(20*HEIGHT_SCALE);
        make.width.mas_equalTo(60*WIDTH_SCALE);
        
        [self.commbtn.textlab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.tiview.mas_bottom).with.offset(20*HEIGHT_SCALE);
            make.right.equalTo(self).with.offset(-14*WIDTH_SCALE);
            make.height.mas_equalTo(20*HEIGHT_SCALE);
            
        }];
        [self.commbtn.leftimg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.tiview.mas_bottom).with.offset(20*HEIGHT_SCALE);
            make.right.equalTo(self.commbtn.textlab.mas_left).with.offset(-4*WIDTH_SCALE);
            make.height.mas_equalTo(16*WIDTH_SCALE);
            make.width.mas_equalTo(16*WIDTH_SCALE);
            
        }];
    }];
    
    [self.zbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tiview.mas_bottom).with.offset(20*HEIGHT_SCALE);
        make.right.equalTo(self.commbtn).with.offset(-40*WIDTH_SCALE);
        make.height.mas_equalTo(20*HEIGHT_SCALE);
        make.width.mas_equalTo(64*WIDTH_SCALE);
        
        [self.zbtn.zanlab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.tiview.mas_bottom).with.offset(20*HEIGHT_SCALE);
            make.right.equalTo(self.commbtn.leftimg.mas_left).with.offset(-30*WIDTH_SCALE);
            make.height.mas_equalTo(20*HEIGHT_SCALE);
            
        }];
        [self.zbtn.zanimg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.tiview.mas_bottom).with.offset(20*HEIGHT_SCALE);
            make.right.equalTo(self.zbtn.zanlab.mas_left).with.offset(-4*WIDTH_SCALE);
            make.height.mas_equalTo(16*WIDTH_SCALE);
            make.width.mas_equalTo(16*WIDTH_SCALE);
            
        }];
    }];

    
    NSString *str=model.timestr;//时间戳
    [Timestr datetime:str];
    [self layoutIfNeeded];
    
    if (model.contentstr.length!=0&&model.imgurlstr.length!=0) {
        return _texthei+imghei+120*HEIGHT_SCALE;
    }else if (model.contentstr.length==0&&model.imgurlstr.length!=0)
    {
        return imghei +114*HEIGHT_SCALE;
    }else
    {
        return imghei+114*HEIGHT_SCALE+_texthei;
    }
}

- (void)tapAction{
    YYPhotoGroupItem *item = [YYPhotoGroupItem new];
    item.thumbView         = _infoimg;
    item.largeImageURL     = [NSURL URLWithString:self.hmodel.imgurlstr];
    YYPhotoGroupView *view = [[YYPhotoGroupView alloc] initWithGroupItems:@[item]];
    UIView *toView         = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    [view presentFromImageView:_infoimg
                   toContainer:toView
                      animated:YES completion:nil];
}

//按钮事件

//点赞
-(void)test:(UIButton *)sender
{
    [self.delegate myTabVClick1:self];
    
}

//回复
-(void)test2:(UIButton *)sender
{
    
    [self.delegate myTabVClick2:self];
}

-(void)Actiondo
{
    [self.delegate myTabVClick3:self];
}

@end
