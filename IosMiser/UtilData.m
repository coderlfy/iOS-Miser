//
//  UtilData.m
//  IosMiser
//
//  Created by 李峰艳 on 15/7/21.
//  Copyright (c) 2015年 李峰艳. All rights reserved.
//
#import "UtilDate.h"

@implementation UtilDate

+ (NSString *)stringFromDate:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}

+ (NSDate *)dateFromString:(NSString *)str{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *date = [dateFormatter dateFromString:str];
    return date;
}

@end

