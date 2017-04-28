//
//  keyboardView.m
//  Supercomments
//
//  Created by 王俊钢 on 2017/4/24.
//  Copyright © 2017年 wangjungang. All rights reserved.
//

#import "keyboardView.h"

@implementation keyboardView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //self.backgroundColor = [UIColor greenColor];
        [self addSubview:self.textview];
        [self addSubview:self.sendbtn];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.textview.frame = CGRectMake(5, 2, DEVICE_WIDTH-65, 40);
    self.sendbtn.frame = CGRectMake(DEVICE_WIDTH-60, 2, 50, 40);
}

#pragma mark - getters

-(UITextView *)textview
{
    if(!_textview)
    {
        _textview = [[UITextView alloc] init];
        _textview.layer.masksToBounds = YES;
        _textview.layer.borderWidth = 0.6;
        _textview.layer.cornerRadius = 4;
        _textview.returnKeyType=UIReturnKeySend;
    }
    return _textview;
}

-(UIButton *)sendbtn
{
    if(!_sendbtn)
    {
        _sendbtn = [[UIButton alloc] init];
        [_sendbtn setTitle:@"发送" forState:normal];
        [_sendbtn setTitleColor:[UIColor wjColorFloat:@"008CCF"] forState:normal];
    }
    return _sendbtn;
}




@end
