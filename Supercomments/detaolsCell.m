//
//  detaolsCell.m
//  Supercomments
//
//  Created by 王俊钢 on 2017/4/8.
//  Copyright © 2017年 wangjungang. All rights reserved.
//

#import "detaolsCell.h"
#import "detailcellmodel.h"
#import "pinglunCell.h"
static NSString *pinglunidentfid = @"pinglunidentfid";
@interface detaolsCell()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) detailcellmodel *detalmodel;

@property (nonatomic,strong) NSMutableArray *pinglunindexarr;
@end

@implementation detaolsCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.pinglunindexarr = [NSMutableArray array];
        [self.contentView addSubview:self.picimg];
        [self.contentView addSubview:self.namelab];
        [self.contentView addSubview:self.timelab];
        [self.contentView addSubview:self.contentlab];
        [self.contentView addSubview:self.pingluntable];
        
    }
    return self;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    self.picimg.frame = CGRectMake(14*WIDTH_SCALE, 14*HEIGHT_SCALE, 32*WIDTH_SCALE, 32*WIDTH_SCALE);
    self.namelab.frame = CGRectMake(14*WIDTH_SCALE+32*WIDTH_SCALE+14*WIDTH_SCALE, 14*HEIGHT_SCALE, 80*WIDTH_SCALE, 14*HEIGHT_SCALE);
    self.timelab.frame = CGRectMake(14*WIDTH_SCALE+32*WIDTH_SCALE+14*WIDTH_SCALE, 14*HEIGHT_SCALE+20*HEIGHT_SCALE, 80*WIDTH_SCALE, 11*HEIGHT_SCALE);
    self.pingluntable.frame = CGRectMake(128/2*WIDTH_SCALE, (14+32+14+_hei+14)*HEIGHT_SCALE, DEVICE_WIDTH-64+WIDTH_SCALE-14*WIDTH_SCALE, 150);
    
}

-(void)setcelldata:(detailcellmodel*)model
{
    self.detalmodel = model;
    self.namelab.text = model.namestr;
    self.timelab.text = model.timestr;
    self.contentlab.text = model.contstr;
    
    CGSize textSize = [_contentlab setText:_contentlab.text lines:QSTextDefaultLines andLineSpacing:QSTextLineSpacing constrainedToSize:CGSizeMake(DEVICE_WIDTH - 94*WIDTH_SCALE-14*WIDTH_SCALE,MAXFLOAT)];
    self.contentlab.frame = CGRectMake(14*WIDTH_SCALE+32*WIDTH_SCALE+14*WIDTH_SCALE,  60*HEIGHT_SCALE, textSize.width, textSize.height);
    _hei = textSize.height;
    
    self.pinglunindexarr = model.pingluncontarr;
}

#pragma mark - getters

-(UIImageView *)picimg
{
    if(!_picimg)
    {
        _picimg = [[UIImageView alloc] init];
        _picimg.backgroundColor = [UIColor orangeColor];
        _picimg.layer.masksToBounds = YES;
        _picimg.layer.cornerRadius = 16*WIDTH_SCALE;
    }
    return _picimg;
}

-(UILabel *)namelab
{
    if(!_namelab)
    {
        _namelab = [[UILabel alloc] init];
        _namelab.text = @"姓名姓名";
        _namelab.textColor = [UIColor wjColorFloat:@"CDCDC7"];
        _namelab.font = [UIFont systemFontOfSize:14*FX];
    }
    return _namelab;
}

-(UILabel *)timelab
{
    if(!_timelab)
    {
        _timelab = [[UILabel alloc] init];
        _timelab.text = @"12:00";
        _timelab.textColor = [UIColor wjColorFloat:@"CDCDC7"];
        _timelab.font = [UIFont systemFontOfSize:11*FX];
    }
    return _timelab;
}

-(UILabel *)contentlab
{
    if(!_contentlab)
    {
        _contentlab = [[UILabel alloc] init];
        _contentlab.numberOfLines = 0;
        _contentlab.textColor = [UIColor wjColorFloat:@"333333"];
        _contentlab.font = [UIFont systemFontOfSize:17*FX];
       
    }
    return _contentlab;
}


-(UITableView *)pingluntable
{
    if(!_pingluntable)
    {
        _pingluntable = [[UITableView alloc] init];
        _pingluntable.scrollEnabled = NO;
        _pingluntable.dataSource = self;
        _pingluntable.delegate = self;
    }
    return _pingluntable;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    pinglunCell *cell = [tableView dequeueReusableCellWithIdentifier:pinglunidentfid];
    if (!cell) {
        cell = [[pinglunCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:pinglunidentfid];
    }
    cell.backgroundColor = [UIColor wjColorFloat:@"F4F5F6"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.textLabel.text = @"赵客缦胡缨⑵，吴钩霜雪明⑶。银鞍照白马，飒沓如流星⑷。赵客缦胡缨⑵，吴钩霜雪明⑶。银鞍照白马，飒沓如流星⑷赵客缦胡缨⑵，吴钩霜雪明⑶。银鞍照白马，飒沓如流星⑷赵客缦胡缨⑵，吴钩霜雪明⑶。银鞍照白马，飒沓如流星⑷";
    
    // cell.textLabel.text = self.detailsmodel.pingarr[indexPath.row];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont systemFontOfSize:14*FX];
    CGSize textSize = [cell.textLabel setText:cell.textLabel.text lines:QSTextDefaultLines andLineSpacing:QSTextLineSpacing constrainedToSize:CGSizeMake(DEVICE_WIDTH-64,MAXFLOAT)];
    cell.textLabel.frame = CGRectMake(0, 0, textSize.width, textSize.height);
    //_pinglunhei = textSize.height;
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 20;
}
@end
