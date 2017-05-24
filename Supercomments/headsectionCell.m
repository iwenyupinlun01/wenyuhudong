//
//  headsectionCell.m
//  Supercomments
//
//  Created by 王俊钢 on 2017/5/18.
//  Copyright © 2017年 wangjungang. All rights reserved.
//

#import "headsectionCell.h"
#import "headViewModel.h"
#import "Timestr.h"
#import "YYPhotoGroupView.h"
@interface headsectionCell()
@property (nonatomic,strong) NSString *headimgstr;
@end

@implementation headsectionCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.namelab];
        [self.contentView addSubview:self.fromlab];
        [self.contentView addSubview:self.contentlab];
        [self.contentView addSubview:self.numberlab];
        [self.contentView addSubview:self.title];
        [self.contentView addSubview:self.timelab];
        [self.contentView addSubview:self.dianzanbtn];
        [self.contentView addSubview:self.combtn];
        [self.contentView addSubview:self.sharebtn];
        [self.contentView addSubview:self.headimg];
        [self.contentView addSubview:self.thumlabel];
        [self.contentView addSubview:self.lineview];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.namelab.frame = CGRectMake(14*WIDTH_SCALE, 16*HEIGHT_SCALE, DEVICE_WIDTH/2, 14*HEIGHT_SCALE);
    self.fromlab.frame = CGRectMake(DEVICE_WIDTH-200*WIDTH_SCALE, 18*WIDTH_SCALE, 185*WIDTH_SCALE, 12*HEIGHT_SCALE);
    self.numberlab.frame = CGRectMake(14*WIDTH_SCALE, self.frame.size.height-14*HEIGHT_SCALE-8*HEIGHT_SCALE, 100*WIDTH_SCALE, 14*HEIGHT_SCALE);
    _lineview.frame = CGRectMake(14, self.frame.size.height-1, DEVICE_WIDTH-28, 1);
    
}

