//
//  newCell.m
//  Supercomments
//
//  Created by 王俊钢 on 2017/4/7.
//  Copyright © 2017年 wangjungang. All rights reserved.
//

#import "newCell.h"
#import "UILabel+MultipleLines.h"
#import "newModel.h"
#import "YYPhotoGroupView.h"
#import "Timestr.h"
#import "YYKit.h"

@interface newCell()
@property (nonatomic,strong) newModel *nmodel;
@end

@implementation newCell

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
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.commbtn.frame = CGRectMake(DEVICE_WIDTH-90*WIDTH_SCALE, self.frame.size.height-34*HEIGHT_SCALE, 66*WIDTH_SCALE, 16*HEIGHT_SCALE);
    self.zbtn.frame = CGRectMake(160*WIDTH_SCALE, self.frame.size.height-34*HEIGHT_SCALE, 100*WIDTH_SCALE, 20*HEIGHT_SCALE);
    self.namelab.frame = CGRectMake(14*WIDTH_SCALE, 16*HEIGHT_SCALE, DEVICE_WIDTH/2-14*WIDTH_SCALE, 15*HEIGHT_SCALE);
    self.fromlab.frame = CGRectMake(DEVICE_WIDTH-200*WIDTH_SCALE, 16*HEIGHT_SCALE, 185*WIDTH_SCALE, 14*HEIGHT_SCALE);
    self.reimg.frame = CGRectMake(14*WIDTH_SCALE, self.frame.size.height-32*HEIGHT_SCALE, 24*WIDTH_SCALE, 16*HEIGHT_SCALE);
    self.timelab.frame = CGRectMake(14*WIDTH_SCALE+30*WIDTH_SCALE, self.frame.size.height-32*HEIGHT_SCALE, 150*WIDTH_SCALE, 18*HEIGHT_SCALE);
    self.timelab2.frame = CGRectMake(14*WIDTH_SCALE,self.frame.size.height-32*HEIGHT_SCALE, 150*WIDTH_SCALE, 18*HEIGHT_SCALE);
    self.tiview.frame = CGRectMake(14*WIDTH_SCALE, self.frame.size.height-74*HEIGHT_SCALE, DEVICE_WIDTH-28*WIDTH_SCALE, 30*HEIGHT_SCALE);
    
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

+ (CGFloat)cellHeightWithText:(NSString *)text{
    
    CGSize textSize = [UILabel sizeWithText:text
                                      lines:4
                                       font:[UIFont systemFontOfSize:17*FX]
                             andLineSpacing:QSTextLineSpacing*HEIGHT_SCALE
                          constrainedToSize:CGSizeMake(DEVICE_WIDTH - 28*WIDTH_SCALE,MAXFLOAT)];
    return textSize.height;
}

-(void)setcelldata:(newModel *)model
{
    self.nmodel = model;
    self.namelab.text = model.namestr;
    CGSize textSize = [self.contentlab setText:model.contentstr lines:4 andLineSpacing:QSTextLineSpacing*HEIGHT_SCALE constrainedToSize:CGSizeMake(DEVICE_WIDTH-28*WIDTH_SCALE,MAXFLOAT)];
    self.contentlab.frame = CGRectMake(14*WIDTH_SCALE,  38*HEIGHT_SCALE, DEVICE_WIDTH -28*WIDTH_SCALE, textSize.height);
    self.contentlab.text = model.contentstr;
    NSString *str1 = @" 标题: ";
    NSString *str2 = model.titlestr;
    NSMutableAttributedString *strbut = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",str1,str2]];
    [strbut addAttribute:NSForegroundColorAttributeName value:[UIColor wjColorFloat:@"333333"] range:NSMakeRange(0, str1.length)];
    [strbut addAttribute:NSForegroundColorAttributeName value:[UIColor wjColorFloat:@"576B95"] range:NSMakeRange(str1.length, str2.length)];
    self.tiview.titlelab.attributedText = strbut;
    self.commbtn.textlab.text = model.pinglunstr;
    
    
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
    
    self.zbtn.zanlab.frame = CGRectMake(100*WIDTH_SCALE-self.zbtn.zanlab.text.length*10*FX, 2*HEIGHT_SCALE, self.zbtn.zanlab.text.length*10*FX, 20*HEIGHT_SCALE);
    self.zbtn.zanimg.frame = CGRectMake(100*WIDTH_SCALE-self.zbtn.zanlab.text.length*10*FX-16*WIDTH_SCALE, 2*HEIGHT_SCALE, 16*WIDTH_SCALE, 16*WIDTH_SCALE);   
    self.commbtn.textlab.frame = CGRectMake(66*WIDTH_SCALE-self.commbtn.textlab.text.length*10*FX, 2*HEIGHT_SCALE, self.commbtn.textlab.text.length*10*FX, 20*HEIGHT_SCALE);
    self.commbtn.leftimg.frame = CGRectMake(66*WIDTH_SCALE-self.commbtn.textlab.text.length*10*FX-16*WIDTH_SCALE, 2*HEIGHT_SCALE, 16*WIDTH_SCALE, 16*WIDTH_SCALE);

    self.timelab.text = [Timestr datetime:model.timestr];
    self.timelab2.text = [Timestr datetime:model.timestr];
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
        [self.contentView addSubview:self.reimg];
        [self.contentView addSubview:self.timelab];
    }else
    {
        [self.contentView addSubview:self.timelab2];
    }
    
    NSString *str=model.timestr;//时间戳
    [Timestr datetime:str];
    
    CGFloat hei = textSize.height;
    
    [[SDWebImageDownloader sharedDownloader]downloadImageWithURL:[NSURL URLWithString:model.imgurlstr] options:SDWebImageDownloaderUseNSURLCache progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
            //这边就能拿到图片了
            
            if (model.imgurlstr.length==0) {
                
                 [self.infoimg setHidden:YES];
            }
            else if(self.nmodel.contentstr.length==0&&self.nmodel.imgurlstr.length!=0)
            {
                CGFloat width = image.size.width;
                CGRect rect = CGRectMake(0, 0, width, 194*HEIGHT_SCALE);//创建矩形框
                _infoimg.image = [UIImage imageWithCGImage:CGImageCreateWithImageInRect([image CGImage] ,rect)];
                self.infoimg.frame =CGRectMake(14*WIDTH_SCALE, (16+20)*HEIGHT_SCALE, DEVICE_WIDTH-28*WIDTH_SCALE, 194*HEIGHT_SCALE);
                [self.infoimg setHidden:NO];
                //self.infoimg.backgroundColor = [UIColor greenColor];
                
            }
            else
            {
                CGFloat width = image.size.width;
                CGRect rect = CGRectMake(0, 0, width, 194*HEIGHT_SCALE);//创建矩形框
                _infoimg.image = [UIImage imageWithCGImage:CGImageCreateWithImageInRect([image CGImage] ,rect)];
                self.infoimg.frame =CGRectMake(14*WIDTH_SCALE, (16+14+hei+14)*HEIGHT_SCALE, DEVICE_WIDTH-28*WIDTH_SCALE, 194*HEIGHT_SCALE);
                [self.infoimg setHidden:NO];
                
            }
    }];
    
}

- (void)tapAction{
        YYPhotoGroupItem *item = [YYPhotoGroupItem new];
        item.thumbView         = _infoimg;
        item.largeImageURL     = [NSURL URLWithString:self.nmodel.imgurlstr];
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
