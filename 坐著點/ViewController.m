//
//  ViewController.m
//  坐著點
//
//  Created by 許佳航 on 2016/3/8.
//  Copyright © 2016年 許佳航. All rights reserved.
//

#import "ViewController.h"
#import "Note.h"
#import "TheTableViewCell.h"
#import "FoodDetailViewController.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
{

}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSMutableArray *Menus;
@property (nonatomic) NSMutableArray *the_arr;

@end

@implementation ViewController


- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self the_reload_model];
    _Menus = [[NSMutableArray alloc]initWithObjects:_the_arr, nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
            return _Shops.ShopName;
            break;
        default:
            return @"";
            break;
    }
}

// Section的數量
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}

// Cell的數量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
 
    return _Menus.count;
    
}

// Cell的內容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TheTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    Note *note = _Menus[indexPath.row];
    cell.foodname.text = note.FoodName;
    cell.price.text = [NSString stringWithFormat:@"單價：%@元",note.Price];
    cell.foodphoto.image = [UIImage imageNamed:@"loading.png"];
    cell.note = note;
    
//    圖片下載並顯示
    NSString *food = note.FoodPhotoName;
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
                cell.foodphoto.image = image;
            });
        }
    }];
    [task resume];
    
    return cell;
    
}

// 與伺服器溝通
-(void)the_reload_model{
    
    NSURL *url = [NSURL URLWithString:@"http://localhost:8888/OrderEasy/Menus.php"];
    NSMutableURLRequest *request;
    request = [NSMutableURLRequest requestWithURL:url];
//    NSURLSessionConfiguration *config;
//    config = [NSURLSessionConfiguration defaultSessionConfiguration];
//    NSURLSession *session;
//    session = [NSURLSession sessionWithConfiguration:config delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSession *session = [NSURLSession sharedSession] ;
    NSURLSessionDataTask *dataTask;
    dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error != nil) {
            
            UIAlertController *alert;
            alert = [UIAlertController new];
            UIAlertAction * alertAct;
            alertAct = [UIAlertAction actionWithTitle:@"連不上" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:alertAct];
            [self presentViewController:alert animated:true completion:nil];
            [self dismissViewControllerAnimated:true completion:nil];
        } else {
            
//            NSString *con = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
//            NSLog(@"josn=%@", con);
            
            NSArray * arr = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            _the_arr = [NSMutableArray arrayWithArray:arr];
            
            for (int i=0; i<_the_arr.count; i++) {
                
                NSDictionary *book = _the_arr[i];
                Note* note = [Note new];
                note.ShopName = book[@"shopName"];
                note.FoodName = book[@"foodName"];
                note.Price = book[@"price"];
                note.ShopID = book[@"shopID"];
                note.FoodPhotoName = book[@"foodPhoto"];

//                if (note.ShopID == _Shops.ShopID) {
//                    [self.Menus addObject:note];
//                }
                
                if ([note.ShopID isEqualToString:_Shops.ShopID]) {
                    [self.Menus addObject:note];
                }
            }
            
            if (_the_arr) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_tableView reloadData];
                });
            } else {
                
                UIAlertController *alert;
                alert = [UIAlertController new];
                UIAlertAction * alertAct;
                alertAct = [UIAlertAction actionWithTitle:@"伺服器失效" style:UIAlertActionStyleDefault handler:nil];
                [alert addAction:alertAct];
                [self presentViewController:alert animated:true completion:nil];
                [self dismissViewControllerAnimated:true completion:nil];
                
            }
            NSLog(@"連上囉");
        }
    }];
    [dataTask resume];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"MenuToDetail"]) {
        FoodDetailViewController *FoodDetailViewController = segue.destinationViewController;
        NSIndexPath * indexPath = self.tableView.indexPathForSelectedRow;
        FoodDetailViewController.Foods = self.Menus[indexPath.row];
        NSLog(@"Foods = %@",FoodDetailViewController.Foods);
        [_tableView deselectRowAtIndexPath:indexPath animated:true];
    }
}

@end






