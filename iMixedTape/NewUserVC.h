//
//  NewUserVC.h
//  iMixedTape
//
//  Created by Mustafa Qutbuddin on 12/26/16.
//  Copyright © 2016 LemondeIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <Google/SignIn.h>
@interface NewUserVC : UIViewController<FBSDKLoginButtonDelegate,UITextFieldDelegate,GIDSignInUIDelegate,GIDSignInDelegate>



@property (weak, nonatomic) IBOutlet FBSDKLoginButton *fbLoginButton;
@property(weak, nonatomic) IBOutlet GIDSignInButton *googleSignInButton;
@property (weak, nonatomic) IBOutlet UITextField *fNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *LNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *userIDTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;
@property (weak, nonatomic) IBOutlet UISwitch *touchIDSwitch;

- (IBAction)signInButton:(UIButton *)sender;



@end
