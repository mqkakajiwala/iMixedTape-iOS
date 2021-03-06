//
//  SelectSongVC.m
//  iMixedTape
//
//  Created by Mustafa on 05/01/2017.
//  Copyright © 2017 LemondeIT. All rights reserved.
//

#import "SelectSongVC.h"
#import "SelecSongCell.h"
#import "FetchTracksModel.h"
#import "PlayTapeVC.h"
#import "PreviewBuyModel.h"
#import <AVFoundation/AVFoundation.h>
#import "AcceptTapeModel.h"
#import "HomeGridVC.h"

@interface SelectSongVC (){
    NSMutableArray *songsArray;
    NSMutableArray *localSongsArray;
    NSMutableArray *titleArr;
    AVPlayer *player;
    
}

@end

@implementation SelectSongVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.sharedTapeStatus != nil) {
        if ([self.sharedTapeStatus isEqual:@1]) {
            self.acceptBtnOutlet.hidden = YES;
            self.rejectBtnOutlet.hidden = YES;
            
            
            
        }else{
            self.acceptBtnOutlet.hidden = NO;
            self.rejectBtnOutlet.hidden = NO;
        }
        
        switch (self.sharedTapeStatus.intValue) {
            case 0:
                self.titleView.viewColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:255.0/255.0 alpha:0.7];
                break;
            case 1:
                self.titleView.viewColor = [UIColor colorWithRed:0.0/255.0 green:255.0/255.0 blue:0.0/255.0 alpha:0.7];
                break;
            case 2:
                self.titleView.viewColor = [UIColor colorWithRed:255.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.7];
                
            default:
                break;
        }
        
    }else{
        self.acceptBtnOutlet.hidden = YES;
        self.rejectBtnOutlet.hidden = YES;
        
        switch (self.myTapeStatus.intValue) {
            case 0:
                self.titleView.viewColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:255.0/255.0 alpha:0.7];
                break;
            case 1:
                self.titleView.viewColor = [UIColor colorWithRed:0.0/255.0 green:255.0/255.0 blue:0.0/255.0 alpha:0.7];
                break;
            case 2:
                self.titleView.viewColor = [UIColor colorWithRed:255.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.7];
                
            default:
                break;
        }

    }
    
    
    
    if (![self.imageToken isKindOfClass:[NSNull class]]) {
        
    
    [self.tapeImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://staging.imixedtape.com/image/%@/%dx%d",self.imageToken,100,100]] placeholderImage:[UIImage imageNamed:@"logoIconFull"]];
        
    }else{
        self.tapeImage.contentMode = UIViewContentModeScaleAspectFit;
        self.tapeImage.image = [UIImage imageNamed:@"logoIconFull"];
    }
    
 //   dispatch_async(dispatch_get_main_queue(), ^{
    NSInteger charLength = self.tapeTitleString.length;
    
    charLength = (charLength > 6 && charLength < 36) ? round(self.titleView.layer.frame.size.width / charLength) + 2 : charLength;
    
    
    
        NSLog(@"%@",[SharedHelper truncatedLabelString:self.tapeTitleString charactersToLimit:5]);
        self.titleView.labelText =[SharedHelper truncatedLabelString:self.tapeTitleString charactersToLimit:(int)charLength];
        
        self.tapeMessage.text = self.tapeMessageString;
     if (![self.tapeOwnerNameString isKindOfClass:[NSNull class]]) {
        self.tapeOwnerNameLabel.text = self.tapeOwnerNameString;
     }
        
   // });
    
    songsArray = [[NSMutableArray alloc]init];
    localSongsArray = [[NSMutableArray alloc]init];
    titleArr = [[NSMutableArray alloc]init];
    MPMediaQuery *query = [MPMediaQuery songsQuery];
    
    localSongsArray = [query items].mutableCopy;
    for (MPMediaItem *item in localSongsArray) {
        [titleArr addObject:[item valueForProperty:MPMediaItemPropertyTitle]];
    }
    NSLog(@"%@",titleArr);
    


    
    
    [self webServiceForTracksOfTapes];
    
}

-(void)webServiceForTracksOfTapes
{
    [FetchTracksModel fetchTracksForTapeID:self.selectedTapeID offset:200 viewController:self callback:^(id callback) {
        NSLog(@"%@",callback);
        if ([callback isKindOfClass:[NSArray class]]) {
            songsArray = callback;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
            
        }
    }];
}

