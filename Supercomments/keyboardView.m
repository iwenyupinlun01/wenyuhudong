//
//  keyboardView.m
//  Supercomments
//
//  Created by 王俊钢 on 2017/4/24.
//  Copyright © 2017年 wangjungang. All rights reserved.
//

#import "keyboardView.h"

@interface keyboardView()
@property (nonatomic,strong) UIView *toplineview;
@property (nonatomic,strong) UIView *endlineview;
@end





@implementation keyboardView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //self.backgroundColor = [UIColor greenColor];
        [self addSubview:self.bgview];
        [self addSubview:self.textview];
        [self addSubview:self.sendbtn];
        [self addSubview:self.toplineview];
        [self addSubview:self.endlineview];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.textview.frame = CGRectMake(5, 16, DEVICE_WIDTH-65, 30);
    self.sendbtn.frame = CGRectMake(DEVICE_WIDTH-14-40, 10, 40, 40);
}

#pragma mark - getters

-(WJGtextView *)textview
{
    if(!_textview)
    {
        _textview = [[WJGtextView alloc] init];
        _textview.layer.masksToBounds = YES;
        //_textview.layer.borderWidth = 0.6;
        //_textview.layer.cornerRadius = 4;
        _textview.returnKeyType=UIReturnKeySend;
        _textview.enablesReturnKeyAutomatically = YES;
        [_textview setFont:[UIFont systemFontOfSize:15]];
        [_textview setTintColor:[UIColor wjColorFloat:@"576b95"]];
       // _textview.backgroundColor = [UIColor greenColor];
        
    }
    return _textview;
}

-(UIButton *)sendbtn
{
    if(!_sendbtn)
    {
        _sendbtn = [[UIButton alloc] init];
        [_sendbtn setTitle:@"发表" forState:normal];
        //_sendbtn.backgroundColor = [UIColor greenColor];
        [_sendbtn setTitleColor:[UIColor wjColorFloat:@"C7C7CD"] forState:normal];
    }
    return _sendbtn;
}

-(UIView *)toplineview
{
    if(!_toplineview)
    {
        _toplineview = [[UIView alloc] init];
        _toplineview.frame = CGRectMake(0, 0, DEVICE_WIDTH, 0.3);
        _toplineview.backgroundColor = [UIColor wjColorFloat:@"F5F5F5"];
    }
    return _toplineview;
}

-(UIView *)endlineview
{
    if(!_endlineview)
    {
        _endlineview = [[UIView alloc] init];
        _endlineview.backgroundColor = [UIColor wjColorFloat:@"F5F5F5"];
    }
    return _endlineview;
}

-(UIView *)bgview
{
    if(!_bgview)
    {
        _bgview = [[UIView alloc] init];
        _bgview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 58)];
        _bgview.backgroundColor = [UIColor whiteColor];
        
    }
    return _bgview;
}



@end
