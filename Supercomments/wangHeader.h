//
//  wangHeader.h
//  Supercomments
//
//  Created by 王俊钢 on 2017/4/14.
//  Copyright © 2017年 wangjungang. All rights reserved.
//

#ifndef wangHeader_h
#define wangHeader_h


#define WXPatient_App_ID                 @"wx133ee2b8bd5d3c7d" //您的帐号id信息
#define WXPatient_App_Secret             @"a905fbeb82b080c8c643360a062f2531" //您的帐号secret信息
#define WX_BASE_URL                      @"https://api.weixin.qq.com/sns"
#define WX_ACCESS_TOKEN                  @"access_token"
#define WX_OPEN_ID                       @"openid"
#define WX_REFRESH_TOKEN                 @"refresh_token"
#define WX_SCOPE                         @"snsapi_userinfo"
#define WX_STATE                         @"APP"

#define WXLoginSuccess                   @"WXLoginSuccess"


#define newVCload  @"http://np.iwenyu.cn/forum/index/index.html?page=%@&type=%@&token=%@"

#define loginbool @"http://np.iwenyu.cn/forum/index/userInfo.html?token=%@"

#define xiangqin @"http://np.iwenyu.cn/forum/index/detail.html?id=%@&page=%@&token=%@"

#define denglu @"http://np.iwenyu.cn/ucenter/member/login.html"
//点赞或者取消点赞
#define dianzan @"http://np.iwenyu.cn/forum/index/addSupport.html"
//通知消息数量
#define tongzhixianxishuliang @"http://np.iwenyu.cn/forum/index/getInformNum.html?token=%@"
//回复消息
#define huifuxiaoxi @"http://np.iwenyu.cn/forum/user/messageInform.html?token=%@&page=%@"
//系统通知
#define xitongtongzhi @"http://np.iwenyu.cn/forum/user/systemInform.html?token=%@&page=%@"
//看完消息后返回
#define kanwanxiaoxi @"http://np.iwenyu.cn/forum/user/returnMsg.html?token=%@&id=%@"
//删除消息通知
#define shanchuxiaoxi @"http://np.iwenyu.cn/forum/user/removeInform.html?token=%@&type=%@&id=%@"
//意见反馈
#define yijianfankui @"http://np.iwenyu.cn/forum/user/opinionFeedback.html"
//关于界面
#define guanyujiemian @"http://np.iwenyu.cn/forum/user/about.html"
//消息通知
#define xiaoxitongzhijk @"http://np.iwenyu.cn/forum/user/messageInform.html?token=%@&page=%@"
//修改头像
#define touxiang @"http://np.iwenyu.cn/forum/user/userIcon.html?token=%@"
//token替换
#define tokentihuan @"http://np.iwenyu.cn/user/index/begin.html"

#endif /* wangHeader_h */
