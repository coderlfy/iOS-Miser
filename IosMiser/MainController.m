//
//  MainController.m
//  IosMiser
//
//  Created by 李峰艳 on 15/7/13.
//  Copyright (c) 2015年 李峰艳. All rights reserved.
//

#import "MainController.h"

#import "EditConsumptionController.h"
#import "TConsumption.h"
#import  "ConsumptionCell.h"

@interface MainController ()

@property (strong, readwrite, nonatomic) RETableViewSection *section;
@property (strong, readwrite, nonatomic) NSMutableArray *consumptions;

@end

@implementation MainController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"守财奴";
    self.navigationController.navigationBar.barTintColor = [ UIColor colorWithRed: 30.0f/255.0f
                                                                            green: 144.0/255.0f
                                                                             blue: 255.0f/255.0f
                                                                            alpha: 0.5
                                                            ];
    [self.navigationController.navigationBar setTitleTextAttributes: @{
                                                                       NSFontAttributeName:[UIFont systemFontOfSize:19], NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    UIBarButtonItem *item=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAction)];
    self.navigationItem.rightBarButtonItem=item;
    
    _manager = [[RETableViewManager alloc] initWithTableView:self.tableView delegate:self];
    _manager[@"ConsumptionModel"] = @"ConsumptionCell";
    
    if(self.section == nil){
        self.section = [RETableViewSection sectionWithHeaderView:nil];
        [_manager addSection:self.section];
        [self loadDataForSection];
        //[self loadStaticDataForSection];
        
    }
}



-(void)loadStaticDataForSection {
    
    for (NSInteger i = 1; i < 100; i++) {
        NSString *title = [NSString stringWithFormat:@"Item %i", i];
        ConsumptionModel *item = [ConsumptionModel itemWithTitle:title
                                                   accessoryType:UITableViewCellAccessoryDisclosureIndicator
                                                selectionHandler:^(RETableViewItem *item) {
                                                    [item deselectRowAnimated:YES];
                                                }];
        item.title = @"good";
        item.money = title;
        item.startDate = title;
        item.cellHeight = 70;
        
        [self.section addItem:item];
    }
}

-(void)loadDataForSection {
    
    TConsumption *db = [[TConsumption alloc] init];
    [db creatTableWithDataBaseName];
    ConsumptionModel *consumption = [[ConsumptionModel alloc]init];
    consumption.title = @"招财宝投资";
    consumption.isConsumption = false;
    consumption.money = @"1200";
    consumption.startDate = @"2015-6-22 12:33";
    
    [db addConsumptionByExample:consumption];
    self.consumptions = [db findAllConsumption];
    //    self.data = consumptions;
    for (ConsumptionModel *u in self.consumptions) {
        u.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        u.cellHeight = 60;
        [self.section addItem:u];
    }
}

- (void)addAction{
    __typeof (&*self) __weak weakSelf = self;
    
    EditConsumptionController *addcontroller =[[EditConsumptionController alloc] initWithAction:true];
    addcontroller.block = ^(ConsumptionModel *model, BOOL isAdd){
        TConsumption *db=[[TConsumption alloc] init];
        [db addConsumption:model];
        
        model.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        model.cellHeight = 60;
        [weakSelf.section addItem:model];
        [weakSelf.tableView reloadData];
        
        [self.consumptions addObject:model];
    };
    [self.navigationController pushViewController:addcontroller animated:YES];
}

- (UIColor *) getMoneyColorWithIsConsumption:(BOOL)isConsumption {
    
    UIColor *myColorHue = isConsumption?
    [ UIColor colorWithRed: 227.0f/255.0f
                     green: 23.0/255.0f
                      blue: 13.0f/255.0f
                     alpha: 1
     ]:
    [ UIColor colorWithRed: 0.0f/255.0f
                     green: 201.0/255.0f
                      blue: 87.0/255.0f
                     alpha: 1
     ];
    return myColorHue;
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    for (UIView *view in cell.contentView.subviews) {
    //        if ([view isKindOfClass:[UILabel class]] || [view isKindOfClass:[UITextField class]] || [view isKindOfClass:[UITextView class]])
    //            ((UILabel *)view).font = [UIFont fontWithName:@"Avenir-Medium" size:16];
    //    }
    
    //    if ([cell isKindOfClass:[RETableViewCreditCardCell class]]) {
    ConsumptionCell *ccCell = (ConsumptionCell *)cell;
    ConsumptionModel *currentModel = self.consumptions[indexPath.row];
    ccCell.money.textColor = [self getMoneyColorWithIsConsumption:currentModel.isConsumption];
    //    ccCell.cvvField.font = [UIFont fontWithName:@"Avenir-Medium" size:16];
    //    }
}
@end