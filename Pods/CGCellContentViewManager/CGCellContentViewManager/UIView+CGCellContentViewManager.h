//
//  UIView+CGCellContentViewManager.h
//  CGCellContentViewManager
//
//  Created by Coder Gin on 16/11/11
//
// Copyright (c) 2016 Coder Gin ( https://github.com/CoderGin/CGCellContentViewManager )
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

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

/// Method Swizzling for instanceMethod
#define CG_Instance_MethodSwizzling(originalSelector, swizzledSelector)             \
{                                       \
    Class class = [self class];         \
    static dispatch_once_t onceToken;   \
    dispatch_once(&onceToken, ^{        \
        Method originalMethod = class_getInstanceMethod(class, originalSelector);   \
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);   \
                                        \
        BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod)); \
        if (didAddMethod) {             \
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));             \
        } else {                        \
            method_exchangeImplementations(originalMethod, swizzledMethod);         \
        }                               \
    });                                 \
}

/// This category will work automatically, as you drag it in your project.
/// Both supports Objective-C and Swift
@interface UIView (CGCellContentViewManager)

/// This bool value controls whether the category will work for a view.
/// Default is NO for all kinds of UIView, incluing UITableViewCell.
/// If you set YES for a kind of UIView,
/// means that CGCellContentViewManager will not work for the view,
/// and the view in a cell's contentView will change backgroundColor as native style while you're clicking the cell.
/// If you set YES for a kind of UITableViewCell,
/// means that CGCellContentViewManager will not work for the cell,
/// and the subviews in the cell's contentView will change backgroundColor as native style while you're clicking the cell.
@property (nonatomic, assign) BOOL cg_cellContentViewManagerDisabled;

@end
