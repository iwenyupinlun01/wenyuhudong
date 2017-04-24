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
        self.backgroundColor = [UIColor greenColor];
        [self addSubview:self.textview];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.textview.frame = CGRectMake(10, 0, DEVICE_WIDTH-20, 44);
    
}

#pragma mark - getters


-(UITextView *)textview
{
    if(!_textview)
    {
        _textview = [[UITextView alloc] init];
        
    }
    return _textview;
}



@end
