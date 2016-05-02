//
//  ShopsTableViewCell.h
//  坐著點
//
//  Created by 許佳航 on 2016/3/23.
//  Copyright © 2016年 許佳航. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Note.h"

@interface ShopsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *ShopsImage;
@property (weak, nonatomic) IBOutlet UILabel *ShopID;
@property (weak, nonatomic) IBOutlet UILabel *ShopName;
@property (weak, nonatomic) IBOutlet UILabel *orderNumber;

@property (nonatomic) Note *note;

@end
