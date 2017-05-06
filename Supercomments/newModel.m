//
//  newModel.m
//  Supercomments
//
//  Created by 王俊钢 on 2017/4/14.
//  Copyright © 2017年 wangjungang. All rights reserved.
//

#import "newModel.h"
#import "newCell.h"

@implementation newModel
//惰性初始化是这样写的
-(CGFloat)cellHeight
{
    //只在初始化的时候调用一次就Ok
    if(!_cellHeight){
        newCell *cell=[[newCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:newidentfid];
        NSLog(@"我要计算高度");
        _cellHeight = [cell setcelldata:self];
    }
    return _cellHeight;
}

@end
