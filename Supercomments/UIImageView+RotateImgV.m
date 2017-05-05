//
//  strisNull.h
//  Supercomments
//
//  Created by 王俊钢 on 2017/4/25.
//  Copyright © 2017年 wangjungang. All rights reserved.
//

#import "UIImageView+RotateImgV.h"

@implementation UIButton (RotateImgV)

- (void)rotate360DegreeWithImageView {

    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 2;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 100000;
    [self.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}
- (void)stopRotate {
    [self.layer removeAllAnimations];
}
@end
