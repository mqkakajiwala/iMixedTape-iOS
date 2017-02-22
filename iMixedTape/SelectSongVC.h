//
//  SelectSongVC.h
//  iMixedTape
//
//  Created by Mustafa on 05/01/2017.
//  Copyright © 2017 LemondeIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectSongVC : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *tapeTitle;
@property (strong,nonatomic) NSString *tapeTitleString;
@property (strong, nonatomic) IBOutlet UILabel *tapeArtist;
@property (strong, nonatomic) IBOutlet UILabel *tapeGenre;
@property (strong, nonatomic) IBOutlet UILabel *tapeMessage;
@property (strong,nonatomic) NSString *tapeMessageString;
@property (strong,nonatomic) NSString *imageToken;
@property (strong, nonatomic) IBOutlet UIImageView *tapeImage;
@property (strong, nonatomic) IBOutlet UILabel *tapeOwnerNameLabel;
@property (strong,nonatomic) NSString *tapeOwnerNameString;
@property (strong,nonatomic) NSString *selectedTapeID;
@property (strong, nonatomic) IBOutlet TriLabelView *titleView;
@property (strong,nonatomic) NSNumber *tapeStatus;
@property (weak, nonatomic) IBOutlet UIView *tapeStatusView;
@property(strong,nonatomic) NSString *selectedTapeSharedID;


- (IBAction)acceptTapeButton:(UIButton *)sender;
- (IBAction)rejectTapeButton:(UIButton *)sender;
- (IBAction)cloneTapeButton:(UIButton *)sender;


@end
