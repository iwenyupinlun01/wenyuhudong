//
//  headModel.h
//  Supercomments
//
//  Created by 王俊钢 on 2017/4/17.
//  Copyright © 2017年 wangjungang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface headModel : NSObject
@property (nonatomic,strong) NSString *imgurlstr;
@property (nonatomic,strong) NSString *timestr;
@property (nonatomic,strong) NSString *namestr;
@property (nonatomic,strong) NSString *contactstr;
@property (nonatomic,strong) NSMutableArray *dianzaiarr;
@property (nonatomic,strong) NSString *fromstr;

@property (nonatomic,strong) NSMutableArray *thumarr;
@end
