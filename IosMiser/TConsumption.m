//
//  TConsumption.m
//  IosMiser
//
//  Created by 李峰艳 on 15/7/17.
//  Copyright (c) 2015年 李峰艳. All rights reserved.
//
#import "TConsumption.h"

@implementation TConsumption

static TConsumption *model;
static NSString *dbName = @"miser.sqlite";
static NSString *tableName = @"tconsumption";

+(id)shareConsumption{
    if (model==nil) {
        model= [[TConsumption alloc] init];
    }
    return model;
}

-(void)creatTableWithDataBaseName{
    NSString *sql = [NSString stringWithFormat:@"CREATE TABLE %@ (%@ INTEGER PRIMARY KEY AUTOINCREMENT,%@ TEXT,%@ NUMERIC,%@ REAL,%@ DATETIME DEFAULT CURRENT_TIMESTAMP)",
                     tableName,
                     @"ID",
                     @"title",
                     @"isConsumption",
                     @"money",
                     @"startDate"];

    [self createTable:sql dataBaseName:dbName];
}



-(BOOL)addConsumption:(ConsumptionModel*)consumptionModel {
    NSString *sql = [NSString stringWithFormat:@"insert into %@ (title,isConsumption,money,startDate) values (?,?,?,?)",
                     tableName];
//    NSNumber *isconsumption = [NSNumber numberWithInt:consumptionModel.isConsumption];
    NSArray *params = @[consumptionModel.title,
                      consumptionModel.isConsumption?@"1":@"0",
                      [NSString stringWithFormat:@"%i", [consumptionModel.money intValue]],
                      consumptionModel.startDate];
    return  [self execSql:sql parmas:params dataBaseName:dbName];
}

-(BOOL)addConsumptionByExample:(ConsumptionModel*)consumptionModel {
    NSString *sql = [NSString stringWithFormat:@"insert into %@ (ID, title,isConsumption,money,startDate) values (1,?,?,?,?)",
                     tableName];
//    NSNumber *isconsumption = [NSNumber numberWithInt:consumptionModel.isConsumption];
    NSArray *params = @[consumptionModel.title,
                        consumptionModel.isConsumption ? @"1" : @"0",
                        [NSString stringWithFormat:@"%i", [consumptionModel.money intValue]],
                        consumptionModel.startDate];
    return  [self execSql:sql parmas:params dataBaseName:dbName];
}

-(BOOL)updateConsumption:(ConsumptionModel*)consumptionModel {
    NSString *sql = [NSString stringWithFormat:@"update %@ set title=?,isConsumption=?,money=?,startDate=? where ID=?", tableName];
    NSArray *params=@[consumptionModel.title,
                      consumptionModel.isConsumption ? @"1" : @"0",
                      [NSString stringWithFormat:@"%i", [consumptionModel.money intValue]],
                      consumptionModel.startDate,
                      [NSString stringWithFormat:@"%i", [consumptionModel.ID intValue]]];
    
    return [self execSql:sql parmas:params dataBaseName:dbName];
}

-(NSMutableArray*)findAllConsumption {
    NSString *sql = [NSString stringWithFormat:@"select ID,title,isConsumption,money,startDate from %@", tableName];
    NSArray *result = [self selectSql:sql parmas:nil dataBaseName:dbName];
    NSMutableArray *consumptions=[NSMutableArray array];
    for (NSDictionary *dic in result) {
        ConsumptionModel *consumption = [[ConsumptionModel alloc] init];
        NSNumber *isconsumption = [dic objectForKey:@"isConsumption"];
        consumption.isConsumption = isconsumption.boolValue;
        consumption.title = [dic objectForKey:@"title"];
        consumption.money = [dic objectForKey:@"money"];
        consumption.startDate = [dic objectForKey:@"startDate"];
        consumption.ID = [dic objectForKey:@"ID"];
        [consumptions addObject:consumption];
    }
    
    return consumptions;
}

-(BOOL) deleteConsumption:(ConsumptionModel*)consumptionModel {
    NSString *sql = [NSString stringWithFormat:@"delete from %@ where ID =?", tableName];
    NSArray *params = @[ [NSString stringWithFormat:@"%i", [consumptionModel.ID intValue]]];
    return  [self execSql:sql parmas:params dataBaseName:dbName];
}

@end
