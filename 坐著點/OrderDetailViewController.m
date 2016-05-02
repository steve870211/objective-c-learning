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
    NSTimer *timer;
}

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic) NSMutableArray *myarr;
@property (nonatomic) NSMutableArray *orderarr;
@property DGActivityIndicatorView *dgActivity;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *LoginBtn;

@end

@implementation OrderDetailViewController

-(void)viewWillAppear:(BOOL)animated {
    
    [self isLogined];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = [UIColor brownColor];
    _orderarr = [NSMutableArray arrayWithArray:_myarr];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _orderarr = [[NSMutableArray alloc]init];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidDisappear:(BOOL)animated {
    [timer setFireDate:[NSDate distantFuture]];
}

#pragma mark Timer
-(void)initializeTimer {
    
    //設定Timer觸發的頻率，每30秒1次
    float theInterval = 5.0/1.0;
    
    //正式啟用Timer，selector是設定Timer觸發時所要呼叫的函式
    timer = [NSTimer scheduledTimerWithTimeInterval:theInterval
                                     target:self
                                   selector:@selector(the_reload_model)
                                   userInfo:nil
                                    repeats:YES];
    
}

#pragma mark TableView
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.orderarr.count;
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    OrderDetailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    OrderDetail *orderdetail = _orderarr[indexPath.row];
    
    cell.ShopName.text = [NSString stringWithFormat:@"店家：%@",orderdetail.shopname];
    cell.FoodName.text = [NSString stringWithFormat:@"品項：%@",orderdetail.foodname];
    cell.Number.text = [NSString stringWithFormat:@"數量：%@",orderdetail.number];
    cell.TotalPrice.text = [NSString stringWithFormat:@"金額：%@元",orderdetail.totalprice];
    cell.OrderID.text = [NSString stringWithFormat:@"訂單編號：%@",orderdetail.orderID];
    cell.ordertime.text = [NSString stringWithFormat:@"訂餐時間：%@",orderdetail.ordertime];
    
    cell.Situation.text = [NSString stringWithFormat:@"%@",orderdetail.Situation];
    if ([cell.Situation.text isEqualToString:@"請取餐"]) {
        cell.Situation.textColor = [UIColor redColor];
        cell.Situation.backgroundColor = [UIColor yellowColor];
    } else if ([cell.Situation.text isEqualToString:@"準備中"]) {
        cell.Situation.textColor = [UIColor whiteColor];
        cell.Situation.backgroundColor = [UIColor blackColor];
    } else {
        cell.Situation.textColor = [UIColor blackColor];
        cell.Situation.backgroundColor = [UIColor orangeColor];
    }
    
    return cell;
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake([[UIScreen mainScreen] bounds].size.width-30, 160);
}

#pragma mark Talk with PHP
// 與伺服器溝通
-(void)the_reload_model{
    
    // 讀取動畫開始
    dispatch_async(dispatch_get_main_queue(),^{
    self.dgActivity = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeTripleRings tintColor:[UIColor whiteColor] size:45.0f];
    self.dgActivity.center = self.view.center;
    [self.view addSubview:self.dgActivity];
    [self.dgActivity startAnimating];
    });
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    NSURL *url = [NSURL URLWithString:@"http://scu-ordereasy.rhcloud.com/Order.php"];
    // 讀取
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    request.HTTPMethod=@"POST";
    NSString *parameter=[NSString stringWithFormat:@"Account=%@",appDelegate.Account];
    NSData *body=[parameter dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody=body;
    
    NSURLSession *session = [NSURLSession sharedSession] ;
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error == nil) {
            
            NSArray * arr = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            _myarr = [NSMutableArray arrayWithArray:arr];
            [_orderarr removeAllObjects];
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
                orderdetail.Situation = [NSString stringWithFormat:@"%@",book[@"Situation"]];
                
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
                alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您沒有任何排隊中的餐點喔！" preferredStyle:UIAlertControllerStyleAlert];
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

#pragma mark LoginBtnPress
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
        [self.navigationController popViewControllerAnimated:true];
    }
    
}

#pragma mark Check isLogin?
- (void)isLogined {
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    if (appDelegate.isLogined == true) {
        self.LoginBtn.title = [NSString stringWithFormat:@"登出"];
        [self the_reload_model];
        [self initializeTimer];
        
    } else {
        self.LoginBtn.title = [NSString stringWithFormat:@"登入"];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"請先登入您的帳號" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"登入" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIViewController *LoginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
            [self.navigationController pushViewController:LoginVC animated:YES];
        }];
        UIAlertAction *back = [UIAlertAction actionWithTitle:@"上一頁" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:true];
        }];
        [alert addAction:back];
        [alert addAction:ok];
        [self presentViewController:alert animated:true completion:nil];
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










