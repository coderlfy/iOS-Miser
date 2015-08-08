//
//  EditConsumptionController.h
//  IosMiser
//
//  Created by 李峰艳 on 15/7/9.
//  Copyright (c) 2015年 李峰艳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RETableViewManager.h"
#import "RETableViewOptionsController.h"
#import "ConsumptionModel.h"

typedef void(^ButBlock)(ConsumptionModel *consumption, BOOL isAdd);

@interface EditConsumptionController : UITableViewController <RETableViewManagerDelegate>

@property (strong, readonly, nonatomic) RETableViewManager *manager;
@property (strong, readwrite, nonatomic) RETableViewSection *basicControlsSection;
@property (strong, readwrite, nonatomic) RETableViewSection *buttonSection;
@property (nonatomic,copy) ButBlock block;
//测试12356223
- (instancetype) initByAddUI;
- (instancetype) initByUpdateUI:(ConsumptionModel *)consumption;
@end

