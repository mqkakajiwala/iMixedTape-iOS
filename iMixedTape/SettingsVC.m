//
//  SettingsVC.m
//  iMixedTape
//
//  Created by Mustafa on 25/12/2016.
//  Copyright © 2016 LemondeIT. All rights reserved.
//

#import "SettingsVC.h"
#import "SignInVC.h"
#import "FetchTapesModel.h"


@interface SettingsVC (){
    UserModel *userModel;
}

@end

@implementation SettingsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
  
  
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    userModel = [[UserModel alloc]init];
    
    if (userModel.isLoggedIn) {
        [self.signInButtonOutlet setEnabled:NO];
        [self.logOutButtonOutlet setEnabled:YES];
        [self.setupButtonOutlet setEnabled:NO];
        [self.preferencesBtnOutlet setEnabled:YES];

    }else{
        [self.signInButtonOutlet setEnabled:YES];
        [self.logOutButtonOutlet setEnabled:NO];
        [self.setupButtonOutlet setEnabled:YES];
        [self.preferencesBtnOutlet setEnabled:NO];

    }
    
}

- (IBAction)signInButton:(UIButton *)sender
{
   
}

- (IBAction)logOutButton:(UIButton *)sender
{
    [userModel logoutUserSession];
    
    [FetchTapesModel sharedInstance].myCretedTapesArray = [[NSMutableArray alloc]init];
    [FetchTapesModel sharedInstance].sharedTapesArray = [[NSMutableArray alloc]init];
    
    [sender setEnabled:NO];
    
    [self.signInButtonOutlet setEnabled:YES];
    [self.setupButtonOutlet setEnabled:YES];
    [self.preferencesBtnOutlet setEnabled:NO];

    [FBSDKAccessToken setCurrentAccessToken:nil];
    
    [CreateTapeModel resetCreateTapeModel];
    
}

- (IBAction)preferencesButton:(UIButton *)sender
{
    
}

- (IBAction)socialButton:(UIButton *)sender
{
    UIViewController *vcc = [self.storyboard instantiateViewControllerWithIdentifier:@"SOCIAL_VC"];
    [self presentViewController:vcc animated:YES completion:nil];
}

- (IBAction)mixedTapeLogoBtn:(UIButton *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://imixedtape.com"]];
}
@end
