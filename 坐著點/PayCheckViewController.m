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
#import "OrderDetail.h"
#import "AppDelegate.h"
#import "ShopsViewController.h"
#import "OrderDetailViewController.h"
#import <AudioToolbox/AudioToolbox.h>
@import MMNumberKeyboard;

@interface PayCheckViewController ()
<
UITableViewDataSource,
UITableViewDelegate,
UITextFieldDelegate,
MMNumberKeyboardDelegate
>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *totalprice;
@property NSMutableArray *ordernumber;
@property int AllPrice;
//@property (weak, nonatomic) IBOutlet UITextField *CustomerName;
//@property (weak, nonatomic) IBOutlet UITextField *CustomerPhoneNumber;
@property (nonatomic) UITextField * editingTextField;
@property (nonatomic) int keyboardHeight;

// addToOrder
@property NSString *parameter;
@property NSString *TrueParameter;
@property int i;
@property NSString *ordertime;
@property NSString *orderID;
@property int shopID;
@property NSString *shopName;
@property int foodID;
@property NSString *foodName;
@property int orderNumber;
@property int total;
@property NSString *thecustomerName;
@property NSString *thecellphoneNumber;
@property NSString *theEmail;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *LoginBtn;
@property (weak, nonatomic) IBOutlet UILabel *orderuserName;
@property (weak, nonatomic) IBOutlet UILabel *orderuserPhone;
@property (weak, nonatomic) IBOutlet UILabel *orderuserEmail;



@end

@implementation PayCheckViewController

-(void)viewWillAppear:(BOOL)animated {
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    if (appDelegate.isLogined == true) {
        self.LoginBtn.title = [NSString stringWithFormat:@"登出"];
        [self.orderuserName setText:[NSString stringWithFormat:@"姓名：%@",appDelegate.userName]];
        [self.orderuserPhone setText:[NSString stringWithFormat:@"電話：%@",appDelegate.userPhone]];
        [self.orderuserEmail setText:[NSString stringWithFormat:@"信箱：%@",appDelegate.userEmail]];

    } else {
        self.LoginBtn.title = [NSString stringWithFormat:@"登入"];
        [self.orderuserName setText:[NSString stringWithFormat:@""]];
        [self.orderuserPhone setText:[NSString stringWithFormat:@""]];
        [self.orderuserEmail setText:[NSString stringWithFormat:@""]];

    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Order *order = [Order sharedInstance];
    self.ordernumber = [[NSMutableArray alloc]initWithArray:order.AllOrder];
    //    NSLog(@"order.count=%ld",order.AllOrder.count);
    
//    self.CustomerName.delegate = self;
//    self.CustomerPhoneNumber.delegate = self;
    
//    MMNumberKeyboard *keyboard = [[MMNumberKeyboard alloc] initWithFrame:CGRectZero];
//    keyboard.allowsDecimalPoint = YES;
//    keyboard.delegate = self;
//    self.CustomerPhoneNumber.inputView = keyboard;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    for (int i=0; i<order.AllOrder.count; i++) {
        
        NSDictionary *total = order.AllOrder[i];
        int Total = [[total objectForKey:@"FoodTotalPrice"]intValue];
        self.AllPrice = self.AllPrice + Total;
        
    }
    
    self.totalprice.text = [NSString stringWithFormat:@"總金額:%d元",self.AllPrice];
//    self.keyboardHeight = 0;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

//加入觀察，view自動往上code開始
//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    // register for keyboard notifications
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillShow:)
//                                                 name:UIKeyboardWillShowNotification
//                                               object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillHide:)
//                                                 name:UIKeyboardWillHideNotification
//                                               object:nil];
//}
//解除觀察
//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    // unregister for keyboard notifications while not visible.
//    [[NSNotificationCenter defaultCenter] removeObserver:self
//                                                    name:UIKeyboardWillShowNotification
//                                                  object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self
//                                                    name:UIKeyboardWillHideNotification
//                                                  object:nil];
//}

