//
//  HomeGridVC.m
//  iMixedTape
//
//  Created by Mustafa Qutbuddin on 11/8/16.
//  Copyright © 2016 LemondeIT. All rights reserved.
//

#import "HomeGridVC.h"
#import <MediaPlayer/MediaPlayer.h>
#import "FetchTapesModel.h"
#import "SelectSongVC.h"
#import "CreateStepOneVC.h"
#import "CreateStepThreeVC.h"
#import "CreateTapeModel.h"
#import "CreateTapeVC.h"


@interface HomeGridVC (){
    CreateTapeModel *tapeModel;
}




@end

@implementation HomeGridVC
//@synthesize myTapesArray;
//@synthesize sharedTapesArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    tapeModel = [CreateTapeModel sharedInstance];
    
    [self emptyCollectionViewScreen];
    
    
}

-(void)webServiceToFetchTapes :(NSString *)userID
{
    [FetchTapesModel fetchUserTapesWithPagination:200 userID:userID viewController:self :^(NSArray *callback) {
        
        [FetchTapesModel sharedInstance].myCretedTapesArray = callback.mutableCopy;
        
        [SharedHelper emptyCollectionViewScreenText:@"No Mixed Tapes to show." Array:[FetchTapesModel sharedInstance].myCretedTapesArray.mutableCopy collectionView:self.collectionView view:self.view];
        
        FMDatabase *database = [FMDatabase databaseWithPath:[SharedHelper databaseWithPath]];
        [database open];
        
        
        [FetchTapesModel sharedInstance].myCretedTapesArray = [[FetchTapesModel sharedInstance].myCretedTapesArray arrayByAddingObjectsFromArray:[SharedHelper getSavedTaoesFromDB:database]].mutableCopy;
        
        

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
    }];
    
    [FetchTapesModel mySharedTapesWihPagination:200 userID:userID viewController:self :^(NSArray *callback) {
        [FetchTapesModel sharedInstance].sharedTapesArray = callback.mutableCopy;
       
         [SharedHelper emptyCollectionViewScreenText:@"No Mixed Tapes to show." Array:[FetchTapesModel sharedInstance].sharedTapesArray.mutableCopy collectionView:self.receivedTapesCollectionView view:self.view];
        
        int badgeCount = 0;
        
        for (int i=0; i<[FetchTapesModel sharedInstance].sharedTapesArray.count; i++) {
            if ([[[[FetchTapesModel sharedInstance].sharedTapesArray objectAtIndex:i] valueForKey:@"status"]intValue] == 0) {
                badgeCount++;
                NSLog(@"%d",badgeCount);
                [UIApplication sharedApplication].applicationIconBadgeNumber = badgeCount;
            }
        }
        
        if (badgeCount == 0) {
            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        }
        
        
        
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.receivedTapesCollectionView reloadData];
        });
    }];
}

