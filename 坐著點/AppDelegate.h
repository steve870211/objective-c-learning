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

@property NSString * userName;
@property NSString * userPhone;
@property NSString * userEmail;
@property NSString * userType;

-(BOOL) isLogined;
-(void) login;
-(void) logout;

@end

