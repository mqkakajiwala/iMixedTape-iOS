//
//  SocialVC.h
//  iMixedTape
//
//  Created by Mustafa Qutbuddin on 12/29/16.
//  Copyright © 2016 LemondeIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SocialVC : UIViewController


@property (weak, nonatomic) IBOutlet UIBarButtonItem *actionBarItem;
- (IBAction)dismissVCButton:(UIBarButtonItem *)sender;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *mixedTapeLogoTopConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tellFriendsViewTopConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *rateBoxTopConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *applogoTopConstraint;
@property (strong, nonatomic) IBOutlet GADBannerView *adBannerView;
@property (strong, nonatomic) IBOutlet UIButton *OnestarBtn;
@property (strong, nonatomic) IBOutlet UIButton *twostarBtn;
@property (strong, nonatomic) IBOutlet UIButton *threeStarBtn;
@property (strong, nonatomic) IBOutlet UIButton *fourStarBtn;
@property (strong, nonatomic) IBOutlet UIButton *fiveStarBtn;
@property (strong, nonatomic) IBOutlet UIView *starsView;





- (IBAction)rateStarsPressed:(UIButton *)sender;
- (IBAction)noThanksButton:(UIButton *)sender;
- (IBAction)rateButton:(UIButton *)sender;

@end
