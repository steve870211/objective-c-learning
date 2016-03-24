//
//  Note.h
//  坐著點
//
//  Created by 許佳航 on 2016/3/10.
//  Copyright © 2016年 許佳航. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@interface Note : NSObject

@property (nonatomic) NSString *ShopID;
@property (nonatomic) NSString *ShopName;
@property (nonatomic) NSString *FoodName;
@property (nonatomic) NSString *Price;
@property (nonatomic) NSNumber *Number;
@property (nonatomic) UIImage *FoodPhoto;
@property (nonatomic) UIImage *ShopImage;
@property (nonatomic) NSString *FoodPhotoName;

@end
