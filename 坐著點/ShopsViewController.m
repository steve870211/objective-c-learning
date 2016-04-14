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

@end

@implementation ShopsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self the_reload_model];
    self.tableView.dataSource = self;
    _ShopsList = [[NSMutableArray alloc]initWithObjects:_the_arr, nil];
    
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
    
    self.tableView.backgroundColor = [UIColor brownColor];
    
    self.colors = [NSArray arrayWithObjects:cloudsColor,alizarinColor,sunFlowerColor,peterriver,carrotColor,orangeColor,silverColor,emeraldColor,pumpkinColor,concreteColor,asbestosColor,amethystColor, nil]; // 隨機色彩
    
    // 讀取動畫
    self.dgActivity = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeLineScaleParty tintColor:alizarinColor size:60.0f];
    self.dgActivity.center = self.view.center;
    [self.view addSubview:self.dgActivity];
    [self.dgActivity startAnimating];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _ShopsList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShopsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"shopscell"];
    Note *note = _ShopsList[indexPath.row];
    cell.ShopName.text = note.ShopName;
    cell.ShopID.text = note.ShopID;
    cell.ShopsImage.image = [UIImage imageNamed:@"loading.png"];
    
    CGFloat comps[3];
    for (int i = 0; i < 3; i++)
        comps[i] = (CGFloat)arc4random_uniform(256)/255.f;
    cell.backgroundColor = [UIColor colorWithRed:comps[0] green:comps[1] blue:comps[2] alpha:1.0];
    
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
                UIImage *image = [UIImage imageWithData:data];
                cell.ShopsImage.image = image;
            });
        }
    }];
    [task resume];
    [self.dgActivity stopAnimating];
    [self.dgActivity removeFromSuperview];
    return cell;
}

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
            alert = [UIAlertController new];
            UIAlertAction * alertAct;
            alertAct = [UIAlertAction actionWithTitle:@"連線失敗" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:alertAct];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"ToFoods"]) {
        ViewController *foodViewController = segue.destinationViewController;
        NSIndexPath * indexPath = self.tableView.indexPathForSelectedRow;
        foodViewController.Shops = self.ShopsList[indexPath.row];
        [_tableView deselectRowAtIndexPath:indexPath animated:true];
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