-(CGFloat )setdata:(NSDictionary *)dic userarr:(NSMutableArray *)userarr
{
    
    CGFloat headheight = 0.0;
    
    
    if (userarr.count<=12) {
        NSString *goodTotalString2 = [userarr componentsJoinedByString:@", "];
        NSString *goodTotalString = [NSString stringWithFormat:@"%@%@%lu%@",goodTotalString2,@" ",(unsigned long)userarr.count,@"人已赞"];
        NSMutableAttributedString *newGoodString = [[NSMutableAttributedString alloc] initWithString:goodTotalString];
        [newGoodString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, goodTotalString.length)];
        //设置行距 实际开发中间距为0太丑了，根据项目需求自己把握
        NSMutableParagraphStyle *paragraphstyle = [[NSMutableParagraphStyle alloc] init];
        paragraphstyle.lineSpacing = 3;
        [newGoodString addAttribute:NSParagraphStyleAttributeName value:paragraphstyle range:NSMakeRange(0, goodTotalString.length)];
        // 添加图片
        NSTextAttachment *attch = [[NSTextAttachment alloc] init];
        // 图片
        attch.image = [UIImage imageNamed:@"详情页点赞-提示"];
        // 设置图片大小
        attch.bounds = CGRectMake(0, 0, 14*WIDTH_SCALE, 14*WIDTH_SCALE);
        // 创建带有图片的富文本
        NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
        [newGoodString insertAttributedString:string atIndex:0];
        
        NSMutableAttributedString
        * attStr = [[NSMutableAttributedString alloc]initWithString:@" "];
        [newGoodString insertAttributedString:attStr atIndex:1];
        
        self.thumlabel.attributedText = newGoodString;
        self.thumlabel.numberOfLines = 0;
        //设置UILable自适
        self.thumlabel.lineBreakMode = NSLineBreakByCharWrapping;
        [self.thumlabel sizeToFit];
        
    }else
    {
        NSArray *smallArray = [userarr subarrayWithRange:NSMakeRange(0, 12)];
        NSString *goodTotalString2 = [smallArray componentsJoinedByString:@", "];
        NSString *goodTotalString = [NSString stringWithFormat:@"%@%@%@%lu%@",goodTotalString2,@"等",@" ",(unsigned long)userarr.count,@"人已赞"];
        NSMutableAttributedString *newGoodString = [[NSMutableAttributedString alloc] initWithString:goodTotalString];
        [newGoodString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, goodTotalString.length)];
        //设置行距 实际开发中间距为0太丑了，根据项目需求自己把握
        NSMutableParagraphStyle *paragraphstyle = [[NSMutableParagraphStyle alloc] init];
        paragraphstyle.lineSpacing = 3;
        [newGoodString addAttribute:NSParagraphStyleAttributeName value:paragraphstyle range:NSMakeRange(0, goodTotalString.length)];
        // 添加图片
        NSTextAttachment *attch = [[NSTextAttachment alloc] init];
        // 图片
        attch.image = [UIImage imageNamed:@"详情页点赞-提示"];
        // 设置图片大小
        attch.bounds = CGRectMake(0, 0, 14*WIDTH_SCALE, 14*WIDTH_SCALE);
        // 创建带有图片的富文本
        NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
        [newGoodString insertAttributedString:string atIndex:0];
        NSMutableAttributedString
        * attStr = [[NSMutableAttributedString alloc]initWithString:@" "];
        [newGoodString insertAttributedString:attStr atIndex:1];
        self.thumlabel.attributedText = newGoodString;
        self.thumlabel.numberOfLines = 0;
        //设置UILable自适
        self.thumlabel.lineBreakMode = NSLineBreakByCharWrapping;
        [self.thumlabel sizeToFit];
        
    }

    
    self.headimgstr = [dic objectForKey:@"images"];
    
    self.namelab.text = [dic objectForKey:@"name"];
    NSString *typestr = [dic objectForKey:@"type"];
    NSString *platformstr = [dic objectForKey:@"platform"];
    NSString *support_countstr = [dic objectForKey:@"support_count"];
    
    if (typestr.length!=0) {
        if ([typestr isEqualToString:@"1"]) {
            self.fromlab.text = [NSString stringWithFormat:@"%@%@%@",@"腾讯老司机已赞",support_countstr,@"次"];
        }
        else if ([typestr isEqualToString:@"2"]) {
            self.fromlab.text = [NSString stringWithFormat:@"%@%@%@",@"网易老司机已赞",support_countstr,@"次"];
        }
        else if ([typestr isEqualToString:@"5"]) {
            self.fromlab.text = [NSString stringWithFormat:@"%@%@%@%@",platformstr,@"已赞",support_countstr,@"次"];
        }
        else{
            self.fromlab.text = [NSString stringWithFormat:@"%@%@%@",@"今日牛评老司机已赞",support_countstr,@"次"];
        }

    }
    
    NSString *contentstr = [dic objectForKey:@"content"];
    NSString *small_imageurlstr = [dic objectForKey:@"small_images"];
    
    NSString *shifoudianzan = [dic objectForKey:@"is_support"];
    
    
    
    if (shifoudianzan.length!=0) {
        self.timelab.text = [Timestr datetime:[dic objectForKey:@"create_time"]];
        self.dianzanbtn.zanlab.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"support_num"]];
        self.combtn.textlab.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"reply_num"]];
        
        if ([shifoudianzan isEqualToString:@"0"]) {
            self.dianzanbtn.zanimg.image = [UIImage imageNamed:@"点赞-"];
            self.dianzanbtn.zanlab.textColor = [UIColor wjColorFloat:@"C7C7CD"];
        }else
        {
            self.dianzanbtn.zanimg.image = [UIImage imageNamed:@"点赞-拷贝"];
            self.dianzanbtn.zanlab.textColor = [UIColor wjColorFloat:@"FF4444"];
        }
    }
    
    
    
    
    NSString *reply_num = [dic objectForKey:@"reply_num"];
    if (reply_num.length!=0) {
        self.numberlab.text = [NSString stringWithFormat:@"%@%@",[dic objectForKey:@"reply_num"],@"人评论"];
    }
    
    [self.headimg sd_setImageWithURL:[NSURL URLWithString:small_imageurlstr] placeholderImage:[UIImage imageNamed:@"默认图"]];
    
    
    
    NSString *str1 = @" 标题: ";
    NSString *str2 = [dic objectForKey:@"title"];
    NSMutableAttributedString *strbut = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",str1,str2]];
    [strbut addAttribute:NSForegroundColorAttributeName value:[UIColor wjColorFloat:@"333333"] range:NSMakeRange(0, str1.length)];
    [strbut addAttribute:NSForegroundColorAttributeName value:[UIColor wjColorFloat:@"576B95"] range:NSMakeRange(str1.length, str2.length)];
    
    if (str2.length!=0) {
        self.title.titlelab.attributedText = strbut;
    }

    
    
    
    if (userarr.count==0) {
        [self.thumlabel setHidden:YES];
        
        if (contentstr.length!=0&&small_imageurlstr.length!=0) {

            
            self.contentlab.numberOfLines = 0;
            self.contentlab.font = [UIFont systemFontOfSize:17];
            self.contentlab.preferredMaxLayoutWidth = (DEVICE_WIDTH - 14*2*WIDTH_SCALE);
            [self.contentlab setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
            self.contentlab.lineBreakMode = NSLineBreakByWordWrapping;//换行方式
            self.contentlab.text = contentstr;
            CGSize textSize= [contentstr boundingRectWithSize:CGSizeMake(DEVICE_WIDTH-28*WIDTH_SCALE, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size;
            [self.contentlab sizeToFit];
            
            
            [self.contentlab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self).with.offset(38*HEIGHT_SCALE);
                make.left.equalTo(self).with.offset(14*WIDTH_SCALE);
                make.right.equalTo(self).with.offset(-14*WIDTH_SCALE);
                make.height.mas_equalTo(textSize.height);
            }];

            
            [self.headimg sd_setImageWithURL:[NSURL URLWithString:small_imageurlstr] placeholderImage:[UIImage imageNamed:@"默认图"]];
            [self.headimg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.contentlab.mas_bottom).with.offset(12*HEIGHT_SCALE);
                make.left.equalTo(self).with.offset(14*WIDTH_SCALE);
                make.right.equalTo(self).with.offset(-14*WIDTH_SCALE);
                make.height.mas_equalTo(192*HEIGHT_SCALE);
            }];
            [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).with.offset(14*WIDTH_SCALE);
                make.right.equalTo(self).with.offset(-14*WIDTH_SCALE);
                make.top.equalTo(self.headimg.mas_bottom).with.offset(2*HEIGHT_SCALE);
                make.height.mas_equalTo(20*HEIGHT_SCALE);
            }];
            [self.timelab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).with.offset(14*WIDTH_SCALE);
                make.top.equalTo(self.title).with.offset(45*HEIGHT_SCALE);
            }];
            
            
            [self.thumlabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).with.offset(14*WIDTH_SCALE);
                make.right.equalTo(self).with.offset(-14*WIDTH_SCALE);
                make.top.equalTo(self.timelab).with.offset(33*HEIGHT_SCALE);
            }];
            [self.sharebtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self).with.offset(-14*WIDTH_SCALE);
                make.top.equalTo(self.title).with.offset(22*HEIGHT_SCALE+20*HEIGHT_SCALE);
            }];
            [self.combtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self).with.offset(-70*WIDTH_SCALE);
                make.top.equalTo(self.title).with.offset(22*HEIGHT_SCALE+20*HEIGHT_SCALE);
                [self.combtn.textlab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.title).with.offset(45*HEIGHT_SCALE);
                    make.right.equalTo(self.sharebtn).with.offset(-40*WIDTH_SCALE);
                    make.height.mas_equalTo(20*HEIGHT_SCALE);
                }];
                [self.combtn.leftimg mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.title).with.offset(45*HEIGHT_SCALE);
                    make.right.equalTo(self.combtn.textlab.mas_left).with.offset(-4*WIDTH_SCALE);
                    make.height.mas_equalTo(16*WIDTH_SCALE);
                    make.width.mas_equalTo(16*WIDTH_SCALE);
                }];
                
            }];
            [self.dianzanbtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.combtn).with.offset(-50*WIDTH_SCALE);
                make.top.equalTo(self.title).with.offset(22*HEIGHT_SCALE+20*HEIGHT_SCALE);
                make.width.mas_equalTo(64*WIDTH_SCALE);
                [self.dianzanbtn.zanlab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.title).with.offset(45*HEIGHT_SCALE);
                    make.right.equalTo(self.combtn.leftimg).with.offset(-40*WIDTH_SCALE);
                    make.height.mas_equalTo(20*HEIGHT_SCALE);
                }];
                [self.dianzanbtn.zanimg mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.title).with.offset(45*HEIGHT_SCALE);
                    make.right.equalTo(self.dianzanbtn.zanlab.mas_left).with.offset(-4*WIDTH_SCALE);
                    make.height.mas_equalTo(16*WIDTH_SCALE);
                    make.width.mas_equalTo(16*WIDTH_SCALE);
                }];
            }];
            
            headheight = textSize.height+340*HEIGHT_SCALE;
            
            
           
        }
        else if (contentstr.length==0&&small_imageurlstr.length!=0)
        {
            [self.headimg sd_setImageWithURL:[NSURL URLWithString:small_imageurlstr] placeholderImage:[UIImage imageNamed:@"默认图"]];
            [self.headimg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.namelab.mas_bottom).with.offset(14*HEIGHT_SCALE);
                make.left.equalTo(self).with.offset(14*WIDTH_SCALE);
                make.right.equalTo(self).with.offset(-14*WIDTH_SCALE);
                make.height.mas_equalTo(192*HEIGHT_SCALE);
            }];
            [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).with.offset(14*WIDTH_SCALE);
                make.right.equalTo(self).with.offset(-14*WIDTH_SCALE);
                make.top.equalTo(self.headimg.mas_bottom).with.offset(2*HEIGHT_SCALE);
                make.height.mas_equalTo(20*HEIGHT_SCALE);
            }];
            [self.timelab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).with.offset(14*WIDTH_SCALE);
                make.top.equalTo(self.title).with.offset(45*HEIGHT_SCALE);
            }];
            [self.sharebtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self).with.offset(-14*WIDTH_SCALE);
                make.top.equalTo(self.title).with.offset(22*HEIGHT_SCALE+20*HEIGHT_SCALE);
            }];
            [self.combtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self).with.offset(-70*WIDTH_SCALE);
                make.top.equalTo(self.title).with.offset(22*HEIGHT_SCALE+20*HEIGHT_SCALE);
                [self.combtn.textlab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.title).with.offset(45*HEIGHT_SCALE);
                    make.right.equalTo(self.sharebtn).with.offset(-40*WIDTH_SCALE);
                    make.height.mas_equalTo(20*HEIGHT_SCALE);
                }];
                [self.combtn.leftimg mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.title).with.offset(45*HEIGHT_SCALE);
                    make.right.equalTo(self.combtn.textlab.mas_left).with.offset(-4*WIDTH_SCALE);
                    make.height.mas_equalTo(16*WIDTH_SCALE);
                    make.width.mas_equalTo(16*WIDTH_SCALE);
                }];
                
            }];
            [self.dianzanbtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.combtn).with.offset(-50*WIDTH_SCALE);
                make.top.equalTo(self.title).with.offset(22*HEIGHT_SCALE+20*HEIGHT_SCALE);
                make.width.mas_equalTo(64*WIDTH_SCALE);
                [self.dianzanbtn.zanlab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.title).with.offset(45*HEIGHT_SCALE);
                    make.right.equalTo(self.combtn.leftimg).with.offset(-40*WIDTH_SCALE);
                    make.height.mas_equalTo(20*HEIGHT_SCALE);
                }];
                [self.dianzanbtn.zanimg mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.title).with.offset(45*HEIGHT_SCALE);
                    make.right.equalTo(self.dianzanbtn.zanlab.mas_left).with.offset(-4*WIDTH_SCALE);
                    make.height.mas_equalTo(16*WIDTH_SCALE);
                    make.width.mas_equalTo(16*WIDTH_SCALE);
                }];
            }];
            
            headheight = 380*HEIGHT_SCALE;
            
            
        }else
        {
            
            self.contentlab.numberOfLines = 0;
            self.contentlab.font = [UIFont systemFontOfSize:17];
            self.contentlab.preferredMaxLayoutWidth = (DEVICE_WIDTH - 14*2*WIDTH_SCALE);
            [self.contentlab setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
            self.contentlab.lineBreakMode = NSLineBreakByWordWrapping;//换行方式
            self.contentlab.text = contentstr;
            CGSize textSize= [contentstr boundingRectWithSize:CGSizeMake(DEVICE_WIDTH-28*WIDTH_SCALE, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size;
            [self.contentlab sizeToFit];
            
            
            [self.contentlab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self).with.offset(38*HEIGHT_SCALE);
                make.left.equalTo(self).with.offset(14*WIDTH_SCALE);
                make.right.equalTo(self).with.offset(-14*WIDTH_SCALE);
                make.height.mas_equalTo(textSize.height);
            }];

            
            [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).with.offset(14*WIDTH_SCALE);
                make.right.equalTo(self).with.offset(-14*WIDTH_SCALE);
                make.top.equalTo(self.contentlab.mas_bottom).with.offset(2*HEIGHT_SCALE);
                make.height.mas_equalTo(20*HEIGHT_SCALE);
            }];
            [self.timelab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).with.offset(14*WIDTH_SCALE);
                make.top.equalTo(self.title).with.offset(45*HEIGHT_SCALE);
            }];
            
            [self.thumlabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).with.offset(14*WIDTH_SCALE);
                make.right.equalTo(self).with.offset(-14*WIDTH_SCALE);
                make.top.equalTo(self.timelab).with.offset(33*HEIGHT_SCALE);
                
            }];
            [self.sharebtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self).with.offset(-14*WIDTH_SCALE);
                make.top.equalTo(self.title).with.offset(22*HEIGHT_SCALE+20*HEIGHT_SCALE);
            }];
            [self.combtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self).with.offset(-70*WIDTH_SCALE);
                make.top.equalTo(self.title).with.offset(22*HEIGHT_SCALE+20*HEIGHT_SCALE);
                [self.combtn.textlab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.title).with.offset(45*HEIGHT_SCALE);
                    make.right.equalTo(self.sharebtn).with.offset(-40*WIDTH_SCALE);
                    make.height.mas_equalTo(20*HEIGHT_SCALE);
                }];
                [self.combtn.leftimg mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.title).with.offset(45*HEIGHT_SCALE);
                    make.right.equalTo(self.combtn.textlab.mas_left).with.offset(-4*WIDTH_SCALE);
                    make.height.mas_equalTo(16*WIDTH_SCALE);
                    make.width.mas_equalTo(16*WIDTH_SCALE);
                }];
                
            }];
            [self.dianzanbtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.combtn).with.offset(-50*WIDTH_SCALE);
                make.top.equalTo(self.title).with.offset(22*HEIGHT_SCALE+20*HEIGHT_SCALE);
                make.width.mas_equalTo(64*WIDTH_SCALE);
                [self.dianzanbtn.zanlab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.title).with.offset(45*HEIGHT_SCALE);
                    make.right.equalTo(self.combtn.leftimg).with.offset(-40*WIDTH_SCALE);
                    make.height.mas_equalTo(20*HEIGHT_SCALE);
                }];
                [self.dianzanbtn.zanimg mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.title).with.offset(45*HEIGHT_SCALE);
                    make.right.equalTo(self.dianzanbtn.zanlab.mas_left).with.offset(-4*WIDTH_SCALE);
                    make.height.mas_equalTo(16*WIDTH_SCALE);
                    make.width.mas_equalTo(16*WIDTH_SCALE);
                }];
            }];
            
            headheight = textSize.height+160*HEIGHT_SCALE;
            
            
        }
        
    }else
    {
        [self.thumlabel setHidden:NO];
        if (contentstr.length!=0&&small_imageurlstr.length!=0) {
            
            self.contentlab.numberOfLines = 0;
            self.contentlab.font = [UIFont systemFontOfSize:17];
            self.contentlab.preferredMaxLayoutWidth = (DEVICE_WIDTH - 14*2*WIDTH_SCALE);
            [self.contentlab setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
            self.contentlab.lineBreakMode = NSLineBreakByWordWrapping;//换行方式
            self.contentlab.text = contentstr;
             CGSize textSize= [contentstr boundingRectWithSize:CGSizeMake(DEVICE_WIDTH-28*WIDTH_SCALE, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size;
            [self.contentlab sizeToFit];
            
            CGSize textsize2= [self.thumlabel.text boundingRectWithSize:CGSizeMake(DEVICE_WIDTH-28*WIDTH_SCALE, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
            
            
            
            [self.contentlab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self).with.offset(38*HEIGHT_SCALE);
                make.left.equalTo(self).with.offset(14*WIDTH_SCALE);
                make.right.equalTo(self).with.offset(-14*WIDTH_SCALE);
                make.height.mas_equalTo(textSize.height);
            }];

            
            [self.headimg sd_setImageWithURL:[NSURL URLWithString:small_imageurlstr] placeholderImage:[UIImage imageNamed:@"默认图"]];
            
            [self.headimg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).with.offset(14*WIDTH_SCALE);
                make.right.equalTo(self).with.offset(-14*WIDTH_SCALE);
                make.top.equalTo(self.contentlab.mas_bottom).with.offset(12*HEIGHT_SCALE);
                make.height.mas_equalTo(192*WIDTH_SCALE);
            }];
            
            [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).with.offset(14*WIDTH_SCALE);
                make.right.equalTo(self).with.offset(-14*WIDTH_SCALE);
                make.top.equalTo(self.headimg.mas_bottom).with.offset(2*HEIGHT_SCALE);
                make.height.mas_equalTo(20*HEIGHT_SCALE);
            }];
            
            [self.timelab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).with.offset(14*WIDTH_SCALE);
                make.top.equalTo(self.title).with.offset(45*HEIGHT_SCALE);
                
            }];
            
            [self.thumlabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).with.offset(14*WIDTH_SCALE);
                make.right.equalTo(self).with.offset(-14*WIDTH_SCALE);
                make.top.equalTo(self.timelab).with.offset(33*HEIGHT_SCALE);
            }];
            
            [self.sharebtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self).with.offset(-14*WIDTH_SCALE);
                make.top.equalTo(self.title).with.offset(22*HEIGHT_SCALE+20*HEIGHT_SCALE);
            }];
            
            [self.combtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self).with.offset(-70*WIDTH_SCALE);
                make.top.equalTo(self.title).with.offset(22*HEIGHT_SCALE+20*HEIGHT_SCALE);
                [self.combtn.textlab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.title).with.offset(45*HEIGHT_SCALE);
                    make.right.equalTo(self.sharebtn).with.offset(-40*WIDTH_SCALE);
                    make.height.mas_equalTo(20*HEIGHT_SCALE);
                }];
                [self.combtn.leftimg mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.title).with.offset(45*HEIGHT_SCALE);
                    make.right.equalTo(self.combtn.textlab.mas_left).with.offset(-4*WIDTH_SCALE);
                    make.height.mas_equalTo(16*WIDTH_SCALE);
                    make.width.mas_equalTo(16*WIDTH_SCALE);
                }];
                
            }];
            [self.dianzanbtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.combtn).with.offset(-50*WIDTH_SCALE);
                make.top.equalTo(self.title).with.offset(22*HEIGHT_SCALE+20*HEIGHT_SCALE);
                make.width.mas_equalTo(64*WIDTH_SCALE);
                [self.dianzanbtn.zanlab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.title).with.offset(45*HEIGHT_SCALE);
                    make.right.equalTo(self.combtn.leftimg).with.offset(-40*WIDTH_SCALE);
                    make.height.mas_equalTo(20*HEIGHT_SCALE);
                }];
                [self.dianzanbtn.zanimg mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.title).with.offset(45*HEIGHT_SCALE);
                    make.right.equalTo(self.dianzanbtn.zanlab.mas_left).with.offset(-4*WIDTH_SCALE);
                    make.height.mas_equalTo(16*WIDTH_SCALE);
                    make.width.mas_equalTo(16*WIDTH_SCALE);
                }];
            }];
            
            headheight = textSize.height+380*HEIGHT_SCALE+textsize2.height;
            
            
        }
        else if (contentstr.length==0&&small_imageurlstr.length!=0)
        {
            CGSize textsize2= [self.thumlabel.text boundingRectWithSize:CGSizeMake(DEVICE_WIDTH-28*WIDTH_SCALE, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
            
            [self.headimg sd_setImageWithURL:[NSURL URLWithString:small_imageurlstr] placeholderImage:[UIImage imageNamed:@"默认图"]];
            
            [self.headimg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).with.offset(14*WIDTH_SCALE);
                make.right.equalTo(self).with.offset(-14*WIDTH_SCALE);
                make.top.equalTo(self.namelab.mas_bottom).with.offset(12*HEIGHT_SCALE);
                make.height.mas_equalTo(192*WIDTH_SCALE);
            }];
            
            [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).with.offset(14*WIDTH_SCALE);
                make.right.equalTo(self).with.offset(-14*WIDTH_SCALE);
                make.top.equalTo(self.headimg.mas_bottom).with.offset(2*HEIGHT_SCALE);
                make.height.mas_equalTo(20*HEIGHT_SCALE);
            }];
            
            [self.timelab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).with.offset(14*WIDTH_SCALE);
                make.top.equalTo(self.title).with.offset(45*HEIGHT_SCALE);
                
            }];
            
            [self.thumlabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).with.offset(14*WIDTH_SCALE);
                make.right.equalTo(self).with.offset(-14*WIDTH_SCALE);
                make.top.equalTo(self.timelab).with.offset(33*HEIGHT_SCALE);
                
            }];
            [self.sharebtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self).with.offset(-14*WIDTH_SCALE);
                make.top.equalTo(self.title).with.offset(42*HEIGHT_SCALE);
            }];
            [self.combtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self).with.offset(-70*WIDTH_SCALE);
                make.top.equalTo(self.title).with.offset(22*HEIGHT_SCALE+20*HEIGHT_SCALE);
                [self.combtn.textlab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.title).with.offset(45*HEIGHT_SCALE);
                    make.right.equalTo(self.sharebtn).with.offset(-40*WIDTH_SCALE);
                    make.height.mas_equalTo(20*HEIGHT_SCALE);
                }];
                [self.combtn.leftimg mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.title).with.offset(45*HEIGHT_SCALE);
                    make.right.equalTo(self.combtn.textlab.mas_left).with.offset(-4*WIDTH_SCALE);
                    make.height.mas_equalTo(16*WIDTH_SCALE);
                    make.width.mas_equalTo(16*WIDTH_SCALE);
                }];
                
            }];
            [self.dianzanbtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.combtn).with.offset(-50*WIDTH_SCALE);
                make.top.equalTo(self.title).with.offset(22*HEIGHT_SCALE+20*HEIGHT_SCALE);
                make.width.mas_equalTo(64*WIDTH_SCALE);
                [self.dianzanbtn.zanlab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.title).with.offset(45*HEIGHT_SCALE);
                    make.right.equalTo(self.combtn.leftimg).with.offset(-40*WIDTH_SCALE);
                    make.height.mas_equalTo(20*HEIGHT_SCALE);
                    
                }];
                [self.dianzanbtn.zanimg mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.title).with.offset(45*HEIGHT_SCALE);
                    make.right.equalTo(self.dianzanbtn.zanlab.mas_left).with.offset(-4*WIDTH_SCALE);
                    make.height.mas_equalTo(16*WIDTH_SCALE);
                    make.width.mas_equalTo(16*WIDTH_SCALE);
                }];
            }];
            
            headheight = textsize2.height+400*HEIGHT_SCALE;
           
        }else
        {

            self.contentlab.numberOfLines = 0;
            self.contentlab.font = [UIFont systemFontOfSize:17];
            self.contentlab.preferredMaxLayoutWidth = (DEVICE_WIDTH - 14*2*WIDTH_SCALE);
            [self.contentlab setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
            self.contentlab.lineBreakMode = NSLineBreakByWordWrapping;//换行方式
            self.contentlab.text = contentstr;
            CGSize textSize= [contentstr boundingRectWithSize:CGSizeMake(DEVICE_WIDTH-28*WIDTH_SCALE, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size;
            [self.contentlab sizeToFit];
            
            CGSize textsize2= [self.thumlabel.text boundingRectWithSize:CGSizeMake(DEVICE_WIDTH-28*WIDTH_SCALE, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
            
            
            [self.contentlab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self).with.offset(38*HEIGHT_SCALE);
                make.left.equalTo(self).with.offset(14*WIDTH_SCALE);
                make.right.equalTo(self).with.offset(-14*WIDTH_SCALE);
                make.height.mas_equalTo(textSize.height);
            }];

            
            [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).with.offset(14*WIDTH_SCALE);
                make.right.equalTo(self).with.offset(-14*WIDTH_SCALE);
                make.height.mas_equalTo(20*HEIGHT_SCALE);
                make.top.equalTo(self.contentlab.mas_bottom).with.offset(2*HEIGHT_SCALE);
            }];
            [self.timelab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).with.offset(14*WIDTH_SCALE);
                make.top.equalTo(self.title).with.offset(45*HEIGHT_SCALE);
            }];
            [self.thumlabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).with.offset(14*WIDTH_SCALE);
                make.right.equalTo(self).with.offset(-14*WIDTH_SCALE);
                make.top.equalTo(self.timelab).with.offset(33*HEIGHT_SCALE);
            }];
            [self.sharebtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self).with.offset(-14*WIDTH_SCALE);
                make.top.equalTo(self.title).with.offset(22*HEIGHT_SCALE+20*HEIGHT_SCALE);
            }];
            [self.combtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self).with.offset(-70*WIDTH_SCALE);
                make.top.equalTo(self.title).with.offset(22*HEIGHT_SCALE+20*HEIGHT_SCALE);
                [self.combtn.textlab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.title).with.offset(45*HEIGHT_SCALE);
                    make.right.equalTo(self.sharebtn).with.offset(-40*WIDTH_SCALE);
                    make.height.mas_equalTo(20*HEIGHT_SCALE);
                }];
                [self.combtn.leftimg mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.title).with.offset(45*HEIGHT_SCALE);
                    make.right.equalTo(self.combtn.textlab.mas_left).with.offset(-4*WIDTH_SCALE);
                    make.height.mas_equalTo(16*WIDTH_SCALE);
                    make.width.mas_equalTo(16*WIDTH_SCALE);
                }];
                
            }];
            [self.dianzanbtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.combtn).with.offset(-50*WIDTH_SCALE);
                make.top.equalTo(self.title).with.offset(22*HEIGHT_SCALE+20*HEIGHT_SCALE);
                make.width.mas_equalTo(64*WIDTH_SCALE);
                [self.dianzanbtn.zanlab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.title).with.offset(45*HEIGHT_SCALE);
                    make.right.equalTo(self.combtn.leftimg).with.offset(-40*WIDTH_SCALE);
                    make.height.mas_equalTo(20*HEIGHT_SCALE);
                }];
                [self.dianzanbtn.zanimg mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.title).with.offset(45*HEIGHT_SCALE);
                    make.right.equalTo(self.dianzanbtn.zanlab.mas_left).with.offset(-4*WIDTH_SCALE);
                    make.height.mas_equalTo(16*WIDTH_SCALE);
                    make.width.mas_equalTo(16*WIDTH_SCALE);
                }];
            }];
            
            headheight = textSize.height+180*HEIGHT_SCALE+textsize2.height;
            
          
        }
    }
    
    [self layoutIfNeeded];
    return headheight;
}

