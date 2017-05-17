//
//  firstCell.m
//  Supercomments
//
//  Created by 王俊钢 on 2017/5/16.
//  Copyright © 2017年 wangjungang. All rights reserved.
//

#import "firstCell.h"
#import "firstModel.h"
#import "secondCell.h"

@interface firstCell()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) firstModel *fmodel;
@property (nonatomic,strong) NSMutableArray *dataarr;
@property (nonatomic,strong) secondCell *cell;
@end

static NSString *secondidentfid = @"secondidentfid";

@implementation firstCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.dataarr = [NSMutableArray array];
        [self.contentView addSubview:self.contentlab];
        [self.contentView addSubview:self.texttable];
        [self setlayout];
    }
    return self;
}

-(void)setlayout
{
    [self.contentlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(14*HEIGHT_SCALE);
        make.left.equalTo(self).with.offset(14*WIDTH_SCALE);
        make.right.equalTo(self).with.offset(-14*WIDTH_SCALE);
    }];
    [self.texttable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentlab.mas_bottom).with.offset(14*HEIGHT_SCALE);
        make.left.equalTo(self).with.offset(14*WIDTH_SCALE);
        make.right.equalTo(self).with.offset(-14*WIDTH_SCALE);
    }];
    
}

-(CGFloat )setcelldata:(firstModel *)model
{
    self.fmodel = model;
    self.contentlab.numberOfLines = 0;
    self.contentlab.font = [UIFont systemFontOfSize:14];
    self.contentlab.preferredMaxLayoutWidth = (DEVICE_WIDTH - 14*2*WIDTH_SCALE);
    [self.contentlab setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    self.contentlab.lineBreakMode = NSLineBreakByWordWrapping;//换行方式
    self.contentlab.text = model.contentstr;
    CGSize textsize= [model.contentstr boundingRectWithSize:CGSizeMake(DEVICE_WIDTH-28*WIDTH_SCALE, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    [self.contentlab sizeToFit];
    for (int i = 0; i<model.pinglunarr.count; i++) {
        NSDictionary *dit = [model.pinglunarr objectAtIndex:i];
        [self.dataarr addObject:dit];
    }
    [self layoutIfNeeded];
    CGFloat hei = textsize.height;
    self.cellheight = hei+28+self.texttable.frame.size.height;
    [self.texttable reloadData];
    return self.cellheight;
}

#pragma mark - getters

-(UILabel *)contentlab
{
    if(!_contentlab)
    {
        _contentlab = [[UILabel alloc] init];
        _contentlab.backgroundColor = [UIColor lightGrayColor];
    }
    return _contentlab;
}

-(UITableView *)texttable
{
    if(!_texttable)
    {
        _texttable = [[UITableView alloc] init];
        _texttable.dataSource = self;
        _texttable.delegate = self;
        _texttable.scrollEnabled = NO;
//        _texttable.rowHeight = UITableViewAutomaticDimension;
//        _texttable.estimatedRowHeight = 50.0f;
    }
    return _texttable;
}

#pragma mark - UITableViewDataSource&&UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    NSDictionary *dic = [self.dataarr objectAtIndex:indexPath.row];
    //NSString *contentstr = [dic objectForKey:@"content"];
    
    NSString *str1 = [dic objectForKey:@"s_nickname"];
    NSString *str2 = @"回复";
    NSString *str3 = [dic objectForKey:@"s_to_nickname"];
    NSString *str4 = [NSString stringWithFormat:@"%@%@",@":",[dic objectForKey:@"content"]];
    NSString *str = [NSString stringWithFormat:@"%@%@%@%@",str1,str2,str3,str4];
    
    CGSize textsize= [str boundingRectWithSize:CGSizeMake(DEVICE_WIDTH-64*WIDTH_SCALE-14*WIDTH_SCALE, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    
  
   // secondCell* cell = [[secondCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:secondidentfid];
//    NSMutableAttributedString *newstr = cell.pinglunlab.attributedText;
    
    [self.texttable mas_makeConstraints:^(MASConstraintMaker *make) {
       // make.height.mas_offset((cell.pinglunlab.frame.size.height+16)*self.dataarr.count);
        make.height.mas_equalTo((textsize.height+16)*self.dataarr.count);
    }];
    
    return textsize.height+16;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataarr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    secondCell *cell = [tableView dequeueReusableCellWithIdentifier:secondidentfid];
    cell = [[secondCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:secondidentfid];
    NSDictionary *dic = [self.dataarr objectAtIndex:indexPath.row];
    cell.pinglunlab.font = [UIFont systemFontOfSize:14];
    cell.pinglunlab.numberOfLines = 0;
    
    NSString *str1 = [dic objectForKey:@"s_nickname"];
    NSString *str2 = @"回复";
    NSString *str3 = [dic objectForKey:@"s_to_nickname"];
    NSString *str4 = [NSString stringWithFormat:@"%@%@",@":",[dic objectForKey:@"content"]];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@%@%@",str1,str2,str3,str4]];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor wjColorFloat:@"576b95"] range:NSMakeRange(0,str1.length)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor wjColorFloat:@"333333"] range:NSMakeRange(str1.length,str2.length)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor wjColorFloat:@"576b95"] range:NSMakeRange(str1.length+str2.length,str3.length)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor wjColorFloat:@"333333"] range:NSMakeRange(str1.length+str2.length+str3.length,str4.length)];
    NSLog(@"str===============%@",str);
    cell.pinglunlab.attributedText = str;
    cell.pinglunlab.lineBreakMode = NSLineBreakByCharWrapping;
    cell.backgroundColor = [UIColor greenColor];
    cell.pinglunlab.backgroundColor = [UIColor lightGrayColor];
    cell.pinglunlab.preferredMaxLayoutWidth = (DEVICE_WIDTH-64*WIDTH_SCALE-14*WIDTH_SCALE);
    [cell.pinglunlab setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [cell.pinglunlab sizeToFit];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = self.dataarr[indexPath.row];
    [self.delegate myTabVClick:self datadic:dic];
}

@end
