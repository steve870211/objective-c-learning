//
//  ShopsViewController.m
//  坐著點
//
//  Created by 許佳航 on 2016/3/23.
//  Copyright © 2016年 許佳航. All rights reserved.
//

#import "ShopsViewController.h"
#import "ShopsTableViewCell.h"
#import "ViewController.h"


@interface ShopsViewController () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSMutableArray *ShopsList;
@property (nonatomic) NSMutableArray *the_arr;
@end

@implementation ShopsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self the_reload_model];
    self.tableView.dataSource = self;
    _ShopsList = [[NSMutableArray alloc]initWithObjects:_the_arr, nil];
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
//    cell.ShopsImage.image = note.ShopImage;
    cell.backgroundColor = [UIColor grayColor];
    return cell;
}

-(void)the_reload_model {
    
    NSURL *url = [NSURL URLWithString:@"http://localhost:8888/OrderEasy/Shops.php"];
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
            
            NSString *con = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            NSLog(@"josn=%@", con);
            
            NSArray * arr = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            _the_arr = [NSMutableArray arrayWithArray:arr];
            
            for (int i=0; i<_the_arr.count; i++) {
                
                NSDictionary *book = _the_arr[i];
                Note* note = [Note new];
                note.ShopID = book[@"shopID"];
                note.ShopName = book[@"shopName"];
                note.ShopImage = book[@"shopLogo"];
                
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
            
            NSLog(@"連上囉");
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
