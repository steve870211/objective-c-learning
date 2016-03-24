//  TheTableViewCell.h
//  坐著點
//  客製化cell的class
//  Created by 許佳航 on 2016/3/14.
//  Copyright © 2016年 許佳航. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Note.h"

@interface TheTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *foodphoto;
@property (weak, nonatomic) IBOutlet UILabel *foodname;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) Note *note ;

@end
