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

#pragma mark - SearchBar Delegate

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    searchActive = YES;

}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    searchResultsArray = [[NSMutableArray alloc]init];
    
    if (searchText.length != 0) {
        searchActive = YES;
        [self searchTableList];
    }
    else{
        searchActive = NO;
        [self.tableView reloadData];
    }
    
    
    
}

-(void)searchTableList {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
    
    
    if (ifMusicLib) {
        
        
        if (ifAlbums) {
            for (MPMediaItem *rowItem  in mediaArray) {
                NSComparisonResult result = [[rowItem valueForProperty:MPMediaItemPropertyAlbumTitle] compare:self.searchBar.text options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [self.searchBar.text length])];
                if (result == NSOrderedSame) {
                    NSLog(@"%@",rowItem);
                    if (![searchResultsArray containsObject:rowItem]) {
                        [searchResultsArray addObject:rowItem];
                    }
                }
            }
            
        }else{
            for (MPMediaItem *rowItem  in mediaArray) {
                NSComparisonResult result = [[rowItem valueForProperty:MPMediaItemPropertyTitle] compare:self.searchBar.text options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [self.searchBar.text length])];
                if (result == NSOrderedSame) {
                    NSLog(@"%@",rowItem);
                    if (![searchResultsArray containsObject:rowItem]) {
                        [searchResultsArray addObject:rowItem];
                    }
                    
                }
            }
        }
    }else {
        //            NSPredicate *resultPredicate = [NSPredicate
        //                                            predicateWithFormat:@"SELF contains[cd] %@",
        //                                            searchText];
        //
        //            mediaArray = [mediaArray filteredArrayUsingPredicate:resultPredicate].mutableCopy;
    }
    
        
        [self.tableView reloadData];
        });
    
    
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
}

#pragma mark - Predicate/Filter Search method

-(NSMutableArray *)predicateFilterSearch :(NSString *)searchText forMediaProperty:(NSString *)property
{
    MPMediaPropertyPredicate *predicate =
    [MPMediaPropertyPredicate predicateWithValue:searchText
                                     forProperty:property
                                  comparisonType:MPMediaPredicateComparisonContains];
    
    NSSet *predicates = [NSSet setWithObjects: predicate, nil];
    
    MPMediaQuery *songsQuery =  [[MPMediaQuery alloc] initWithFilterPredicates: predicates];
    
    NSLog(@"%@", [songsQuery items]);
    
    return [songsQuery items].mutableCopy;
}

