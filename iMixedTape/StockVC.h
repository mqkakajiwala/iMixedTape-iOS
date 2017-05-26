//
//  StockVC.h
//  iMixedTape
//
//  Created by Mustafa on 26/05/2017.
//  Copyright © 2017 LemondeIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StockVC : UIViewController<UICollectionViewDelegate, UICollectionViewDataSource>

- (IBAction)dismissVC:(UIBarButtonItem *)sender;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@end
