//
//  OrderDetailCollectionViewCell.h
//  坐著點
//
//  Created by 許佳航 on 2016/4/14.
//  Copyright © 2016年 許佳航. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDetailCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *ShopName;
@property (weak, nonatomic) IBOutlet UILabel *FoodName;
@property (weak, nonatomic) IBOutlet UILabel *Number;
@property (weak, nonatomic) IBOutlet UILabel *TotalPrice;
@property (weak, nonatomic) IBOutlet UILabel *OrderID;

@end
