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
@synthesize myTapesArray;
@synthesize sharedTapesArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    myTapesArray = [[NSArray alloc]init];
    sharedTapesArray = [[NSArray alloc]init];
    
    //    [self reloadTableData];
    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UserModel *userModel = [[UserModel alloc]init];
    NSLog(@"%@", userModel.userID);
    if (userModel.isLoggedIn) {
        [self webServiceToFetchTapes : userModel.userID];
    }else{
        
        dispatch_async(dispatch_get_main_queue(), ^{
        [SharedHelper emptyCollectionViewScreenText:@"No Mixed Tapes to show." Array:myTapesArray.mutableCopy collectionView:self.collectionView view:self.view];
        
        
            [self.collectionView reloadData];
        });
        
        dispatch_async(dispatch_get_main_queue(), ^{
        [SharedHelper emptyCollectionViewScreenText:@"No Mixed Tapes to show." Array:myTapesArray.mutableCopy collectionView:self.receivedTapesCollectionView view:self.view];
        
            [self.receivedTapesCollectionView reloadData];
        });
        
        
    }
    
    
}

-(void)webServiceToFetchTapes :(NSString *)userID
{
    
    [FetchTapesModel fetchUserTapesWithPagination:200 userID:userID :^(NSArray *callback) {
        
        
        myTapesArray = callback;
        
        //        myTapesArray = callback;
        NSLog(@"%@",myTapesArray);
        
        [SharedHelper emptyCollectionViewScreenText:@"No Mixed Tapes to show." Array:myTapesArray.mutableCopy collectionView:self.collectionView view:self.view];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
    }];
    
    [FetchTapesModel mySharedTapesWihPagination:200 userID:userID :^(NSArray *callback) {
        sharedTapesArray = callback;
        
        //        myTapesArray = callback;
        NSLog(@"%@",sharedTapesArray);
        
        [SharedHelper emptyCollectionViewScreenText:@"No Mixed Tapes to show." Array:sharedTapesArray.mutableCopy collectionView:self.receivedTapesCollectionView view:self.view];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.receivedTapesCollectionView reloadData];
        });
    }];
}

#pragma mark - CollectionView Data Source
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == self.collectionView) {
        return myTapesArray.count;
    }
    else{
        return sharedTapesArray.count;
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
            
            
            if (myTapesArray.count != 0) {
                
                albumArtworkImage.contentMode = UIViewContentModeScaleAspectFit;
                
                [albumArtworkImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://staging.imixedtape.com/image/%@/%dx%d",[[myTapesArray valueForKey:@"image_token"]objectAtIndex:indexPath.row],100,100]] placeholderImage:[UIImage imageNamed:@"logoIconFull"]];
                
                
                messageLabel.text = [[myTapesArray valueForKey:@"message"]objectAtIndex:indexPath.row];
                triView.labelText = [SharedHelper truncatedLabelString:[[[myTapesArray valueForKey:@"title"]objectAtIndex:indexPath.row]uppercaseString] charactersToLimit:5];
                triView.fontSize = 8;
                
            }else{
                [SharedHelper emptyCollectionViewScreenText:@"No Mixed Tapes to show." Array:myTapesArray.mutableCopy collectionView:self.collectionView view:self.view];
            }
            
        }else {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"sharedCell" forIndexPath:indexPath];
            
            UIImageView *albumArtworkImage = (UIImageView *)[cell viewWithTag:1];
            UILabel *messageLabel = (UILabel *)[cell viewWithTag:2];
            TriLabelView *triView = (TriLabelView *)[cell viewWithTag:1000];
            
            
            
            
            if (sharedTapesArray.count !=0) {
                
                albumArtworkImage.contentMode = UIViewContentModeScaleAspectFit;
                
                [albumArtworkImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://staging.imixedtape.com/image/%@/%dx%d",[[sharedTapesArray valueForKey:@"image_token"]objectAtIndex:indexPath.row],100,100]] placeholderImage:[UIImage imageNamed:@"logoIconFull"]];
                
                
                messageLabel.text = [[sharedTapesArray valueForKey:@"message"]objectAtIndex:indexPath.row];
                triView.labelText = [SharedHelper truncatedLabelString:[[[myTapesArray valueForKey:@"title"]objectAtIndex:indexPath.row]uppercaseString] charactersToLimit:5];
                triView.fontSize = 8;
            }else{
                [SharedHelper emptyCollectionViewScreenText:@"No Mixed Tapes to show." Array:myTapesArray.mutableCopy collectionView:self.collectionView view:self.view];
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
        selectedTape = myTapesArray;
        vc.tapeOwnerNameString = @"";
        vc.selectedTapeID = [[selectedTape valueForKey:@"id"]objectAtIndex:indexPath.row];
    }else{
        selectedTape = sharedTapesArray;
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







@end
