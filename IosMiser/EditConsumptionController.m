//
//  EditConsumptionController.m
//  IosMiser
//
//  Created by 李峰艳 on 15/7/9.
//  Copyright (c) 2015年 李峰艳. All rights reserved.
//

#import "EditConsumptionController.h"
#import "UtilDate.h"

@interface EditConsumptionController ()

@property (strong, readwrite, nonatomic) RELongTextItem *ltiTitle;
@property (strong, readwrite, nonatomic) REDateTimeItem *dtiStartTime;
@property (strong, readwrite, nonatomic) REBoolItem *biCalculated;
@property (strong, readwrite, nonatomic) RERadioItem *riIsConsumption;
@property (strong, readwrite, nonatomic) RENumberItem *niMoney;
@property (nonatomic,assign)BOOL isAdd;
@property (strong, readwrite, nonatomic) RETableViewSection *section;
@property (strong, readwrite, nonatomic) ConsumptionModel *consumption;

@end

@implementation EditConsumptionController

- (instancetype) initByAddUI{
    self = [self initWithStyle:UITableViewStyleGrouped];
    self.isAdd = true;
    return self;
}
- (instancetype) initByUpdateUI:(ConsumptionModel *)consumption{
    self = [self initWithStyle:UITableViewStyleGrouped];
    self.isAdd = false;
    self.consumption = consumption;
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"记账";
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    _manager = [[RETableViewManager alloc] initWithTableView:self.tableView delegate:self];
    
    self.basicControlsSection = [self addBasicControls];
    self.buttonSection = [self addButton];
    
    [self assignToControl];
}
- (void)assignToControl{
    if(!self.isAdd){
        self.ltiTitle.value = self.consumption.title;
        self.dtiStartTime.value = [UtilDate dateFromString:self.consumption.startDate];
        self.riIsConsumption.value = self.consumption.isConsumption?@"支出":@"收入";
        self.niMoney.value = [NSString stringWithFormat:@"%i", [self.consumption.money intValue]];
    }
}
- (RETableViewSection *)addBasicControls{
    self.section = [RETableViewSection sectionWithHeaderTitle:@"账目项目"];
    [_manager addSection:self.section];
    
    [self.section addItem:@"事项或摘要描述："];
    [self addTitle];
    [self addStartDate];
    [self addIsConsumption];
    [self addMoney];
    [self addIsCalculated];
    
    return self.section;
}
-(void)addTitle{
    self.ltiTitle = [RELongTextItem itemWithValue:nil
                                      placeholder:@"这里输入内容（必填项）"];
    self.ltiTitle.cellHeight = 88;
    [self.section addItem:self.ltiTitle];
}
-(void)addIsConsumption{
    self.riIsConsumption = [RERadioItem itemWithTitle:@"产生费用方式："
                                                value:@"支出"
                                     selectionHandler:[self viewConsumpionMode]];
    [self.section addItem:self.riIsConsumption];
}
-(void(^)(RERadioItem *))viewConsumpionMode{
    __typeof (&*self) __weak weakSelf = self;
    return ^(RERadioItem *item){
        
        [item deselectRowAnimated:YES];
        
        NSMutableArray *options = [[NSMutableArray alloc] init];
        
        [options addObject:@"支出"];
        [options addObject:@"收入"];
        
        RETableViewOptionsController *optionsController =
        [[RETableViewOptionsController alloc] initWithItem:item
                                                   options:options
                                            multipleChoice:NO
                                         completionHandler:^{
                                             [weakSelf.navigationController popViewControllerAnimated:YES];
                                             [item reloadRowWithAnimation:UITableViewRowAnimationNone];
                                         }];
        
        optionsController.delegate = weakSelf;
        optionsController.style = self.section.style;
        if (weakSelf.tableView.backgroundView == nil) {
            optionsController.tableView.backgroundColor = weakSelf.tableView.backgroundColor;
            optionsController.tableView.backgroundView = nil;
        }
        [weakSelf.navigationController pushViewController:optionsController animated:YES];
        
    };
}
-(void)addStartDate{
    self.dtiStartTime = [REDateTimeItem itemWithTitle:@"发生时刻："
                                                value:[NSDate date]
                                          placeholder:nil
                                               format:@"yyyy-MM-dd hh:mm a"
                                       datePickerMode:UIDatePickerModeDateAndTime];
    [self.section addItem:self.dtiStartTime];
}
-(void)addMoney{
    self.niMoney = [RENumberItem itemWithTitle:@"金额："
                                         value:@""
                                   placeholder:@"￥0"
                                        format:@"￥XXXXXXX"];
    [self.section addItem:self.niMoney];
}
-(void)addIsCalculated{
    self.biCalculated = [REBoolItem itemWithTitle:@"是否入账："
                                            value:YES
                         switchValueChangeHandler:^(REBoolItem *item) {
                             NSLog(@"Value: %@", item.value ? @"YES" : @"NO");
                         }];
    [self.section addItem:self.biCalculated];
}
- (RETableViewSection *)addButton{
    RETableViewSection *section = [RETableViewSection section];
    [_manager addSection:section];
    
    RETableViewItem *buttonItem = [RETableViewItem itemWithTitle:@"保存"
                                                   accessoryType:UITableViewCellAccessoryNone
                                                selectionHandler:[self saveAction]];
    buttonItem.textAlignment = NSTextAlignmentCenter;
    [section addItem:buttonItem];
    
    return section;
}
-(void(^)(RETableViewItem *))saveAction{
    __typeof (&*self) __weak weakSelf = self;
    return ^(RETableViewItem *item){
        [weakSelf.tableView deselectRowAtIndexPath:item.indexPath animated:YES];
        NSLog(@"longTextItem ＝ %@", self.ltiTitle.value);
        if(self.ltiTitle.value == nil ||
           [self.ltiTitle.value isEqualToString:@""]){
            [self showAlert:@"账目描述不可为空！"];
            return;
        }
        
        ConsumptionModel *consumption = (self.consumption==nil)?
                                        [[ConsumptionModel alloc]init]:
                                        self.consumption;
        consumption.title = self.ltiTitle.value;
        consumption.isConsumption = [self.riIsConsumption.value  isEqual: @"支出"];
        consumption.money = [NSNumber numberWithInt:[self.niMoney.value intValue]];
        consumption.startDate = [UtilDate stringFromDate:self.dtiStartTime.value];
        self.block(consumption,self.isAdd);
        
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
}
-(void)showAlert:(NSString*) message{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"系统提醒"
                                                 message:message
                                                delegate:nil
                                       cancelButtonTitle:@"确定"
                                       otherButtonTitles:nil, nil];
    [av show];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