#pragma mark - CollectionView Data Source
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    if (collectionView == self.collectionView) {
        return [FetchTapesModel sharedInstance].myCretedTapesArray.count;
    }
    else{
        return [FetchTapesModel sharedInstance].sharedTapesArray.count;
    }
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell;
    @try {
        
        if (collectionView == self.collectionView) {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"myCell" forIndexPath:indexPath];
            
            UIImageView *albumArtworkImage = (UIImageView *)[cell viewWithTag:1];
            UILabel *messageLabel = (UILabel *)[cell viewWithTag:2];
            TriLabelView *triView = (TriLabelView *)[cell viewWithTag:1000];
           
            
            if ([FetchTapesModel sharedInstance].myCretedTapesArray.count != 0) {
                
                albumArtworkImage.contentMode = UIViewContentModeScaleAspectFill;
                
                NSLog(@"%@",[[[FetchTapesModel sharedInstance].myCretedTapesArray valueForKey:@"stock_cover_id"]objectAtIndex:indexPath.row]);
                
                if (![[[[FetchTapesModel sharedInstance].myCretedTapesArray valueForKey:@"stock_cover_id"]objectAtIndex:indexPath.row] isKindOfClass:[NSNull class]] && ![[[[FetchTapesModel sharedInstance].myCretedTapesArray valueForKey:@"stock_cover_id"]objectAtIndex:indexPath.row] isEqualToString:@""]) {
                    albumArtworkImage.image = [UIImage imageNamed:[[[FetchTapesModel sharedInstance].myCretedTapesArray valueForKey:@"stock_cover_id"]objectAtIndex:indexPath.row]];
                }else{
                
                [albumArtworkImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://staging.imixedtape.com/image/%@/%dx%d",[[[FetchTapesModel sharedInstance].myCretedTapesArray valueForKey:@"image_token"]objectAtIndex:indexPath.row],100,100]] placeholderImage:[UIImage imageNamed:@"logoIconFull"]];
                }
                
                
                
                if (![[[[FetchTapesModel sharedInstance].myCretedTapesArray valueForKey:@"message"]objectAtIndex:indexPath.row] isEqualToString:@"(null)"]) {
                    messageLabel.text = [[[FetchTapesModel sharedInstance].myCretedTapesArray valueForKey:@"message"]objectAtIndex:indexPath.row];
                }else{
                    messageLabel.text = @"";
                }
                
                
                
                NSLog(@"%@",[[[[FetchTapesModel sharedInstance].myCretedTapesArray valueForKey:@"title"]objectAtIndex:indexPath.row]uppercaseString]);
                if (![[[[[FetchTapesModel sharedInstance].myCretedTapesArray valueForKey:@"title"]objectAtIndex:indexPath.row]uppercaseString] isEqualToString:@"(NULL)"]) {
                    
                    NSInteger charLength = [[[[FetchTapesModel sharedInstance].myCretedTapesArray valueForKey:@"title"]objectAtIndex:indexPath.row] length];
                    
                    charLength = (charLength > 6 && charLength < 36) ? round(triView.layer.frame.size.width / charLength) + 2 : charLength;
                    
                    
                    triView.labelText = [SharedHelper truncatedLabelString:[[[[FetchTapesModel sharedInstance].myCretedTapesArray valueForKey:@"title"]objectAtIndex:indexPath.row]uppercaseString] charactersToLimit:(int)charLength];
                   
                    
                }else{
                    triView.labelText = @"";
                }
                
                triView.fontSize = 8;
                
                if ([[[[FetchTapesModel sharedInstance].myCretedTapesArray objectAtIndex:indexPath.row] valueForKey:@"saved"]boolValue]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        triView.viewColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.7];
                        triView.textColor = [UIColor colorWithRed:120.0/255.0 green:3.0/255.0 blue:10.0/255.0 alpha:0.7];
                    });
                    
                }else{
                    NSLog(@"%d",[[[[FetchTapesModel sharedInstance].myCretedTapesArray objectAtIndex:indexPath.row] valueForKey:@"share_tape_status"]intValue]);
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        switch ([[[[FetchTapesModel sharedInstance].myCretedTapesArray objectAtIndex:indexPath.row] valueForKey:@"share_tape_status"]intValue]) {
                            case 0:
                                triView.viewColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:255.0/255.0 alpha:0.7];
                                triView.textColor = [UIColor whiteColor];
                                break;
                            case 1:
                                triView.viewColor = [UIColor colorWithRed:0.0/255.0 green:255.0/255.0 blue:0.0/255.0 alpha:0.7];
                                triView.textColor = [UIColor whiteColor];
                                break;
                            case 2:
                                triView.viewColor = [UIColor colorWithRed:255.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.7];
                                triView.textColor = [UIColor whiteColor];
                                
                            default:
                                break;
                        }
                    });
                    
                }
                
            }else{
                [SharedHelper emptyCollectionViewScreenText:@"No Mixed Tapes to show." Array:[FetchTapesModel sharedInstance].myCretedTapesArray.mutableCopy collectionView:self.collectionView view:self.view];
            }
            
        }else {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"sharedCell" forIndexPath:indexPath];
            
            UIImageView *albumArtworkImage = (UIImageView *)[cell viewWithTag:1];
            UILabel *messageLabel = (UILabel *)[cell viewWithTag:2];
            TriLabelView *triView = (TriLabelView *)[cell viewWithTag:1000];
            
            if ([FetchTapesModel sharedInstance].sharedTapesArray.count !=0) {
                
                albumArtworkImage.contentMode = UIViewContentModeScaleAspectFill;
                
                NSLog(@"%@",[[[FetchTapesModel sharedInstance].sharedTapesArray valueForKey:@"stock_cover_id"]objectAtIndex:indexPath.row]);
                
                if (![[[[FetchTapesModel sharedInstance].sharedTapesArray valueForKey:@"stock_cover_id"]objectAtIndex:indexPath.row] isKindOfClass:[NSNull class]] && ![[[[FetchTapesModel sharedInstance].sharedTapesArray valueForKey:@"stock_cover_id"]objectAtIndex:indexPath.row] isEqualToString:@""] ) {
                    NSLog(@"%@",[[[FetchTapesModel sharedInstance].sharedTapesArray valueForKey:@"stock_cover_id"]objectAtIndex:indexPath.row]);
                    albumArtworkImage.image = [UIImage imageNamed:[[[FetchTapesModel sharedInstance].sharedTapesArray valueForKey:@"stock_cover_id"]objectAtIndex:indexPath.row]];
                }else{
                    [albumArtworkImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://staging.imixedtape.com/image/%@/%dx%d",[[[FetchTapesModel sharedInstance].sharedTapesArray valueForKey:@"image_token"]objectAtIndex:indexPath.row],100,100]] placeholderImage:[UIImage imageNamed:@"logoIconFull"]];
                }
                
                
                
               
                
                
                messageLabel.text = [[[FetchTapesModel sharedInstance].sharedTapesArray valueForKey:@"message"]objectAtIndex:indexPath.row];
                triView.labelText = [SharedHelper truncatedLabelString:[[[[FetchTapesModel sharedInstance].sharedTapesArray valueForKey:@"title"]objectAtIndex:indexPath.row]uppercaseString] charactersToLimit:5];
                triView.fontSize = 8;
                
                switch ([[[[FetchTapesModel sharedInstance].sharedTapesArray objectAtIndex:indexPath.row] valueForKey:@"status"]intValue]) {
                    case 0:
                        triView.viewColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:255.0/255.0 alpha:0.7];
                        break;
                    case 1:
                        triView.viewColor = [UIColor colorWithRed:0.0/255.0 green:255.0/255.0 blue:0.0/255.0 alpha:0.7];
                        break;
                    case 2:
                        triView.viewColor = [UIColor colorWithRed:255.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.7];
                        
                    default:
                        break;
                }
                
            }else{
                [SharedHelper emptyCollectionViewScreenText:@"No Mixed Tapes to show." Array:[FetchTapesModel sharedInstance].sharedTapesArray.mutableCopy collectionView:self.collectionView view:self.view];
            }
            
        }
        
      
        
        
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    } @finally {
        
    }
    return cell;
    
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    float cellWidth = [UIScreen mainScreen].bounds.size.width / 3.5; //Replace the divisor with the column count requirement. Make sure to have it in float.
    return  CGSizeMake(cellWidth, cellWidth);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    NSArray *selectedTape = [[NSArray alloc]init];
    SelectSongVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SELECT_SONG_VC"];
    
    
    
    if (collectionView == self.collectionView) {
        selectedTape = [FetchTapesModel sharedInstance].myCretedTapesArray;
        vc.tapeOwnerNameString = @"";
        vc.selectedTapeID = [[selectedTape valueForKey:@"id"]objectAtIndex:indexPath.row];
        vc.myTapeStatus = [[selectedTape valueForKey:@"share_tape_status"]objectAtIndex:indexPath.row];
    }else{
        selectedTape = [FetchTapesModel sharedInstance].sharedTapesArray;
        vc.tapeOwnerNameString = [[selectedTape valueForKey:@"full_name"]objectAtIndex:indexPath.row];
        vc.selectedTapeID = [[selectedTape valueForKey:@"imixed_tape_id"]objectAtIndex:indexPath.row];
        vc.sharedTapeStatus = [[selectedTape valueForKey:@"status"]objectAtIndex:indexPath.row];
    }
    
    
    vc.tapeTitleString = [[selectedTape valueForKey:@"title"]objectAtIndex:indexPath.row];
    vc.tapeMessageString = [[selectedTape valueForKey:@"message"]objectAtIndex:indexPath.row];
    vc.imageToken =  [[selectedTape valueForKey:@"image_token"]objectAtIndex:indexPath.row];
    vc.stockCover = [[selectedTape valueForKey:@"stock_cover_id"]objectAtIndex:indexPath.row];
    vc.imageUploadId =  [[selectedTape valueForKey:@"upload_id"]objectAtIndex:indexPath.row];
    vc.selectedTapeSharedID =[[selectedTape valueForKey:@"shared_id"]objectAtIndex:indexPath.row];
    
    NSLog(@"%@",vc.selectedTapeID);
    
    NSLog(@"%c",[[[selectedTape objectAtIndex:indexPath.row]valueForKey:@"saved"]boolValue]);
    
    if (![[[selectedTape objectAtIndex:indexPath.row] valueForKey:@"saved"]boolValue]) {
        
        
        
        [self presentViewController:vc animated:YES completion:nil];
        
    }
    else{
        
        
        NSLog(@"%@",[FetchTapesModel sharedInstance].myCretedTapesArray);
        
        tapeModel.selectedTapeIndex = indexPath.row;
        tapeModel.tapeID = [[[FetchTapesModel sharedInstance].myCretedTapesArray valueForKey:@"tapeID"]objectAtIndex:indexPath.row];
        tapeModel.title = [[[FetchTapesModel sharedInstance].myCretedTapesArray valueForKey:@"title"]objectAtIndex:indexPath.row];
        tapeModel.message = [[[FetchTapesModel sharedInstance].myCretedTapesArray valueForKey:@"message"]objectAtIndex:indexPath.row];
        tapeModel.sendTo = [[[FetchTapesModel sharedInstance].myCretedTapesArray valueForKey:@"sendto"]objectAtIndex:indexPath.row];
        tapeModel.emailOrMobile = [[[FetchTapesModel sharedInstance].myCretedTapesArray valueForKey:@"sendVia"]objectAtIndex:indexPath.row];
        tapeModel.from = [[[FetchTapesModel sharedInstance].myCretedTapesArray valueForKey:@"signed"]objectAtIndex:indexPath.row];
        tapeModel.uploadImageAccessToken = [[[FetchTapesModel sharedInstance].myCretedTapesArray valueForKey:@"image_token"]objectAtIndex:indexPath.row];
        tapeModel.songsAddedArray = [[[FetchTapesModel sharedInstance].myCretedTapesArray valueForKey:@"tapeSongs"]objectAtIndex:indexPath.row];
        tapeModel.uploadImageID = [[[FetchTapesModel sharedInstance].myCretedTapesArray valueForKey:@"tapeImageUploadId"]objectAtIndex:indexPath.row];
        
        
        
        
        self.tabBarController.selectedIndex = 1;
    }
}


-(void)getWebserviceDataOnLoad
{
    
    UserModel *userModel = [[UserModel alloc]init];
    NSLog(@"%@", userModel.userID);
    if (userModel.isLoggedIn) {
        [self webServiceToFetchTapes : userModel.userID];
    }else{
        [self emptyCollectionViewScreen];
        
    }
}

#pragma mark - Empty Collection Screen Message
-(void)emptyCollectionViewScreen
{
    
    
    [SharedHelper emptyCollectionViewScreenText:@"No Mixed Tapes to show." Array:[FetchTapesModel sharedInstance].myCretedTapesArray.mutableCopy collectionView:self.collectionView view:self.view];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
    
    
    [SharedHelper emptyCollectionViewScreenText:@"No Mixed Tapes to show." Array:[FetchTapesModel sharedInstance].sharedTapesArray.mutableCopy collectionView:self.receivedTapesCollectionView view:self.view];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.receivedTapesCollectionView reloadData];
    });
    
}


@end
