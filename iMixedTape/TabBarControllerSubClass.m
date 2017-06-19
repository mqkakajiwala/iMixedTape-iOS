//
//  TabBarControllerSubClass.m
//  iMixedTape
//
//  Created by Mustafa on 12/12/2016.
//  Copyright © 2016 LemondeIT. All rights reserved.
//

#import "TabBarControllerSubClass.h"
#import "PlayTapeVC.h"

@interface TabBarControllerSubClass ()

@end

@implementation TabBarControllerSubClass

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    CGFloat numberOFItems = self.tabBar.items.count;
    CGSize tabBarItemSize = CGSizeMake(self.tabBar.frame.size.width/numberOFItems, self.tabBar.frame.size.height);
    
    self.tabBar.selectionIndicatorImage = [[self imageWithColor:[UIColor colorWithRed:0.714 green:0.024 blue:0.075 alpha:1.00] size:tabBarItemSize]resizableImageWithCapInsets:UIEdgeInsetsZero];
    
    //    self.tabBar.frame.size.width = self.view.frame.size.width +4;
    //    self.tabBar.frame.origin.x = -2;
    
    
    
}

-(UIImage *)imageWithColor :(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [color setFill];
    UIRectFill(rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    MPMusicPlayerController *musicPlayer = [MPMusicPlayerController systemMusicPlayer];
    
    if ([item.title isEqualToString:@"Play Mixed Tape"]) {
        
    
        if (musicPlayer.playbackState == MPMusicPlaybackStatePlaying) {
            PlayTapeVC *playVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PLAYTAPEVC"];
            
            
            [self presentViewController:playVC animated:YES completion:nil];
        }
        
    }
    
}





@end
