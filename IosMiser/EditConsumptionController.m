//
//  EditConsumptionController.m
//  IosMiser
//
//  Created by 李峰艳 on 15/7/9.
//  Copyright (c) 2015年 李峰艳. All rights reserved.
//

#import "EditConsumptionController.h"


@interface EditConsumptionController ()

@property (strong, readwrite, nonatomic) RELongTextItem *longTextItem;
@property (strong, readwrite, nonatomic) REDateTimeItem *dateTimeItem;
@property (strong, readwrite, nonatomic) REBoolItem *boolItem;
@property (strong, readwrite, nonatomic) RERadioItem *radioItem;
@property (strong, readwrite, nonatomic) RENumberItem *numberItem;
@property (nonatomic,assign)BOOL isAdd;

@end

@implementation EditConsumptionController

- (instancetype) initWithAction:(BOOL)isAdd{
    self = [self initWithStyle:UITableViewStyleGrouped];
    self.isAdd = isAdd;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"记账";
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    _manager = [[RETableViewManager alloc] initWithTableView:self.tableView delegate:self];
    
    self.basicControlsSection = [self addBasicControls];
    self.buttonSection = [self addButton];
    // Do any additional setup after loading the view, typically from a nib.
}

- (RETableViewSection *)addBasicControls
{
    __typeof (&*self) __weak weakSelf = self;
    
    RETableViewSection *section = [RETableViewSection sectionWithHeaderTitle:@"账目项目"];
    [_manager addSection:section];
    
    [section addItem:@"事项或摘要描述："];
    
    self.longTextItem = [RELongTextItem itemWithValue:nil placeholder:@"这里输入内容"];
    self.longTextItem.cellHeight = 88;
    [section addItem:self.longTextItem];
    
    self.dateTimeItem = [REDateTimeItem itemWithTitle:@"发生时刻：" value:[NSDate date] placeholder:nil format:@"yyyy-MM-dd hh:mm a" datePickerMode:UIDatePickerModeDateAndTime];
    [section addItem:self.dateTimeItem];
    
    self.radioItem = [RERadioItem itemWithTitle:@"产生费用方式：" value:@"支出" selectionHandler:^(RERadioItem *item) {
        [item deselectRowAnimated:YES]; // same as [weakSelf.tableView deselectRowAtIndexPath:item.indexPath animated:YES];
        
        // Generate sample options
        //
        NSMutableArray *options = [[NSMutableArray alloc] init];
        /*
         for (NSInteger i = 1; i < 40; i++)
         [options addObject:[NSString stringWithFormat:@"Option %i", i]];
         */
        [options addObject:@"支出"];
        [options addObject:@"收入"];
        // Present options controller
        //
        RETableViewOptionsController *optionsController = [[RETableViewOptionsController alloc] initWithItem:item options:options multipleChoice:NO completionHandler:^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
            
            [item reloadRowWithAnimation:UITableViewRowAnimationNone]; // same as [weakSelf.tableView reloadRowsAtIndexPaths:@[item.indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }];
        
        // Adjust styles
        //
        optionsController.delegate = weakSelf;
        optionsController.style = section.style;
        if (weakSelf.tableView.backgroundView == nil) {
            optionsController.tableView.backgroundColor = weakSelf.tableView.backgroundColor;
            optionsController.tableView.backgroundView = nil;
        }
        
        // Push the options controller
        //
        [weakSelf.navigationController pushViewController:optionsController animated:YES];
    }];
    [section addItem:self.radioItem];
    
    self.numberItem = [RENumberItem itemWithTitle:@"金额：" value:@"" placeholder:@"￥0" format:@"￥XXXXXXX"];
    [section addItem:self.numberItem];
    
    
    self.boolItem = [REBoolItem itemWithTitle:@"是否入账：" value:YES switchValueChangeHandler:^(REBoolItem *item) {
        NSLog(@"Value: %@", item.value ? @"YES" : @"NO");
    }];
    [section addItem:self.boolItem];
    
    return section;
}

- (NSString *)stringFromDate:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}

- (RETableViewSection *)addButton
{
    __typeof (&*self) __weak weakSelf = self;
    
    RETableViewSection *section = [RETableViewSection section];
    [_manager addSection:section];
    
    RETableViewItem *buttonItem = [RETableViewItem itemWithTitle:@"保存" accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item) {
        [weakSelf.tableView deselectRowAtIndexPath:item.indexPath animated:YES];
        NSLog(@"longTextItem ＝ %@", self.longTextItem.value);
        
        ConsumptionModel *consumption = [[ConsumptionModel alloc]init];
        consumption.title = self.longTextItem.value;
        consumption.isConsumption = [self.radioItem.value  isEqual: @"支出"];
        consumption.money = [NSNumber numberWithInt:[self.numberItem.value intValue]];
        consumption.startDate = [self stringFromDate:self.dateTimeItem.value];
        self.block(consumption,self.isAdd);
        
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    //    buttonItem.accessoryView.tintColor = [UIColor  orangeColor];
    buttonItem.textAlignment = NSTextAlignmentCenter;
    [section addItem:buttonItem];
    //    section.tableViewManager.tableView.backgroundColor =[UIColor  orangeColor];
    
    return section;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
