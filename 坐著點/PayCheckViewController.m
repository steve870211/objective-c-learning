//
//  PayCheckViewController.m
//  坐著點
//
//  Created by 許佳航 on 2016/3/15.
//  Copyright © 2016年 許佳航. All rights reserved.
//

#import "PayCheckViewController.h"
#import "PayCheckTableViewCell.h"
#import "Order.h"
@import MMNumberKeyboard;

@interface PayCheckViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,MMNumberKeyboardDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *totalprice;
@property NSMutableArray *ordernumber;
@property int AllPrice;
@property (weak, nonatomic) IBOutlet UITextField *CustomerName;
@property (weak, nonatomic) IBOutlet UITextField *CustomerPhoneNumber;
@property (nonatomic) UITextField * editingTextField;
@property (nonatomic) int keyboardHeight;
@end

@implementation PayCheckViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    Order *order = [Order sharedInstance];
    self.ordernumber = [[NSMutableArray alloc]initWithArray:order.AllOrder];
//    NSLog(@"order.count=%ld",order.AllOrder.count);
    
    self.CustomerName.delegate = self;
    self.CustomerPhoneNumber.delegate = self;
    MMNumberKeyboard *keyboard = [[MMNumberKeyboard alloc] initWithFrame:CGRectZero];
    keyboard.allowsDecimalPoint = YES;
    keyboard.delegate = self;
    self.CustomerPhoneNumber.inputView = keyboard;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    for (int i=0; i<order.AllOrder.count; i++) {
        
        NSDictionary *total = order.AllOrder[i];
        int Total = [[total objectForKey:@"FoodTotalPrice"]intValue];
        self.AllPrice = self.AllPrice + Total;
        
    }
    
    self.totalprice.text = [NSString stringWithFormat:@"總金額:%d元",self.AllPrice];
    self.keyboardHeight = 0;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

//加入觀察，view自動往上code開始
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}
//解除觀察
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

//鍵盤出現/消失：調整view
- (void)keyboardWillShow:(NSNotification *)notification {
    
    NSDictionary* info = [notification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGPoint itemOrigin = [self.editingTextField convertPoint:self.editingTextField.frame.origin toView:self.view];
    CGFloat itemHeight = self.editingTextField.frame.size.height;
    CGRect visibleRect = self.view.bounds;
    visibleRect.size.height -= (keyboardSize.height+itemHeight);
    //BOOL tmp =CGRectContainsPoint(visibleRect, itemOrigin);
    
    //move up view if keyboard hide the textfield
    if (!CGRectContainsPoint(visibleRect, itemOrigin)){
        
        int iH = keyboardSize.height - self.keyboardHeight ;
        
        CGRect rect = self.view.frame;
        rect.origin.y = rect.origin.y - iH;
        [UIView animateWithDuration:1.0 animations:^{
            self.view.frame = rect ;
        }];
    }
    self.keyboardHeight = keyboardSize.height;
}
- (void)keyboardWillHide:(NSNotification *)notification {
    
    CGRect rect = self.view.frame;
    rect.origin.y= 0;
    [UIView animateWithDuration:1.0 animations:^{
        self.view.frame = rect;
    }];
    
    self.keyboardHeight = 0 ;
    
    
}

#pragma mark - textField Delegate
// 鍵盤按下return自動收起
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    self.editingTextField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
} // view自動往上code結束

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PayCheckTableViewCell *paycheckcell = [tableView dequeueReusableCellWithIdentifier:@"paycheckcell"forIndexPath:indexPath];
    
    Order *order = [Order sharedInstance];
    NSMutableDictionary *dictionary = order.AllOrder[indexPath.row];

    paycheckcell.orderShopname.text = [dictionary objectForKey:@"ShopName"];
    paycheckcell.serialNumber.text = [NSString stringWithFormat:@"店家編號:%@",[dictionary objectForKey:@"ShopID"]];
    paycheckcell.orderFoodname.text = [dictionary objectForKey:@"FoodName"];
    paycheckcell.orderFoodnumber.text = [NSString stringWithFormat:@"數量:%@",[dictionary objectForKey:@"amount"]];
    paycheckcell.orderFoodprice.text = [NSString stringWithFormat:@"金額:%@元",[dictionary objectForKey:@"FoodTotalPrice"]];
    
    int orderid = arc4random()%1000000;
    NSDateFormatter *dateFormatter =[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYYMMDDAAAAAAAA"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    NSLog(@"%@-%d",dateString,orderid);
    
    return paycheckcell;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.ordernumber.count;
    
}



@end











