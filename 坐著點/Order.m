//
//  Order.m
//  坐著點
//
//  Created by 許佳航 on 2016/3/31.
//  Copyright © 2016年 許佳航. All rights reserved.
//

#import "Order.h"

@implementation Order

static Order *instance;

+(Order*)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[Order alloc]init];
        instance.AllOrder = [[NSMutableArray alloc]init];
    });
    return instance;
}

-(NSMutableArray*)setAllOrder{
    return _AllOrder;
}

@end
