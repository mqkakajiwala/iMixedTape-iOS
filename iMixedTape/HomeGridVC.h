//
//  HomeGridVC.h
//  iMixedTape
//
//  Created by Mustafa Qutbuddin on 11/8/16.
//  Copyright © 2016 LemondeIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeGridVC : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *receivedTapesCollectionView;
//@property (strong,nonatomic) NSArray *myTapesArray;
//@property (strong,nonatomic) NSArray *sharedTapesArray;

-(void)webServiceToFetchTapes :(NSString *)userID;
-(void)getWebserviceDataOnLoad;

@end
