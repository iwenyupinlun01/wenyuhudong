//
//  pinglunCell.m
//  Supercomments
//
//  Created by 王俊钢 on 2017/4/19.
//  Copyright © 2017年 wangjungang. All rights reserved.
//

#import "pinglunCell.h"
#import "detailcellmodel.h"

@interface pinglunCell()
@property (nonatomic,strong) detailcellmodel *detalmodel;
@end

@implementation pinglunCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        
    }
    return self;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    
    
}

-(void)pingluncelldata:(detailcellmodel *)model
{
    self.detalmodel = model;
    
    
}

@end
