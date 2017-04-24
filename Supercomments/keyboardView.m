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
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.textview.frame = CGRectMake(5, 2, DEVICE_WIDTH-10, 42);
    
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
    }
    return _textview;
}



@end
