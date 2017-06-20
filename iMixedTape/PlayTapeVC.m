//
//  PlayTapeVC.m
//  iMixedTape
//
//  Created by Mustafa on 05/01/2017.
//  Copyright © 2017 LemondeIT. All rights reserved.
//

#import "PlayTapeVC.h"
#import "FetchTracksModel.h"
#import "PlayTapeModel.h"
@interface PlayTapeVC (){
    MPMusicPlayerController *musicPlayer;
    NSTimer *timer;
    PlayTapeModel *playModel;
}

@end

@implementation PlayTapeVC

#pragma mark - View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    playModel = [PlayTapeModel sharedInstance];
    
    musicPlayer = [MPMusicPlayerController systemMusicPlayer];
    [self registerMediaPlayerNotifications];
    
    
    [SharedHelper fetchGoogleAdds:self.adBannerView onViewController:self];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //    musicPlayer = nil;
    
    if (IS_IPHONE_5) {
        self.scrollBottomConstraint.constant = 50;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (playModel != nil) {
            
            if (musicPlayer.playbackState == MPMusicPlaybackStatePlaying) {
                [self.playButtonOutlet setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
            }else{
                [self.playButtonOutlet setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
            }
            
//            self.songAlbumArtImageView.image = self.albumArtImage;//[self getAlbumArtworkWithSize:self.songAlbumArtImageView.frame.size :self.currentSongStr];
            if (![[playModel getUserSessionForKey:@"imageToken"] isKindOfClass:[NSNull class]]) {
                
                
                [self.songAlbumArtImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://staging.imixedtape.com/image/%@/%dx%d",[playModel getUserSessionForKey:@"imageToken"],100,100]] placeholderImage:[UIImage imageNamed:@"logoIconFull"]];
                
            }else{
                self.songAlbumArtImageView.contentMode = UIViewContentModeScaleAspectFit;
                self.songAlbumArtImageView.image = [UIImage imageNamed:@"logoIconFull"];
            }
            
            
            
            self.currentSongLabel.text = [SharedHelper truncatedLabelString:[NSString stringWithFormat:@"%@-%@",[playModel getUserSessionForKey:@"artistString"],[playModel getUserSessionForKey:@"currentSong"]] charactersToLimit:30];
            self.tapeMessageLabel.text = [playModel getUserSessionForKey:@"tapeMessageString"];
            self.songTimerLabel.text = @"00:00/00:00";
            self.nextSongLabel.text = [SharedHelper truncatedLabelString:[NSString stringWithFormat:@"Next Song - %@",[playModel getUserSessionForKey:@"nextSongString"]] charactersToLimit:30];
            self.triLabelView.labelText = [playModel getUserSessionForKey:@"tapeTitleString"];
            
            timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
            [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
            
            
        }else{
//            self.currentSongLabel.text = [SharedHelper truncatedLabelString: @"Unknown title" charactersToLimit:30];
            self.tapeMessageLabel.text = @"No mixed tapes found.";
            self.songTimerLabel.text = @"00:00/00:00";
            self.nextSongLabel.text = [SharedHelper truncatedLabelString:[NSString stringWithFormat:@"Next Song - %@",@"Unknown title"] charactersToLimit:30];
        }
        
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    [[NSNotificationCenter defaultCenter] removeObserver: self
                                                    name: MPMusicPlayerControllerNowPlayingItemDidChangeNotification
                                                  object: musicPlayer];
    
    [[NSNotificationCenter defaultCenter] removeObserver: self
                                                    name: MPMusicPlayerControllerPlaybackStateDidChangeNotification
                                                  object: musicPlayer];
    
    [[NSNotificationCenter defaultCenter] removeObserver: self
                                                    name: MPMusicPlayerControllerVolumeDidChangeNotification
                                                  object: musicPlayer];
    
    [musicPlayer endGeneratingPlaybackNotifications];
}

#pragma mark - Register Play Music notifications
- (void) registerMediaPlayerNotifications
{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    [notificationCenter addObserver: self
                           selector: @selector (handle_NowPlayingItemChanged:)
                               name: MPMusicPlayerControllerNowPlayingItemDidChangeNotification
                             object: musicPlayer];
    
    [notificationCenter addObserver: self
                           selector: @selector (handle_PlaybackStateChanged:)
                               name: MPMusicPlayerControllerPlaybackStateDidChangeNotification
                             object: musicPlayer];
    
    [notificationCenter addObserver: self
                           selector: @selector (handle_VolumeChanged:)
                               name: MPMusicPlayerControllerVolumeDidChangeNotification
                             object: musicPlayer];
    
    [musicPlayer beginGeneratingPlaybackNotifications];
}

-(void)updateTime:(NSTimer *)timer
{
    
}

#pragma mark - getAlbumArtWork Resized
- (UIImage *) getAlbumArtworkWithSize: (CGSize) albumSize :(NSString *)songTitle
{
    MPMediaQuery *query = [MPMediaQuery songsQuery];
    
    MPMediaPropertyPredicate *albumPredicate = [MPMediaPropertyPredicate predicateWithValue: songTitle forProperty: MPMediaItemPropertyTitle];
    
    [query addFilterPredicate:albumPredicate];
    
    NSArray *Tracks = [query items];
    
    for (int i = 0; i < [Tracks count]; i++) {
        
        MPMediaItem *mediaItem = [Tracks objectAtIndex:i];
        UIImage *artworkImage;
        
        MPMediaItemArtwork *artwork = [mediaItem valueForProperty: MPMediaItemPropertyArtwork];
        artworkImage = [artwork imageWithSize: CGSizeMake (1, 1)];
        
        if (artworkImage) {
            artworkImage = [artwork imageWithSize:albumSize];
            return artworkImage;
        }
        
    }
    
    return [UIImage imageNamed:@"logoIconFull"];
}

#pragma mark - IBActions
- (IBAction)dismissPlayTape:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)nextButton:(UIButton *)sender
{
    [musicPlayer skipToNextItem];
}

- (IBAction)playButton:(UIButton *)sender
{
    if (![self.currentSongLabel.text isEqualToString:@"Unknown title"]) {
        
        if ([musicPlayer playbackState] == MPMusicPlaybackStatePlaying) {
            [musicPlayer pause];
            
        } else {
            [musicPlayer play];
        }
        
    }
}

- (IBAction)prevButton:(UIButton *)sender
{
    [musicPlayer skipToPreviousItem];
}

- (IBAction)openSocialPageButton:(UIButton *)sender
{
    UIViewController *vcc = [self.storyboard instantiateViewControllerWithIdentifier:@"SOCIAL_VC"];
    [self presentViewController:vcc animated:YES completion:nil];
}

-(IBAction)prepareForUnwind :(UIStoryboardSegue *)segue
{
    
    
}

#pragma mark - Now Playing Notification
-(void) handle_NowPlayingItemChanged: (id) notification
{
    
    if ([musicPlayer playbackState] != MPMusicPlaybackStateStopped) {
        MPMediaItem *currentItem = [musicPlayer nowPlayingItem];
        
        
//        MPMediaItemArtwork *artwork = [currentItem valueForProperty: MPMediaItemPropertyArtwork];
//        UIImage *artworkImage = [artwork imageWithSize: CGSizeMake (320, 320)];
        
//        if (!artworkImage) {
//            artworkImage = [UIImage imageNamed:@"logoIconFull"];
//        }
        
//        [self.songAlbumArtImageView setImage:artworkImage];
        
        NSString *titleString = [currentItem valueForProperty:MPMediaItemPropertyTitle];
        if (titleString) {
            self.currentSongLabel.text = [SharedHelper truncatedLabelString:titleString charactersToLimit:30];
        } else {
            self.currentSongLabel.text = [SharedHelper truncatedLabelString:@"Unknown title" charactersToLimit:30];
        }
        
        NSString *artistString = [currentItem valueForProperty:MPMediaItemPropertyArtist];
        if (artistString) {
            self.currentSongLabel.text = [SharedHelper truncatedLabelString:[NSString stringWithFormat:@"%@-%@",artistString,titleString] charactersToLimit:30];
        } else {
        }
        
        int index = (int)musicPlayer.indexOfNowPlayingItem+1;
        MPMediaItem *nextItem;
        NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithData: [playModel getUserSessionForKey:@"queueSongsArray"]];
       
        if (index < arr.count) {
            nextItem = [arr objectAtIndex:index];
            self.nextSongLabel.text = [SharedHelper truncatedLabelString:[NSString stringWithFormat:@"Next Song - %@",[nextItem valueForProperty:MPMediaItemPropertyTitle]]charactersToLimit:30];
        }else{
            nextItem = [arr objectAtIndex:0];
            self.nextSongLabel.text =  [SharedHelper truncatedLabelString:[NSString stringWithFormat:@"Next Song - %@",[nextItem valueForProperty:MPMediaItemPropertyTitle]] charactersToLimit:30];
        }
        
        // The total duration of the track...
        long totalPlaybackTime = [[[musicPlayer nowPlayingItem] valueForProperty: @"playbackDuration"] longValue];
        int tHours = (int)(totalPlaybackTime / 3600);
        int tMins = (int)((totalPlaybackTime/60) - tHours*60);
        int tSecs = (totalPlaybackTime % 60 );
        playModel.songDurationStr = [NSString stringWithFormat:@"%i:%02d:%02d", tHours, tMins, tSecs ];
        NSLog(@"%@",playModel.songDurationStr);
        
    }
}

#pragma mark - Handle Playback notification
-(void) handle_PlaybackStateChanged: (id) notification
{
    MPMusicPlaybackState playbackState = [musicPlayer playbackState];
    
    if (playbackState == MPMusicPlaybackStatePaused) {
        [self.playButtonOutlet setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        
        
    } else if (playbackState == MPMusicPlaybackStatePlaying) {
        [self.playButtonOutlet setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
        
    } else if (playbackState == MPMusicPlaybackStateStopped) {
        
        [self.playButtonOutlet setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        [musicPlayer stop];
    }
    
}

- (void) handle_VolumeChanged: (id) notification
{
}

#pragma mark - Song Seek Slider
- (IBAction)songSliderChanged:(UISlider *)sender
{
    musicPlayer.currentPlaybackTime = sender.value;
}


#pragma mark - Like Button
- (IBAction)likeButtonPressed:(UIButton *)sender
{
    if (playModel.songID != nil) {
        
        
        [FetchTracksModel hitLikeOnTrackWithID:playModel.songID userID:[[NSUserDefaults standardUserDefaults]objectForKey:key_userID] viewController:self callback:^(id callback) {
            NSLog(@"%@",callback);
            if ([callback boolValue] == YES) {
                NSLog(@"LIKED");
                [sender setImage:[UIImage imageNamed:@"heart"] forState:UIControlStateNormal];
            }else{
                [sender setImage:[UIImage imageNamed:@"like_inactive"] forState:UIControlStateNormal];
            }
        }];
    }
}

#pragma mark - Timer Method
- (void)onTimer:(NSTimer *)myTimer {
    
    long currentPlaybackTime = musicPlayer.currentPlaybackTime;
    int currentHours = (int)(currentPlaybackTime / 3600);
    int currentMinutes = (int)((currentPlaybackTime / 60) - currentHours*60);
    int currentSeconds = (currentPlaybackTime % 60);
    
    NSString *duration = [musicPlayer.nowPlayingItem valueForProperty:MPMediaItemPropertyPlaybackDuration];
    long mins = (duration.integerValue / 60); // fullminutes is an int
    long secs = (duration.integerValue - mins * 60);  // fullseconds is an int
    
    
    self.songSlider.maximumValue = musicPlayer.nowPlayingItem.playbackDuration;
    self.songTimerLabel.text = [NSString stringWithFormat:@"%02d:%02d/%@",currentMinutes, currentSeconds,[NSString stringWithFormat:@"%02ld:%02ld", mins, secs]];
    
    NSLog(@"%d",currentSeconds);
    NSLog(@"%ld",currentPlaybackTime);
    
    [self.songSlider setValue:currentPlaybackTime animated:YES];
    
    
    
    
}


- (IBAction)mixedTapeLogoBtn:(UIButton *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://imixedtape.com"]];
}



@end
