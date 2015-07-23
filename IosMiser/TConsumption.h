//
//  TConsumption.h
//  IosMiser
//
//  Created by 李峰艳 on 15/7/17.
//  Copyright (c) 2015年 李峰艳. All rights reserved.
//

#import "BaseDB.h"
#import "ConsumptionModel.h"

@interface TConsumption : BaseDB{
    
}

+(id)shareConsumption;

-(void)creatTableWithDataBaseName;

-(int)addConsumption:(ConsumptionModel*)consumptionModel;

-(BOOL)addConsumptionByExample:(ConsumptionModel*)consumptionModel;

-(BOOL)updateConsumption:(ConsumptionModel*)consumptionModel;

-(NSMutableArray*)findAllConsumption;

-(BOOL) deleteConsumption:(ConsumptionModel*)consumptionModel;

@end
