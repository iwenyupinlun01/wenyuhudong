//
//  newModel.h
//  Supercomments
//
//  Created by 王俊钢 on 2017/4/14.
//  Copyright © 2017年 wangjungang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface newModel : NSObject
@property (nonatomic,strong) NSString *namestr;
@property (nonatomic,strong) NSString *fromstr;
@property (nonatomic,strong) NSString *contentstr;
@property (nonatomic,strong) NSString *titlestr;
@property (nonatomic,strong) NSString *timestr;
@property (nonatomic,strong) NSString *imgurlstr;
@property (nonatomic,strong) NSString *dianzanstr;
@property (nonatomic,strong) NSString *pinglunstr;
@property (nonatomic,strong) NSString *newidstr;
@property (nonatomic,strong) NSString *typestr;
@property (nonatomic,strong) NSString *sifoudianzanstr;
@property (nonatomic,strong) NSString *objidstr;
@property (nonatomic,strong) NSString *weburlstr;

@property (nonatomic,strong) NSString *platformstr;

@property (nonatomic,strong) NSString *small_imagesstrl;
@property (nonatomic,strong) NSString *ishot;

@property (nonatomic,strong) NSString *textheightstr;

//单元格的高度
@property (nonatomic,assign) CGFloat cellHeight;
@end
