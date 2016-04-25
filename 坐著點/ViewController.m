//
//  ViewController.m
//  坐著點 菜單
//
//  Created by 許佳航 on 2016/3/8.
//  Copyright © 2016年 許佳航. All rights reserved.
//

#import "ViewController.h"
#import "Note.h"
#import "TheTableViewCell.h"
#import "FoodDetailViewController.h"
#import "AppDelegate.h"
#import <AudioToolbox/AudioToolbox.h>
@import DGActivityIndicatorView;
@import ASCFlatUIColor;

@interface ViewController ()
<
UITableViewDataSource,
UITableViewDelegate
>
{

}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSMutableArray *Menus;
@property (nonatomic) NSMutableArray *the_arr;
@property DGActivityIndicatorView *dgActivity;
@property NSArray *colors;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *LoginBtn;



@end

@implementation ViewController


- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    return self;
}

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
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    self.LoginBtn.title = [NSString stringWithFormat:@"Hello %@",appDelegate.userName];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self the_reload_model];
    _Menus = [[NSMutableArray alloc]initWithObjects:_the_arr, nil];
    
//    UIColor *color = [ASCFlatUIColor alizarinColor];
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
    
    self.tableView.backgroundColor = [UIColor brownColor];
    
    self.colors = [NSArray arrayWithObjects:cloudsColor,alizarinColor,sunFlowerColor,peterriver,carrotColor,orangeColor,silverColor,emeraldColor,pumpkinColor,concreteColor,asbestosColor,amethystColor, nil]; // 隨機色彩
    
    // 讀取動畫
    self.dgActivity = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeLineScaleParty tintColor:[UIColor whiteColor] size:45.0f];
    self.dgActivity.center = self.view.center;
    [self.view addSubview:self.dgActivity];
    [self.dgActivity startAnimating]; // 轉轉轉開始！
    
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
    cell.price.text = [NSString stringWithFormat:@"單價:%@元",note.Price];
    cell.foodphoto.image = [UIImage imageNamed:@"loading.png"];
    cell.note = note;
    
    CGFloat comps[3];
    for (int i = 0; i < 3; i++)
        comps[i] = (CGFloat)arc4random_uniform(256)/255.f;
    cell.backgroundColor = [UIColor colorWithRed:comps[0] green:comps[1] blue:comps[2] alpha:1.0];

//    int anycolor = arc4random()%self.colors.count;
//    cell.backgroundColor = self.colors[anycolor];
    
//    圖片下載並顯示
    NSString *food = note.FoodPhotoName;
    food = [food stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *urlstr = [NSString stringWithFormat:@"http://scu-ordereasy.rhcloud.com/MenuPhoto/%@",food];
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
    
    // 轉轉轉結束
    [self.dgActivity stopAnimating];
    [self.dgActivity removeFromSuperview];
    
    return cell;
    
}

// 與伺服器溝通
-(void)the_reload_model{
    
    NSURL *url = [NSURL URLWithString:@"http://scu-ordereasy.rhcloud.com/Menus.php"];
    NSMutableURLRequest *request;
    request = [NSMutableURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession] ;
    NSURLSessionDataTask *dataTask;
    dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error != nil) {
            
            UIAlertController *alert;
            alert = [UIAlertController new];
            UIAlertAction * alertAct;
            alertAct = [UIAlertAction actionWithTitle:@"連不上" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:alertAct];
            dispatch_async(dispatch_get_main_queue(),^{
                
                [self presentViewController:alert animated:true completion:nil];
                [self dismissViewControllerAnimated:true completion:nil];
            });
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
                note.FoodID = book[@"foodID"];
                
                if ([note.ShopID isEqualToString:_Shops.ShopID]) {
                    [self.Menus addObject:note];
                }
            }
            
            if (_the_arr) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_tableView reloadData];
                // 菜單沒東西
                if (self.Menus.count == 0) {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"訊息" message:@"對不起，本店目前尚未開始營業。" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        [self.dgActivity stopAnimating];
                        [self.dgActivity removeFromSuperview];
                        [self.navigationController popToRootViewControllerAnimated:true];
                    }];
                        [alert addAction:ok];
                        [self presentViewController:alert animated:true completion:nil];
                    }
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
//            NSLog(@"連上囉");
        }
    }];
    
    [dataTask resume];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"MenuToDetail"]) {
        
        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        [appDelegate prepareSound:@"bicycle_bell"];
        
        FoodDetailViewController *FoodDetailViewController = segue.destinationViewController;
        NSIndexPath * indexPath = self.tableView.indexPathForSelectedRow;
        FoodDetailViewController.Foods = self.Menus[indexPath.row];
//        NSLog(@"Foods = %@",FoodDetailViewController.Foods);
        [_tableView deselectRowAtIndexPath:indexPath animated:true];
    }
    
    if ([segue.identifier isEqualToString:@"menutocart"]) {
        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        [appDelegate prepareSound:@"click"];
    }
    
    if ([segue.identifier isEqualToString:@"menutoorderdetail"]) {
        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        [appDelegate prepareSound:@"burp1"];
    }
    
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


@end






