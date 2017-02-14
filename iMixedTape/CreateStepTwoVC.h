//
//  CreateStepTwoVC.h
//  iMixedTape
//
//  Created by Mustafa on 25/12/2016.
//  Copyright © 2016 LemondeIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateStepTwoVC : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *myTapesButtonOutlet;
@property (strong, nonatomic) IBOutlet UIButton *albumsButtonOutlet;
@property (strong, nonatomic) IBOutlet UIButton *songsButtonOutlet;
@property (strong, nonatomic) IBOutlet UIButton *streamingButtonOutlet;
@property (strong, nonatomic) IBOutlet UIView *myView;

//@property(strong,nonatomic) UISearchController *searchController;
@end
