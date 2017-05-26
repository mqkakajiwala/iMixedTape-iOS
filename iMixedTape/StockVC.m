//
//  StockVC.m
//  iMixedTape
//
//  Created by Mustafa on 26/05/2017.
//  Copyright © 2017 LemondeIT. All rights reserved.
//

#import "StockVC.h"
#import "CreateStepOneVC.h"

@interface StockVC (){
    NSArray *stockImagesArray;
    CreateTapeModel *tapeModel;
}

@end

@implementation StockVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    tapeModel = [CreateTapeModel sharedInstance];
    
    stockImagesArray = [[NSArray alloc]init];
    stockImagesArray = @[@"stock1", @"stock2", @"stock3", @"stock4", @"stock5", @"stock6", @"stock7"];
}

#pragma mark - Collection View Data Source

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return stockImagesArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    
    UIImageView *stockImages = (UIImageView *)[cell viewWithTag:1];
    stockImages.image = [UIImage imageNamed:stockImagesArray[indexPath.row]];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIImage *choosenImage = [UIImage imageNamed:stockImagesArray[indexPath.row]];
    tapeModel.imageData = UIImagePNGRepresentation(choosenImage);
    
    
    NSString *base64str = [self encodeToBase64String:choosenImage];
    [CreateTapeModel uploadFileWithAttachnment:base64str viewController:self callback:^(id callback) {
        
        if ([[callback objectForKey:@"error"]boolValue] == NO) {
          NSString  *imageUploadID = [[callback objectForKey:@"data"]objectForKey:@"id"];
            
            tapeModel.uploadImageID = imageUploadID;
            tapeModel.uploadImageAccessToken = [[callback objectForKey:@"data"]objectForKey:@"access_token"];
            
            tapeModel.albumImage = choosenImage;
            NSLog(@"%@",tapeModel.albumImage);
            NSLog(@"%@", base64str);
            
            
            
      [self performSegueWithIdentifier:@"segueStock" sender:indexPath];
            
        }
        else{
            [SharedHelper AlertControllerWithTitle:@"Error" message:@"Image cannot be uploaded" viewController:self];
        }
        
    }];

    

      
    
    
    
}

#pragma mark - Encode to base 64 string
- (NSString *)encodeToBase64String:(UIImage *)image {
    return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

- (IBAction)dismissVC:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

    
   
}
@end
