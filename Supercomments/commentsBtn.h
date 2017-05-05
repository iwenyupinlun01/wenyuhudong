//
//  commentsBtn.h
//  Supercomments
//
//  Created by 王俊钢 on 2017/4/8.
//  Copyright © 2017年 wangjungang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface commentsBtn : UIButton
@property (nonatomic,strong) UIImageView *leftimg;
@property (nonatomic,strong) UILabel *textlab;
@property (nonatomic,strong) NSString *commentnumberstr;
-(void)commentframedata:(NSString *)commnumber;
@end
