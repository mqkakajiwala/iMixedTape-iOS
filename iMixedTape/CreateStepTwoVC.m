//
//  CreateStepTwoVC.m
//  iMixedTape
//
//  Created by Mustafa on 25/12/2016.
//  Copyright © 2016 LemondeIT. All rights reserved.
//

#import "CreateStepTwoVC.h"
#import "CustomCell.h"
#import <AVFoundation/AVFoundation.h>
#import "FetchTapesModel.h"
#import "FetchTracksModel.h"



@interface CreateStepTwoVC (){
    NSMutableArray *searchResultsArray;
    NSMutableArray *mediaArray;
    BOOL ifAlbums;
    BOOL ifMusicLib;
    BOOL ifMyTapes;
    BOOL searchActive;
    MPMediaQuery *query;
    NSString *songTitle;
    NSMutableArray *matchArray;
    NSString *songDuration;
    CreateTapeModel *tapeModel;
    SharedHelper *helper;
}

@end

@implementation CreateStepTwoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.searchBar.delegate = self;
    searchResultsArray = [[NSMutableArray alloc]init];
   
    MPMediaPropertyPredicate *predicate = [MPMediaPropertyPredicate predicateWithValue:[NSNumber numberWithInteger:MPMediaTypeMusic] forProperty:MPMediaItemPropertyMediaType];
    query = [[MPMediaQuery alloc]init];
    [query addFilterPredicate:predicate];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboardOnTap)];
    [self.view addGestureRecognizer:tap];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.myTapesButtonOutlet setSelected:YES];
        [self.myTapesButtonOutlet setBackgroundColor:[UIColor blackColor]];
    });
    

        helper = [[SharedHelper alloc]init];

    
    matchArray = [[[[NSUserDefaults standardUserDefaults]objectForKey:key_createTapeSongs]mutableCopy]valueForKey:@"title"];
    NSLog(@"%@",matchArray);
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    tapeModel = [CreateTapeModel sharedInstance];
   
    MPMediaPropertyPredicate *predicate = [MPMediaPropertyPredicate predicateWithValue:[NSNumber numberWithInteger:MPMediaTypeMusic] forProperty:MPMediaItemPropertyMediaType];
    query = [[MPMediaQuery alloc]init];
    [query addFilterPredicate:predicate];
    
    [self fetchMyTapes];
}
#pragma mark - Dismiss Keyboard on tap
-(void)dismissKeyboardOnTap
{
//    [mySearchBar resignFirstResponder];
}
//#pragma mark - Search Delegate
//-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
//{
//    searchActive = YES;
//}
//
//-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
//{
//    searchActive = NO;
//}
//
//-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
//{
//    searchActive = NO;
//}
//
//-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
//{
//    searchActive = NO;
//}
//
//-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
//{
//    if (searchResultsArray.count != 0) {
//        [searchResultsArray removeAllObjects];
//    }
//    
//    for (int i =0; i< mediaArray.count; i++)
//    {
//        NSString *string = [[mediaArray objectAtIndex:i] valueForKey:@"message"];
//        NSRange nameRange = [string rangeOfString:searchBar.text options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch)];
//        
//        if(nameRange.location != NSNotFound)
//        {
//            [searchResultsArray addObject:string];
//        }
//        
//        if (searchResultsArray.count == 0) {
//            searchActive = NO;
//        }else{
//            searchActive = YES;
//        }
//        [self.tableView reloadData];
//    }
//    
//    
//}

