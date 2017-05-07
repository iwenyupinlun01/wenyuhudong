//
//  XSNoDataView.h
//  Supercomments
//
//  Created by 王俊钢 on 2017/5/7.
//  Copyright © 2017年 wangjungang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ButtonBlock) (id sender);
@interface XSNoDataView : UIView

- (void)addButtonAction:(ButtonBlock)block;
@end
