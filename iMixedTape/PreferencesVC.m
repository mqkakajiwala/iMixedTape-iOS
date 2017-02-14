//
//  PreferencesVC.m
//  iMixedTape
//
//  Created by Mustafa on 28/01/2017.
//  Copyright © 2017 LemondeIT. All rights reserved.
//

#import "PreferencesVC.h"

@interface PreferencesVC ()

@end

@implementation PreferencesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    
    
    [self.view addGestureRecognizer:tap];
}

-(void)dismissKeyboard
{
    [self.passwordTF resignFirstResponder];
    [self.confirmPassTF resignFirstResponder];
}


- (IBAction)changePasswordButton:(UIButton *)sender
{
    NSString *errMsg;
    if ([self.passwordTF.text isEqualToString:@""]) {
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
        [UserModel changeUserPassword:self.passwordTF.text confirmPass:self.confirmPassTF.text callback:^(id callback) {
            NSLog(@"%@",callback);
            if ([callback boolValue] == YES) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Password changed successfully." preferredStyle:UIAlertControllerStyleAlert];
                
                [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    [self.navigationController popViewControllerAnimated:YES];
                }]];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }];
    }
}

@end
