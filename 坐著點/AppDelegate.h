//
//  AppDelegate.h
//  坐著點
//
//  Created by 許佳航 on 2016/3/8.
//  Copyright © 2016年 許佳航. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic) NSMutableDictionary *order;
@property (nonatomic) NSString *shopName;
@property (nonatomic) NSString *foodName;
@property (nonatomic) NSString *price;
@property (nonatomic) NSString *orderNumber;
@property (nonatomic) NSString *total;
@property (nonatomic) NSString *serialNumber;
@property (nonatomic) NSString *customerName;
@property (nonatomic) NSString *cellphoneNumber;;

@end

