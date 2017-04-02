//
//  NewUserVC.m
//  iMixedTape
//
//  Created by Mustafa Qutbuddin on 12/26/16.
//  Copyright © 2016 LemondeIT. All rights reserved.
//

#import "NewUserVC.h"
#import "HomeGridVC.h"


@interface NewUserVC (){
    NSString *dToken;
    
}

@end

@implementation NewUserVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([FBSDKAccessToken currentAccessToken] != nil) {
        
    }else{
        self.fbLoginButton.delegate = self;
        self.fbLoginButton.readPermissions = @[@"public_profile",@"email"];
    }
    
    NSLog(@"MUSTAFA");
    
    [self setDelegateOfTextFields];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    
    
    
    //google
    [GIDSignIn sharedInstance].uiDelegate = self;
    [GIDSignIn sharedInstance].delegate = self;
    
    dToken = [[NSUserDefaults standardUserDefaults]valueForKey:key_deviceToken];
    if (dToken == nil) {
        dToken = @"";
    }
}

#pragma mark - Google signin methods
-(void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error
{
    if (error !=nil) {
        NSLog(@"%@",error.localizedDescription);
    }else{
        NSLog(@"%@",user.userID);                  // For client-side use only!
        NSLog(@"%@",user.authentication.idToken); // Safe to send to the server
        NSLog(@"%@",user.profile.name);
        NSLog(@"%@",user.profile.givenName);
        NSLog(@"%@",user.profile.familyName);
        NSLog(@"%@",user.profile.email);
        
        NSDictionary *result = @{@"name" : user.profile.givenName,
                                 @"last_name" : user.profile.familyName,
                                 @"email" : user.profile.email,
                                 @"oauth_provider" : @"google",
                                 @"oauth_uid" : user.authentication.idToken
                                 };
        
        //  [self askForPasswordWhenExternalLogin:result];
        [self userLoginSessionWithFirstName:result[@"name"]
                                      lName:result[@"last_name"]
                                      email:result[@"email"]
                                       pass:@""
                                      phone:@""
                             oauth_provider:result[@"oauth_provider"]
                                  oauth_uid:result[@"oauth_uid"]
         ];
        
        
    }
}

-(void)setDelegateOfTextFields
{
    self.fNameTextField.delegate = self;
    self.LNameTextField.delegate = self;
    self.userIDTextField.delegate = self;
    self.phoneTextField.delegate = self;
    self.emailTextField.delegate = self;
    self.passwordTextField.delegate = self;
    self.confirmPasswordTextField.delegate = self;
}

-(void)dismissKeyboard
{
    [self.fNameTextField resignFirstResponder];
    [self.LNameTextField resignFirstResponder];
    [self.userIDTextField resignFirstResponder];
    [self.phoneTextField resignFirstResponder];
    [self.emailTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    [self.confirmPasswordTextField resignFirstResponder];
}



#pragma mark - Facebook Delegate Methods

-(void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error
{
    if (error) {
        NSLog(@"%@",error.localizedDescription);
    }else{
        [self getUserINFO];
    }
}

-(void)getUserINFO
{
    if ([FBSDKAccessToken currentAccessToken]) {
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"/me"
                                           parameters:@{@"fields": @"email, name, first_name, last_name, picture.type(large), id , cover"
                                                        }]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error) {
                 
                 NSLog(@"%@",result);
                 
                 [self userLoginSessionWithFirstName:result[@"name"]
                                               lName:result[@"last_name"]
                                               email:result[@"email"]
                                                pass:@""
                                               phone:@""
                                      oauth_provider:@"facebook"
                                           oauth_uid:result[@"id"]];
                 
                 
             }
         }];
    }
    
}

