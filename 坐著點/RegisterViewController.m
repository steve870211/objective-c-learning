//
//  RegisterViewController.m
//  坐著點
//
//  Created by 許佳航 on 2016/4/21.
//  Copyright © 2016年 許佳航. All rights reserved.
//

#import "RegisterViewController.h"
#import "LoginViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "AppDelegate.h"
@import DGActivityIndicatorView;
@import MMNumberKeyboard;

@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *account;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *passwordCheck;
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *userPhone;
@property (weak, nonatomic) IBOutlet UITextField *userEmail;
@property (weak, nonatomic) NSString *userType;
@property (weak, nonatomic) NSString *dataGot;
@property (weak, nonatomic) IBOutlet UILabel *message;
@property DGActivityIndicatorView *dgActivity;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    MMNumberKeyboard *Keyboard = [[MMNumberKeyboard alloc]initWithFrame:CGRectZero];
    self.userPhone.inputView = Keyboard;
    self.userEmail.keyboardType = UIKeyboardTypeEmailAddress;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doEditFieldDone:(id)sender {
    //取消目前是第一回應者（鍵盤消失）
    [sender resignFirstResponder];
}

- (IBAction)backBtn:(id)sender {
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate prepareSound:@"click"];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)commit:(id)sender {
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate prepareSound:@"click"];
    
    if (self.account.text.length > 10 || self.account.text.length < 6) {
        self.message.text = [NSString stringWithFormat:@"帳號字數必須為6~10個字元"];
    } else if(self.password.text.length > 8 || self.password.text.length < 4) {
        self.message.text = [NSString stringWithFormat:@"密碼字數必須為4~8個字元"];
    } else if(self.passwordCheck.text != self.password.text) {
        self.message.text = [NSString stringWithFormat:@"密碼檢查失敗，請確認您的密碼"];
    } else if(self.userName.text.length < 1) {
        self.message.text = [NSString stringWithFormat:@"姓名不得為空"];
    } else if(self.userPhone.text.length != 10) {
        self.message.text = [NSString stringWithFormat:@"請填入10碼手機號碼"];
    } else if(self.userEmail.text.length < 8) {
        self.message.text = [NSString stringWithFormat:@"請填寫正確的Email"];
    } else {
        [self Register];
    }
}

-(void) Register {
    
    // 讀取動畫
    dispatch_async(dispatch_get_main_queue(),^{
        
        [self.commitBtn setEnabled:false];
        
        self.dgActivity = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeBallScaleRippleMultiple tintColor:[UIColor whiteColor] size:45.0f];
        
        self.dgActivity.center = CGPointMake([[UIScreen mainScreen]bounds].size.width/2, [[UIScreen mainScreen]bounds].size.height-150);
        [self.view addSubview:self.dgActivity];
        [self.dgActivity startAnimating]; // 轉轉轉開始！
    });
    
    // 聯繫PHP
    NSURL *url = [NSURL URLWithString:@"http://scu-ordereasy.rhcloud.com/Register.php"];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod=@"POST";
    self.dataGot = [NSString stringWithFormat:@"accountID=%@&password=%@&userName=%@&userPhone=%@&userEmail=%@&userType=customer",self.account.text,self.password.text,self.userName.text,self.userPhone.text,self.userEmail.text];
    NSData *body=[self.dataGot dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody=body;
    NSURLSession *session=[NSURLSession sharedSession];
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        // 如果收到PHP回傳的物件
        if (data != nil) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSString *returndata = [dic objectForKey:@"status"];
            
            // 如果字串顯示已存在此帳號
            if ([returndata  isEqual: @"NO"]){
                dispatch_async(dispatch_get_main_queue(),^{
                   self.message.text = [NSString stringWithFormat:@"帳號已存在，請重新輸入"];
                });
            } else if([returndata isEqual: @"Success!"]) {
                dispatch_async(dispatch_get_main_queue(),^{
                    
                    [self.message setTextColor:[UIColor whiteColor]];
                    self.message.text = [NSString stringWithFormat:@"註冊成功"];
                    
                    SystemSoundID click;
                    NSURL *sound = [[NSBundle mainBundle]URLForResource:@"guitar" withExtension:@"mp3"];
                    AudioServicesCreateSystemSoundID((CFURLRef)CFBridgingRetain(sound),&click);
                    AudioServicesPlaySystemSound(click);
                });
                
                [NSThread sleepForTimeInterval:1.5];
                
                dispatch_async(dispatch_get_main_queue(),^{
                    UIViewController *LoginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
                    [self dismissViewControllerAnimated:YES completion:nil];
                    [self presentViewController:LoginVC animated:true completion:nil];
                });
            }
        }
    }];
    [task resume];
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
