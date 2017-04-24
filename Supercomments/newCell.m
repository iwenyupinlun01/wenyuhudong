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
@interface newCell()
@property (nonatomic,strong) UIImageView *reimg;
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
        [self.contentView addSubview:self.reimg];
        [self.contentView addSubview:self.commbtn];
        [self.contentView addSubview:self.zbtn];
        [self.contentView addSubview:self.timelab];
        [self.contentView addSubview:self.infoimg];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.namelab.frame = CGRectMake(14*WIDTH_SCALE, 8*HEIGHT_SCALE, DEVICE_WIDTH/2-14*WIDTH_SCALE, 15*HEIGHT_SCALE);
    self.fromlab.frame = CGRectMake(DEVICE_WIDTH-200*WIDTH_SCALE, 10*HEIGHT_SCALE, 185*WIDTH_SCALE, 14*HEIGHT_SCALE);
    self.reimg.frame = CGRectMake(14*WIDTH_SCALE, self.frame.size.height-30*HEIGHT_SCALE, 24*WIDTH_SCALE, 18*HEIGHT_SCALE);
    self.timelab.frame = CGRectMake(14*WIDTH_SCALE+30*WIDTH_SCALE, self.frame.size.height-30*HEIGHT_SCALE, 150*WIDTH_SCALE, 18*HEIGHT_SCALE);
    self.commbtn.frame = CGRectMake(DEVICE_WIDTH-50*WIDTH_SCALE, self.frame.size.height-30*HEIGHT_SCALE, 40*WIDTH_SCALE, 22*HEIGHT_SCALE);
    self.zbtn.frame = CGRectMake(DEVICE_WIDTH-110*WIDTH_SCALE, self.frame.size.height-30*HEIGHT_SCALE, 40*WIDTH_SCALE, 20*HEIGHT_SCALE);
    self.tiview.frame = CGRectMake(14*WIDTH_SCALE, self.frame.size.height-65*HEIGHT_SCALE, DEVICE_WIDTH-28*WIDTH_SCALE, 30*HEIGHT_SCALE);
    
    
}

#pragma mark - getters

-(UILabel *)namelab
{
    if(!_namelab)
    {
        _namelab = [[UILabel alloc] init];
        _namelab.textColor = [UIColor wjColorFloat:@"C7C7CD"];
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

#pragma 行间距 4

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
        //_timelab.text = @"十分钟前";
        _timelab.textColor = [UIColor wjColorFloat:@"C7C7CD"];
        _timelab.font = [UIFont systemFontOfSize:12*FX];
        
    }
    return _timelab;
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
                                      lines:QSTextDefaultLines2
                                       font:[UIFont systemFontOfSize:17*FX]
                             andLineSpacing:QSTextLineSpacing
                          constrainedToSize:CGSizeMake(DEVICE_WIDTH - 28*WIDTH_SCALE,MAXFLOAT)];
    
    return textSize.height;
    
}

+(CGFloat)cellimagehti:(NSString *)imgstr
{
    return 200;
}

