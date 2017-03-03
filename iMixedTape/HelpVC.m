//
//  HelpVC.m
//  iMixedTape
//
//  Created by Mustafa on 04/11/2016.
//  Copyright © 2016 LemondeIT. All rights reserved.
//

#import "HelpVC.h"

@interface HelpVC ()

@end

@implementation HelpVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self loadChildViewsWithIndexOf:0];
        [self.legalButtonOutlet setSelected:YES];
        [self.legalButtonOutlet setBackgroundColor:[UIColor blackColor]];
    });
    
       [SharedHelper fetchGoogleAdds:self.adBannerView onViewController:self];
}


#pragma mark - IBActions
- (IBAction)legalButton:(UIButton *)sender
{
    
   [SharedHelper changeButtonBackgroundOnSelection:sender :self.buttonsView];
    
    [self loadChildViewsWithIndexOf:0];
}

- (IBAction)howItWorksButton:(UIButton *)sender
{
    
    [SharedHelper changeButtonBackgroundOnSelection:sender :self.buttonsView];
    
    
    [self loadChildViewsWithIndexOf:1];
}

- (IBAction)aboutUsButton:(UIButton *)sender
{
    [SharedHelper changeButtonBackgroundOnSelection:sender :self.buttonsView];
    
    
    [self loadChildViewsWithIndexOf:2];
}

- (IBAction)faqButton:(UIButton *)sender
{
    [SharedHelper changeButtonBackgroundOnSelection:sender :self.buttonsView];
    
    
    [self loadChildViewsWithIndexOf:3];
}

- (IBAction)socialButtonPressed:(UIButton *)sender
{
    UIViewController *vcc = [self.storyboard instantiateViewControllerWithIdentifier:@"SOCIAL_VC"];
  
    [self presentViewController:vcc animated:YES completion:nil];
}


#pragma mark - Change child views on button click
-(void)loadChildViewsWithIndexOf :(int)index
{
    dispatch_async(dispatch_get_main_queue(), ^{
    UIView *view;
    [view removeFromSuperview];
    view = [[[NSBundle mainBundle]loadNibNamed:@"HelpScreenChildViews" owner:self options:nil]objectAtIndex:index];
    
    
    
        view.frame = self.parentView.bounds;
        [self.parentView addSubview:view];
    });
}
@end
