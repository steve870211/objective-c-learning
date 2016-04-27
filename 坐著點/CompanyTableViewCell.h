//
//  CompanyTableViewCell.h
//  坐著點
//
//  Created by 許佳航 on 2016/4/25.
//  Copyright © 2016年 許佳航. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompanyTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *FoodName;
@property (weak, nonatomic) IBOutlet UILabel *Amount;
@property (weak, nonatomic) IBOutlet UILabel *Time;
@property (weak, nonatomic) IBOutlet UILabel *OrderID;
@property (weak, nonatomic) IBOutlet UILabel *Price;
@property (weak, nonatomic) IBOutlet UISegmentedControl *Segment;
@property (weak, nonatomic) NSString *situation;

@end
