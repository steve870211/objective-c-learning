//
//  OrderDetailViewController.m
//  坐著點
//
//  Created by 許佳航 on 2016/4/12.
//  Copyright © 2016年 許佳航. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "OrderDetailCollectionViewCell.h"
#import "OrderDetail.h"
#import "Order.h"
#import "AppDelegate.h"
#import <AudioToolbox/AudioToolbox.h>
@import DGActivityIndicatorView;

@interface OrderDetailViewController ()
<
UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout
>
{
    
}

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic) NSMutableArray *myarr;
@property (nonatomic) NSMutableArray *orderarr;
@property DGActivityIndicatorView *dgActivity;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *LoginBtn;

@end

@implementation OrderDetailViewController

-(void)viewWillAppear:(BOOL)animated {
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    if (appDelegate.isLogined == true) {
        self.LoginBtn.title = [NSString stringWithFormat:@"登出"];
    } else {
        self.LoginBtn.title = [NSString stringWithFormat:@"登入"];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = [UIColor brownColor];
    [self the_reload_model];
    _orderarr = [NSMutableArray arrayWithArray:_myarr];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _orderarr = [[NSMutableArray alloc]init];
    
    // 讀取動畫開始
    self.dgActivity = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeNineDots tintColor:[UIColor whiteColor] size:45.0f];
    self.dgActivity.center = self.view.center;
    [self.view addSubview:self.dgActivity];
    [self.dgActivity startAnimating];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.orderarr.count;
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    OrderDetailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    OrderDetail *order = _orderarr[indexPath.row];
    
    cell.ShopName.text = [NSString stringWithFormat:@"店家：%@",order.shopname];
    cell.FoodName.text = [NSString stringWithFormat:@"品項：%@",order.foodname];
    cell.Number.text = [NSString stringWithFormat:@"數量：%@",order.number];
    cell.TotalPrice.text = [NSString stringWithFormat:@"金額：%@元",order.totalprice];
    cell.OrderID.text = [NSString stringWithFormat:@"訂單編號：%@",order.orderID];
    cell.ordertime.text = [NSString stringWithFormat:@"訂餐時間：%@",order.ordertime];
    
//    NSLog(@"orderID=%@",order.orderID);
//    NSLog(@"ordertime=%@",order.ordertime);
    
    return cell;
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake([[UIScreen mainScreen] bounds].size.width-30, 200);
}

// 與伺服器溝通
-(void)the_reload_model{
        
    NSURL *url = [NSURL URLWithString:@"http://scu-ordereasy.rhcloud.com/Order.php"];
    NSMutableURLRequest *request;
    request = [NSMutableURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession] ;
    NSURLSessionDataTask *dataTask;
    dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error == nil) {
            
            NSArray * arr = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            _myarr = [NSMutableArray arrayWithArray:arr];
                
            for (int i=0; i<_myarr.count; i++) {
                
                NSDictionary *book = _myarr[i];
                OrderDetail *orderdetail = [OrderDetail new];
                orderdetail.shopname = [NSString stringWithFormat:@"%@",book[@"shopName"]];
                orderdetail.foodname = [NSString stringWithFormat:@"%@",book[@"foodName"]];
                orderdetail.number = [NSString stringWithFormat:@"%@",book[@"orderNumber"]];
                orderdetail.totalprice = [NSString stringWithFormat:@"%@",book[@"total"]];
                orderdetail.orderID = [NSString stringWithFormat:@"%@",book[@"orderID"]];
                orderdetail.Account = [NSString stringWithFormat:@"%@",book[@"Account"]];
                orderdetail.ordertime = [NSString stringWithFormat:@"%@",book[@"ordertime"]];
                
                AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
                if ([appDelegate.Account isEqualToString:orderdetail.Account]) {
                    [_orderarr addObject:orderdetail];
                }
            }
            if (_orderarr.count != 0) {
                
                // 讀取動畫結束
                dispatch_async(dispatch_get_main_queue(),^{
                    [self.dgActivity stopAnimating];
                    [self.dgActivity removeFromSuperview];
                    [_collectionView reloadData];
                });
                
            } else {
                
                UIAlertController *alert;
                alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您沒有任何未出餐的訂單喔！" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction * alertAct;
                alertAct = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    [self.navigationController popViewControllerAnimated:YES];
                }];
                [alert addAction:alertAct];
                
                // 讀取動畫結束
                dispatch_async(dispatch_get_main_queue(),^{
                    [self.dgActivity stopAnimating];
                    [self.dgActivity removeFromSuperview];
                    [self presentViewController:alert animated:YES completion:nil];
                });
                
                

            }
            
        } else {

            UIAlertController *alert;
            alert = [UIAlertController new];
            UIAlertAction * alertAct;
            alertAct = [UIAlertAction actionWithTitle:@"請檢查網路狀況" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:alertAct];
            
            dispatch_async(dispatch_get_main_queue(),^{    
            //讀取動畫結束
            [self.dgActivity stopAnimating];
            [self.dgActivity removeFromSuperview];
            
            [self presentViewController:alert animated:true completion:nil];
            [self dismissViewControllerAnimated:true completion:nil];
            });

        }
    }];
    
    [dataTask resume];

}

- (IBAction)LoginBtnPress:(id)sender {
    
    SystemSoundID click;
    NSURL *sound = [[NSBundle mainBundle]URLForResource:@"locking_a_wooden_door1" withExtension:@"mp3"];
    AudioServicesCreateSystemSoundID((CFURLRef)CFBridgingRetain(sound),&click);
    AudioServicesPlaySystemSound(click);
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    if (appDelegate.isLogined == false) {
        UIViewController *LoginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
        [self presentViewController:LoginVC animated:true completion:nil];
    } else {
        [appDelegate logout];
        appDelegate.Account = @"";
        [self.LoginBtn setTitle:@"登入"];
    }
    
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end










