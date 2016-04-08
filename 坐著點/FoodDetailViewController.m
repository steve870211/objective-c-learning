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

@interface FoodDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *ShopName;
@property (weak, nonatomic) IBOutlet UILabel *ShopID;
@property (weak, nonatomic) IBOutlet UILabel *FoodName;
@property (weak, nonatomic) IBOutlet UILabel *Price;
@property (weak, nonatomic) IBOutlet UIImageView *FoodPhoto;
@property (nonatomic) NSString *FoodID;

@end

@implementation FoodDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.ShopName.text = self.Foods.ShopName;
    self.ShopID.text = self.Foods.ShopID;
    self.FoodName.text = self.Foods.FoodName;
    self.Price.text = [NSString stringWithFormat:@"%@",self.Foods.Price];
    self.FoodID = self.Foods.FoodID;

    NSString *food = self.Foods.FoodPhotoName;
    food = [food stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *urlstr = [NSString stringWithFormat:@"http://localhost:8888/OrderEasy/MenuPhoto/%@",food];
    NSURL *url = [NSURL URLWithString:urlstr];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"error %@",error.description);
        } else {
            dispatch_async(dispatch_get_main_queue(),^{
                UIImage *image = [UIImage imageWithData:data];
                self.FoodPhoto.image = image;
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

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    
//}

- (IBAction)addToOrderBtnPressed:(id)sender {
    
    UIAlertController * alert = [UIAlertController
                                  alertControllerWithTitle:@"您要點幾份?"
                                  message:nil
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
       
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.placeholder = @"訂餐數量";
        
    }];
    
    UIAlertAction *addtoOrder = [UIAlertAction actionWithTitle:@"加入訂單" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UITextField *amountField = alert.textFields.firstObject;
        int amount;
        amount = [amountField.text intValue];
        int foodTotalPrice = amount*[_Foods.Price intValue];
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
        [self.car setObject:amountField.text forKey:@"amount"];
        [self.car setObject:FoodTotalPrice forKey:@"FoodTotalPrice"];
        
        Order *order = [Order sharedInstance];
        [order.AllOrder addObject:self.car];
        NSLog(@"AllOrder=%ld",order.AllOrder.count);

    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alert addAction:addtoOrder];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

@end













