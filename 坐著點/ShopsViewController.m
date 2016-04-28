//
//  ShopsViewController.m
//  坐著點 商店目錄
//
//  Created by 許佳航 on 2016/3/23.
//  Copyright © 2016年 許佳航. All rights reserved.
//

#import "ShopsViewController.h"
#import "ShopsTableViewCell.h"
#import "ViewController.h"
#import "AppDelegate.h"
#import <AudioToolbox/AudioToolbox.h>
@import DGActivityIndicatorView;
@import ASCFlatUIColor;

@interface ShopsViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSMutableArray *ShopsList;
@property (nonatomic) NSMutableArray *the_arr;
@property DGActivityIndicatorView *dgActivity;
@property NSArray *colors;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *LoginBtn;

@end

@implementation ShopsViewController

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
    
    // 讀取動畫
    self.dgActivity = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeLineScaleParty tintColor:[UIColor whiteColor] size:45.0f];
    self.dgActivity.center = self.view.center;
    [self.view addSubview:self.dgActivity];
    [self.dgActivity startAnimating];
    
    [self the_reload_model];
    self.tableView.dataSource = self;
    _ShopsList = [[NSMutableArray alloc]initWithObjects:_the_arr, nil];
    
    
    
    self.tableView.backgroundColor = [UIColor brownColor];
    
    UIColor *alizarinColor = [ASCFlatUIColor alizarinColor];
    UIColor *cloudsColor = [ASCFlatUIColor cloudsColor];
    UIColor *sunFlowerColor = [ASCFlatUIColor sunFlowerColor];
    UIColor *carrotColor = [ASCFlatUIColor carrotColor];
    UIColor *orangeColor = [ASCFlatUIColor orangeColor];
    UIColor *silverColor = [ASCFlatUIColor silverColor];
    UIColor *emeraldColor = [ASCFlatUIColor emeraldColor];
    UIColor *pumpkinColor = [ASCFlatUIColor pumpkinColor];
    UIColor *concreteColor = [ASCFlatUIColor concreteColor];
    UIColor *asbestosColor = [ASCFlatUIColor asbestosColor];
    UIColor *amethystColor = [ASCFlatUIColor amethystColor];
    UIColor *peterriver = [ASCFlatUIColor peterRiverColor];
    self.colors = [NSArray arrayWithObjects:cloudsColor,alizarinColor,sunFlowerColor,peterriver,carrotColor,orangeColor,silverColor,emeraldColor,pumpkinColor,concreteColor,asbestosColor,amethystColor, nil]; // 隨機色彩
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Tableview delegate.datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _ShopsList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShopsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"shopscell"];
    Note *note = _ShopsList[indexPath.row];
    cell.ShopName.text = note.ShopName;
    cell.ShopID.text = note.ShopID;
//    cell.ShopsImage.image = [UIImage imageNamed:@"loading.png"];
    // 加入圖片
    cell.ShopsImage.animationImages = [NSArray arrayWithObjects:
                                      [UIImage imageNamed:@"1.png"],
                                      [UIImage imageNamed:@"2.png"],
                                      [UIImage imageNamed:@"3.png"],
                                      [UIImage imageNamed:@"4.png"],nil ];
    // 設定一輪播放的時間
    cell.ShopsImage.animationDuration = 1;
    // 設置0 不斷重複
    cell.ShopsImage.animationRepeatCount = 0;
    // 開始動畫
    [cell.ShopsImage startAnimating];
    
//    隨機色彩
//    CGFloat comps[3];
//    for (int i = 0; i < 3; i++)
//        comps[i] = (CGFloat)arc4random_uniform(256)/255.f;
//    cell.backgroundColor = [UIColor colorWithRed:comps[0] green:comps[1] blue:comps[2] alpha:1.0];
    cell.backgroundColor = [UIColor whiteColor];
    
