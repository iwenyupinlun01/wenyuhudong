//
//  emptyerrorView.h
//  Supercomments
//
//  Created by 王俊钢 on 2017/5/8.
//  Copyright © 2017年 wangjungang. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol myviewdelegate <NSObject>
-(void)myview:(UIView *)myview;

@end

@interface emptyerrorView : UIView

@property (nonatomic,assign)id<myviewdelegate>delegate;

@end
