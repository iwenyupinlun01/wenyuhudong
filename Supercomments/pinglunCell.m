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
    self.bgview.frame = CGRectMake(128/2*WIDTH_SCALE, 0, DEVICE_WIDTH-64*WIDTH_SCALE-14*WIDTH_SCALE, self.frame.size.height);
}

-(void)setcelldata:(detailcellmodel *)model
{
    self.detalmodel = model;
    //CGSize textSize = [self.pinglunlab setText:model.contstr lines:QSTextDefaultLines2 andLineSpacing:QSTextLineSpacing constrainedToSize:CGSizeMake(DEVICE_WIDTH,MAXFLOAT)];
    //self.pinglunlab.frame = CGRectMake(128/2*WIDTH_SCALE,  14*HEIGHT_SCALE, DEVICE_WIDTH -64*WIDTH_SCALE, textSize.height);
    
}

-(UIView *)bgview
{
    if(!_bgview)
    {
        _bgview = [[UIView alloc] init];
        _bgview.backgroundColor = [UIColor wjColorFloat:@"F4F5F6"];
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
                                       font:[UIFont systemFontOfSize:16*FX]
                             andLineSpacing:QSTextLineSpacing
                          constrainedToSize:CGSizeMake(DEVICE_WIDTH - 94*WIDTH_SCALE-14*WIDTH_SCALE,MAXFLOAT)];
    
    return textSize.height;
    
}

@end
