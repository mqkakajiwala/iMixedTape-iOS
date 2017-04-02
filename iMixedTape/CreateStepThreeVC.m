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
    CreateTapeModel *tapeModel;
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
    
    
    previewArray = [[NSMutableArray alloc]init];
    tapeModel = [CreateTapeModel sharedInstance];
    NSLog(@"%@",tapeModel.songsAddedArray);
    previewArray = tapeModel.songsAddedArray;
    NSLog(@"%@",previewArray);
    
    if (previewArray.count == 0) {
        [SharedHelper emptyTableScreenText:@"No songs added." Array:previewArray tableView:self.tableView view:self.view];
    }
    [self.tableView reloadData];
    
    if ([tapeModel.uploadImageAccessToken isKindOfClass:[NSString class]]) {
        if (![tapeModel.uploadImageAccessToken isEqualToString:@""]) {
            [self.tapeMainImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://staging.imixedtape.com/image/%@/%dx%d",tapeModel.uploadImageAccessToken,100,100]] placeholderImage:[UIImage imageNamed:@"imgicon"]];
        }else{
            self.tapeMainImage.image = tapeModel.albumImage;
        }
    }
    self.titleView.labelText = tapeModel.title;
    self.messageLabel.text = tapeModel.message;
    
    
    
}
#pragma mark - TableView Datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return previewArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCell *cell = (CustomCell *) [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSLog(@"%@",[[previewArray objectAtIndex:indexPath.row] objectForKey:@"albumArt"]);
    
    [cell.albumArtImageView sd_setImageWithURL:[NSURL URLWithString:[[previewArray objectAtIndex:indexPath.row] objectForKey:@"albumArt"]]];
    
    cell.songTitleLabel.text = [[previewArray objectAtIndex:indexPath.row] objectForKey:@"title"];
    cell.songDecLabel.text = [[previewArray objectAtIndex:indexPath.row] objectForKey:@"artist"];
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
        
        tapeModel.songsAddedArray = previewArray;
        NSLog(@"%@",previewArray);
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


@end
