//
//  CompanyTableViewCell.m
//  坐著點
//
//  Created by 許佳航 on 2016/4/25.
//  Copyright © 2016年 許佳航. All rights reserved.
//

#import "CompanyTableViewCell.h"
#import "AppDelegate.h"
#import "CompanyViewController.h"

@implementation CompanyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)ValueChange:(id)sender {
    
    CompanyViewController *comVC = [[CompanyViewController alloc]init];
    
    switch (self.Segment.selectedSegmentIndex) {
        case 0:
            self.situation = [NSString stringWithFormat:@"Situation=準備中&%@&foodName=%@",_OrderID.text,_FoodName.text];
            //            NSLog(@"%@",_situation);
            [comVC OrderSituationChange:_situation];
            break;
        case 1:
            self.situation = [NSString stringWithFormat:@"Situation=烹飪中&%@&foodName=%@",_OrderID.text,_FoodName.text];
            [comVC OrderSituationChange:_situation];
            break;
        case 2:
            self.situation = [NSString stringWithFormat:@"Situation=請取餐&%@&foodName=%@",_OrderID.text,_FoodName.text];
//            NSLog(@"%@",_situation);
            [comVC OrderSituationChange:_situation];
        default:
            break;
    }
    
}



@end
