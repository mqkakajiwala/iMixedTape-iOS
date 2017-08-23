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
    NSString *dToken;
}

@end

@implementation SignInVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([FBSDKAccessToken currentAccessToken] != nil) {
        
    }else{
        self.fbLoginButton.delegate = self;
        self.fbLoginButton.readPermissions = @[@"public_profile",@"email"];
    }
    
    //google
    [GIDSignIn sharedInstance].uiDelegate = self;
    [GIDSignIn sharedInstance].delegate = self;
    
    dToken = [[NSUserDefaults standardUserDefaults]valueForKey:key_deviceToken];
    if (dToken == nil) {
        dToken = @"";
    }

    
    
    userModel = [[UserModel alloc]init];
    
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    
    self.emailTextField.delegate = self;
    self.passwordTextField.delegate =self;
    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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

-(void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"Successfully logged out from facebook" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
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
