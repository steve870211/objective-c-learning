//
//  PayCheckTableViewCell.h
//  坐著點
//
//  Created by 許佳航 on 2016/3/15.
//  Copyright © 2016年 許佳航. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayCheckTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *orderShopname;
@property (weak, nonatomic) IBOutlet UILabel *orderFoodname;
@property (weak, nonatomic) IBOutlet UILabel *orderFoodnumber;
@property (weak, nonatomic) IBOutlet UILabel *orderFoodprice;


@end
