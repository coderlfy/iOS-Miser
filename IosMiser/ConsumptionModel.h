//
//  ConsumptionItem.h
//  IosMiser
//
//  Created by 李峰艳 on 15/7/14.
//  Copyright (c) 2015年 李峰艳. All rights reserved.
//

#import "RETableViewItem.h"

@interface ConsumptionModel : RETableViewItem

//@property (copy, readwrite, nonatomic) NSString *describe;
@property (copy, readwrite, nonatomic) NSNumber *money;
@property (copy, readwrite, nonatomic) NSString *startDate;
@property (readwrite, nonatomic) Boolean isConsumption;

@end
