//
//  CreateStepThreeVC.m
//  iMixedTape
//
//  Created by Mustafa on 25/12/2016.
//  Copyright © 2016 LemondeIT. All rights reserved.
//

#import "CreateStepThreeVC.h"
#import "CustomCell.h"
#import "CreateTapeModel.h"

@interface CreateStepThreeVC (){
    NSMutableArray *previewArray;
}

@end

@implementation CreateStepThreeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
   
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        previewArray = [[NSMutableArray alloc]init];
        CreateTapeModel *cModel = [[CreateTapeModel alloc]init];
        NSLog(@"%@",cModel.songsAddedArray);
        NSLog(@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:key_createTapeSongs]);
        previewArray = [[[NSUserDefaults standardUserDefaults]objectForKey:key_createTapeSongs]mutableCopy];
        NSLog(@"%@",previewArray);
        
        if (previewArray.count == 0) {
            [SharedHelper emptyTableScreenText:@"No songs added." Array:previewArray tableView:self.tableView view:self.view];
        }
        [self.tableView reloadData];
    });
    
    
    
    CreateTapeModel *model = [[CreateTapeModel alloc]init];
    self.tapeMainImage.image = model.albumImage;
    self.titleView.labelText = model.title;
    self.messageLabel.text = model.message;
    
 
    
}
#pragma mark - TableView Datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return previewArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCell *cell = (CustomCell *) [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
//    cell.albumArtImageView;
   
    NSLog(@"%@",[[previewArray objectAtIndex:indexPath.row] objectForKey:@"albumArt"]);
    
    [cell.albumArtImageView sd_setImageWithURL:[NSURL URLWithString:[[previewArray objectAtIndex:indexPath.row] objectForKey:@"albumArt"]]];
    
    cell.songTitleLabel.text = [[previewArray objectAtIndex:indexPath.row] objectForKey:@"title"];
//
    cell.songDecLabel.text = [[previewArray objectAtIndex:indexPath.row] objectForKey:@"artist"];
//
    cell.songTimeLabel.text = [[previewArray objectAtIndex:indexPath.row] objectForKey:@"duration"];
    
        
    return cell;
}

#pragma mark - Table View delegate methods

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        
        [previewArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        
        [[NSUserDefaults standardUserDefaults]setObject:previewArray forKey:key_createTapeSongs];
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


@end
