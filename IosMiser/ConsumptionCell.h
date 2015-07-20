//
//  ConsumptionCell.h
//  IosMiser
//
//  Created by 李峰艳 on 15/7/14.
//  Copyright (c) 2015年 李峰艳. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "RETableViewCell.h"
#import "ConsumptionModel.h"

@interface ConsumptionCell : RETableViewCell

@property (strong, readwrite, nonatomic) IBOutlet UILabel *describe;
@property (strong, readwrite, nonatomic) IBOutlet UILabel *money;
@property (strong, readwrite, nonatomic) IBOutlet UILabel *occurTime;
@property (strong, readwrite, nonatomic) ConsumptionModel *item;

@end
