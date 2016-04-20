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

@interface LoginViewController ()
<
UITextFieldDelegate
>
@property (weak, nonatomic) IBOutlet UITextField *account;
@property (weak, nonatomic) IBOutlet UITextField *passwd;

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
    
    NSString *account = self.account.text;
    NSString *passwd = self.passwd.text;
    BOOL accountOK = false;
    BOOL passwdOK = false;
    if ([account isEqualToString:@"abc"]) {
        accountOK = true;
    }
    if ([passwd isEqualToString:@"123"]) {
        passwdOK = true;
    }
    if (accountOK && passwdOK) {
        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        [appDelegate login];
        UIViewController *shopsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"shopsVC"];
        [self dismissViewControllerAnimated:YES completion:nil];
        [self presentViewController:shopsVC animated:true completion:nil];
        NSLog(@"login ok");
    }
    
}

- (IBAction)registerButton:(id)sender {
    
    
    
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
