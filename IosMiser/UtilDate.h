//
//  UtilDate.h
//  IosMiser
//
//  Created by 李峰艳 on 15/7/21.
//  Copyright (c) 2015年 李峰艳. All rights reserved.
//
#import <Foundation/Foundation.h>
@interface UtilDate : NSObject

+ (NSString *)stringFromDate:(NSDate *)date;
+ (NSDate *)dateFromString:(NSString *)str;

@end