- (IBAction)dismissVCButton:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return songsArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SelecSongCell *cell = (SelecSongCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.songTitleLabel.text = [[songsArray valueForKey:@"title"]objectAtIndex:indexPath.row];
    [cell.playButton addTarget:self action:@selector(playButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [cell.previewButton addTarget:self action:@selector(previewButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [cell.buyButton addTarget:self action:@selector(buyButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    
    if ([titleArr containsObject:cell.songTitleLabel.text]) {
        cell.playButton.hidden = NO;
        cell.previewBuyView.hidden = YES;
    }else{
        cell.playButton.hidden = YES;
        cell.previewBuyView.hidden = NO;
    }
    

    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

#pragma mark - IBActions
-(void)playButtonPressed :(UIButton *)sender
{
    //[self dismissViewControllerAnimated:YES completion:nil];
    
    
    //Everything happens with unwind segue from storyboard ..
 //   dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
   //     [self performSegueWithIdentifier:@"unwindToPlayTape" sender:sender];
    //});
    
    PlayTapeVC *playVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PLAYTAPEVC"];
    
    
    [self presentViewController:playVC animated:YES completion:nil];
     [self playClickedSong:playVC sender:sender];
    
    
    
    
    
}

-(void)previewButtonPressed :(UIButton *)sender
{
   [PreviewBuyModel iTunesAPiForPreviewBuyForSongID:[[songsArray valueForKey:@"song_id"]objectAtIndex:(long)[self selectedIndexOfSender:sender].row] viewController:self callback:^(id responseObject) {
       
       NSLog(@"%@",[[[responseObject objectForKey:@"results"]valueForKey:@"previewUrl"]firstObject]);
       NSLog(@"%u",[[responseObject objectForKey:@"results"]count]);
       
       if ([ [[responseObject objectForKey:@"results"]valueForKey:@"previewUrl"]firstObject] != nil) {
           
           
           [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[[[responseObject objectForKey:@"results"]valueForKey:@"previewUrl"]firstObject]]];
       }else{
           [SharedHelper AlertControllerWithTitle:@"" message:@"Preview for this song is unavailable" viewController:self];
       }
   }];

}

-(void)buyButtonPressed :(UIButton *)sender
{
    [PreviewBuyModel iTunesAPiForPreviewBuyForSongID:[[songsArray valueForKey:@"song_id"]objectAtIndex:(long)[self selectedIndexOfSender:sender].row] viewController:self  callback:^(id responseObject) {
        
        if (![[[[responseObject objectForKey:@"results"]valueForKey:@"trackViewUrl"]firstObject] isKindOfClass:[NSNull class]]) {
            
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[[[responseObject objectForKey:@"results"]valueForKey:@"trackViewUrl"]firstObject]]];
        }else{
           [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[[[responseObject objectForKey:@"results"]valueForKey:@"artistLinkUrl"]firstObject]]];
        }

        
        }];
}

//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender

-(void)playClickedSong : (PlayTapeVC *)vc sender:(id)sender
{
    //if ([segue.identifier isEqualToString:@"segueToPlayTapeVC"]) {
        
    
    
   // if ([segue.destinationViewController isKindOfClass:[PlayTapeVC class]]) {
        //PlayTapeVC *vc = segue.destinationViewController;
        NSLog(@"%ld",(long)[self selectedIndexOfSender:sender].row);
        NSLog(@"%@",[songsArray valueForKey:@"title"]);
        vc.currentSongStr = [[songsArray valueForKey:@"title"]objectAtIndex:(long)[self selectedIndexOfSender:sender].row];
        vc.tapeMessageStr = self.tapeMessageString;
        vc.artistStr = [[songsArray valueForKey:@"artist"]objectAtIndex:(long)[self selectedIndexOfSender:sender].row];
        vc.songID = [[songsArray valueForKey:@"song_id"]objectAtIndex:(long)[self selectedIndexOfSender:sender].row];
        vc.tapeTitleStr = self.tapeTitleString;
        
        
        
        //play selected song..
        MPMediaQuery *selectedSongQuery = [MPMediaQuery songsQuery];
        
        MPMediaPropertyPredicate *albumPredicate = [MPMediaPropertyPredicate predicateWithValue: [[songsArray valueForKey:@"title"]objectAtIndex:(long)[self selectedIndexOfSender:sender].row] forProperty: MPMediaItemPropertyTitle];
        
        [selectedSongQuery addFilterPredicate:albumPredicate];
        NSArray *songs = [selectedSongQuery items];
        NSArray *tempArr = [[NSArray alloc]init];
        NSMutableArray *tapeSongsArr = [[NSMutableArray alloc]init];
        
        MPMediaItem *selectedItem = [songs objectAtIndex:0];
        MPMusicPlayerController *musicPlayer = [MPMusicPlayerController systemMusicPlayer];
        
        //get all the songs from local library that are included in the mixed tapes..
        MPMediaQuery *allSongsQuery = [MPMediaQuery songsQuery];
        for (int i=0; i<[[songsArray valueForKey:@"title"]count]; i++) {
            NSLog(@"%@",[[songsArray valueForKey:@"title"]objectAtIndex:i]);
            
            MPMediaPropertyPredicate *tapePredicate = [MPMediaPropertyPredicate predicateWithValue:[[songsArray valueForKey:@"title"]objectAtIndex:i] forProperty:MPMediaItemPropertyTitle comparisonType:MPMediaPredicateComparisonEqualTo];
            
            [allSongsQuery addFilterPredicate:tapePredicate];
            
            tempArr = [allSongsQuery items];
            for (MPMediaItem *item in tempArr) {
                [tapeSongsArr addObject:item];
            }
            
            allSongsQuery = [MPMediaQuery songsQuery];
            
        }
        
        NSLog(@"%@",tapeSongsArr);
        MPMediaItemCollection *tapeCollection = [[MPMediaItemCollection alloc]initWithItems:tapeSongsArr];
        
        [musicPlayer setQueueWithItemCollection:tapeCollection];
        
        [musicPlayer setNowPlayingItem:selectedItem];
        
        [musicPlayer play];
        
        
        int index = (int)[self selectedIndexOfSender:sender].row +1;
        MPMediaItem *nextItem;
        if (index < tapeSongsArr.count) {
            nextItem = [tapeSongsArr objectAtIndex:index];
            vc.nextSongMPMediaItem = nextItem;
            vc.nextSongStr = [nextItem valueForProperty:MPMediaItemPropertyTitle];
        }else{
            nextItem = [tapeSongsArr objectAtIndex:0];
            vc.nextSongMPMediaItem = nextItem;
            vc.nextSongStr = [nextItem valueForProperty:MPMediaItemPropertyTitle];
        }
        
        vc.queueSongArray = tapeSongsArr;
        
    //}
}

-(NSIndexPath *)selectedIndexOfSender :(id)sender
{
    CGPoint touchLocation = [sender convertPoint:CGPointZero toView:self.tableView];
   NSIndexPath *selectedIndex = [self.tableView indexPathForRowAtPoint:touchLocation];
    NSLog(@"%ld",(long)selectedIndex.row);
    
    return selectedIndex;
}
- (IBAction)acceptTapeButton:(UIButton *)sender
{
    [AcceptTapeModel acceptSharedTapeWithID:self.selectedTapeSharedID status:@"1" viewController:self  callback:^(id callback) {
        NSLog(@"%@",callback);
        if ([[callback[@"data"]objectForKey:@"status"] isEqualToString:@"1"]) {
            self.acceptBtnOutlet.hidden = YES;
            self.rejectBtnOutlet.hidden = YES;
            [self getRefreshedTapes];
//            int badgeCount = [[NSUserDefaults standardUserDefaults]integerForKey:key_appBadgeCount];
//            [UIApplication sharedApplication].applicationIconBadgeNumber = badgeCount - 1;
        }
        
    }];
}

- (IBAction)rejectTapeButton:(UIButton *)sender
{
    [AcceptTapeModel acceptSharedTapeWithID:self.selectedTapeSharedID status:@"2" viewController:self  callback:^(id callback) {
        NSLog(@"%@",callback);
        if ([[callback[@"data"]objectForKey:@"status"] isEqualToString:@"2"]) {
            [self getRefreshedTapes];
           [self dismissViewControllerAnimated:YES completion:nil];
        }
        
    }];
}

- (IBAction)cloneTapeButton:(UIButton *)sender
{
    [CreateTapeModel resetCreateTapeModel];
    CreateTapeModel *tapeModel = [CreateTapeModel sharedInstance];
    
    tapeModel.title = self.tapeTitleString;
    tapeModel.uploadImageAccessToken = self.imageToken;
    tapeModel.message = self.tapeMessageString;
    tapeModel.isCloned = YES;
    
    NSLog(@"%@",songsArray);
    for (int i = 0; i<songsArray.count; i++) {
        [SharedHelper iTunesSearchAPI:[[songsArray valueForKey:@"title"]objectAtIndex:i]];
    }
}

-(void)getRefreshedTapes
{
    HomeGridVC *hg = [[HomeGridVC alloc]init];
    
    [hg getWebserviceDataOnLoad];
}
@end
