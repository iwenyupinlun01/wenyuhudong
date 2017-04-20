//
//  systemCell.m
//  Supercomments
//
//  Created by 王俊钢 on 2017/4/6.
//  Copyright © 2017年 wangjungang. All rights reserved.
//



#import "systemCell.h"
#import "UILabel+MultipleLines.h"
@interface systemCell()


@end

@implementation systemCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        //[self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.contentLabel];
        [self.contentView addSubview:self.timelabel];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.timelabel.frame = CGRectMake(DEVICE_WIDTH-60*WIDTH_SCALE, self.frame.size.height-28, 50*WIDTH_SCALE, 18*HEIGHT_SCALE);
}

- (UILabel *)contentLabel{
    
    if (!_contentLabel) {
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.font = [UIFont systemFontOfSize:QSTextFontSize];
        _contentLabel.textColor = [UIColor wjColorFloat:@"333333"];
    }
    return _contentLabel;
}

-(UILabel *)timelabel
{
    if(!_timelabel)
    {
        _timelabel = [[UILabel alloc] init];
        _timelabel.textColor = [UIColor wjColorFloat:@"999999"];
        _timelabel.font = [UIFont systemFontOfSize:12];
        _timelabel.text = @"12:30";
    }
    return _timelabel;
}

- (void)layoutSubviewsWithText:(NSString *)text{
    CGSize textSize = [_contentLabel setText:text lines:QSTextDefaultLines andLineSpacing:QSTextLineSpacing constrainedToSize:CGSizeMake(DEVICE_WIDTH - 30,MAXFLOAT)];
    _contentLabel.frame = CGRectMake(15,  10, textSize.width, textSize.height);
//    _contentLabel.layer.borderColor = [UIColor redColor].CGColor;
//    _contentLabel.layer.borderWidth = 1;
    
}

+ (CGFloat)cellHeightWithText:(NSString *)text{
    
    CGSize textSize = [UILabel sizeWithText:text
                                      lines:QSTextDefaultLines
                                       font:[UIFont systemFontOfSize:QSTextFontSize]
                             andLineSpacing:QSTextLineSpacing
                          constrainedToSize:CGSizeMake(DEVICE_WIDTH - 30,MAXFLOAT)];
    return textSize.height + 41;
    
}

@end