-(void)askForPasswordWhenExternalLogin :(id)result
{
    //    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"Login"
    //                                                                              message: @"Input username and password"
    //                                                                       preferredStyle:UIAlertControllerStyleAlert];
    //
    //    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
    //        textField.placeholder = @"password";
    //        textField.textColor = [UIColor blueColor];
    //        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    //        textField.borderStyle = UITextBorderStyleRoundedRect;
    //        textField.secureTextEntry = YES;
    //    }];
    //    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
    //        textField.placeholder = @"phone";
    //        textField.textColor = [UIColor blueColor];
    //        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    //        textField.borderStyle = UITextBorderStyleRoundedRect;
    //        textField.secureTextEntry = YES;
    //    }];
    //    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    //        NSArray * textfields = alertController.textFields;
    //        UITextField * passwordField = textfields[0];
    //        UITextField * phoneField = textfields[1];
    //        NSLog(@"%@:%@",passwordField.text,phoneField.text);
    
    //    }]];
    //    [self presentViewController:alertController animated:YES completion:nil];
    
    
    
}

-(void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"Successfully logged out from facebook" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}


#pragma mark - SignIn Button
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
        errMsg = @"Please Enter a valid Email.";
        
    } else if (!pwdValid) {
        // Error message for invalid password
        errMsg = @"Please Enter a valid Password.";
        
    } else if ([_fNameTextField.text isEqualToString:@""]) {
        // Error message for invalid password
        errMsg = @"Please Enter a valid First Name.";
        
    } else if ([_LNameTextField.text isEqualToString:@""]) {
        // Error message for invalid password
        errMsg = @"Please Enter a valid Last Name.";
        
    } else if ([_confirmPasswordTextField.text isEqualToString:@""]) {
        // Error message for invalid password
        errMsg = @"Please Confirm Password.";
        
    } else if ([_phoneTextField.text isEqualToString:@""]) {
        // Error message for invalid password
        errMsg = @"Please Enter a valid Phone.";
        
    }
    else {
        
        [self userLoginSessionWithFirstName:self.fNameTextField.text
                                      lName:self.LNameTextField.text
                                      email:self.emailTextField.text
                                       pass:self.passwordTextField.text
                                      phone:self.phoneTextField.text
                             oauth_provider:@""
                                  oauth_uid:@""];
        
        
    }
    
    // Show alert if there's an error when submitting the form
    if (errMsg) {
        [self.emailTextField becomeFirstResponder];
        [SharedHelper AlertControllerWithTitle:@"" message:errMsg viewController:self];
    }
    
    
    
}

-(void)userLoginSessionWithFirstName :(NSString *)fname lName :(NSString *)lname email:(NSString *)email pass:(NSString *)pass phone:(NSString *)phone oauth_provider:(NSString *)oauth_provider oauth_uid:(NSString *)oauth_uid
{
    NSLog(@"%@",email);
    [NewUserModel postUserSessionWithName:fname
                                    lname:lname
                                    email:email
                                 password:pass
                                   gender:@""
                                      dob:@""
                                 deviceID:@"asdasdasd"
                              deviceToken:@"asdasd"
                                 platform:@"iOS"
                                  country:@""
                                     city:@""
                                    state:@""
                                    phone:phone
                           oauth_provider:oauth_provider
                                oauth_uid:oauth_uid
                                  zipcode:@""
                           viewController:self
                                         :^(id callback) {
                                             NSLog(@"%@",callback);
                                             if ([callback isKindOfClass:[NSDictionary class]]) {
                                                 
                                                 
                                                 NSData *encodedData = [NSKeyedArchiver archivedDataWithRootObject:callback];
                                                 [[NSUserDefaults standardUserDefaults]setObject:encodedData forKey:key_userData];
                                                 [self.navigationController popViewControllerAnimated:YES];
                                                 
                                                 HomeGridVC *hg = self.tabBarController.viewControllers[0].childViewControllers[0];
                                                 
                                                 
                                                 [hg getWebserviceDataOnLoad];
                                                 self.tabBarController.selectedIndex = 0;

                                             }else{
                                                 if ([[callback firstObject] isKindOfClass:[NSString class]]) {
                                                     [SharedHelper AlertControllerWithTitle:@"" message:[callback firstObject] viewController:self];
                                                 }
                                                 
                                             }
                                         }
     
     
     ];
    
    
    
    
    
    
}
@end