//鍵盤出現/消失：調整view
//- (void)keyboardWillShow:(NSNotification *)notification {
//    
//    NSDictionary* info = [notification userInfo];
//    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
//    CGPoint itemOrigin = [self.editingTextField convertPoint:self.editingTextField.frame.origin toView:self.view];
//    CGFloat itemHeight = self.editingTextField.frame.size.height;
//    CGRect visibleRect = self.view.bounds;
//    visibleRect.size.height -= (keyboardSize.height+itemHeight);
//    //BOOL tmp =CGRectContainsPoint(visibleRect, itemOrigin);
//    
//    //move up view if keyboard hide the textfield
//    if (!CGRectContainsPoint(visibleRect, itemOrigin)){
//        
//        int iH = keyboardSize.height - self.keyboardHeight ;
//        
//        CGRect rect = self.view.frame;
//        rect.origin.y = rect.origin.y - iH;
//        [UIView animateWithDuration:1.0 animations:^{
//            self.view.frame = rect ;
//        }];
//    }
//    self.keyboardHeight = keyboardSize.height;
//}
//- (void)keyboardWillHide:(NSNotification *)notification {
//    
//    CGRect rect = self.view.frame;
//    rect.origin.y= 0;
//    [UIView animateWithDuration:1.0 animations:^{
//        self.view.frame = rect;
//    }];
//    
//    self.keyboardHeight = 0 ;
//    
//    
//}
//
//#pragma mark - textField Delegate
// 鍵盤按下return自動收起
//- (BOOL)textFieldShouldReturn:(UITextField *)textField{
//    [textField resignFirstResponder];
//    return YES;
//}
//
//- (void)textFieldDidBeginEditing:(UITextField *)textField{
//    self.editingTextField = textField;
//}
//
//- (void)textFieldDidEndEditing:(UITextField *)textField {
//    [textField resignFirstResponder];
//} view自動往上code結束

#pragma mark tableview
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
    
    Order *order = [Order sharedInstance];
    self.ordernumber = [[NSMutableArray alloc]initWithArray:order.AllOrder];
    return self.ordernumber.count;
    
}

#pragma mark 送出訂單
// add order to MySQL
- (IBAction)addToOrder:(id)sender {
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    Order *order = [Order sharedInstance];
    [appDelegate prepareSound:@"click"];
    // 購物車為空
    if (order.AllOrder.count == 0) {
        UIAlertController *ordernothing = [UIAlertController alertControllerWithTitle:@"Error!" message:@"您沒有訂購任何餐點" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Go shopping" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            dispatch_async(dispatch_get_main_queue(),^{
                [self dismissViewControllerAnimated:true completion:nil];
                //UIViewController *shopsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"shopsVC"];
                //[self presentViewController:shopsVC animated:true completion:nil];
                
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
        }];
        [ordernothing addAction:ok];
        [self presentViewController:ordernothing animated:YES completion:nil];
        
    } else if (appDelegate.isLogined == false) {
        dispatch_async(dispatch_get_main_queue(),^{
            UIViewController *LoginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
            [self dismissViewControllerAnimated:YES completion:nil];
            [self presentViewController:LoginVC animated:true completion:nil];
        });
        
    } else {
        // 確認是否送出訂單
        UIAlertController *check = [UIAlertController alertControllerWithTitle:@"Check" message:@"您確定要訂購這些餐點嗎？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *yes = [UIAlertAction actionWithTitle:@"YES!" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            int idnumber = arc4random()%10000000000;
            NSDateFormatter *dateFormatter =[[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"YYYY/MM/dd_HH:mm:ss"];
            NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
            if (idnumber<0) {
                idnumber = idnumber*-1;
            }
            
            AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
            self.orderID = [NSString stringWithFormat:@"%d",idnumber];
            self.ordertime = [NSString stringWithFormat:@"%@",dateString];
            self.thecustomerName = appDelegate.userName;
            self.thecellphoneNumber = appDelegate.userPhone;
            self.theEmail = appDelegate.userEmail;
            
            [self addOrderDetail];
        }];
        UIAlertAction *no = [UIAlertAction actionWithTitle:@"NO!" style:UIAlertActionStyleCancel handler:nil];
        [check addAction:yes];
        [check addAction:no];
        [self presentViewController:check animated:YES completion:nil];
    }
}