#pragma mark - TableView Datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (self.searchController.isActive && self.searchController.searchBar.text.length > 0) {
//        return searchResultsArray.count;
//    }
    
    if (searchActive) {
        return searchResultsArray.count;
    }else{
    return mediaArray.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCell *cell = (CustomCell *) [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    @try {
        if ([mediaArray.firstObject isKindOfClass:[MPMediaItem class]] || [mediaArray.firstObject isKindOfClass:[MPMediaItemCollection class]] ) {
            
            
            if (ifMusicLib) {
                
                MPMediaItem *rowItem;
                
                if (ifAlbums) {
                    rowItem = [mediaArray[indexPath.row]representativeItem];
                    cell.songTitleLabel.text = [rowItem valueForProperty:MPMediaItemPropertyAlbumTitle];
                    cell.songDecLabel.text = [rowItem valueForProperty:MPMediaItemPropertyAlbumArtist];
                    cell.songTimeLabel.hidden = YES;
                    NSLog(@"%@",[rowItem valueForProperty:MPMediaItemPropertyAlbumPersistentID]);
                }else{
                    rowItem = mediaArray[indexPath.row];
                    NSLog(@"%@",[rowItem valueForProperty:MPMediaItemPropertyTitle]);
                    cell.songTitleLabel.text = [rowItem valueForProperty:MPMediaItemPropertyTitle];
                    cell.songDecLabel.text = [rowItem valueForProperty:MPMediaItemPropertyArtist];
                    cell.songTimeLabel.hidden = NO;
                    NSNumber *duration = [rowItem valueForProperty:MPMediaItemPropertyPlaybackDuration];
                    NSLog(@"%@",[rowItem valueForKey:MPMediaItemPropertyPersistentID]);
                    NSLog(@"%@",[rowItem valueForKey:MPMediaItemPropertyAssetURL]);
                    
                    
                    long mins = (duration.integerValue / 60); // fullminutes is an int
                    long secs = (duration.integerValue - mins * 60);  // fullseconds is an int
                    cell.songTimeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld", mins, secs];
                    
                    
                    
//                    [cell.songAddButon addTarget:self action:@selector(addSongsBtn:) forControlEvents:UIControlEventTouchUpInside];
                    
                    
                }
                
                
                
                MPMediaItemArtwork *artwork = [rowItem valueForProperty:MPMediaItemPropertyArtwork];
                cell.albumArtImageView.image = [artwork imageWithSize: CGSizeMake (44, 44)];
                
                //test
                
                
            }
            //        else{
            //            [SharedHelper emptyTableScreenText:@"Please Login to create tapes" Array:mediaArray.mutableCopy tableView:self.tableView view:self.myView];
            //        }
            
        }else{
            if (ifMyTapes) {
                
                cell.albumArtImageView.contentMode = UIViewContentModeScaleAspectFit;
                
                [cell.albumArtImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://staging.imixedtape.com/image/%@/%dx%d",[[mediaArray valueForKey:@"image_token"]objectAtIndex:indexPath.row],100,100]] placeholderImage:[UIImage imageNamed:@"logoIconFull"]];
                
                //if (!searchActive) {
                 cell.songTitleLabel.text = [[mediaArray valueForKey:@"message"]objectAtIndex:indexPath.row];
               // }else{
                    //cell.songTitleLabel.text = [[searchResultsArray valueForKey:@"message"]objectAtIndex:indexPath.row];
   
                //}
                
                
                cell.songDecLabel.text = @"";
                cell.songTimeLabel.text = @"";
                
                
                
            }
            
        }
    } @catch (NSException *exception) {
        NSLog(@"%@", exception.reason);
    } @finally {
        
    }
    
    [cell.songAddButon addTarget:self action:@selector(addMyTapesTracks:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

#pragma mark - Search Methods

//- (void)filterContentForSearchText:(NSString*)searchText
//{
//    
//    NSPredicate *resultPredicate = [NSPredicate
//                                    predicateWithFormat:@"title contains[c] %@",
//                                    searchText];
//    
//    searchResultsArray = [mediaArray filteredArrayUsingPredicate:resultPredicate];
//    NSLog(@"%@",searchResultsArray);
//    
//    
//  
//}

//-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
//{
//    [self filterContentForSearchText:searchBar.text];
//}

#pragma mark - IBActions

- (IBAction)myTapesBtn:(UIButton *)sender
{
    ifMusicLib = NO;
    
    [SharedHelper changeButtonBackgroundOnSelection:sender :self.myView];
    
    
    [self fetchMyTapes];
    
    
}

-(void)fetchMyTapes
{
    ifMyTapes = YES;
    ifAlbums = NO;
    UserModel *userModel = [[UserModel alloc]init];
    NSLog(@"%@", userModel.userID);
    if (userModel.isLoggedIn) {
        [self webServiceToFetchTapes : userModel.userID];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [SharedHelper emptyTableScreenText:@"Please Login To Create Tapes." Array:mediaArray.mutableCopy tableView:self.tableView view:self.myView];
            
            [self.tableView reloadData];
        });
    }
}
-(void)webServiceToFetchTapes :(NSString *)userID
{
    
    [FetchTapesModel fetchUserTapesWithPagination:200 userID:userID viewController:self :^(NSArray *callback) {
        
        
        mediaArray = callback.mutableCopy;

        NSLog(@"%@",mediaArray);
        if (mediaArray.count == 0) {
            [SharedHelper emptyTableScreenText:@"You have not created mixed tapes." Array:mediaArray.mutableCopy tableView:self.tableView view:self.myView];
        }else{
            [SharedHelper emptyTableScreenText:@"" Array:mediaArray.mutableCopy tableView:self.tableView view:self.myView];
        }
        
        [self.tableView reloadData];
    }];
}

- (IBAction)albumsBtn:(UIButton *)sender
{
    [SharedHelper changeButtonBackgroundOnSelection:sender :self.myView];
    query = [MPMediaQuery albumsQuery];
    mediaArray = [query collections].mutableCopy;
    
    ifAlbums = YES;
    ifMusicLib = YES;
    ifMyTapes = NO;
    
    if (mediaArray.count == 0) {
        [SharedHelper emptyTableScreenText:@"You have no albums to show." Array:mediaArray.mutableCopy tableView:self.tableView view:self.myView];
    }else{
        [SharedHelper emptyTableScreenText:@"" Array:mediaArray.mutableCopy tableView:self.tableView view:self.myView];
    }
    
    
    
    [self.tableView reloadData];
}

- (IBAction)songsBtn:(UIButton *)sender
{
    [SharedHelper changeButtonBackgroundOnSelection:sender :self.myView];
    ifAlbums = NO;
    ifMusicLib = YES;
    ifMyTapes = NO;
    query = [MPMediaQuery songsQuery];
    
    mediaArray = [query items].mutableCopy;
    
    if (mediaArray.count == 0) {
        [SharedHelper emptyTableScreenText:@"You have no songs to show." Array:mediaArray.mutableCopy tableView:self.tableView view:self.myView];
    }
 
    
    for (int i=0; i<tapeModel.songsAddedArray.count; i++) {
        NSString *addedSongsTitle = [[tapeModel.songsAddedArray objectAtIndex:i]objectForKey:@"title"];
//        int j = 0;
        for (int j=0; j<mediaArray.count; j++) {
            MPMediaItem *rowItem = [mediaArray objectAtIndex:j];
            NSString *mediaTitle = [rowItem valueForProperty:MPMediaItemPropertyTitle];
            if ([addedSongsTitle isEqualToString:mediaTitle]) {
                [mediaArray removeObjectAtIndex:j];
                j--;
            }
        }
    }
    
//    for (int i=0; i<mediaArray.count; i++) {
//        MPMediaItem *rowItem = [mediaArray objectAtIndex:0];
//        NSLog(@"%@",[rowItem valueForProperty:MPMediaItemPropertyAlbumTrackNumber]);
//        NSLog(@"%@",[rowItem valueForProperty:MPMediaItemPropertyPersistentID]);
//        NSLog(@"%@",[rowItem valueForProperty:MPMediaItemPropertyArtistPersistentID]);
//        NSLog(@"%@",[rowItem valueForProperty:MPMediaItemPropertyAlbumPersistentID]);
//    }
//    
    
    [self.tableView reloadData];
}

- (IBAction)streamingBtn:(UIButton *)sender
{
    [SharedHelper changeButtonBackgroundOnSelection:sender :self.myView];
    ifMusicLib = NO;
    ifMyTapes = NO;
    mediaArray = [[NSMutableArray alloc]init];
    [SharedHelper emptyTableScreenText:@"Streaming is not available for now." Array:mediaArray tableView:self.tableView view:self.view];
    [self.tableView reloadData];
}

#pragma mark - table IBActions

-(void)addMyTapesTracks :(UIButton *)sender
{
    CGPoint touchLocation = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *selectedIndex = [self.tableView indexPathForRowAtPoint:touchLocation];
    NSLog(@"%ld",(long)selectedIndex.row);
    
    
    NSLog(@"%@",mediaArray[selectedIndex.row]);
    
    if (ifMyTapes== YES) {
        [FetchTracksModel fetchTracksForTapeID:[[mediaArray valueForKey:@"id"]objectAtIndex:selectedIndex.row] offset:200 viewController:self  callback:^(id callback) {
            NSLog(@"%@",callback);
            for (int i=0; i<[callback count]; i++) {
                [SharedHelper iTunesSearchAPI:[[callback valueForKey:@"title"]objectAtIndex:i]];
            }
            
            
        }];

    }else if (ifAlbums == YES){
        
        MPMediaQuery *albumsQuery = [MPMediaQuery albumsQuery];
        NSArray *albums = [albumsQuery collections];
        NSArray * al = [NSArray arrayWithObjects:[albums objectAtIndex:selectedIndex.row], nil];
        MPMediaItemCollection *albumCollection;
        for (albumCollection in al) {
            NSString *selectedAlbumTitle = [[albumCollection representativeItem] valueForProperty:MPMediaItemPropertyAlbumTitle];
            NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
            [dic setObject:selectedAlbumTitle forKey:@"AlbumName"];
            NSArray *songs = albumCollection.items;
            NSLog(@"album title is %@",selectedAlbumTitle);
            NSMutableArray * songsArray = [[NSMutableArray alloc]init];
            for (MPMediaItem *song in songs) {
                NSLog(@"the album songs title is--->%@",[song valueForProperty: MPMediaItemPropertyTitle]);
                [songsArray addObject:[song valueForProperty: MPMediaItemPropertyTitle]];
            }
            NSLog(@"%@",songs);
            NSLog(@"%@",songsArray);
            [dic setObject:songsArray forKey:@"Song"];
//            [localSongsList addObject:dic];
            NSLog(@"alub song list %@",dic);
            NSLog(@"%@",[[dic objectForKey:@"Song"]firstObject]);
            for(int i=0; i<[[dic objectForKey:@"Song"]count]; i++){
                NSLog(@"%@",[[dic objectForKey:@"Song"]objectAtIndex:i]);
            [SharedHelper iTunesSearchAPI:[[dic objectForKey:@"Song"]objectAtIndex:i]];
             }
        }
        
    }else{
        MPMediaItem *rowItem =  mediaArray[selectedIndex.row];
        songTitle =(NSString *)[rowItem valueForProperty:MPMediaItemPropertyTitle];
        
        NSNumber *duration = [rowItem valueForProperty:MPMediaItemPropertyPlaybackDuration];
        NSLog(@"%@",[rowItem valueForKey:MPMediaItemPropertyPersistentID]);
        NSLog(@"%@",[rowItem valueForKey:MPMediaItemPropertyAssetURL]);
        
        
        long mins = (duration.integerValue / 60); // fullminutes is an int
        long secs = (duration.integerValue - mins * 60);  // fullseconds is an int
        songDuration = [NSString stringWithFormat:@"%02ld:%02ld", mins, secs];
        
        NSLog(@"%@",mediaArray[selectedIndex.row]);
        
        [SharedHelper iTunesSearchAPI:songTitle];
        
        
       

    }
    
    [mediaArray removeObjectAtIndex:selectedIndex.row];
    [self.tableView deleteRowsAtIndexPaths:@[selectedIndex] withRowAnimation:UITableViewRowAnimationLeft];
   
}

//-(void)addSongsBtn :(UIButton *)sender
//{
//    CGPoint touchLocation = [sender convertPoint:CGPointZero toView:self.tableView];
//    NSIndexPath *selectedIndex = [self.tableView indexPathForRowAtPoint:touchLocation];
//    NSLog(@"%ld",(long)selectedIndex.row);
//    
//    
//    }


#pragma mark - Media Library Permissionn
-(void) checkMediaLibraryPermissions {
    [MPMediaLibrary requestAuthorization:^(MPMediaLibraryAuthorizationStatus status){
        switch (status) {
            case MPMediaLibraryAuthorizationStatusNotDetermined: {
                // not determined
                break;
            }
            case MPMediaLibraryAuthorizationStatusRestricted: {
                // restricted
                break;
            }
            case MPMediaLibraryAuthorizationStatusDenied: {
                // denied
                break;
            }
            case MPMediaLibraryAuthorizationStatusAuthorized: {
                // authorized
                
                
                break;
            }
            default: {
                break;
            }
        }
    }];
}




@end
