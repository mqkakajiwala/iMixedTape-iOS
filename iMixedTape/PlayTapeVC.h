//
//  PlayTapeVC.h
//  iMixedTape
//
//  Created by Mustafa on 05/01/2017.
//  Copyright © 2017 LemondeIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayTapeVC : UIViewController

@property (strong,nonatomic) NSString *testName;



@property (strong, nonatomic) IBOutlet NSLayoutConstraint *scrollBottomConstraint;
//@property (strong,nonatomic) NSString *tapeMessageStr;
@property (strong, nonatomic) IBOutlet UILabel *tapeMessageLabel;
@property (strong, nonatomic) IBOutlet UIImageView *songAlbumArtImageView;
//@property (strong,nonatomic) UIImage *albumArtImage;
//@property (strong,nonatomic) NSString *nextSongStr;
@property (strong, nonatomic) IBOutlet UILabel *nextSongLabel;
//@property (strong,nonatomic) NSString *currentSongStr;
@property (strong, nonatomic) IBOutlet UILabel *currentSongLabel;
//@property (strong,nonatomic) NSString *songDurationStr;
@property (strong, nonatomic) IBOutlet UILabel *songTimerLabel;
@property (strong, nonatomic) IBOutlet UISlider *songSlider;
@property (strong, nonatomic) IBOutlet UISlider *volumeSlider;
@property (strong, nonatomic) IBOutlet UIButton *playButtonOutlet;
//@property (strong,nonatomic) NSString *artistStr;
//@property (strong,nonatomic) MPMediaItem *nextSongMPMediaItem;
//@property(strong,nonatomic) NSString *songID;
@property (strong, nonatomic) IBOutlet TriLabelView *triLabelView;
//@property (strong,nonatomic) NSString *tapeTitleStr;
@property (strong, nonatomic) IBOutlet GADBannerView *adBannerView;
//@property (strong,nonatomic) NSArray *queueSongArray;
//@property (strong,nonatomic) NSString *imgToken;








- (IBAction)dismissPlayTape:(UIBarButtonItem *)sender;

- (IBAction)nextButton:(UIButton *)sender;

- (IBAction)playButton:(UIButton *)sender;

- (IBAction)prevButton:(UIButton *)sender;

- (IBAction)openSocialPageButton:(UIButton *)sender;
- (IBAction)mixedTapeLogoBtn:(UIButton *)sender;

@end
