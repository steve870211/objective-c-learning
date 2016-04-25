//
//  CompanyViewController.m
//  坐著點
//
//  Created by 許佳航 on 2016/4/25.
//  Copyright © 2016年 許佳航. All rights reserved.
//

#import "CompanyViewController.h"
#import "CompanyTableViewCell.h"
#import "OrderDetail.h"
#import "AppDelegate.h"
@import DGActivityIndicatorView;

@interface CompanyViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic) NSMutableArray *myarr;
@property (nonatomic) NSMutableArray *orderarr;
@property (nonatomic) DGActivityIndicatorView *dgActivity;

@end

@implementation CompanyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self the_reload_model];
    
    _orderarr = [[NSMutableArray alloc]init];
    
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    
    self.dgActivity = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeBallScaleRippleMultiple tintColor:[UIColor blackColor] size:45.0f];
    self.dgActivity.center = CGPointMake([[UIScreen mainScreen]bounds].size.width/2, [[UIScreen mainScreen]bounds].size.height/2);
    [self.view addSubview:self.dgActivity];
    [self.dgActivity startAnimating]; // 轉轉轉開始！
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark tableview delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.orderarr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CompanyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    OrderDetail *order = self.orderarr[indexPath.row];
    
    cell.FoodName.text = [NSString stringWithFormat:@"%@",order.foodname];
    cell.Amount.text = [NSString stringWithFormat:@"%@個",order.number];
    cell.Price.text = [NSString stringWithFormat:@"共%@元",order.totalprice];
    cell.OrderID.text = [NSString stringWithFormat:@"ID:%@",order.orderID];
    cell.Time.text = [NSString stringWithFormat:@"%@",order.ordertime];
    
    return cell;
}

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
                if ([appDelegate.userName isEqualToString:orderdetail.shopname]) {
                    [_orderarr addObject:orderdetail];
                }
            }
            if (_orderarr.count != 0) {
                
                // 讀取動畫結束
                dispatch_async(dispatch_get_main_queue(),^{
                    [self.dgActivity stopAnimating];
                    [self.dgActivity removeFromSuperview];
                    [self.tableview reloadData];
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
