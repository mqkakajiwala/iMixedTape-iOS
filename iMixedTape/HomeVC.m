//
//  HomeVC.m
//  iMixedTape
//
//  Created by Mustafa on 06/11/2016.
//  Copyright © 2016 LemondeIT. All rights reserved.
//

#import "HomeVC.h"
#import "PlayTapeVC.h"
#import "HomeGridVC.h"
#import "CreateTapeVC.h"


@interface HomeVC (){
    BOOL selected;
    UIViewController *vc;
    NSString *iTunesLink;
}

@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addViewControllerAsChildVC:@"GRID_VC"];
    
    
    NSLog(@"HOME");
    
    
    [SharedHelper fetchGoogleAdds:self.adBannerView onViewController:self];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        HomeGridVC *hg = self.tabBarController.viewControllers[0].childViewControllers[0];
        [hg getWebserviceDataOnLoad];
    });
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
        
    UserModel *userModel = [[UserModel alloc]init];
    
    if (userModel.firstName != nil) {
        self.nameLabel.text = [NSString stringWithFormat:@"%@ %@",userModel.firstName,userModel.lastName];
    }else{
        self.nameLabel.text = @"";
    }
}

#pragma mark - IBActions
- (IBAction)mixedTapeLogoButton:(UIButton *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://imixedtape.com"]];
}

- (IBAction)gridButtonPressed:(UIButton *)sender
{
    
    [self changeButtonImageUponSelection:sender buttonType:@"GRID"];
    [self addViewControllerAsChildVC:@"GRID_VC"];
}

- (IBAction)listButtonPressed:(UIButton *)sender
{
    [self changeButtonImageUponSelection:sender buttonType:@"LIST"];
    [self addViewControllerAsChildVC:@"LIST_VC"];
}

- (IBAction)shareButtonPressed:(UIButton *)sender
{
    UIViewController *vcc = [self.storyboard instantiateViewControllerWithIdentifier:@"SOCIAL_VC"];
    [self presentViewController:vcc animated:YES completion:nil];
}

#pragma mark - Child ViewControllers

-(void)addViewControllerAsChildVC :(NSString *)identifier
{
    
    vc = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
    
    
    [self addChildViewController:vc];
    
    [self.parentView addSubview:vc.view];
    
    
    vc.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth |
                                UIViewAutoresizingFlexibleHeight);
    vc.view.frame = self.parentView.bounds;
}

#pragma mark - change button image upon selection

-(void)changeButtonImageUponSelection :(UIButton *)sender buttonType:(NSString *)type
{
    if ([type isEqualToString:@"GRID"]) {
        [self.gridButtonOutlet setImage:[UIImage imageNamed:@"gridactive"] forState:UIControlStateNormal];
        
        [self.listButtonOutlet setImage:[UIImage imageNamed:@"listinactive"] forState:UIControlStateNormal];
    }else{
        [self.gridButtonOutlet setImage:[UIImage imageNamed:@"gridinactive"] forState:UIControlStateNormal];
        
        [self.listButtonOutlet setImage:[UIImage imageNamed:@"listactive"] forState:UIControlStateNormal];
    }
    
    
}

-(IBAction)unwindSegueToClone :(UIStoryboardSegue *)segue
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.tabBarController.selectedIndex = 1;
    });
    
}

//-(IBAction)unwindToPlayTape:(UIStoryboardSegue *)segue
//{
//    PlayTapeVC *playvc = [self.storyboard instantiateViewControllerWithIdentifier:@"PLAYTAPEVC"];
//    
//    [self presentViewController:playvc animated:YES completion:nil];
//}


@end
