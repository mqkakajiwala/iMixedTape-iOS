//
//  MeshVC.m
//  iMixedTape
//
//  Created by Mustafa on 20/06/2017.
//  Copyright © 2017 LemondeIT. All rights reserved.
//

#import "MeshVC.h"
#import "TabBarControllerSubClass.h"

@interface MeshVC ()

@end

@implementation MeshVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (IBAction)gotItButton:(UIButton *)sender {
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"mesh"];
    
//    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"main" bundle:nil];
    TabBarControllerSubClass *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"TABVC"];
    
    
//    myAppDelegate.window.rootViewController = vc;
    [self presentViewController:vc animated:YES completion:nil];
    
}

@end
