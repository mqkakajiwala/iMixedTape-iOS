//
//  ListCell.h
//  iMixedTape
//
//  Created by Mustafa on 21/12/2016.
//  Copyright © 2016 LemondeIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *albumArtImageView;
@property (strong, nonatomic) IBOutlet UILabel *titleTextLabel;
@property (strong, nonatomic) IBOutlet UIButton *addTracksButton;

@property (strong, nonatomic) IBOutlet UIView *cardView;
@end
