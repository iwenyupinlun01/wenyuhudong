//
//  agreementView.m
//  Supercomments
//
//  Created by 王俊钢 on 2017/4/11.
//  Copyright © 2017年 wangjungang. All rights reserved.
//

#import "agreementView.h"

@interface agreementView()
@property (nonatomic,strong) UILabel *textlab;
@end

@implementation agreementView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.textlab];
        [self addSubview:self.agreementbtn];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
}

#pragma mark - getters


-(UILabel *)textlab
{
    if(!_textlab)
    {
        _textlab = [[UILabel alloc] init];
        _textlab.text = @"登录即表示您同意";
        _textlab.font = [UIFont systemFontOfSize:12];
        _textlab.textColor = [UIColor wjColorFloat:@"CDCDC7"];
        
    }
    return _textlab;
}


-(UIButton *)agreementbtn
{
    if(!_agreementbtn)
    {
        _agreementbtn = [[UIButton alloc] init];
        
    }
    return _agreementbtn;
}



@end
