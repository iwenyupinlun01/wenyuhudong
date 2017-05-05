//
//  replyModel.h
//  Supercomments
//
//  Created by 王俊钢 on 2017/4/7.
//  Copyright © 2017年 wangjungang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface replyModel : NSObject

@property (nonatomic,strong) NSString *replyurl;
@property (nonatomic,strong) NSString *replyname;
@property (nonatomic,strong) NSString *replytext;
@property (nonatomic,strong) NSString *replyrighturl;
@property (nonatomic,strong) NSString *replytimestr;
@property (nonatomic,strong) NSString *replyidstr;
@property (nonatomic,strong) NSString *replyissetstr;
@property (nonatomic,strong) NSString *replyrightlabstr;

@property (nonatomic,strong) NSString *comment_img_type;
@property (nonatomic,strong) NSString *comment_imgstr;
//牛评的id
@property (nonatomic,strong) NSString *obj_id;
//是否已读
@property (nonatomic,strong) NSString *is_checkstr;
@end
