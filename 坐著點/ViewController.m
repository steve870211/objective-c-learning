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

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSMutableArray *Menus;


@end

@implementation ViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    NSMutableArray<Note*> *mcdonaldmenus = [[NSMutableArray alloc]init];
    NSMutableArray<Note*> *KFCmenu = [[NSMutableArray alloc]init];
    self = [super initWithCoder:aDecoder];
    
    NSArray *foodNames = @[@"麥克雞塊餐",@"麥脆雞餐",@"雙層牛肉起士堡",@"三層牛肉超級堡",@"太空米漢堡",@"北海鱈魚堡"];
    NSArray *price = @[@"125",@"129",@"125",@"135",@"111",@"150"];
    for(int i=0 ; i < foodNames.count ; i++){
        Note * menu = [[Note alloc]init];
        menu.FoodName = foodNames[i];
        menu.Price = price[i];
        menu.Number = @(0);
        [mcdonaldmenus addObject:menu];
    }
    
    NSArray * foodNames2 = @[@"六塊🐔餐", @"三號全家餐", @"蛋塔禮盒", @"辣味脆雞", @"薄皮嫩雞"];
    NSArray * price2 = @[@"199",@"299",@"329",@"129",@"129"];
    for(int i=0 ; i < foodNames2.count ; i++){
        Note * menu = [[Note alloc]init];
        menu.FoodName = foodNames2[i];
        menu.Price = price2[i];
        menu.Number = @(0);
        [KFCmenu addObject:menu];
    }
    
    _Menus = [[NSMutableArray alloc]initWithObjects:mcdonaldmenus,KFCmenu, nil];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"麥當勞";
            break;
            
        case 1:
            return @"肯德基";
            break;
            
        default:
            return @"";
            break;
    }
}

// Section的數量
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return _Menus.count;
    
}

// Cell的數量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
 
    return [[_Menus objectAtIndex:section] count];
    
}

// Cell的內容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TheTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    Note *note = _Menus[indexPath.section][indexPath.row];
//    cell.shopname.text = note.ShopName;
    cell.foodname.text = note.FoodName;
    cell.price.text = note.Price;
    cell.number.text = [NSString stringWithFormat:@"%@",note.Number];
    cell.imageView.image = note.Foodphoto;
    cell.Btn_plus.tag = indexPath.row;
    cell.Btn_decrease.tag = indexPath.row;
    cell.number.tag = indexPath.row;
    cell.note = note;
    
    return cell;
    
}

// 訂餐數量+1
- (IBAction)number_plus:(id)sender {
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    
    Note * menu = _Menus[indexPath.section][indexPath.row];
    
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
    
    Note * menu = _Menus[indexPath.section][indexPath.row];
    
    NSNumber *a = menu.Number;
    if ( a.intValue > 0 ) {
        a = @([menu.Number intValue]-1);
        menu.Number = @([a intValue]);
    }
//    NSLog(@"%@",a);
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

}



@end






