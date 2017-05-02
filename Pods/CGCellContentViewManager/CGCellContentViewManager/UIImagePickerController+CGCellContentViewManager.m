//
//  UIImagePickerController+CGCellContentViewManager.m
//  CGCellContentViewManager
//
//  Created by Gin on 17/1/1.
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

#import "UIImagePickerController+CGCellContentViewManager.h"
#import "UIView+CGCellContentViewManager.h"

@implementation UIImagePickerController (CGCellContentViewManager)

/// Weak association of the current tableView in UIImagePickerController
- (UITableView *)cg_currentTableView {
    
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setCg_currentTableView:(UITableView *)cg_currentTableView {
    
    objc_setAssociatedObject(self, @selector(cg_currentTableView), cg_currentTableView, OBJC_ASSOCIATION_ASSIGN);
}


+ (void)load {
    
    /// Method Swizzling for selector (viewDidAppear:)
    CG_Instance_MethodSwizzling(@selector(viewDidAppear:), @selector(cg_viewDidAppear:))
}

- (void)cg_viewDidAppear:(BOOL)animated {
    
    [self cg_viewDidAppear:animated];
    
    // Associate current tableView in the UIImagePickerController
    [self associateCurrentTableViewInView:self.view];
    
    // Get all cells in current tableView
    NSArray <UITableViewCell *> *cells = [self.cg_currentTableView visibleCells];
    
    // Disable CGCellContentViewManager for the cells in current tableView
    [cells enumerateObjectsUsingBlock:^(UITableViewCell * _Nonnull cell, NSUInteger idx, BOOL * _Nonnull stop) {
        cell.cg_cellContentViewManagerDisabled = YES;
    }];
}

/// Traverse all view hierarchy in the view, and associate the UITableView in the UIImagePickerController
- (void)associateCurrentTableViewInView:(UIView *)view {
    
    [view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull subview, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([subview isKindOfClass:[UITableView class]]) {
            // Associate current tableView
            self.cg_currentTableView = subview;
            *stop = YES;
            return ;
        }
        [self associateCurrentTableViewInView:subview];
    }];
}

@end
