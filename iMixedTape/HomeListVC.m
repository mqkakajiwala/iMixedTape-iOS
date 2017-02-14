//
//  HomeListVC.m
//  iMixedTape
//
//  Created by Mustafa on 21/12/2016.
//  Copyright © 2016 LemondeIT. All rights reserved.
//

#import "HomeListVC.h"
#import "ListCell.h"
#import "FetchTapesModel.h"
#import "SelectSongVC.h"
@interface HomeListVC (){
    FetchTapesModel *fetchTapesModel;
    NSArray *myTapesArray;
    NSArray *sharedTapesArray;
    
}

@end

@implementation HomeListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    myTapesArray = [[NSArray alloc]init];
    sharedTapesArray = [[NSArray alloc]init];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UserModel *userModel = [[UserModel alloc]init];
    NSLog(@"%@", userModel.userID);
    if (userModel.isLoggedIn) {
        [self webServiceToFetchTapes : userModel.userID];
    }
    else{
        
            [SharedHelper emptyTableScreenText:@"No Mixed Tapes to show." Array:myTapesArray.mutableCopy tableView:self.myMixedTapeTableView view:self.view];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.myMixedTapeTableView reloadData];
            });
            
            [SharedHelper emptyTableScreenText:@"No Mixed Tapes to show." Array:sharedTapesArray.mutableCopy tableView:self.receivedTapeTableView view:self.view];
        dispatch_async(dispatch_get_main_queue(), ^{

            [self.receivedTapeTableView reloadData];
        
        });
            
        
    }

}

#pragma mark - Webservice
-(void)webServiceToFetchTapes :(NSString *)userID
{
    [FetchTapesModel fetchUserTapesWithPagination:200 userID:userID :^(NSArray *callback) {
        
        fetchTapesModel = [[FetchTapesModel alloc]initWithArray:callback];
        myTapesArray = fetchTapesModel.myTapesArray;
        
        //        myTapesArray = callback;
        NSLog(@"%@",myTapesArray);
        dispatch_async(dispatch_get_main_queue(), ^{
             [SharedHelper emptyTableScreenText:@"No Mixed Tapes to show." Array:myTapesArray.mutableCopy tableView:self.myMixedTapeTableView view:self.view];
            [self.myMixedTapeTableView reloadData];
        });
    }];
    
    [FetchTapesModel mySharedTapesWihPagination:200 userID:userID :^(NSArray *callback) {
        sharedTapesArray = callback;
        
        //        myTapesArray = callback;
        NSLog(@"%@",sharedTapesArray);
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [SharedHelper emptyTableScreenText:@"No Mixed Tapes to show." Array:sharedTapesArray.mutableCopy tableView:self.receivedTapeTableView view:self.view];
            
            [self.receivedTapeTableView reloadData];
        });
    }];

}

#pragma mark - UITableView DataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.myMixedTapeTableView) {
        return myTapesArray.count;
    }else {
        return sharedTapesArray.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView registerNib:[UINib nibWithNibName:@"HomeListCell" bundle:nil] forCellReuseIdentifier:@"ListCell"];
    ListCell *cell;
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"HomeListCell" owner:self options:nil]objectAtIndex:0];
        
    }
     cell = (ListCell *)[tableView dequeueReusableCellWithIdentifier:@"ListCell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    @try {
        if (tableView == self.myMixedTapeTableView) {
           
            
            if (myTapesArray.count != 0) {
                
                cell.albumArtImageView.contentMode = UIViewContentModeScaleAspectFit;
                
                [cell.albumArtImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://staging.imixedtape.com/image/%@/%dx%d",[[myTapesArray valueForKey:@"image_token"]objectAtIndex:indexPath.row],100,100]] placeholderImage:[UIImage imageNamed:@"logoIconFull"]];
                
                
                cell.titleTextLabel.text = [[myTapesArray valueForKey:@"message"]objectAtIndex:indexPath.row];
            }else{
                [SharedHelper emptyTableScreenText:@"No Mixed Tapes to show." Array:myTapesArray.mutableCopy tableView:self.myMixedTapeTableView view:self.view];
                
                
            }
        }else{
//            cell = (ListCell *)[tableView dequeueReusableCellWithIdentifier:@"ListCell" forIndexPath:indexPath];
            
            if (sharedTapesArray.count != 0) {
                
                cell.albumArtImageView.contentMode = UIViewContentModeScaleAspectFit;
                
                [cell.albumArtImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://staging.imixedtape.com/image/%@/%dx%d",[[sharedTapesArray valueForKey:@"image_token"]objectAtIndex:indexPath.row],100,100]] placeholderImage:[UIImage imageNamed:@"logoIconFull"]];
                
                
                cell.titleTextLabel.text = [[sharedTapesArray valueForKey:@"message"]objectAtIndex:indexPath.row];
            }else{
            [SharedHelper emptyTableScreenText:@"No Mixed Tapes to show." Array:sharedTapesArray.mutableCopy tableView:self.receivedTapeTableView view:self.view];
            }
            
           
        }
    
        
        
    

    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    } @finally {
        
    }
    
    
    return cell;
}

#pragma mark - TableView delegate method
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *selectedTape = [[NSArray alloc]init];
    SelectSongVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SELECT_SONG_VC"];
    
    if (tableView == self.myMixedTapeTableView) {
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
