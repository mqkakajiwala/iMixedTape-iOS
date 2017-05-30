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
//    NSArray *myTapesArray;
//    NSArray *sharedTapesArray;
    
}

@end

@implementation HomeListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self emptyTableScreen];

}

#pragma mark - UITableView DataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.myMixedTapeTableView) {
        return [FetchTapesModel sharedInstance].myCretedTapesArray.count;
    }else {
        return [FetchTapesModel sharedInstance].sharedTapesArray.count;
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
           
            
            if ([FetchTapesModel sharedInstance].myCretedTapesArray.count != 0) {
                
                cell.albumArtImageView.contentMode = UIViewContentModeScaleAspectFit;
                
                [cell.albumArtImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://staging.imixedtape.com/image/%@/%dx%d",[[[FetchTapesModel sharedInstance].myCretedTapesArray valueForKey:@"image_token"]objectAtIndex:indexPath.row],100,100]] placeholderImage:[UIImage imageNamed:@"logoIconFull"]];
                
                
                cell.titleTextLabel.text = [[[FetchTapesModel sharedInstance].myCretedTapesArray valueForKey:@"title"]objectAtIndex:indexPath.row];
            }else{
                [SharedHelper emptyTableScreenText:@"No Mixed Tapes to show." Array:[FetchTapesModel sharedInstance].myCretedTapesArray.mutableCopy tableView:self.myMixedTapeTableView view:self.view];
                
                
            }
        }else{
            if ([FetchTapesModel sharedInstance].sharedTapesArray.count != 0) {
                
                cell.albumArtImageView.contentMode = UIViewContentModeScaleAspectFit;
                
                [cell.albumArtImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://staging.imixedtape.com/image/%@/%dx%d",[[[FetchTapesModel sharedInstance].sharedTapesArray valueForKey:@"image_token"]objectAtIndex:indexPath.row],100,100]] placeholderImage:[UIImage imageNamed:@"logoIconFull"]];
                
                
                cell.titleTextLabel.text = [[[FetchTapesModel sharedInstance].sharedTapesArray valueForKey:@"message"]objectAtIndex:indexPath.row];
            }else{
            [SharedHelper emptyTableScreenText:@"No Mixed Tapes to show." Array:[FetchTapesModel sharedInstance].sharedTapesArray.mutableCopy tableView:self.receivedTapeTableView view:self.view];
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
//    [CreateTapeModel resetCreateTapeModel];
    
    NSArray *selectedTape = [[NSArray alloc]init];
    SelectSongVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SELECT_SONG_VC"];
    
    if (tableView == self.myMixedTapeTableView) {
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
    
    vc.selectedTapeSharedID =[[selectedTape valueForKey:@"shared_id"]objectAtIndex:indexPath.row];
    
    NSLog(@"%@",vc.selectedTapeID);
    
    
    if (![[[selectedTape objectAtIndex:indexPath.row] valueForKey:@"saved"]boolValue]) {
        
        [self presentViewController:vc animated:YES completion:nil];
    }
    else{
        CreateTapeModel *tapeModel = [CreateTapeModel sharedInstance];
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

#pragma mark - Empty Table Screen
-(void)emptyTableScreen
{
        [SharedHelper emptyTableScreenText:@"No Mixed Tapes to show." Array:[FetchTapesModel sharedInstance].myCretedTapesArray.mutableCopy tableView:self.myMixedTapeTableView view:self.view];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.myMixedTapeTableView reloadData];
        });
        
        [SharedHelper emptyTableScreenText:@"No Mixed Tapes to show." Array:[FetchTapesModel sharedInstance].sharedTapesArray.mutableCopy tableView:self.receivedTapeTableView view:self.view];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.receivedTapeTableView reloadData];
            
        });

}
@end
