//
//  PayCheckTableViewCell.m
//  坐著點
//
//  Created by 許佳航 on 2016/3/15.
//  Copyright © 2016年 許佳航. All rights reserved.
//

#import "PayCheckTableViewCell.h"
@import MMNumberKeyboard;

@interface PayCheckTableViewCell()
<
UITextFieldDelegate,
MMNumberKeyboardDelegate
>

@end

@implementation PayCheckTableViewCell

- (void)awakeFromNib {
    // Initialization code
    MMNumberKeyboard *keyboard = [[MMNumberKeyboard alloc] initWithFrame:CGRectZero];
    keyboard.allowsDecimalPoint = YES;
    keyboard.delegate = self;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - textField Delegate
// 鍵盤按下return自動收起
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
} // view自動往上code結束

@end
