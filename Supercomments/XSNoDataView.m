//
//  XSNoDataView.m
//  Supercomments
//
//  Created by 王俊钢 on 2017/5/7.
//  Copyright © 2017年 wangjungang. All rights reserved.
//

#import "XSNoDataView.h"

#import "XSNoDataView.h"

@interface XSNoDataView ()



@end

@implementation XSNoDataView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(DEVICE_WIDTH*2/8, 150, DEVICE_WIDTH/2, DEVICE_HEIGHT/4-50);
        
        [self addSubview:imageView];
        imageView.image = [UIImage imageNamed:@"加载失败"];
        
        
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(0, imageView.frame.origin.y+20+DEVICE_WIDTH/4, DEVICE_WIDTH, 30);
        label.textColor = [UIColor lightGrayColor];
        label.text = @"亲,您的手机网络不太顺畅喔~";
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
//        [self addSubview:label];
        
         //self.refreshBTN = [UIButton buttonWithType:UIButtonTypeCustom];
        self.refreshBTN = [[UIButton alloc] init];
        [self.refreshBTN setTitle:@"重新加载" forState:UIControlStateNormal];
        [self.refreshBTN setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        self.refreshBTN.titleLabel.font = [UIFont systemFontOfSize:14];
        self.refreshBTN.layer.masksToBounds = YES;
        self.refreshBTN.layer.borderWidth = 1;
        self.refreshBTN.layer.cornerRadius = 3;
        self.refreshBTN.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.refreshBTN.frame = CGRectMake(DEVICE_WIDTH/2-50, label.frame.origin.y+120, 100, 30);
        [self addSubview:self.refreshBTN];

        
    }
    return self;
}

@end
