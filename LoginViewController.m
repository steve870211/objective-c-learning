//
//  LoginViewController.m
//  坐著點
//
//  Created by 許佳航 on 2016/4/20.
//  Copyright © 2016年 許佳航. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "ShopsViewController.h"
@import DGActivityIndicatorView;

@interface LoginViewController ()
<
UITextFieldDelegate
>
{
    NSString *accountID;
    NSString *password;
}
@property (weak, nonatomic) IBOutlet UITextField *account;
@property (weak, nonatomic) IBOutlet UITextField *passwd;
@property (weak, nonatomic) IBOutlet UILabel *message;
@property DGActivityIndicatorView *dgActivity;
@property (weak, nonatomic) IBOutlet UIButton *LoginBtn;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.account.keyboardType = UIKeyboardTypeDefault;
    self.passwd.keyboardType = UIKeyboardTypeDefault;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doEditFieldDone:(id)sender {
    //取消目前是第一回應者（鍵盤消失）
    [sender resignFirstResponder];
}

- (IBAction)checkIdentity:(id)sender {
    
    [self customerQuery];
    
}

- (void)customerQuery {
    
    // 讀取動畫
    dispatch_async(dispatch_get_main_queue(),^{
        [self.LoginBtn setEnabled:false];
        self.dgActivity = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeBallScaleRippleMultiple tintColor:[UIColor whiteColor] size:45.0f];
        self.dgActivity.center = CGPointMake([[UIScreen mainScreen]bounds].size.width/2, [[UIScreen mainScreen]bounds].size.height-150);
        [self.view addSubview:self.dgActivity];
        [self.dgActivity startAnimating]; // 轉轉轉開始！
    });
    
    accountID=self.account.text;
    password=self.passwd.text;
    
    NSURL *url=[NSURL URLWithString:@"http://scu-ordereasy.rhcloud.com/AccountList.php"];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod=@"POST";
    
    NSString *parameter=[NSString stringWithFormat:@"accountID=%@&password=%@",accountID,password];
    NSData *body=[parameter dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody=body;
    
    NSURLSession *session=[NSURLSession sharedSession];
    NSURLSessionTask *task=[session dataTaskWithRequest:request completionHandler:^(NSData *  data, NSURLResponse *  response, NSError *  error){
        if (error){
            
            NSLog(@"error %@",error);
            
        }else{
            
            AppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
            
            NSArray *datas=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSLog(@"%lu",datas.count) ;
            
            if (datas.count==0){
                
                dispatch_async(dispatch_get_main_queue(),^{
                    // 轉轉轉結束
                    [self.dgActivity stopAnimating];
                    [self.dgActivity removeFromSuperview];
                    
                    [self.message setTextColor:[UIColor redColor]];
                    self.message.text = [[NSString alloc]initWithFormat:@"帳號或密碼錯誤！"];
                    [self.LoginBtn setEnabled:true];
                });
                
                
            } else{
                
                [appDelegate login];
                
                NSDictionary *customerDict=datas[0];
                appDelegate.userName=customerDict[@"userName"];
                appDelegate.userPhone=customerDict[@"userPhone"];
                appDelegate.userEmail=customerDict[@"userEmail"];
                appDelegate.userType=customerDict[@"userType"];
//                NSLog(@"user:%@,phone:%@,email:%@,type:%@",appDelegate.userName,appDelegate.userPhone,appDelegate.userEmail,appDelegate.userType);
                
                dispatch_async(dispatch_get_main_queue(),^{
                    [self.message setTextColor:[UIColor whiteColor]];
                    self.message.text = [[NSString alloc]initWithFormat:@"登入成功！"];
                });
                [NSThread sleepForTimeInterval:1.5];
                dispatch_async(dispatch_get_main_queue(),^{
                    // 轉轉轉結束
                    [self.dgActivity stopAnimating];
                    [self.dgActivity removeFromSuperview];
                    
                    UIViewController *shopsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"shopsVC"];
                    [self dismissViewControllerAnimated:YES completion:nil];
                    [self.LoginBtn setEnabled:true];
                    [self presentViewController:shopsVC animated:true completion:nil];
                });
            }
            
        }
    }];
    [task resume];
}

- (IBAction)toRegister:(id)sender {
    
    dispatch_async(dispatch_get_main_queue(),^{
        [self.message setText:@""];
    });
    
    UIViewController *RegisterVC = [self.storyboard instantiateViewControllerWithIdentifier:@"RegisterVC"];
    [self dismissViewControllerAnimated:true completion:nil];
    [self presentViewController:RegisterVC animated:true completion:nil];
    
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
