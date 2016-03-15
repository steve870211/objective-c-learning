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
@property (nonatomic) NSMutableArray<Note*> *menus;

@end

@implementation ViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    self.menus = [NSMutableArray array];
    for(int i=1 ; i <=10 ; i++){
        Note * menu = [[Note alloc]init];
        menu.ShopName = [NSString stringWithFormat:@"麥當勞"];
        menu.FoodName = [NSString stringWithFormat:@"%d 號餐",i];
        menu.Price = [NSString stringWithFormat:@"%d元",i*10+100];
        menu.Number = @(0);
        [self.menus addObject:menu];
    }
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _menus.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TheTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    Note *note = _menus[indexPath.row];
    cell.shopname.text = note.ShopName;
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

- (IBAction)number_plus:(id)sender {
    
//  [sender addTarget:self action:@selector(buttonPlusPress:) forControlEvents:UIControlEventTouchUpInside];
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    
    Note * menu = self.menus[indexPath.row];
    
    NSNumber *a = menu.Number;
    if ( a.intValue < 99) {
        a = @([menu.Number intValue]+1);
        menu.Number = @([a intValue]);
    }
    NSLog(@"%@",a);
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];


}

- (IBAction)number_decrease:(id)sender {

//  [sender addTarget:self action:@selector(buttonDecreasePress:) forControlEvents:UIControlEventTouchUpInside];
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    
    Note * menu = self.menus[indexPath.row];
    
    NSNumber *a = menu.Number;
    if ( a.intValue > 0 ) {
        a = @([menu.Number intValue]-1);
        menu.Number = @([a intValue]);
    }
    NSLog(@"%@",a);
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

}



@end






