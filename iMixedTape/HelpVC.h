//
//  HelpVC.h
//  iMixedTape
//
//  Created by Mustafa on 04/11/2016.
//  Copyright © 2016 LemondeIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HelpVC : UIViewController


@property (weak, nonatomic) IBOutlet UIView *parentView;
@property (weak, nonatomic) IBOutlet UIView *buttonsView;
@property (weak, nonatomic) IBOutlet UIButton *legalButtonOutlet;
@property (strong, nonatomic) IBOutlet GADBannerView *adBannerView;



- (IBAction)legalButton:(UIButton *)sender;
- (IBAction)howItWorksButton:(UIButton *)sender;
- (IBAction)aboutUsButton:(UIButton *)sender;
- (IBAction)faqButton:(UIButton *)sender;
- (IBAction)socialButtonPressed:(UIButton *)sender;

@end
