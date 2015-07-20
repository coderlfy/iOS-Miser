//
//  ConsumptionCell.m
//  IosMiser
//
//  Created by 李峰艳 on 15/7/14.
//  Copyright (c) 2015年 李峰艳. All rights reserved.
//

#import "ConsumptionCell.h"

@implementation ConsumptionCell

- (void)cellWillAppear
{
    [super cellWillAppear];
    self.textLabel.text = @"";
    self.describe.text = self.item.title;
    self.money.text = [NSString stringWithFormat:@"¥%i", [self.item.money intValue]];
    self.occurTime.text = self.item.startDate;
}

@end