#pragma mark - TableView Datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (searchActive) {
        return searchResultsArray.count;
    }else{
        return mediaArray.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCell *cell = (CustomCell *) [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    if (searchActive) {
        @try {
            if ([searchResultsArray.firstObject isKindOfClass:[MPMediaItem class]] || [searchResultsArray.firstObject isKindOfClass:[MPMediaItemCollection class]] ) {
                
                
                
                
                if (ifMusicLib) {
                    
                    MPMediaItem *rowItem;
                    
                    if (ifAlbums) {
                        rowItem = [searchResultsArray[indexPath.row]representativeItem];
                        cell.songTitleLabel.text = [rowItem valueForProperty:MPMediaItemPropertyAlbumTitle];
                        cell.songDecLabel.text = [rowItem valueForProperty:MPMediaItemPropertyAlbumArtist];
                        cell.songTimeLabel.hidden = YES;
                        NSLog(@"%@",[rowItem valueForProperty:MPMediaItemPropertyAlbumPersistentID]);
                    }else{
                        rowItem = searchResultsArray[indexPath.row];
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
                        
                        
                    }
                    
                    
                    
                    MPMediaItemArtwork *artwork = [rowItem valueForProperty:MPMediaItemPropertyArtwork];
                    cell.albumArtImageView.image = [artwork imageWithSize: CGSizeMake (44, 44)];
                    
                }
                
            }else{
                if (ifMyTapes) {
                    
                    cell.albumArtImageView.contentMode = UIViewContentModeScaleAspectFit;
                    
                    [cell.albumArtImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://staging.imixedtape.com/image/%@/%dx%d",[[searchResultsArray valueForKey:@"image_token"]objectAtIndex:indexPath.row],100,100]] placeholderImage:[UIImage imageNamed:@"logoIconFull"]];
                    
                    cell.songTitleLabel.text = [[searchResultsArray valueForKey:@"message"]objectAtIndex:indexPath.row];
                    
                    cell.songDecLabel.text = @"";
                    cell.songTimeLabel.text = @"";
                    
                    
                    
                }
                
            }
        } @catch (NSException *exception) {
            NSLog(@"%@", exception.reason);
        } @finally {
            
        }
    }else{
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
                        
                        
                    }
                    
                    
                    
                    MPMediaItemArtwork *artwork = [rowItem valueForProperty:MPMediaItemPropertyArtwork];
                    cell.albumArtImageView.image = [artwork imageWithSize: CGSizeMake (44, 44)];
                    
                }
                
            }else{
                if (ifMyTapes) {
                    
                    cell.albumArtImageView.contentMode = UIViewContentModeScaleAspectFit;
                    
                    [cell.albumArtImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://staging.imixedtape.com/image/%@/%dx%d",[[mediaArray valueForKey:@"image_token"]objectAtIndex:indexPath.row],100,100]] placeholderImage:[UIImage imageNamed:@"logoIconFull"]];
                    
                    cell.songTitleLabel.text = [[mediaArray valueForKey:@"message"]objectAtIndex:indexPath.row];
                    
                    cell.songDecLabel.text = @"";
                    cell.songTimeLabel.text = @"";
                    
                    
                    
                }
                
            }
        } @catch (NSException *exception) {
            NSLog(@"%@", exception.reason);
        } @finally {
            
        }
    }
    
    
    
    
    [cell.songAddButon addTarget:self action:@selector(addMyTapesTracks:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

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
    }else {
         [SharedHelper emptyTableScreenText:@"" Array:mediaArray.mutableCopy tableView:self.tableView view:self.myView];
    }
    
    
    for (int i=0; i<tapeModel.songsAddedArray.count; i++) {
        NSString *addedSongsTitle = [[tapeModel.songsAddedArray objectAtIndex:i]objectForKey:@"title"];
        
        for (int j=0; j<mediaArray.count; j++) {
            MPMediaItem *rowItem = [mediaArray objectAtIndex:j];
            NSString *mediaTitle = [rowItem valueForProperty:MPMediaItemPropertyTitle];
            if ([addedSongsTitle isEqualToString:mediaTitle]) {
                [mediaArray removeObjectAtIndex:j];
                j--;
            }
        }
    }
    
    
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
    
    if (searchActive) {
        NSLog(@"%@",searchResultsArray[selectedIndex.row]);
        
        if (ifMyTapes== YES) {
            [FetchTracksModel fetchTracksForTapeID:[[searchResultsArray valueForKey:@"id"]objectAtIndex:selectedIndex.row] offset:200 viewController:self  callback:^(id callback) {
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
                NSLog(@"alub song list %@",dic);
                NSLog(@"%@",[[dic objectForKey:@"Song"]firstObject]);
                for(int i=0; i<[[dic objectForKey:@"Song"]count]; i++){
                    NSLog(@"%@",[[dic objectForKey:@"Song"]objectAtIndex:i]);
                    [SharedHelper iTunesSearchAPI:[[dic objectForKey:@"Song"]objectAtIndex:i]];
                }
            }
            
        }else{
            MPMediaItem *rowItem =  searchResultsArray[selectedIndex.row];
            songTitle =(NSString *)[rowItem valueForProperty:MPMediaItemPropertyTitle];
            
            NSNumber *duration = [rowItem valueForProperty:MPMediaItemPropertyPlaybackDuration];
            NSLog(@"%@",[rowItem valueForKey:MPMediaItemPropertyPersistentID]);
            NSLog(@"%@",[rowItem valueForKey:MPMediaItemPropertyAssetURL]);
            
            
            long mins = (duration.integerValue / 60); // fullminutes is an int
            long secs = (duration.integerValue - mins * 60);  // fullseconds is an int
            songDuration = [NSString stringWithFormat:@"%02ld:%02ld", mins, secs];
            
            NSLog(@"%@",searchResultsArray[selectedIndex.row]);
            
            [SharedHelper iTunesSearchAPI:songTitle];
            
            
            
            
        }
        
        [searchResultsArray removeObjectAtIndex:selectedIndex.row];
        [self.tableView deleteRowsAtIndexPaths:@[selectedIndex] withRowAnimation:UITableViewRowAnimationLeft];

    }else {
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
    
}


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
