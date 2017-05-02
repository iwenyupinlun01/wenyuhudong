//
//  UITableViewCell+CGCellContentViewManager.m
//  CGCellContentViewManager
//
//  Created by Coder Gin on 17/1/1.
//
// Copyright (c) 2017 Coder Gin ( https://github.com/CoderGin/CGCellContentViewManager )
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#import "UITableViewCell+CGCellContentViewManager.h"
#import "UIView+CGCellContentViewManager.h"

@implementation UIView (_CGCellContentViewManager)

/// This value record the cell's contentView's backgroundColor before you click the cell
/// you should never set this value manually.
- (UIColor *)cg_originalBackgroundColor {
    
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setCg_originalBackgroundColor:(UIColor *)cg_originalBackgroundColor {
    
    objc_setAssociatedObject(self, @selector(cg_originalBackgroundColor), cg_originalBackgroundColor, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end


@implementation UITableViewCell (CGCellContentViewManager)

+ (void)load {
    
    /// Method Swizzling for selector (setHighlighted:animated:)
    CG_Instance_MethodSwizzling(@selector(setHighlighted:animated:), @selector(cg_setHighlighted:animated:))
    /// Method Swizzling for selector (setSelected:animated:)
    CG_Instance_MethodSwizzling(@selector(setSelected:animated:), @selector(cg_setSelected:animated:))
}

- (void)cg_setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    
    if (self.cg_cellContentViewManagerDisabled) {
        [self cg_setHighlighted:highlighted animated:animated];
    } else {
        // Record the subview.backgroundColor
        highlighted ? [self recordAllSubviewsOriginalBackgroundColorInView:self.contentView] : 0;
        
        [self cg_setHighlighted:highlighted animated:animated];
        
        // Recover the subview.backgroundColor
        [self recoverAllSubviewsBackgroundColorInView:self.contentView];
    }
}

- (void)cg_setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [self cg_setSelected:selected animated:animated];
    // Recover the subview.backgroundColor
    [self recoverAllSubviewsBackgroundColorInView:self.contentView];
}

/// Traverse all view hierarchy in the view, and record the subview.backgroundColor to cg_originalBackgroundColor
- (void)recordAllSubviewsOriginalBackgroundColorInView:(UIView *)view {
    
    [view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull subview, NSUInteger idx, BOOL * _Nonnull stop) {
        subview.cg_originalBackgroundColor = nil;
        // Record backgroundColor
        subview.cg_cellContentViewManagerDisabled ? 0 : (subview.cg_originalBackgroundColor = subview.backgroundColor);
        // Traverse in all view hierarchy
        [self recordAllSubviewsOriginalBackgroundColorInView:subview];
    }];
}

/// Traverse all view hierarchy in the view, and recover the subview.backgroundColor to cg_originalBackgroundColor
- (void)recoverAllSubviewsBackgroundColorInView:(UIView *)view {
    
    [view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull subview, NSUInteger idx, BOOL * _Nonnull stop) {
        if (subview.cg_originalBackgroundColor) {
            // Recover backgroundColor
            subview.backgroundColor = subview.cg_originalBackgroundColor;
        }
        // Traverse in all view hierarchy
        [self recoverAllSubviewsBackgroundColorInView:subview];
    }];
}

@end
