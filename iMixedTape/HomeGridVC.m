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


@interface HomeGridVC (){

    FetchTapesModel *fetchTapesModel;
}

@end

@implementation HomeGridVC
//@synthesize myTapesArray;
//@synthesize sharedTapesArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    
    
    //    [self reloadTableData];
    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self emptyCollectionViewScreen];
    
    
}

-(void)webServiceToFetchTapes :(NSString *)userID
{
    
    [FetchTapesModel fetchUserTapesWithPagination:200 userID:userID :^(NSArray *callback) {
        
        
        [FetchTapesModel sharedInstance].myCretedTapesArray = callback.mutableCopy;
        
        //        myTapesArray = callback;
        NSLog(@"%@",[FetchTapesModel sharedInstance].myCretedTapesArray);
        
        [SharedHelper emptyCollectionViewScreenText:@"No Mixed Tapes to show." Array:[FetchTapesModel sharedInstance].myCretedTapesArray.mutableCopy collectionView:self.collectionView view:self.view];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
    }];
    
    [FetchTapesModel mySharedTapesWihPagination:200 userID:userID :^(NSArray *callback) {
        [FetchTapesModel sharedInstance].sharedTapesArray = callback.mutableCopy;
        
        //        myTapesArray = callback;
        NSLog(@"%@",[FetchTapesModel sharedInstance].sharedTapesArray);
        
        [SharedHelper emptyCollectionViewScreenText:@"No Mixed Tapes to show." Array:[FetchTapesModel sharedInstance].sharedTapesArray.mutableCopy collectionView:self.receivedTapesCollectionView view:self.view];
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
                
                albumArtworkImage.contentMode = UIViewContentModeScaleAspectFit;
                
                [albumArtworkImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://staging.imixedtape.com/image/%@/%dx%d",[[[FetchTapesModel sharedInstance].myCretedTapesArray valueForKey:@"image_token"]objectAtIndex:indexPath.row],100,100]] placeholderImage:[UIImage imageNamed:@"logoIconFull"]];
                
                
                messageLabel.text = [[[FetchTapesModel sharedInstance].myCretedTapesArray valueForKey:@"message"]objectAtIndex:indexPath.row];
                triView.labelText = [SharedHelper truncatedLabelString:[[[[FetchTapesModel sharedInstance].myCretedTapesArray valueForKey:@"title"]objectAtIndex:indexPath.row]uppercaseString] charactersToLimit:5];
                triView.fontSize = 8;
                
            }else{
                [SharedHelper emptyCollectionViewScreenText:@"No Mixed Tapes to show." Array:[FetchTapesModel sharedInstance].myCretedTapesArray.mutableCopy collectionView:self.collectionView view:self.view];
            }
            
        }else {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"sharedCell" forIndexPath:indexPath];
            
            UIImageView *albumArtworkImage = (UIImageView *)[cell viewWithTag:1];
            UILabel *messageLabel = (UILabel *)[cell viewWithTag:2];
            TriLabelView *triView = (TriLabelView *)[cell viewWithTag:1000];
            
            
            
            
            if ([FetchTapesModel sharedInstance].sharedTapesArray.count !=0) {
                
                albumArtworkImage.contentMode = UIViewContentModeScaleAspectFit;
                
                [albumArtworkImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://staging.imixedtape.com/image/%@/%dx%d",[[[FetchTapesModel sharedInstance].sharedTapesArray valueForKey:@"image_token"]objectAtIndex:indexPath.row],100,100]] placeholderImage:[UIImage imageNamed:@"logoIconFull"]];
                
                
                messageLabel.text = [[[FetchTapesModel sharedInstance].sharedTapesArray valueForKey:@"message"]objectAtIndex:indexPath.row];
                triView.labelText = [SharedHelper truncatedLabelString:[[[[FetchTapesModel sharedInstance].sharedTapesArray valueForKey:@"title"]objectAtIndex:indexPath.row]uppercaseString] charactersToLimit:5];
                triView.fontSize = 8;
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
    }else{
        selectedTape = [FetchTapesModel sharedInstance].sharedTapesArray;
        vc.tapeOwnerNameString = [[selectedTape valueForKey:@"full_name"]objectAtIndex:indexPath.row];
        vc.selectedTapeID = [[selectedTape valueForKey:@"imixed_tape_id"]objectAtIndex:indexPath.row];
    }
    
    
    vc.tapeTitleString = [[selectedTape valueForKey:@"title"]objectAtIndex:indexPath.row];
    vc.tapeMessageString = [[selectedTape valueForKey:@"message"]objectAtIndex:indexPath.row];
    vc.imageToken =  [[selectedTape valueForKey:@"image_token"]objectAtIndex:indexPath.row];
    vc.tapeStatus = [[selectedTape valueForKey:@"status"]objectAtIndex:indexPath.row];
    vc.selectedTapeSharedID =[[selectedTape valueForKey:@"shared_id"]objectAtIndex:indexPath.row];
    NSLog(@"%@",vc.tapeStatus);
    NSLog(@"%@",vc.selectedTapeID);
    
    
    [self presentViewController:vc animated:YES completion:nil];
}


-(void)getWebserviceDataOnLoad
{
    
//    myTapesArray = [[NSArray alloc]init];
//    sharedTapesArray = [[NSArray alloc]init];
    
    
    
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
    

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
            [self.receivedTapesCollectionView reloadData];
        });
    
    
  
    
}


@end