-(void)setcelldata:(newModel *)model
{
    self.nmodel = model;
    self.namelab.text = model.namestr;
    self.contentlab.text = model.contentstr;
    self.tiview.titlelab.text = [NSString stringWithFormat:@"%@%@",@"  标题: ",model.titlestr];
    self.commbtn.textlab.text = model.pinglunstr;
    self.zbtn.zanlab.text = model.dianzanstr;
    self.timelab.text = [self datetime:model.timestr];
    
    if ([model.sifoudianzanstr isEqualToString:@"0"]) {
        self.zbtn.zanimg.image = [UIImage imageNamed:@"点赞-"];
    }
    else
    {
        self.zbtn.zanimg.image = [UIImage imageNamed:@"点赞-拷贝"];
    }
    
    if ([model.typestr isEqualToString:@"1"]) {
        self.fromlab.text = [NSString stringWithFormat:@"%@%@%@",@"腾讯老司机已赞",model.fromstr,@"次"];
    }else if ([model.typestr isEqualToString:@"2"])
    {
        self.fromlab.text = [NSString stringWithFormat:@"%@%@%@",@"网易老司机已赞",model.fromstr,@"次"];

    }else
    {
        self.fromlab.text = [NSString stringWithFormat:@"%@%@%@",@"今日牛评老司机已赞",model.fromstr,@"次"];
        
    }
    
    NSString *str=model.timestr;//时间戳
    [self datetime:str];
    
    CGSize textSize = [self.contentlab setText:model.contentstr lines:QSTextDefaultLines2 andLineSpacing:QSTextLineSpacing constrainedToSize:CGSizeMake(DEVICE_WIDTH,MAXFLOAT)];
    self.contentlab.frame = CGRectMake(14*WIDTH_SCALE,  30*HEIGHT_SCALE, DEVICE_WIDTH -28*WIDTH_SCALE, textSize.height);
    
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
                CGRect rect = CGRectMake(14*WIDTH_SCALE, (16+14+textSize.height+16)*HEIGHT_SCALE, width, 196*HEIGHT_SCALE);//创建矩形框
                
                _infoimg.image = [UIImage imageWithCGImage:CGImageCreateWithImageInRect([image CGImage] ,rect)];
                
                //self.infoimg.image = image;
                [self.infoimg sd_setImageWithURL:[NSURL URLWithString:self.nmodel.imgurlstr] placeholderImage:[UIImage imageNamed:@"默认图"]];
                
                self.infoimg.frame =CGRectMake(14*WIDTH_SCALE, (16+14)*HEIGHT_SCALE, DEVICE_WIDTH-28*WIDTH_SCALE, 196*HEIGHT_SCALE);
                
                [self.infoimg setHidden:NO];
            }
            else
            {
                CGFloat width = image.size.width;
                CGRect rect = CGRectMake(14*WIDTH_SCALE, (16+14+textSize.height+16)*HEIGHT_SCALE, width, 196*HEIGHT_SCALE);//创建矩形框
                
                _infoimg.image = [UIImage imageWithCGImage:CGImageCreateWithImageInRect([image CGImage] ,rect)];
               // self.infoimg.image = image;
                [self.infoimg sd_setImageWithURL:[NSURL URLWithString:self.nmodel.imgurlstr] placeholderImage:[UIImage imageNamed:@"默认图"]];
                self.infoimg.frame =CGRectMake(14*WIDTH_SCALE, (16+14+hei+14)*HEIGHT_SCALE, DEVICE_WIDTH-28*WIDTH_SCALE, 196*HEIGHT_SCALE);
                
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
    NSLog(@"122212");
    
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

//时间计算
-(NSString *)datetime:(NSString *)datestr
{
    NSTimeInterval time=[datestr doubleValue]+28800;//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    NSLog(@"date:%@",[detaildate description]);
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    //NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    NSDate *date = [NSDate date];
    //计算时间间隔（单位是秒）
    NSTimeInterval time2 = [date timeIntervalSinceDate:detaildate];
    //计算天数、时、分、秒
    
    int days = ((int)time2)/(3600*24);
    int hours = ((int)time2)%(3600*24)/3600;
    int minutes = ((int)time2)%(3600*24)%3600/60;
    int seconds = ((int)time2)%(3600*24)%3600%60;
    
    NSString *dateContent = [[NSString alloc] initWithFormat:@"过去%i天%i小时%i分%i秒",days,hours,minutes,seconds];
    NSLog(@"datacunt=====%@",dateContent);
    
    NSString *fanhuistr = [[NSString alloc] init];
    if (days>=365) {
        //实例化一个NSDateFormatter对象
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //设定时间格式,这里可以设置成自己需要的格式
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        //用[NSDate date]可以获取系统当前时间
        NSString *currentDateStr = [dateFormatter stringFromDate:detaildate];
        //输出格式为：2010-10-27 10:22:13
        NSLog(@"%@",currentDateStr);
        fanhuistr = currentDateStr;
    }
    else if(hours>=72&&hours<365)
    {
        //M月M日
        //实例化一个NSDateFormatter对象
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //设定时间格式,这里可以设置成自己需要的格式
        [dateFormatter setDateFormat:@"MM-dd HH:mm:ss"];
        //用[NSDate date]可以获取系统当前时间
        NSString *currentDateStr = [dateFormatter stringFromDate:detaildate];
        //输出格式为：2010-10-27 10:22:13
        NSLog(@"%@",currentDateStr);
        fanhuistr = currentDateStr;
    }else if (hours<72&&hours>=48)
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //设定时间格式,这里可以设置成自己需要的格式
        [dateFormatter setDateFormat:@"HH:mm"];
        //用[NSDate date]可以获取系统当前时间
        NSString *currentDateStr = [dateFormatter stringFromDate:detaildate];
        //输出格式为：2010-10-27 10:22:13
        NSLog(@"%@",currentDateStr);
        
        fanhuistr = [NSString stringWithFormat:@"%@%@",@"前天",@"currentDateStr"];
        
    }else if (hours<48&&hours>=24)
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //设定时间格式,这里可以设置成自己需要的格式
        [dateFormatter setDateFormat:@"HH:mm"];
        //用[NSDate date]可以获取系统当前时间
        NSString *currentDateStr = [dateFormatter stringFromDate:detaildate];
        //输出格式为：2010-10-27 10:22:13
        NSLog(@"%@",currentDateStr);
        
        fanhuistr = [NSString stringWithFormat:@"%@%@",@"昨天",@"currentDateStr"];
    }else if (hours<24&&hours>=1)
    {
         fanhuistr = [NSString stringWithFormat:@"%d%@%@",hours,@"小时",@"前"];
    }else
    {
        fanhuistr = [NSString stringWithFormat:@"%d%@%@",minutes,@"分钟",@"前"];
    }
    
    return fanhuistr;
}

@end
