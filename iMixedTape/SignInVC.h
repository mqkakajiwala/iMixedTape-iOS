//
//  SignInVC.h
//  iMixedTape
//
//  Created by Mustafa on 25/12/2016.
//  Copyright © 2016 LemondeIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <Google/SignIn.h>

@interface SignInVC : UIViewController<UITextFieldDelegate,FBSDKLoginButtonDelegate,GIDSignInUIDelegate,GIDSignInDelegate>

@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
- (IBAction)signInButton:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet FBSDKLoginButton *fbLoginButton;
@property(weak, nonatomic) IBOutlet GIDSignInButton *googleSignInButton;
@end
