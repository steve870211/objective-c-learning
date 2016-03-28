//
//  FoodDetailViewController.m
//  坐著點 商品詳細資料
//
//  Created by 許佳航 on 2016/3/24.
//  Copyright © 2016年 許佳航. All rights reserved.
//

#import "FoodDetailViewController.h"

@interface FoodDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *ShopName;
@property (weak, nonatomic) IBOutlet UILabel *ShopID;
@property (weak, nonatomic) IBOutlet UILabel *FoodName;
@property (weak, nonatomic) IBOutlet UILabel *Price;
@property (weak, nonatomic) IBOutlet UIImageView *FoodPhoto;

@end

@implementation FoodDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.ShopName.text = self.Foods.ShopName;
    self.ShopID.text = self.Foods.ShopID;
    self.FoodName.text = self.Foods.FoodName;
    self.Price.text = self.Foods.Price;
//    self.FoodPhoto.image = ;
    NSString *food = self.Foods.FoodPhotoName;
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
                self.FoodPhoto.image = image;
            });
        }
    }];
    [task resume];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
