//
//  ResetPasswordVC.m
//  iMixedTape
//
//  Created by Mustafa Qutbuddin on 1/27/17.
//  Copyright © 2017 LemondeIT. All rights reserved.
//

#import "ResetPasswordVC.h"
#import "UserModel.h"

@interface ResetPasswordVC ()

@end

@implementation ResetPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.emailTF.text = self.emailStr;
    
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
}

-(void)dismissKeyboard
{
    [self.emailTF resignFirstResponder];
    [self.passwordTF resignFirstResponder];
    [self.confirmPassTF resignFirstResponder];
    [self.resetTokenTF resignFirstResponder];
}


- (IBAction)dismissResetPassVC:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)changePassButton:(UIButton *)sender
{
    NSString *errMsg;
    if ([self.resetTokenTF.text isEqualToString:@""]) {
        errMsg = @"Please enter valid reset token.";
        [SharedHelper AlertControllerWithTitle:@"" message:errMsg viewController:self];
    }
    else if ([self.passwordTF.text isEqualToString:@""]) {
        errMsg = @"Please enter valid password.";
        [SharedHelper AlertControllerWithTitle:@"" message:errMsg viewController:self];
    }
    else if (![self.passwordTF.text isEqualToString:self.confirmPassTF.text]) {
        errMsg = @"Your password didn't match with confirm password.";
        [SharedHelper AlertControllerWithTitle:@"" message:errMsg viewController:self];
    }
    else if ([self.confirmPassTF.text isEqualToString:@""]) {
        errMsg = @"Please enter valid confirm password.";
        [SharedHelper AlertControllerWithTitle:@"" message:errMsg viewController:self];
    }
    else{
        
        
        [UserModel resetPasswordForEmail:self.emailStr
                              resetToken:self.resetTokenTF.text
                                password:self.passwordTF.text
                             confirmPass:self.confirmPassTF.text
                                callback:^(id callback) {
                                    NSLog(@"%@",callback);
                                    if ([callback boolValue] == YES) {
                                        
                                        [SVProgressHUD showImage:nil status:@"Password changed successfully.Please login to continue"];
                                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                         [self dismissViewControllerAnimated:YES completion:nil];
                                        });
                                        
                                        
                                        
                                    }
                                }];
    }
    
    
}
@end
