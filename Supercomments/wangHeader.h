//
//  wangHeader.h
//  Supercomments
//
//  Created by 王俊钢 on 2017/4/14.
//  Copyright © 2017年 wangjungang. All rights reserved.
//

#ifndef wangHeader_h
#define wangHeader_h

#define IPAddress @"np.iwenyu.cn"




#define WXPatient_App_ID                 @"wx133ee2b8bd5d3c7d" //您的帐号id信息
#define WXPatient_App_Secret             @"a905fbeb82b080c8c643360a062f2531" //您的帐号secret信息
#define WX_BASE_URL                      @"https://api.weixin.qq.com/sns"
#define WX_ACCESS_TOKEN                  @"access_token"
#define WX_OPEN_ID                       @"openid"
#define WX_REFRESH_TOKEN                 @"refresh_token"
#define WX_SCOPE                         @"snsapi_userinfo"
#define WX_STATE                         @"APP"

#define WXLoginSuccess                   @"WXLoginSuccess"


//#define newVCload  @"http://np.iwenyu.cn/forum/index/index.html?page=%@&type=%@&token=%@"

#define newVCload  @"http://"IPAddress"/forum/index/index.html?page=%@&type=%@&token=%@"

#define loginbool @"http://"IPAddress"/forum/index/userInfo.html?token=%@"

#define xiangqin @"http://"IPAddress"/forum/index/detail.html?id=%@&page=%@&token=%@"

#define denglu @"http://"IPAddress"/ucenter/member/login.html"
//点赞或者取消点赞
#define qudianzan @"http://"IPAddress"/forum/index/addSupport.html"
//通知消息数量
#define tongzhixianxishuliang @"http://"IPAddress"/forum/index/getInformNum.html?token=%@"
//回复消息
#define huifuxiaoxi @"http://"IPAddress"/forum/user/messageInform.html?token=%@&page=%@"
//系统通知
#define xitongtongzhi @"http://"IPAddress"/forum/user/systemInform.html?token=%@&page=%@"
//看完消息后返回
#define kanwanxiaoxi @"http://"IPAddress"/forum/user/returnMsg.html?token=%@&id=%@"

//删除消息通知
#define shanchuxiaoxi @"http://"IPAddress"/forum/user/removeInform.html?token=%@&type=%@&id=%@"
//意见反馈
#define yijianfankui @"http://"IPAddress"/forum/user/opinionFeedback.html"
//关于界面
#define guanyujiemian @"http://"IPAddress"/forum/user/about.html"
//消息通知
#define xiaoxitongzhijk @"http://"IPAddress"/forum/user/messageInform.html?token=%@&page=%@"
//修改头像
#define touxiang @"http://"IPAddress"/forum/user/userIcon.html"
//token替换
#define tokentihuan @"http://"IPAddress"/forum/user/begin.html"
//退出登陆
#define tuichudenglu @"http://"IPAddress"/forum/user/loginout.html"
//评论
#define pinglunhuifu @"http://"IPAddress"/forum/index/addComment.html"
//界面隐藏
#define jiemianyingcang @"http://"IPAddress"/forum/user/proHide.html?token=%@&type=%@"
//修改昵称
#define xiugainicheng @"http://"IPAddress"/forum/user/editNickname.html"
#endif /* wangHeader_h */
