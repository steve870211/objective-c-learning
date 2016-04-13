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

// addToOrder
@property NSString *parameter;
@property NSString *TrueParameter;
@property int i;
@property NSString *orderID;
@property int shopID;
@property int foodID;
@property int orderNumber;
@property int total;
@property NSString *thecustomerName;
@property NSString *thecellphoneNumber;

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
    
    return paycheckcell;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.ordernumber.count;
    
}

// add order to MAMP
- (IBAction)addToOrder:(id)sender {
    
    Order *order = [Order sharedInstance];
    if (order.AllOrder.count == 0) {
        UIAlertController *ordernothing = [UIAlertController alertControllerWithTitle:@"Error!" message:@"You have not ordered anything yet." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Go shopping" style:UIAlertActionStyleCancel handler:nil];
        [ordernothing addAction:ok];
        [self presentViewController:ordernothing animated:YES completion:nil];
    } else if ([self.CustomerName.text isEqualToString:@""]) {
        UIAlertController *noName = [UIAlertController alertControllerWithTitle:@"Error!" message:@"You must type your name before you send the order." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [noName addAction:ok];
        [self presentViewController:noName animated:YES completion:nil];
    } else if([self.CustomerPhoneNumber.text isEqualToString:@""]){
        UIAlertController *noPhoneNumber = [UIAlertController alertControllerWithTitle:@"Error!" message:@"You must type your cell phone number before you send the order." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [noPhoneNumber addAction:ok];
        [self presentViewController:noPhoneNumber animated:YES completion:nil];
    } else {
        // 確認是否送出訂單
        UIAlertController *check = [UIAlertController alertControllerWithTitle:@"Check" message:@"Do you want to order these foods?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *yes = [UIAlertAction actionWithTitle:@"YES!" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            int idnumber = arc4random()%1000000;
            NSDateFormatter *dateFormatter =[[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"YYYYMMDDAAAAAAAA"];
            NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
            self.orderID = [NSString stringWithFormat:@"%@%d",dateString,idnumber];
            self.thecustomerName = self.CustomerName.text;
            self.thecellphoneNumber = self.CustomerPhoneNumber.text;
            
//            for (int i=0; i<order.AllOrder.count; i++) {
//                NSDictionary *dictionary = order.AllOrder[i];
//                self.shopID = [[dictionary objectForKey:@"ShopID"]intValue];
//                self.foodID = [[dictionary objectForKey:@"FoodID"]intValue];
//                self.orderNumber = [[dictionary objectForKey:@"amount"]intValue];
//                self.total = [[dictionary objectForKey:@"FoodTotalPrice"]intValue];
//                
//                self.parameter = [NSString stringWithFormat:@"orderID%d=%@&shopID%d=%d&foodID%d=%d&orderNumber%d=%d&total%d=%d&customerName%d=%@&cellphoneNumber%d=%@",i,self.orderID,i,self.shopID,i,self.foodID,i,self.orderNumber,i,self.total,i,self.thecustomerName,i,self.thecellphoneNumber];
//                
//                [self addOrderDetail];
//            }
            
            [self addOrderDetail];
            // 成功送出訂單
//            UIAlertController *done = [UIAlertController alertControllerWithTitle:@"Success!" message:@"Thanks for your ordered. We will present the foods as soon as posible." preferredStyle:UIAlertControllerStyleAlert];
//            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
//            [done addAction:ok];
//            [self presentViewController:done animated:YES completion:nil];
        }];
        UIAlertAction *no = [UIAlertAction actionWithTitle:@"NO!" style:UIAlertActionStyleCancel handler:nil];
        [check addAction:yes];
        [check addAction:no];
        [self presentViewController:check animated:YES completion:nil];
    }
}

- (void)addOrderDetail{
    
    Order *order = [Order sharedInstance];
    NSURL *url=[NSURL URLWithString:@"http://scu-ordereasy.rhcloud.com/orderadd.php"];
//    NSURL *url=[NSURL URLWithString:@"http://localhost:8888/OrderEasy/orderadd.php"];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod=@"POST";
    self.TrueParameter = [NSString stringWithFormat:@"count=%lu&orderID=%@&customerName=%@&cellphoneNumber=%@",order.AllOrder.count, self.orderID, self.thecustomerName,self.thecellphoneNumber];
    
    for (int i = 0; i < order.AllOrder.count; i++) {
        NSDictionary *dictionary = order.AllOrder[i];
        self.shopID = [[dictionary objectForKey:@"ShopID"]intValue];
        self.foodID = [[dictionary objectForKey:@"FoodID"]intValue];
        self.orderNumber = [[dictionary objectForKey:@"amount"]intValue];
        self.total = [[dictionary objectForKey:@"FoodTotalPrice"]intValue];
        
        self.TrueParameter = [self.TrueParameter stringByAppendingString:[NSString stringWithFormat:@"&shopID%d=%d&foodID%d=%d&orderNumber%d=%d&total%d=%d", i, self.shopID, i, self.foodID, i, self.orderNumber, i, self.total]]  ;
    }
    NSLog(@"TrueParameter=%@",self.TrueParameter);
    
    NSData *body=[self.TrueParameter dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody=body;
    
    NSURLSession *session=[NSURLSession sharedSession];
    NSURLSessionTask *task=[session dataTaskWithRequest:request completionHandler:^(NSData *  data, NSURLResponse *  response, NSError *  error) {
        if (error != nil){
            
            dispatch_async(dispatch_get_main_queue(),^{
                UIAlertController *Error = [UIAlertController alertControllerWithTitle:@"Error!" message:@"訂單傳送失敗，請確認您的網路狀況是否正常。" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
                [Error addAction:cancel];
            });
        } else {
            NSString *returndata = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"%@",returndata);
        }
    }];
    [task resume];
}

@end











