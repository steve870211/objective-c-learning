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
@property (nonatomic) NSMutableArray<Note*> *menu;

@end

@implementation ViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    self.menu = [NSMutableArray array];
    for(int i=1 ; i <=10 ; i++){
        Note * menu = [[Note alloc]init];
        menu.ShopName = [NSString stringWithFormat:@"麥當勞"];
        menu.FoodName = [NSString stringWithFormat:@"%d 號餐",i];
        menu.FoodPrice = [NSString stringWithFormat:@"%d元",i*10+100];
        [self.menu addObject:menu];
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
    
    return _menu.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TheTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    Note *note = _menu[indexPath.row];
    cell.shopname.text = note.ShopName;
    cell.foodname.text = note.FoodName;
    cell.price.text = note.FoodPrice;
    cell.imageView.image = note.Foodphoto;
    
    return cell;
    
}

@end
