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
#import <AudioToolbox/AudioToolbox.h>
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
@property (weak, nonatomic) IBOutlet UIButton *RegisterBtn;
@property (nonatomic) NSString *saveAccount;
@property (weak, nonatomic) IBOutlet UISwitch *switchBtn;
@property NSString *accountPath;

@end

@implementation LoginViewController

-(void)viewWillAppear:(BOOL)animated {

    // AccountSave根目錄
    self.accountPath = [NSString stringWithFormat:@"%@/Documents/AccountSave.plist",NSHomeDirectory()];

    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:self.accountPath];
    self.saveAccount = [NSString stringWithFormat:@"%@",[data objectForKey:@"BOOL"]];

    if ([self.saveAccount isEqualToString:@"1"]) {
        self.switchBtn.on = true;
    } else {
        self.switchBtn.on = false;
    }
    if ([self.saveAccount isEqualToString:@"1"]) {

        NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:self.accountPath];
        NSString *Accountload = [data objectForKey:@"Account"];
        NSString *Passwordload = [data objectForKey:@"Password"];
        self.account.text = [NSString stringWithFormat:@"%@",Accountload];
        self.passwd.text = [NSString stringWithFormat:@"%@",Passwordload];
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.account.keyboardType = UIKeyboardTypeDefault;
    self.passwd.keyboardType = UIKeyboardTypeAlphabet;
    
    if (self.switchBtn.on == true) {

        NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:self.accountPath];
        NSString *Accountload = [data objectForKey:@"Account"];
        NSString *Passwordload = [data objectForKey:@"Password"];
        self.account.text = [NSString stringWithFormat:@"%@",Accountload];
        self.passwd.text = [NSString stringWithFormat:@"%@",Passwordload];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 是否要記錄帳號密碼
- (IBAction)saveAccountBtn:(id)sender {
    
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:self.accountPath];
    
    if (self.switchBtn.on == true) {
        self.saveAccount = @"1";
        [data setObject:@(YES) forKey:@"BOOL"];
        [data writeToFile:self.accountPath atomically:true];
    } else {
        self.saveAccount = @"0";
        [data setObject:@(NO) forKey:@"BOOL"];
        [data setObject:@"" forKey:@"Account"];
        [data setObject:@"" forKey:@"Password"];
        [data writeToFile:self.accountPath atomically:true];
    }
    
}

- (IBAction)doEditFieldDone:(id)sender {
    //取消目前是第一回應者（鍵盤消失）
    [sender resignFirstResponder];
}

- (IBAction)checkIdentity:(id)sender {
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate prepareSound:@"click"];
    [self customerQuery];
    
}

- (void)customerQuery {
    
    // 讀取動畫
    dispatch_async(dispatch_get_main_queue(),^{
        [self.LoginBtn setEnabled:false];
        [self.RegisterBtn setEnabled:false];
        self.dgActivity = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeBallScaleRippleMultiple tintColor:[UIColor whiteColor] size:40.0f];
        self.dgActivity.center = CGPointMake([[UIScreen mainScreen]bounds].size.width/2, [[UIScreen mainScreen]bounds].size.height-220);
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
//            NSLog(@"%lu",datas.count) ;
            
            if (datas.count==0){
                
                dispatch_async(dispatch_get_main_queue(),^{
                    // 轉轉轉結束
                    [self.dgActivity stopAnimating];
                    [self.dgActivity removeFromSuperview];
                    
                    [self.message setTextColor:[UIColor redColor]];
                    self.message.text = [[NSString alloc]initWithFormat:@"帳號或密碼錯誤！"];
                    [self.LoginBtn setEnabled:true];
                    [self.RegisterBtn setEnabled:true];
                });
                
                
            } else{
                
                [appDelegate login];
                
                NSDictionary *customerDict = datas[0];
                appDelegate.userName = customerDict[@"userName"];
                appDelegate.userPhone = customerDict[@"userPhone"];
                appDelegate.userEmail = customerDict[@"userEmail"];
                appDelegate.userType = customerDict[@"userType"];
                appDelegate.Account = customerDict[@"accountID"];
                
                dispatch_async(dispatch_get_main_queue(),^{
                    [self.message setTextColor:[UIColor whiteColor]];
                    self.message.text = [[NSString alloc]initWithFormat:@"登入成功！"];
                });
                
                // 記錄帳號密碼
                if ([self.saveAccount isEqualToString:@"1"]) {
//                    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"AccountSave" ofType:@"plist"];
                    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:self.accountPath];
                    [data setValue:appDelegate.Account forKey:@"Account"];
                    [data setValue:password forKey:@"Password"];
                    [data writeToFile:self.accountPath atomically:true];
                }
                
                SystemSoundID click;
                NSURL *sound = [[NSBundle mainBundle]URLForResource:@"guitar" withExtension:@"mp3"];
                AudioServicesCreateSystemSoundID((CFURLRef)CFBridgingRetain(sound),&click);
                AudioServicesPlaySystemSound(click);
                
                [NSThread sleepForTimeInterval:1.0];
                dispatch_async(dispatch_get_main_queue(),^{
                    // 轉轉轉結束
                    [self.dgActivity stopAnimating];
                    [self.dgActivity removeFromSuperview];
                    
                    [self.LoginBtn setEnabled:true];
                    [self.RegisterBtn setEnabled:true];
                    if ([appDelegate.userType isEqualToString:@"customer"]) {
//                        [self dismissViewControllerAnimated:YES completion:nil];
                        [self.navigationController popViewControllerAnimated:YES];
                    } else if([appDelegate.userType isEqualToString:@"company"]) {
//                        [self dismissViewControllerAnimated:YES completion:nil];
                        UIViewController *companyVC = [self.storyboard instantiateViewControllerWithIdentifier:@"Company"];
                        [self.navigationController pushViewController:companyVC animated:YES];
                    }

                });
            }
            
        }
    }];
    [task resume];
}

- (IBAction)toRegister:(id)sender {
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate prepareSound:@"click"];
    
    dispatch_async(dispatch_get_main_queue(),^{
        [self.message setText:@""];
    });
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
