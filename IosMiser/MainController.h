//
//  MainController.h
//  IosMiser
//
//  Created by 李峰艳 on 15/7/13.
//  Copyright (c) 2015年 李峰艳. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "RETableViewManager.h"
#import "RETableViewOptionsController.h"
#import "ConsumptionModel.h"


@interface MainController : UITableViewController <RETableViewManagerDelegate>

@property (strong, readonly, nonatomic) RETableViewManager *manager;


@end