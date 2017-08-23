//
//  HomeVC.h
//  iMixedTape
//
//  Created by Mustafa on 06/11/2016.
//  Copyright © 2016 LemondeIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeVC : UIViewController

@property (weak, nonatomic) IBOutlet UIView *parentView;
@property (weak, nonatomic) IBOutlet UIButton *gridButtonOutlet;
@property (weak, nonatomic) IBOutlet UIButton *listButtonOutlet;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet GADBannerView *adBannerView;


- (IBAction)mixedTapeLogoButton:(UIButton *)sender;

- (IBAction)gridButtonPressed:(UIButton *)sender;
- (IBAction)listButtonPressed:(UIButton *)sender;
- (IBAction)shareButtonPressed:(UIButton *)sender;

@end
