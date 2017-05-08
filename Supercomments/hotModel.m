//
//  hotModel.m
//  Supercomments
//
//  Created by 王俊钢 on 2017/5/8.
//  Copyright © 2017年 wangjungang. All rights reserved.
//

#import "hotModel.h"
#import "hotCell.h"
@implementation hotModel
//惰性初始化是这样写的
-(CGFloat)cellHeight
{
    //只在初始化的时候调用一次就Ok
    if(!_cellHeight){
        hotCell *cell=[[hotCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:hotidentfid];
        NSLog(@"我要计算高度");
        _cellHeight = [cell setcelldata:self];
    }
    return _cellHeight;
}

@end
