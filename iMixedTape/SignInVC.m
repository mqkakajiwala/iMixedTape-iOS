//
//  SignInVC.m
//  iMixedTape
//
//  Created by Mustafa on 25/12/2016.
//  Copyright © 2016 LemondeIT. All rights reserved.
//

#import "SignInVC.h"
#import "ResetPasswordVC.h"
#import "HomeGridVC.h"



@interface SignInVC (){
    UserModel *userModel;
    
}

@end

@implementation SignInVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    userModel = [[UserModel alloc]init];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    self.emailTextField.delegate = self;
    self.passwordTextField.delegate =self;
    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)dismissKeyboard
{
    [self.emailTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}

- (IBAction)signInButton:(UIButton *)sender
{
    
    // Trim data inputted from form
    NSString *email = [self.emailTextField.text stringByTrimmingCharactersInSet : [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    
    
    // Validating username
    BOOL emailValid = [SharedHelper validateEmail : email
                                         required : YES
                                         minChars : 1
                                         maxChars : 100];
    // Validating password
    BOOL pwdValid = [SharedHelper validatePassword: self.passwordTextField.text
                                         required : YES
                                         minChars : 6
                                         maxChars : 45];
    // Used for error messages
    NSString *errMsg;
    
    if (!emailValid) {
        // Error message for invalid email
        errMsg = @"Please enter a valid email.";
        
    } else if (!pwdValid) {
        // Error message for invalid password
        errMsg = @"Please enter a valid password.";
        
    } else {
        
        [UserModel postUserSessionWithEmail:self.emailTextField.text
                                   password:self.passwordTextField.text
                             viewController:self
                                    success:^(id responseObject) {
                                        NSLog(@"%@",responseObject);
                                        
                                        if ([responseObject[@"data"] isKindOfClass:[NSDictionary class]]) {
                                            
                                            
                                            NSData *encodedData = [NSKeyedArchiver archivedDataWithRootObject:responseObject[@"data"]];
                                            [[NSUserDefaults standardUserDefaults]setObject:encodedData forKey:key_userData];
                                            [self.navigationController popViewControllerAnimated:YES];
                                            
                                            HomeGridVC *hg = self.tabBarController.viewControllers[0].childViewControllers[0];
                                            
                                            
                                                [hg getWebserviceDataOnLoad];
                                                self.tabBarController.selectedIndex = 0;
                                            
                                        }
                                        else{
                                            [SharedHelper AlertControllerWithTitle:@"" message:@"Incorrect email or password" viewController:self];
                                        }
                                    }];
        
        
        
    }
    
    // Show alert if there's an error when submitting the form
    if (errMsg) {
        [self.emailTextField becomeFirstResponder];
        [SharedHelper AlertControllerWithTitle:@"" message:errMsg viewController:self];
    }
    
   
    
}

- (IBAction)forgotPasswordButton:(UIButton *)sender
{
    // Trim data inputted from form
    NSString *email = [self.emailTextField.text stringByTrimmingCharactersInSet : [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    // Validating username
    BOOL emailValid = [SharedHelper validateEmail : email
                                         required : YES
                                         minChars : 1
                                         maxChars : 100];
    
    if ([self.emailTextField.text isEqualToString:@""] || !emailValid) {
        [SharedHelper AlertControllerWithTitle:@"" message:@"Please enter a valid email." viewController:self];
    }else{
        [UserModel forgotPasswordAPIForEmail:self.emailTextField.text viewController:self  callback:^(id callback) {
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@""
                                                                                      message:[NSString stringWithFormat:@"%@, Please fill the required fields accordingly.",callback]
                                                                               preferredStyle:UIAlertControllerStyleAlert];
            
            [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                ResetPasswordVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"RESET_PASS_VC"];
                vc.emailStr = self.emailTextField.text;
                [self presentViewController :vc animated:YES completion:nil];
            }]];
            
            
     
            [self presentViewController:alertController animated:YES completion:nil];
    
        }];
        
        
    }
}

-(void)emptyFieldsCheck :(UITextField *)TF
{
    if ([TF.text isEqualToString:@""]) {
        
    }
}
@end
