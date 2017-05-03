//
//  Timestr.m
//  Supercomments
//
//  Created by 王俊钢 on 2017/4/24.
//  Copyright © 2017年 wangjungang. All rights reserved.
//

#import "Timestr.h"

@implementation Timestr
//时间计算
+(NSString *)datetime:(NSString *)datestr
{

    NSString*  format = @"YYYY-MM-dd HH:mm:ss";
    NSInteger timeinter = [datestr intValue];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:format]; // （@"YYYY-MM-dd hh:mm:ss"）----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timeinter];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    NSString *modeltimestr = confromTimespStr;
    //首先创建格式化对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //然后创建日期对象
    NSDate *date1 = [dateFormatter dateFromString:modeltimestr];
    NSDate *date = [NSDate date];
    //计算时间间隔（单位是秒）
    NSTimeInterval time = [date timeIntervalSinceDate:date1];
    //计算天数、时、分、秒
    int days = ((int)time)/(3600*24);
    int hours = ((int)time)%(3600*24)/3600;
    int minutes = ((int)time)%(3600*24)%3600/60;
    int seconds = ((int)time)%(3600*24)%3600%60;
    NSString *fanhuistr = [[NSString alloc] init];
    if (days>=365) {
        fanhuistr = modeltimestr;
    }
    else if(hours>=72&&hours<365)
    {
        //M月M日
        //实例化一个NSDateFormatter对象
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //设定时间格式,这里可以设置成自己需要的格式
        [dateFormatter setDateFormat:@"MM-dd HH:mm:ss"];
        //用[NSDate date]可以获取系统当前时间
        NSString *currentDateStr = [dateFormatter stringFromDate:date1];
        fanhuistr = currentDateStr;
    }else if (hours<72&&hours>=48)
    {
        //前天
        //实例化一个NSDateFormatter对象
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //设定时间格式,这里可以设置成自己需要的格式
        [dateFormatter setDateFormat:@"HH:mm"];
        //用[NSDate date]可以获取系统当前时间
        NSString *currentDateStr = [dateFormatter stringFromDate:date1];
        fanhuistr = [NSString stringWithFormat:@"%@%@",@"前天",currentDateStr];
        
    }else if (hours<48&&hours>=24)
    {
        //前天
        //实例化一个NSDateFormatter对象
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //设定时间格式,这里可以设置成自己需要的格式
        [dateFormatter setDateFormat:@"HH:mm"];
        //用[NSDate date]可以获取系统当前时间
        NSString *currentDateStr = [dateFormatter stringFromDate:date1];
        fanhuistr = [NSString stringWithFormat:@"%@%@",@"昨天",currentDateStr];
    }else if (hours<24&&hours>=1)
    {
        
        fanhuistr = [NSString stringWithFormat:@"%d%@%@",hours,@"小时",@"前"];
    }else if(hours<1&&minutes>59)
    {
        fanhuistr = [NSString stringWithFormat:@"%d%@%@",minutes,@"分钟",@"前"];
    }else if(minutes<=1)
    {
        fanhuistr = @"刚刚";
    }
    return fanhuistr;

}


//获取当前系统时间的时间戳

#pragma mark - 获取当前时间的 时间戳

+(NSString* )getNowTimestamp{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *datenow = [NSDate date];//现在时间
    
    
    
    NSLog(@"设备当前的时间:%@",[formatter stringFromDate:datenow]);
    
    //时间转时间戳的方法:
    
    
    
    NSInteger timeSp = [[NSNumber numberWithDouble:[datenow timeIntervalSince1970]] integerValue];
    
    
    
    NSLog(@"设备当前的时间戳:%ld",(long)timeSp); //时间戳的值
    
    NSString *timespstr = [NSString stringWithFormat:@"%ld",(long)timeSp];
    
    return timespstr;
    
}



//将某个时间转化成 时间戳

#pragma mark - 将某个时间转化成 时间戳

+(NSInteger)timeSwitchTimestamp:(NSString *)formatTime andFormatter:(NSString *)format{
    
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:format]; //(@"YYYY-MM-dd hh:mm:ss") ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    
    [formatter setTimeZone:timeZone];
    
    
    
    NSDate* date = [formatter dateFromString:formatTime]; //------------将字符串按formatter转成nsdate
    
    //时间转时间戳的方法:
    
    NSInteger timeSp = [[NSNumber numberWithDouble:[date timeIntervalSince1970]] integerValue];
    
    
    
    NSLog(@"将某个时间转化成 时间戳&&&&&&&timeSp:%ld",(long)timeSp); //时间戳的值
    
    
    
    return timeSp;
    
}



//将某个时间戳转化成 时间

#pragma mark - 将某个时间戳转化成 时间

-(NSString *)timestampSwitchTime:(NSInteger)timestamp andFormatter:(NSString *)format{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];

    [formatter setDateFormat:format]; // （@"YYYY-MM-dd hh:mm:ss"）----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timestamp];
    
    NSLog(@"1296035591  = %@",confromTimesp);
    
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    
    //NSLog(@"&&&&&&&confromTimespStr = : %@",confromTimespStr);
    
    return confromTimespStr;
}


@end