//    int anycolor = arc4random()%self.colors.count;
//    cell.backgroundColor = self.colors[anycolor];
    
    NSString *shop = note.ShopLogoName;
    shop = [shop stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *urlstr = [NSString stringWithFormat:@"http://scu-ordereasy.rhcloud.com/MenuPhoto/%@",shop];
    NSURL *url = [NSURL URLWithString:urlstr];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"error %@",error.description);
        } else {
            dispatch_async(dispatch_get_main_queue(),^{
                [cell.ShopsImage stopAnimating];
                UIImage *image = [UIImage imageWithData:data];
                cell.ShopsImage.image = image;
            });
        }
    }];
    [task resume];
    
    // 讀取動畫結束
    [self.dgActivity stopAnimating];
    [self.dgActivity removeFromSuperview];
    return cell;
}

#pragma mark Talk with PHP
-(void)the_reload_model {
    
    NSURL *url = [NSURL URLWithString:@"http://scu-ordereasy.rhcloud.com/Shops.php"];
    NSMutableURLRequest *request;
    request = [NSMutableURLRequest requestWithURL:url];
    NSURLSessionConfiguration *config;
    config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session;
    session = [NSURLSession sessionWithConfiguration:config delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *dataTask;
    dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error != nil) {
            
            UIAlertController *alert;
            alert = [UIAlertController alertControllerWithTitle:@"網路問題" message:@"請檢查您的網路狀況" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * alertAct = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                AppDelegate *app = [UIApplication sharedApplication].delegate;
                UIWindow *window = app.window;
                
                [UIView animateWithDuration:0.4f animations:^{
                    window.alpha = 0;
                    CGFloat y = window.bounds.size.height;
                    CGFloat x = window.bounds.size.width / 2;
                    window.frame = CGRectMake(x, y, 0, 0);
                } completion:^(BOOL finished) {
                    exit(0);
                }];
            }];
            UIAlertAction *alertAgain = [UIAlertAction actionWithTitle:@"重新連線" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self the_reload_model];
            }];
            [alert addAction:alertAct];
            [alert addAction:alertAgain];
            [self presentViewController:alert animated:true completion:nil];
            
        } else {
            
//            NSString *con = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
//            NSLog(@"josn=%@", con);
            
            NSArray * arr = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            _the_arr = [NSMutableArray arrayWithArray:arr];
            
            for (int i=0; i<_the_arr.count; i++) {
                
                NSDictionary *book = _the_arr[i];
                Note* note = [Note new];
                note.ShopID = book[@"shopID"];
                note.ShopName = book[@"shopName"];
                note.ShopLogoName = book[@"shopLogo"];
                [self.ShopsList addObject:note];
                
            }
            
            
            
            if (_the_arr) {
                
                [_tableView reloadData];
                
            } else {
                
                UIAlertController *alert;
                alert = [UIAlertController new];
                UIAlertAction * alertAct;
                alertAct = [UIAlertAction actionWithTitle:@"伺服器失效" style:UIAlertActionStyleDefault handler:nil];
                [alert addAction:alertAct];
                [self presentViewController:alert animated:true completion:nil];
                
            }
            
//            NSLog(@"連上囉");
        }
        
    }];
    
    [dataTask resume];
    
}

// Login/Logout
- (IBAction)LoginBtnPressed:(id)sender {
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    [appDelegate prepareSound:@"locking_a_wooden_door1"];
    
    if (appDelegate.isLogined == false) {
        UIViewController *LoginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
        [self.navigationController pushViewController:LoginVC animated:YES];
    } else {
        [appDelegate logout];
        appDelegate.Account = @"";
        [self.LoginBtn setTitle:@"登入"];
    }

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"ToFoods"]) {
        
        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        
        [appDelegate prepareSound:@"click"];
        
        ViewController *foodViewController = segue.destinationViewController;
        NSIndexPath * indexPath = self.tableView.indexPathForSelectedRow;
        foodViewController.Shops = self.ShopsList[indexPath.row];
        [_tableView deselectRowAtIndexPath:indexPath animated:true];
    }
    
    if ([segue.identifier isEqualToString:@"shoptocart"]) {
        
        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        
        [appDelegate prepareSound:@"click"];
    }
    
    if ([segue.identifier isEqualToString:@"shoptoorderdetail"]) {
        
        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        
        [appDelegate prepareSound:@"burp1"];
    }
    
}


//#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//}


@end
