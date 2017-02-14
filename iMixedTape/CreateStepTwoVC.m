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
    NSArray *searchResultsArray;
    NSMutableArray *mediaArray;
    BOOL ifAlbums;
    BOOL ifMusicLib;
    BOOL ifMyTapes;
//    UISearchBar *mySearchBar;
    MPMediaQuery *query;
    NSString *songTitle;
//    NSMutableArray *songsAddedArray;
    NSMutableArray *matchArray;
    NSString *songDuration;
    CreateTapeModel *cTModel;
    SharedHelper *helper;
}

@end

@implementation CreateStepTwoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
//    self.searchController.searchResultsUpdater = self;
//    self.searchController.dimsBackgroundDuringPresentation = NO;
//    
//    self.searchController.searchBar.delegate = self;
////    mySearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 44)];
////    mySearchBar.delegate = self;
//    self.tableView.tableHeaderView = self.searchController.searchBar;
//    self.definesPresentationContext = YES;
//    [self.searchController.searchBar sizeToFit];
//    
    searchResultsArray = [[NSArray alloc]init];
    //    mediaArray = @[@"Mustafa",@"Mustee",@"MUTTUUU"];
    
    MPMediaPropertyPredicate *predicate = [MPMediaPropertyPredicate predicateWithValue:[NSNumber numberWithInteger:MPMediaTypeMusic] forProperty:MPMediaItemPropertyMediaType];
    query = [[MPMediaQuery alloc]init];
    [query addFilterPredicate:predicate];
    
    //    MPMediaQuery *songsQuery = [MPMediaQuery songsQuery];
    //    mediaArray = [songsQuery items];
    
//    [self checkMediaLibraryPermissions];
    
    
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboardOnTap)];
    [self.view addGestureRecognizer:tap];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.myTapesButtonOutlet setSelected:YES];
        [self.myTapesButtonOutlet setBackgroundColor:[UIColor blackColor]];
    });
    
//    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"runOnce"] == NO) {
        helper = [[SharedHelper alloc]init];
//        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"runOnce"];
//    }
    
    
  
//    songsAddedArray = [[NSUserDefaults standardUserDefaults]objectForKey:key_createTapeSongs];
    
    matchArray = [[[[NSUserDefaults standardUserDefaults]objectForKey:key_createTapeSongs]mutableCopy]valueForKey:@"title"];
    NSLog(@"%@",matchArray);
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    helper = [SharedHelper sharedInstance];
    
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
#pragma mark - Search Results Updating Delegate

//- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
//{
//    NSString *searchString = searchController.searchBar.text;
//    [self filterContentForSearchText:searchString];
//    NSLog(@"%@",searchString);
//    [self.tableView reloadData];
//}

//- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
//{
//    [self updateSearchResultsForSearchController:self.searchController];
//}
#pragma mark - TableView Datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (self.searchController.isActive && self.searchController.searchBar.text.length > 0) {
//        return searchResultsArray.count;
//    }
    return mediaArray.count;
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
                
                
                cell.songTitleLabel.text = [[mediaArray valueForKey:@"message"]objectAtIndex:indexPath.row];
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

- (void)filterContentForSearchText:(NSString*)searchText
{
    
    NSPredicate *resultPredicate = [NSPredicate
                                    predicateWithFormat:@"title contains[c] %@",
                                    searchText];
    
    searchResultsArray = [mediaArray filteredArrayUsingPredicate:resultPredicate];
    NSLog(@"%@",searchResultsArray);
    
    
  
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self filterContentForSearchText:searchBar.text];
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
    
    [FetchTapesModel fetchUserTapesWithPagination:200 userID:userID :^(NSArray *callback) {
        
        
        mediaArray = callback.mutableCopy;
        
        //        myTapesArray = callback;
        NSLog(@"%@",mediaArray);
        dispatch_async(dispatch_get_main_queue(), ^{
            [SharedHelper emptyTableScreenText:@"You have not created tapes" Array:mediaArray.mutableCopy tableView:self.tableView view:self.myView];
            
            [self.tableView reloadData];
        });
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
 
    
    for (int i=0; i<helper.tapeSongsArray.count; i++) {
        NSString *addedSongsTitle = [[helper.tapeSongsArray objectAtIndex:i]objectForKey:@"title"];
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
        [FetchTracksModel fetchTracksForTapeID:[[mediaArray valueForKey:@"id"]objectAtIndex:selectedIndex.row] offset:200 callback:^(id callback) {
            NSLog(@"%@",callback);
            for (int i=0; i<[callback count]; i++) {
                [self iTunesSearchAPI:[[callback valueForKey:@"title"]objectAtIndex:i]];
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
            [self iTunesSearchAPI:[[dic objectForKey:@"Song"]objectAtIndex:i]];
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
        
        [self iTunesSearchAPI:songTitle];
        
        
       

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

-(void)iTunesSearchAPI :(NSString *)mySongtitle
{
    [SVProgressHUD showWithStatus:@"Song Adding .."];
    NSString *url = [NSString stringWithFormat:@"https://itunes.apple.com/search?term=%@&limit=1",mySongtitle];
//    NSString *url = [link stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    
     NSString *encoded = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",url);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:@"Jmnx9P8p3Y0rRy7yxkaLa5oF7IQ1ir5Y" forHTTPHeaderField:@"X-API-KEY"];
    [manager GET:encoded
      parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
          
      } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          NSLog(@"%@",responseObject);
          
          if ([[responseObject objectForKey:@"resultCount"]intValue] == 1) {
              
          
          NSDictionary *dict = @{@"title"  : mySongtitle,
                                 @"song_id": [[[responseObject objectForKey:@"results"]valueForKey:@"trackId"]firstObject],
                                 @"genre"  : [[[responseObject objectForKey:@"results"]valueForKey:@"primaryGenreName"]firstObject],
                                 @"album"  : @"",
                                 @"artist" : [[[responseObject objectForKey:@"results"]valueForKey:@"artistName"]firstObject],
                                 @"language" : @"English",
                                 @"albumArt" : [[[responseObject objectForKey:@"results"]valueForKey:@"artworkUrl60"]firstObject]
                                 };
          
          NSLog(@"%@",dict);
          [helper.tapeSongsArray addObject:dict];
          
          [[NSUserDefaults standardUserDefaults]setObject:helper.tapeSongsArray forKey:key_createTapeSongs];
          NSLog(@"%@",helper.tapeSongsArray);
              
          }
          [SVProgressHUD dismiss];
      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          NSLog(@"%@",error.localizedDescription);
          [SVProgressHUD dismiss];
      }];
}


@end