- (void)addOrderDetail{
    
    Order *order = [Order sharedInstance];
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    NSURL *url=[NSURL URLWithString:@"http://scu-ordereasy.rhcloud.com/orderadd.php"];
//    NSURL *url=[NSURL URLWithString:@"http://localhost:8888/OrderEasy/orderadd.php"];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod=@"POST";
    self.TrueParameter = [NSString stringWithFormat:@"count=%lu&orderID=%@&customerName=%@&cellphoneNumber=%@&ordertime=%@&userEmail=%@&Account=%@",order.AllOrder.count, self.orderID, self.thecustomerName,self.thecellphoneNumber,self.ordertime,self.theEmail,appDelegate.Account];
    
    for (int i = 0; i < order.AllOrder.count; i++) {
        NSDictionary *dictionary = order.AllOrder[i];
        self.shopID = [[dictionary objectForKey:@"ShopID"]intValue];
        self.shopName = [dictionary objectForKey:@"ShopName"];
        self.foodID = [[dictionary objectForKey:@"FoodID"]intValue];
        self.foodName = [dictionary objectForKey:@"FoodName"];
        self.orderNumber = [[dictionary objectForKey:@"amount"]intValue];
        self.total = [[dictionary objectForKey:@"FoodTotalPrice"]intValue];
        
        self.TrueParameter = [self.TrueParameter stringByAppendingString:[NSString stringWithFormat:@"&shopID%d=%d&foodID%d=%d&orderNumber%d=%d&total%d=%d&shopName%d=%@&foodName%d=%@", i, self.shopID, i, self.foodID, i, self.orderNumber, i, self.total, i, self.shopName, i, self.foodName]]  ;
    }
    
//    NSLog(@"TrueParameter=%@",self.TrueParameter);
    
    NSData *body=[self.TrueParameter dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody=body;
    
    NSURLSession *session=[NSURLSession sharedSession];
    NSURLSessionTask *task=[session dataTaskWithRequest:request completionHandler:^(NSData *  data, NSURLResponse *  response, NSError *  error) {
    
        // 如果收到PHP回傳的物件
        if (data != nil) {
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSString *returndata = [dic objectForKey:@"status"];
            // 如果字串顯示傳送成功
            if ([returndata  isEqual: @"Success!"]){
                
                dispatch_async(dispatch_get_main_queue(),^{
                    UIAlertController *success = [UIAlertController alertControllerWithTitle:@"訂餐成功" message:@"感謝您的訂餐！" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
                    [success addAction:ok];
                    [self presentViewController:success animated:YES completion:nil];
                    [order.AllOrder removeAllObjects];
                    self.totalprice.text = [NSString stringWithFormat:@"總金額：0元"];
                    [self.tableView reloadData];
                    });
                
                SystemSoundID click;
                NSURL *sound = [[NSBundle mainBundle]URLForResource:@"bicycle_bell" withExtension:@"mp3"];
                AudioServicesCreateSystemSoundID((CFURLRef)CFBridgingRetain(sound),&click);
                AudioServicesPlaySystemSound(click);
                
                // 如果字串顯示傳送失敗
            } else {
                dispatch_async(dispatch_get_main_queue(),^{
                    UIAlertController *Error = [UIAlertController alertControllerWithTitle:@"訂單傳送失敗" message:@"伺服器發生錯誤！。" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
                    [Error addAction:cancel];
                    [self presentViewController:Error animated:YES completion:nil];
                });
            }
            // 如果沒有收到PHP回傳的物件
        } else {
            dispatch_async(dispatch_get_main_queue(),^{
                UIAlertController *Error = [UIAlertController alertControllerWithTitle:@"訂單傳送失敗" message:@"請確認您的網路狀況是否正常。" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
                [Error addAction:cancel];
                [self presentViewController:Error animated:YES completion:nil];
            });
        }
        
    }];
    [task resume];
}

#pragma mark 刪除cell
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle ==UITableViewCellEditingStyleDelete) {//如果编辑样式为删除样式
        Order *order = [Order sharedInstance];
        if (indexPath.row<[order.AllOrder count]) {
            [order.AllOrder removeObjectAtIndex:indexPath.row];//移除数据源的数据
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];//移除tableView中的数据
            
            SystemSoundID click;
            NSURL *sound = [[NSBundle mainBundle]URLForResource:@"blip2" withExtension:@"mp3"];
            AudioServicesCreateSystemSoundID((CFURLRef)CFBridgingRetain(sound),&click);
            AudioServicesPlaySystemSound(click);
        }
    }
    
}

#pragma mark 登入/登出
- (IBAction)LoginBtnPress:(id)sender {
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    [appDelegate prepareSound:@"locking_a_wooden_door1"];
    
    if (appDelegate.isLogined == false) {
        UIViewController *LoginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
        [self presentViewController:LoginVC animated:true completion:nil];
    } else {
        [appDelegate logout];
        appDelegate.Account = @"";
        [self.LoginBtn setTitle:@"登入"];
    }
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    if ([segue.identifier isEqualToString:@"paychecktoorderdetail"]) {
        [appDelegate prepareSound:@"locking_a_wooden_door1"];
    }
    
}


@end











