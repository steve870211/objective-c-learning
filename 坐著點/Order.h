//
//  Order.h
//  坐著點
//
//  Created by 許佳航 on 2016/3/31.
//  Copyright © 2016年 許佳航. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Order : NSObject
{
    
}
@property NSMutableArray *AllOrder;
+(Order*)sharedInstance;
-(NSMutableArray*)setAllOrder;
@end
