//
//  pinglunCell.m
//  Supercomments
//
//  Created by 王俊钢 on 2017/4/19.
//  Copyright © 2017年 wangjungang. All rights reserved.
//

#import "pinglunCell.h"
#import "detailcellmodel.h"

@interface pinglunCell()
@property (nonatomic,strong) detailcellmodel *detalmodel;
@property (nonatomic,strong) UIView *bgview;

//定义一个contentLabel文本高度的属性
@property (nonatomic,assign) CGFloat contentLabelH;
@end

@implementation pinglunCell

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
    self.bgview.frame = CGRectMake(59*WIDTH_SCALE, 0, DEVICE_WIDTH-64*WIDTH_SCALE-14*WIDTH_SCALE, self.frame.size.height);
}

-(void)setuplayout
{

    [self.pinglunlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(8*HEIGHT_SCALE);
        make.right.equalTo(self).with.offset(-18*WIDTH_SCALE);
        make.left.equalTo(self).with.offset(64*WIDTH_SCALE+6*WIDTH_SCALE);
    }];
}

-(CGFloat )setcelldata:(detailcellmodel *)model andindexrow:(NSInteger )indexstr
{
    self.detalmodel = model;
    NSString *str4 = [NSString stringWithFormat:@"%@%@",@":", [[model.pingarr objectAtIndex:indexstr] objectForKey:@"content"]];
    NSString *str1 = [[model.pingarr objectAtIndex:indexstr] objectForKey:@"s_nickname"];
    NSString *str3 = [[model.pingarr objectAtIndex:indexstr] objectForKey:@"s_to_nickname"];
    NSString *str2 = @"回复";
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@%@%@",str1,str2,str3,str4]];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor wjColorFloat:@"576b95"] range:NSMakeRange(0,str1.length)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor wjColorFloat:@"333333"] range:NSMakeRange(str1.length,str2.length)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor wjColorFloat:@"576b95"] range:NSMakeRange(str1.length+str2.length,str3.length)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor wjColorFloat:@"333333"] range:NSMakeRange(str1.length+str2.length+str3.length,str4.length)];
    NSLog(@"str===============%@",str);
    NSString *newstr = [str string];
    self.pinglunlab.font = [UIFont systemFontOfSize:14];
    self.pinglunlab.attributedText = str;
    self.pinglunlab.lineBreakMode = NSLineBreakByCharWrapping;
    CGSize titleSize = [newstr boundingRectWithSize:CGSizeMake(DEVICE_WIDTH -64*WIDTH_SCALE-14*WIDTH_SCALE-16*WIDTH_SCALE, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    [self.pinglunlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(titleSize.height);
    }];
    [self.pinglunlab sizeToFit];
    model.cellHeight = titleSize.height+16*HEIGHT_SCALE;
    [self layoutIfNeeded];
    return model.cellHeight;
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

-(UILabel *)pinglunlab
{
    if(!_pinglunlab)
    {
        _pinglunlab = [[UILabel alloc] init];
        _pinglunlab.numberOfLines = 0;
    }
    return _pinglunlab;
}

+ (CGFloat)cellHeightWithText:(NSString *)text{
    
    CGSize textSize = [UILabel sizeWithText:text
                                      lines:QSTextDefaultLines
                                       font:[UIFont systemFontOfSize:14*FX]
                             andLineSpacing:4
                          constrainedToSize:CGSizeMake(DEVICE_WIDTH -64*WIDTH_SCALE-14*WIDTH_SCALE-16*WIDTH_SCALE,MAXFLOAT)];
    return textSize.height;
}


@end