#pragma mark - getters

-(UIView *)lineview
{
    if(!_lineview)
    {
        _lineview = [[UIView alloc] init];
        _lineview.backgroundColor = [UIColor wjColorFloat:@"F5F5F5"];
    }
    return _lineview;
}

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

-(UILabel *)numberlab
{
    if(!_numberlab)
    {
        _numberlab = [[UILabel alloc] init];
        _numberlab.textColor = [UIColor wjColorFloat:@"C7C7CD"];
        _numberlab.font = [UIFont systemFontOfSize:14*FX];
        
    }
    return _numberlab;
}

-(titleView *)title
{
    if(!_title)
    {
        _title = [[titleView alloc] init];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleckick)];
        [_title addGestureRecognizer:tap];
    }
    return _title;
}

-(UILabel *)timelab
{
    if(!_timelab)
    {
        _timelab = [[UILabel alloc] init];
        _timelab.textColor = [UIColor wjColorFloat:@"C7C7CD"];
        _timelab.font = [UIFont systemFontOfSize:13*FX];
    }
    return _timelab;
}

-(zanBtn *)dianzanbtn
{
    if(!_dianzanbtn)
    {
        _dianzanbtn =  [[zanBtn alloc] init];
        [_dianzanbtn addTarget:self action:@selector(dianzanclick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dianzanbtn;
}

-(commentsBtn *)combtn
{
    if(!_combtn)
    {
        _combtn = [[commentsBtn alloc] init];
        [_combtn addTarget:self action:@selector(pinglunclick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _combtn;
}

-(UIButton *)sharebtn
{
    if(!_sharebtn)
    {
        _sharebtn = [[UIButton alloc] init];
        [_sharebtn setImage:[UIImage imageNamed:@"分享"] forState:normal];
        [_sharebtn addTarget:self action:@selector(fengxiangclick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sharebtn;
}


-(UILabel *)thumlabel
{
    if(!_thumlabel)
    {
        _thumlabel = [[UILabel alloc] init];
        _thumlabel.textColor = [UIColor wjColorFloat:@"576b95"];
    }
    return _thumlabel;
}

-(UIImageView *)headimg
{
    if(!_headimg)
    {
        _headimg = [[UIImageView alloc] init];
        _headimg.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction2)];
        [_headimg addGestureRecognizer:tap2];
    }
    return _headimg;
}

-(void)dianzanclick
{
    [self.delegate myTabheadClick1:self];
}

-(void)pinglunclick
{
    [self.delegate myTabheadClick2:self];
}

-(void)fengxiangclick
{
    [self.delegate myTabheadClick3:self];
}

-(void)titleckick
{
    [self.delegate myTabheadClick4:self];
}
#pragma mark - 图片放大方法

- (void)tapAction2{
    YYPhotoGroupItem *item = [YYPhotoGroupItem new];
    item.thumbView         = self.headimg;
    
    item.largeImageURL     = [NSURL URLWithString:self.headimgstr];
    YYPhotoGroupView *view = [[YYPhotoGroupView alloc] initWithGroupItems:@[item]];
    UIView *toView         = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    [view presentFromImageView:self.headimg
                   toContainer:toView
                      animated:YES completion:nil];
    
}

@end
