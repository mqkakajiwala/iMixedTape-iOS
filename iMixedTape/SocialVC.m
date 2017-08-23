//
//  SocialVC.m
//  iMixedTape
//
//  Created by Mustafa Qutbuddin on 12/29/16.
//  Copyright © 2016 LemondeIT. All rights reserved.
//

#import "SocialVC.h"


@interface SocialVC ()

@end

@implementation SocialVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        [self.actionBarItem setEnabled:NO];
        [self.actionBarItem setTintColor: [UIColor clearColor]];
    }
    
    if (IS_IPHONE_5) {
        self.mixedTapeLogoTopConstraint.constant = 0;
        
        self.tellFriendsViewTopConstraint.constant = 10;
        self.applogoTopConstraint.constant = 0;
        self.rateBoxTopConstraint.constant = 0;
    }
    
       [SharedHelper fetchGoogleAdds:self.adBannerView onViewController:self];
}


- (IBAction)followSocialPages:(UIButton *)sender
{
    NSString *pageURL;
    switch (sender.tag) {
        case 1:
            pageURL = @"https://www.facebook.com/IMixedTape/";
            break;
        case 2:
            pageURL = @"https://twitter.com/imixedtape";
            break;
        case 3:
            pageURL = @"";
            break;
        case 4:
            pageURL = @"";
            break;
        case 5:
            pageURL = @"https://www.instagram.com/imixedtape/";
            break;
        case 6:
            pageURL = @"https://www.pinterest.com/imixedtape/";
            break;
            
        default:
            break;
    }
    [self openPageURL:pageURL];
    
    

}

- (IBAction)tellFriendsButton:(UIButton *)sender
{
    //NSURL *instagramURL = [NSURL URLWithString:@"instagram://location?id=1"];
    
    
    //switch (sender.tag) {
       // case 501:
            [self openActivityController];
         //   break;
       // case 502:
            
        //    break;
        //case 503:
           // if ([[UIApplication sharedApplication] canOpenURL:instagramURL]) {
             //   [[UIApplication sharedApplication] openURL:instagramURL];
         //   }
      //      break;
     //   case 504:
            
        //    break;
            
      //  default:
          //  break;
  //  }

}

-(void)openActivityController
{
    UIImage *image = [UIImage imageNamed:@"logoIcon"];
    
    
    NSString *text = @"I use iMixedTape to make mixed tapes and share with my friends. I love it! check it out at http://www.imixedtape.com";
    
    UIActivityViewController *controller =
    [[UIActivityViewController alloc]
     initWithActivityItems:@[text, image]
     applicationActivities:nil];
    

    
    [self presentActivityController:controller];
}

-(void)openPageURL :(NSString *)url
{
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:url]
                                      options:@{} completionHandler:nil];
}


- (void)presentActivityController:(UIActivityViewController *)controller {
    
    // for iPad: make the presentation a Popover
    controller.modalPresentationStyle = UIModalPresentationPopover;
    [self presentViewController:controller animated:YES completion:nil];
    
    UIPopoverPresentationController *popController = [controller popoverPresentationController];
    popController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    popController.barButtonItem = self.actionBarItem;
    
    // access the completion handler
    controller.completionWithItemsHandler = ^(NSString *activityType,
                                              BOOL completed,
                                              NSArray *returnedItems,
                                              NSError *error){
        // react to the completion
        if (completed) {
            
            // user shared an item
            NSLog(@"We used activity type%@", activityType);
            
        } else {
            
            // user cancelled
            NSLog(@"We didn't want to share anything after all.");
        }
        
        if (error) {
            NSLog(@"An Error occured: %@, %@", error.localizedDescription, error.localizedFailureReason);
        }
    };
}
- (IBAction)dismissVCButton:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)rateStarsPressed:(UIButton *)sender
{
    
    for (UIButton *btnss in self.starsView.subviews) {
        [btnss setImage:[UIImage imageNamed:@"star"] forState:UIControlStateNormal];
    }
    
    for (int i=1; i<=sender.tag; i++) {
        
        UIButton *btn = (UIButton *)[self.starsView viewWithTag:i];
        [btn setImage:[UIImage imageNamed:@"star_filled"] forState:UIControlStateNormal];
    }
    
    
}

- (IBAction)noThanksButton:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)rateButton:(UIButton *)sender
{
}

- (IBAction)mixedTapeLogoBtn:(UIButton *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://imixedtape.com"]];
}
    
    

@end
