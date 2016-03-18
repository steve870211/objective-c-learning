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

@interface ViewController ()<UITableViewDataSource>
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
    [self the_reload_model];
    self.tableView.dataSource = self;
    _Menus = [[NSMutableArray alloc]initWithObjects:_the_arr, nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
            
        case 0:
            return @"四海遊龍";
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
 
//    return _the_arr.count;
//    return [[_Menus objectAtIndex:section] count];
    return _Menus.count;
    
}

// Cell的內容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TheTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
//    Note *note = _Menus[indexPath.section][indexPath.row];
    Note *note = _Menus[indexPath.row];
//    cell.shopname.text = note.ShopName;
    cell.foodname.text = note.FoodName;
    cell.price.text = note.Price;
    cell.number.text = [NSString stringWithFormat:@"%@",note.Number];
    cell.imageView.image = note.Foodphoto;
    cell.Btn_plus.tag = indexPath.row;
    cell.Btn_decrease.tag = indexPath.row;
    cell.number.tag = indexPath.row;
    cell.note = note;
    
//    TheTableViewCell *cell;
//    cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
//    NSDictionary *er;
//    er = _the_arr[indexPath.row];
//    cell.foodname.text = er[@"foodName"];
//    cell.price.text = er[@"price"];
//    cell.number = 0;
    
    return cell;
    
}

-(void)the_reload_model{
    
    NSURL *url = [NSURL URLWithString:@"http://localhost:8888/myPHP/OrderEasy.php"];
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
            alertAct = [UIAlertAction actionWithTitle:@"連不上" style:UIAlertActionStyleDefault handler:nil];
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
                note.ShopName = book[@"shopName"];
                note.FoodName = book[@"foodName"];
                note.Price = book[@"price"];
                
                [self.Menus addObject:note];
                
            }

            
            
            if (_the_arr) {
                
                [_tableView reloadData];
                
            } else {
                
                UIAlertController *alert;
                alert = [UIAlertController new];
                UIAlertAction * alertAct;
                alertAct = [UIAlertAction actionWithTitle:@"MySQL有問題" style:UIAlertActionStyleDefault handler:nil];
                [alert addAction:alertAct];
                [self presentViewController:alert animated:true completion:nil];
                
            }
            
            NSLog(@"連上囉");
        }
        
    }];
    
    [dataTask resume];
    
}

// 訂餐數量+1
- (IBAction)number_plus:(id)sender {
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    
//    Note * menu = _Menus[indexPath.section][indexPath.row];
    Note *menu = _Menus[indexPath.row];
    
    NSNumber *a = menu.Number;
    if ( a.intValue < 99) {
        a = @([menu.Number intValue]+1);
        menu.Number = @([a intValue]);
    }
//    NSLog(@"%@",a);
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

}

// 訂餐數量-1
- (IBAction)number_decrease:(id)sender {
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    
//    Note * menu = _Menus[indexPath.section][indexPath.row];
    Note *menu = _Menus[indexPath.row];
    
    NSNumber *a = menu.Number;
    if ( a.intValue > 0 ) {
        a = @([menu.Number intValue]-1);
        menu.Number = @([a intValue]);
    }
//    NSLog(@"%@",a);
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

}

- (IBAction)resetBtn:(id)sender {
    
    
    
}



@end






