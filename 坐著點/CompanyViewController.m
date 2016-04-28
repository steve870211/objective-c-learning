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
@property NSString *TrueParameter;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *LoginBtn;


@end

@implementation CompanyViewController

-(void)viewWillAppear:(BOOL)animated {
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    if (appDelegate.isLogined == true) {
        self.LoginBtn.title = [NSString stringWithFormat:@"登出"];
    } else {
        self.LoginBtn.title = [NSString stringWithFormat:@"登入"];
    }

    [self initializeTimer];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [self the_reload_model];
    self.navigationItem.title = appDelegate.userName;
    _orderarr = [[NSMutableArray alloc]init];
    
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Timer
-(void)initializeTimer {
    
    //設定Timer觸發的頻率，每30秒1次
    float theInterval = 10.0/1.0;
    
    //正式啟用Timer，selector是設定Timer觸發時所要呼叫的函式
    [NSTimer scheduledTimerWithTimeInterval:theInterval
                                     target:self
                                   selector:@selector(viewDidLoad)
                                   userInfo:nil
                                    repeats:YES];
}

#pragma mark tableview delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.orderarr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CompanyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"forIndexPath:indexPath];
    OrderDetail *orderdetail = self.orderarr[indexPath.row];
    
    cell.FoodName.text = [NSString stringWithFormat:@"%@",orderdetail.foodname];
    cell.Amount.text = [NSString stringWithFormat:@"%@個",orderdetail.number];
    cell.Price.text = [NSString stringWithFormat:@"共%@元",orderdetail.totalprice];
    cell.OrderID.text = [NSString stringWithFormat:@"orderID=%@",orderdetail.orderID];
    cell.Time.text = [NSString stringWithFormat:@"%@",orderdetail.ordertime];
    
    if ([orderdetail.Situation isEqualToString:@"準備中"]) {
        cell.Segment.selectedSegmentIndex = 0;
    } else if ([orderdetail.Situation isEqualToString:@"烹飪中"]) {
        cell.Segment.selectedSegmentIndex = 1;
    } else if ([orderdetail.Situation isEqualToString:@"請取餐"]){
        cell.Segment.selectedSegmentIndex = 2;
    }
    
    return cell;
}

-(void)the_reload_model{
    
    dispatch_async(dispatch_get_main_queue(),^{
        
    self.dgActivity = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeBallScaleRippleMultiple tintColor:[UIColor grayColor] size:60.0f];
    self.dgActivity.center = CGPointMake([[UIScreen mainScreen]bounds].size.width/2, [[UIScreen mainScreen]bounds].size.height/2);
    [self.view addSubview:self.dgActivity];
    [self.dgActivity startAnimating]; // 轉轉轉開始！
    });
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    NSURL *url = [NSURL URLWithString:@"http://scu-ordereasy.rhcloud.com/CompanyOrder.php"];
    NSMutableURLRequest *request;
    request = [NSMutableURLRequest requestWithURL:url];
    
    request.HTTPMethod=@"POST";
    NSString *parameter=[NSString stringWithFormat:@"userName=%@",appDelegate.userName];
    NSData *body=[parameter dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody=body;
    
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
                orderdetail.Situation = [NSString stringWithFormat:@"%@",book[@"Situation"]];
                
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
                alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您沒有任何訂單喔！" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction * alertAct;
                alertAct = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//                    [self.navigationController popViewControllerAnimated:YES];
                }];
                [alert addAction:alertAct];
                
                // 讀取動畫結束
                dispatch_async(dispatch_get_main_queue(),^{
                    [self.dgActivity stopAnimating];
                    [self.dgActivity removeFromSuperview];
                    if (alert) {
                        [self presentViewController:alert animated:YES completion:nil];
                    }
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

#pragma mark 刪除cell
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"刪除";
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle ==UITableViewCellEditingStyleDelete) {
        
        [self deleteOrder:indexPath];
        [self.orderarr removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//        [self.tableview reloadData];
    }
    
}

-(void) deleteOrder:(NSIndexPath *)indexpath {
    
    OrderDetail *order = self.orderarr[indexpath.row];
    
    NSURL *url=[NSURL URLWithString:@"http://scu-ordereasy.rhcloud.com/DeleteOrder.php"];
    //    NSURL *url=[NSURL URLWithString:@"http://localhost:8888/OrderEasy/orderadd.php"];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod=@"POST";
    self.TrueParameter = [NSString stringWithFormat:@"orderID=%@&foodName=%@",order.orderID,order.foodname];
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
                
                
                // 如果字串顯示傳送失敗
            } else {
                dispatch_async(dispatch_get_main_queue(),^{
                    UIAlertController *Error = [UIAlertController alertControllerWithTitle:@"訂單傳送失敗" message:@"伺服器發生錯誤！" preferredStyle:UIAlertControllerStyleAlert];
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

#pragma mark 登入/登出
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
//        [self dismissViewControllerAnimated:true completion:nil];
        [self.navigationController popViewControllerAnimated:true];
    }
    
}

#pragma mark 更改訂單狀態
-(void)OrderSituationChange:(NSString *)situation {
//    OrderDetail *order = self.orderarr[indexpath.row];
    
    NSURL *url=[NSURL URLWithString:@"http://scu-ordereasy.rhcloud.com/ChangeSituation.php"];
    //    NSURL *url=[NSURL URLWithString:@"http://localhost:8888/OrderEasy/orderadd.php"];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod=@"POST";
    self.TrueParameter = [NSString stringWithFormat:@"%@",situation];
    NSData *body=[self.TrueParameter dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody=body;
    
    NSURLSession *session=[NSURLSession sharedSession];
    NSURLSessionTask *task=[session dataTaskWithRequest:request completionHandler:^(NSData *  data, NSURLResponse *  response, NSError *  error) {
        
        // 如果收到PHP回傳的物件
        if (data != nil) {
            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSString *returndata = [dic objectForKey:@"status"];
//            NSLog(@"%@",returndata);
            // 如果字串顯示傳送成功
            if ([returndata  isEqual: @"Success!"]){
                
                
                // 如果字串顯示傳送失敗
            } else {
                dispatch_async(dispatch_get_main_queue(),^{
                    UIAlertController *Error = [UIAlertController alertControllerWithTitle:@"訊息傳送失敗" message:@"伺服器發生錯誤！。" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
                    [Error addAction:cancel];
                    [self presentViewController:Error animated:YES completion:nil];
                });
            }
            // 如果沒有收到PHP回傳的物件
        } else {
            dispatch_async(dispatch_get_main_queue(),^{
                UIAlertController *Error = [UIAlertController alertControllerWithTitle:@"訊息傳送失敗" message:@"請確認您的網路狀況是否正常。" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
                [Error addAction:cancel];
                [self presentViewController:Error animated:YES completion:nil];
            });
        }
        
    }];
    [task resume];

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
