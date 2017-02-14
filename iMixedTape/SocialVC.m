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
//    // grab an item we want to share
    UIImage *image = [UIImage imageNamed:@"logoIcon"];
//    NSArray *items = @[image];
//    
//    // build an activity view controller
//    UIActivityViewController *controller = [[UIActivityViewController alloc]initWithActivityItems:items applicationActivities:nil];
//    
//    
//    
//    NSArray *excludeActivities = @[UIActivityTypeAirDrop,
//                                   UIActivityTypeCopyToPasteboard,
//                                   UIActivityTypePrint,
//                                   UIActivityTypeAssignToContact,
//                                   UIActivityTypeSaveToCameraRoll,
//                                   UIActivityTypeAddToReadingList,
//                                   ];
//    
//    controller.excludedActivityTypes = excludeActivities;
//
//    
//    // and present it
//
    
    NSString *text = @"I use iMixedTape to make mixed tapes and share with my friends. I love it! check it out at http://www.imixedtape.com";
   
//    UIImage *image = [UIImage imageNamed:@"roadfire-icon-square-200"];
    
    UIActivityViewController *controller =
    [[UIActivityViewController alloc]
     initWithActivityItems:@[text, image]
     applicationActivities:nil];
    
//    controller.excludedActivityTypes = @[UIActivityTypePostToWeibo,
//                                         UIActivityTypeMessage,
//                                         UIActivityTypePrint,
//                                         UIActivityTypeCopyToPasteboard,
//                                         UIActivityTypeAssignToContact,
//                                         UIActivityTypeSaveToCameraRoll,
//                                         UIActivityTypeAddToReadingList,
//                                         UIActivityTypePostToFlickr,
//                                         UIActivityTypePostToVimeo,
//                                         UIActivityTypePostToTencentWeibo,
//                                         UIActivityTypeAirDrop,
//                                         ];
 
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
//#define YOUR_APP_STORE_ID 545174222 //Change this one to your ID
//    
//    static NSString *const iOS7AppStoreURLFormat = @"itms-apps://itunes.apple.com/app/id%d";
//    static NSString *const iOSAppStoreURLFormat = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%d";
//    
//    [NSURL URLWithString:[NSString stringWithFormat:([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f)? iOS7AppStoreURLFormat: iOSAppStoreURLFormat, YOUR_APP_STORE_ID]]; // Would contain the right link
    
    
}
@end
