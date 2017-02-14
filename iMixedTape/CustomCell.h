//
//  CustomCell.h
//  iMixedTape
//
//  Created by Mustafa Qutbuddin on 12/29/16.
//  Copyright © 2016 LemondeIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *cardView;
@property (strong, nonatomic) IBOutlet UIImageView *albumArtImageView;
@property (strong, nonatomic) IBOutlet UILabel *songTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *songDecLabel;
@property (strong, nonatomic) IBOutlet UILabel *songTimeLabel;
@property (strong, nonatomic) IBOutlet UIButton *songAddButon;

@end
