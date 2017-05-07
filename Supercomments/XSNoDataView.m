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

@property (nonatomic, strong, nullable) ButtonBlock block;
@property (nonatomic, strong, nullable) UIButton *button;

@end

@implementation XSNoDataView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImageView *imageView = [[UIImageView alloc] init];
       // imageView.frame = CGRectMake(DEVICE_WIDTH*3/8, adoptValue(240), DEVICE_WIDTH / 4, DEVICE_HEIGHT / 4);
        imageView.frame = CGRectMake(DEVICE_WIDTH*3/8, 240, DEVICE_WIDTH/4, DEVICE_HEIGHT/4);
        [self addSubview:imageView];
        
        NSMutableArray *imgArray = [NSMutableArray array];
        for (int i=0; i<3; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"netError%d.png",i]];
            [imgArray addObject:image];
        }
        imageView.animationImages = imgArray;
        imageView.animationDuration = 6*0.15;
        imageView.animationRepeatCount = 0;
        [imageView startAnimating];
        
        
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(0, imageView.frame.origin.y+20+DEVICE_WIDTH/4, DEVICE_WIDTH, 30);
        label.textColor = [UIColor lightGrayColor];
        label.text = @"亲,您的手机网络不太顺畅喔~";
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        [self addSubview:label];
        
        UIButton *refreshBTN = [UIButton buttonWithType:UIButtonTypeCustom];
        [refreshBTN setTitle:@"重新加载" forState:UIControlStateNormal];
        [refreshBTN setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        refreshBTN.titleLabel.font = [UIFont systemFontOfSize:14];
        refreshBTN.layer.masksToBounds = YES;
        refreshBTN.layer.borderWidth = 1;
        refreshBTN.layer.cornerRadius = 3;
        refreshBTN.layer.borderColor = [UIColor lightGrayColor].CGColor;
        refreshBTN.frame = CGRectMake(DEVICE_WIDTH/2-50, label.frame.origin.y+60, 100, 30);
        [self addSubview:refreshBTN];
        [refreshBTN addTarget:self action:@selector(buttonAction) forControlEvents:(UIControlEventTouchUpInside)];
        
    }
    return self;
}

//实现block回调的方法
- (void)addButtonAction:(ButtonBlock)block {
    self.block = block;
}
- (void)buttonAction {
    if (self.block) {
        self.block(self);
    }
}
@end
