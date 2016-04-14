//
//  OrderDetailViewController.m
//  坐著點
//
//  Created by 許佳航 on 2016/4/12.
//  Copyright © 2016年 許佳航. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "OrderDetailCollectionViewCell.h"
#import "Note.h"

@interface OrderDetailViewController ()
<
UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout
>
{
    NSMutableArray *the_arr;
}

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation OrderDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [the_arr count];
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    OrderDetailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.ShopName.text = [the_arr objectAtIndex:indexPath.row];
    
    return cell;
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake([[UIScreen mainScreen] bounds].size.width-30, 200);
}

// 與伺服器溝通
-(void)the_reload_model{
    
    NSURL *url = [NSURL URLWithString:@"http://scu-ordereasy.rhcloud.com/Orders.php"];
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
            [self presentViewController:alert animated:true completion:nil];
            [self dismissViewControllerAnimated:true completion:nil];
        } else {
            
            //            NSString *con = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            //            NSLog(@"josn=%@", con);
            
            NSArray * arr = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            the_arr = [NSMutableArray arrayWithArray:arr];
            
            for (int i=0; i<the_arr.count; i++) {
                
                NSDictionary *book = the_arr[i];
                Note* note = [Note new];
                note.ShopName = book[@"shopName"];
                note.FoodName = book[@"foodName"];
                note.Price = book[@"price"];
                note.ShopID = book[@"shopID"];
                note.FoodID = book[@"foodID"];
                
                if ([note.ShopID isEqualToString:_Shops.ShopID]) {
                    [self.Menus addObject:note];
                }
            }
            
            if (the_arr) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_collectionView reloadData];
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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end










