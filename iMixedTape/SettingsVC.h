//
//  SettingsVC.h
//  iMixedTape
//
//  Created by Mustafa on 25/12/2016.
//  Copyright © 2016 LemondeIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsVC : UIViewController

- (IBAction)signInButton:(UIButton *)sender;
- (IBAction)preferencesButton:(UIButton *)sender;
- (IBAction)socialButton:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIButton *logOutButtonOutlet;
@property (strong, nonatomic) IBOutlet UIButton *setupButtonOutlet;

@property (strong, nonatomic) IBOutlet UIButton *signInButtonOutlet;
@property (strong, nonatomic) IBOutlet UIButton *preferencesBtnOutlet;


@end
