//
//  FoodDetailViewController.h
//  坐著點
//
//  Created by 許佳航 on 2016/3/24.
//  Copyright © 2016年 許佳航. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Note.h"

@interface FoodDetailViewController : UIViewController

@property (nonatomic) Note *Foods;
@property (nonatomic) NSMutableDictionary *car ; // 用來接訂單資料 用segue傳給paycheck

@end
