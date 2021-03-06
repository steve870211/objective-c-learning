//
//  FoodDetailViewController.m
//  坐著點 商品詳細資料
//
//  Created by 許佳航 on 2016/3/24.
//  Copyright © 2016年 許佳航. All rights reserved.
//

#import "FoodDetailViewController.h"
#import "PayCheckViewController.h"
#import "Order.h"
#import "ViewController.h"
#import "AppDelegate.h"
#import <AudioToolbox/AudioToolbox.h>
@import DGActivityIndicatorView;
@import ASCFlatUIColor;
@import MMNumberKeyboard;

@interface FoodDetailViewController ()
<
UITextFieldDelegate,
MMNumberKeyboardDelegate
>
@property (weak, nonatomic) IBOutlet UILabel *ShopName;
@property (weak, nonatomic) IBOutlet UILabel *ShopID;
@property (weak, nonatomic) IBOutlet UILabel *FoodName;
@property (weak, nonatomic) IBOutlet UILabel *Price;
@property (weak, nonatomic) IBOutlet UIImageView *FoodPhoto;
@property (nonatomic) NSString *FoodID;
@property (nonatomic) BOOL all_or_amount;
@property DGActivityIndicatorView *dgActivity;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *LoginBtn;

@end

@implementation FoodDetailViewController

-(void)viewWillAppear:(BOOL)animated {
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    if (appDelegate.isLogined == true) {
        self.LoginBtn.title = [NSString stringWithFormat:@"登出"];
    } else {
        self.LoginBtn.title = [NSString stringWithFormat:@"登入"];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UIColor *color = [ASCFlatUIColor alizarinColor];
    
    // 讀取動畫
    self.dgActivity = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeLineScaleParty tintColor:color size:60.0f];
    self.dgActivity.center = self.view.center;
    [self.view addSubview:self.dgActivity];
    [self.dgActivity startAnimating]; // 轉轉轉開始！
    
    self.ShopName.text = self.Foods.ShopName;
    self.ShopID.text = self.Foods.ShopID;
    self.FoodName.text = self.Foods.FoodName;
    self.Price.text = [NSString stringWithFormat:@"%@元",self.Foods.Price];
    self.FoodID = self.Foods.FoodID;
    
    NSString *food = self.Foods.FoodPhotoName;
    food = [food stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *urlstr = [NSString stringWithFormat:@"http://scu-ordereasy.rhcloud.com/MenuPhoto/%@",food];
    NSURL *url = [NSURL URLWithString:urlstr];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"error %@",error.description);
        } else {
            dispatch_async(dispatch_get_main_queue(),^{
                UIImage *image = [UIImage imageWithData:data];
                self.FoodPhoto.image = image;
                [self.dgActivity stopAnimating]; // 轉轉轉結束！
                [self.dgActivity removeFromSuperview];
            });
        }
    }];
    [task resume];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:@"foodtoorderdetail"]) {
        
        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        [appDelegate prepareSound:@"burp1"];
        
    }
    if ([segue.identifier isEqualToString:@"foodtopay"]) {
        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        [appDelegate prepareSound:@"click"];
    }
    
}

- (IBAction)addToOrderBtnPressed:(id)sender {
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate prepareSound:@"click"];
    
    UIAlertController * alert = [UIAlertController
                                  alertControllerWithTitle:@"要幾個?"
                                  message:nil
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {

        MMNumberKeyboard *keyboard = [[MMNumberKeyboard alloc] initWithFrame:CGRectZero];
        keyboard.allowsDecimalPoint = YES;
        keyboard.delegate = self;
        textField.inputView = keyboard;
        textField.placeholder = @"訂餐數量";
        
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *addtoOrder = [UIAlertAction actionWithTitle:@"加入購物車" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UITextField *amountField = alert.textFields.firstObject;
        
        int amount;
        amount = [amountField.text intValue];
        NSString *amountstr = [NSString stringWithFormat:@"%d",amount];
        int foodTotalPrice = amount*[_Foods.Price intValue];
//        NSString *foodid = self.Foods.FoodID;
        Order *order = [Order sharedInstance];
        self.all_or_amount = false;

        if (amount < 1 || amount > 99) {
            
            UIAlertController *alert = [UIAlertController
                                        alertControllerWithTitle:@"錯誤"
                                        message:@"訂購數量不得少於1或多餘99"
                                        preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *alertAction = [UIAlertAction
                                          actionWithTitle:@"OK!"
                                          style:UIAlertActionStyleDefault
                                          handler:nil];
            [alert addAction:alertAction];
            [self presentViewController:alert animated:YES completion:nil];
            
        } else {
            
            NSString *FoodTotalPrice = [NSString stringWithFormat:@"%d",foodTotalPrice];
            NSString *shopid = [NSString stringWithFormat:@"%@",self.Foods.ShopID];
            NSString *shopname = [NSString stringWithFormat:@"%@",self.Foods.ShopName];
            NSString *foodid = [NSString stringWithFormat:@"%@",self.Foods.FoodID];
            NSString *foodname = [NSString stringWithFormat:@"%@",self.Foods.FoodName];
            NSString *price = [NSString stringWithFormat:@"%@",self.Foods.Price];
            
            self.car = [NSMutableDictionary new];
            [self.car setObject:shopid forKeyedSubscript:@"ShopID"];
            [self.car setObject:shopname forKeyedSubscript:@"ShopName"];
            [self.car setObject:foodid forKeyedSubscript:@"FoodID"];
            [self.car setObject:foodname forKeyedSubscript:@"FoodName"];
            [self.car setObject:price forKey:@"Price"];
            [self.car setObject:amountstr forKey:@"amount"];
            [self.car setObject:FoodTotalPrice forKey:@"FoodTotalPrice"];
            
            if (order.AllOrder.count != 0) {
                
                for (int i=0; i<order.AllOrder.count; i++) {
                    
                    NSDictionary *dictionary = order.AllOrder[i];
                    
                    if ([[dictionary objectForKey:@"FoodID"] isEqualToString:foodid]) {
                        
                        int number = [[dictionary objectForKey:@"amount"]intValue];
                        number = amount+number;
                        [dictionary setValue:[NSString stringWithFormat:@"%d",number] forKey:@"amount"];
                        [dictionary setValue:[NSString stringWithFormat:@"%d",number * [self.Price.text intValue]] forKey:@"FoodTotalPrice"];
                        self.all_or_amount = true;
                        break;
                        
                    }
                }
                if (self.all_or_amount == false) {
                    
                    [order.AllOrder addObject:self.car];
                    self.all_or_amount = true;
                    
                }
            } else if(self.all_or_amount == false){
                
                [order.AllOrder addObject:self.car];
                
            }
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Success" message:[NSString stringWithFormat:@"完成，您已將%d個%@加入了購物車",amount,foodname] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [alert addAction:ok];
            [self presentViewController:alert animated:true completion:nil];
        }
    }];
    
    [alert addAction:cancel];
    [alert addAction:addtoOrder];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (IBAction)LoginBtnPress:(id)sender {
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    [appDelegate prepareSound:@"locking_a_wooden_door1"];
    
    if (appDelegate.isLogined == false) {
        UIViewController *LoginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
        [self.navigationController pushViewController:LoginVC animated:true];
    } else {
        [appDelegate logout];
        appDelegate.Account = @"";
        [self.LoginBtn setTitle:@"登入"];
    }
    
}


@end













