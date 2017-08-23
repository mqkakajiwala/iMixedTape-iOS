//
//  HomeListVC.h
//  iMixedTape
//
//  Created by Mustafa on 21/12/2016.
//  Copyright © 2016 LemondeIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeListVC : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *myMixedTapeTableView;
@property (strong, nonatomic) IBOutlet UITableView *receivedTapeTableView;
@property (weak, nonatomic) IBOutlet UIView *splitterView;

@end
