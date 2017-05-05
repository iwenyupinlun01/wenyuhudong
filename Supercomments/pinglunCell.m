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
@end

@implementation pinglunCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.bgview];
        [self.contentView addSubview:self.pinglunlab];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.bgview.frame = CGRectMake(59*WIDTH_SCALE, 0, DEVICE_WIDTH-64*WIDTH_SCALE-14*WIDTH_SCALE, self.frame.size.height);
    
}

-(void)setcelldata:(detailcellmodel *)model
{
    self.detalmodel = model;

    
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
