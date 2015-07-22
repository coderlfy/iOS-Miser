//
//  ContextMenuController.h
//  IosMiser
//
//  Created by 李峰艳 on 15/7/22.
//  Copyright (c) 2015年 李峰艳. All rights reserved.
//
#import "YALContextMenuTableView.h"
@interface ContextMenuController : NSObject<
UITableViewDelegate,
UITableViewDataSource,
YALContextMenuTableViewDelegate
>

@property (nonatomic, strong) YALContextMenuTableView* contextMenuTableView;

- (void)initiateMenuOptions;

@end