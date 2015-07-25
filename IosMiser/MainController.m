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
#import "ConsumptionCell.h"
#import "ContextMenuController.h"
#import "YALContextMenuTableView.h"

@interface MainController ()

@property (strong, readwrite, nonatomic) RETableViewSection *section;
@property (strong, readwrite, nonatomic) NSMutableArray *consumptions;
@property (strong, readwrite, nonatomic) ContextMenuController *contextMenuController;
@property (strong, readwrite, nonatomic) UIAlertView *alertView;
//@property (strong, readwrite, nonatomic) UIAlertController *alertController ;

@end

@implementation MainController

- (void) viewDidLoad{
    [super viewDidLoad];
    self.title = @"守财奴";
    //设置导航条的样式（背景色／字体颜色等）
    [self setNavigationBarStyle];
    //
    [self initContextMenu];
    //添加导航条上的功能按钮
    [self addNavigationButtons];
    //加载主题内容
    [self loadContent];
}
- (void) setNavigationBarStyle{
    self.navigationController.navigationBar.barTintColor = [ UIColor colorWithRed: 30.0f/255.0f
                                                                            green: 144.0/255.0f
                                                                             blue: 255.0f/255.0f
                                                                            alpha: 0.5
                                                            ];
    [self.navigationController.navigationBar setTitleTextAttributes: @{
                                                                       NSFontAttributeName:[UIFont systemFontOfSize:19],
                                                                       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}
- (void) addNavigationButtons{
    UIBarButtonItem *rightitem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                             target:self
                                                                             action:@selector(addAction)];
    
    UIBarButtonItem *leftitem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks
                                                                            target:self
                                                                            action:@selector(presentMenuButtonTapped:)];
    self.navigationItem.rightBarButtonItem=leftitem;
    self.navigationItem.leftBarButtonItem=rightitem;
}
- (void) initContextMenu{
    if(self.contextMenuController == nil){
        self.contextMenuController = [[ContextMenuController alloc] init];
        [self.contextMenuController initiateMenuOptions];
        
    }
}
- (void) presentMenuButtonTapped:(UIBarButtonItem *)sender {
    // init YALContextMenuTableView tableView
    if (!self.contextMenuController.contextMenuTableView) {
        self.contextMenuController.contextMenuTableView = [[YALContextMenuTableView alloc]initWithTableViewDelegateDataSource:self.contextMenuController];
        self.contextMenuController.contextMenuTableView.animationDuration = 0.15;
        //optional - implement custom YALContextMenuTableView custom protocol
        self.contextMenuController.contextMenuTableView.yalDelegate = self.contextMenuController;
        
        //register nib
        UINib *cellNib = [UINib nibWithNibName:@"ContextMenuCell" bundle:nil];
        [self.contextMenuController.contextMenuTableView registerNib:cellNib forCellReuseIdentifier:@"rotationCell"];
    }
    
    // it is better to use this method only for proper animation
    [self.contextMenuController.contextMenuTableView showInView:self.navigationController.view withEdgeInsets:UIEdgeInsetsZero animated:YES];
}
- (void) loadContent{
    _manager = [[RETableViewManager alloc] initWithTableView:self.tableView delegate:self];
    _manager[@"ConsumptionModel"] = @"ConsumptionCell";
    
    if(self.section == nil){
        self.section = [RETableViewSection sectionWithHeaderView:nil];
        [_manager addSection:self.section];
        [self loadDataForSection];
        //[self loadStaticDataForSection];
        
    }
}
- (void) loadStaticDataForSection {
    
    for (NSInteger i = 1; i < 100; i++) {
        NSString *title = [NSString stringWithFormat:@"Item %li", (long)i];
        ConsumptionModel *item = [ConsumptionModel itemWithTitle:title
                                                   accessoryType:UITableViewCellAccessoryDisclosureIndicator
                                                selectionHandler:^(RETableViewItem *item) {
                                                    [item deselectRowAnimated:YES];
                                                }];
        item.title = @"good";
        item.money = @120;
        item.startDate = title;
        item.cellHeight = 70;
        
        [self.section addItem:item];
    }
}
- (void) loadDataForSection {
    
    TConsumption *db = [[TConsumption alloc] init];
    
    [db creatTableWithDataBaseName];
    ConsumptionModel *consumption = [[ConsumptionModel alloc]init];
    consumption.title = @"招财宝投资";
    consumption.isConsumption = false;
    consumption.money = [NSNumber numberWithInt:120];
    consumption.startDate = @"2015-6-22 12:33";
    [db addConsumptionByExample:consumption];
    
    self.consumptions = [db findAllConsumption];
    for (ConsumptionModel *u in self.consumptions) {
        
        [self assignAttribute:u];
        [self.section addItem:u];
    }
}
- (void) assignAttribute:(ConsumptionModel*)u{
    __typeof (&*self) __weak weakSelf = self;
    u.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    u.cellHeight = 60;
    u.editingStyle = UITableViewCellEditingStyleDelete;
    u.deletionHandler = ^(RETableViewItem *item) {
        ConsumptionModel *currentModel = (ConsumptionModel *)item;
        [self.consumptions removeObject:currentModel];
        [[TConsumption shareConsumption] deleteConsumption:currentModel];
    };
    u.selectionHandler = ^(RETableViewItem *item) {
        ConsumptionModel *currentModel = (ConsumptionModel *)item;
        
        EditConsumptionController *addcontroller = [[EditConsumptionController alloc] initByUpdateUI:currentModel];
        addcontroller.block = ^(ConsumptionModel *model, BOOL isAdd){
            [weakSelf startShowIndicatorAlert];
            
            TConsumption *db=[[TConsumption alloc] init];
            [db updateConsumption:model];
            [weakSelf.manager.tableView reloadData];
            [weakSelf hideIndicatorAlert];
        };
        [self.navigationController pushViewController:addcontroller animated:YES];
    };
}
- (void) addAction{
    __typeof (&*self) __weak weakSelf = self;
    
    if(weakSelf.contextMenuController != nil){
        [weakSelf.contextMenuController.contextMenuTableView hideContextMenu];
    }
    
    EditConsumptionController *addcontroller = [[EditConsumptionController alloc] initByAddUI];
    addcontroller.block = ^(ConsumptionModel *model, BOOL isAdd){
        /*
         weakSelf.alertController = [UIAlertController alertControllerWithTitle:@"标题"
         message:@"这个是UIAlertController的默认样式"
         preferredStyle:UIAlertControllerStyleAlert];
         
         [weakSelf presentViewController:weakSelf.alertController
         animated:YES
         completion:^{
         
         
         }];
         
         [weakSelf.alertController dismissViewControllerAnimated:YES completion:^{}];
         */
        [weakSelf startShowIndicatorAlert];
        
        TConsumption *db = [[TConsumption alloc] init];
        int insertedid = [db addConsumption:model];
        model.ID = [NSNumber numberWithInt:insertedid];
        
        [weakSelf assignAttribute:model];
        [weakSelf.section insertItem:model atIndex:0];
        [weakSelf.consumptions insertObject:model atIndex:0];
        [weakSelf.manager.tableView reloadData];
        
        [weakSelf hideIndicatorAlert];
        
    };
    [weakSelf.navigationController pushViewController:addcontroller animated:YES];
}
- (void) startShowIndicatorAlert {
    
    self.alertView = [[UIAlertView alloc] initWithTitle:@"请稍候..."
                                                message:nil
                                               delegate:self
                                      cancelButtonTitle:nil
                                      otherButtonTitles:nil, nil];
    [self.alertView show];
    
    UIActivityIndicatorView *aiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    aiv.center = CGPointMake(self.alertView.bounds.size.width/2.0f, self.alertView.bounds.size.height - 50.0f);
    [self.alertView addSubview:aiv];
    [aiv startAnimating];
    /*
     self.alertController = [UIAlertController alertControllerWithTitle:@"标题"
     message:@"这个是UIAlertController的默认样式"
     preferredStyle:UIAlertControllerStyleAlert];
     
     [self presentViewController:self.alertController
     animated:NO
     completion:^{
     
     }];
     */
    
}
- (void) hideIndicatorAlert{
    [self.alertView dismissWithClickedButtonIndex:0 animated:NO];
    //    [self.alertController dismissViewControllerAnimated:YES completion:^{}];
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
- (void) tableView:(UITableView *)tableView
   willDisplayCell:(UITableViewCell *)cell
 forRowAtIndexPath:(NSIndexPath *)indexPath {
    ConsumptionCell *ccCell = (ConsumptionCell *)cell;
    ConsumptionModel *currentModel = self.consumptions[indexPath.row];
    ccCell.money.textColor = [self getMoneyColorWithIsConsumption:currentModel.isConsumption];
}
- (NSString *) tableView:(UITableView *)tableView
titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

@end