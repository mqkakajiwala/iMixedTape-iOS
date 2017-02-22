//
//  SharedHelper.h
//  iMixedTape
//
//  Created by Mustafa Qutbuddin on 1/4/17.
//  Copyright © 2017 LemondeIT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB/FMDatabase.h>
@import GoogleMobileAds;

@interface SharedHelper : NSObject{
    NSMutableArray *savedTapesArray;
}
@property (strong,nonatomic) NSMutableArray *savedTapesArray;

+(SharedHelper *)sharedInstance;



+(void)emptyTableScreenText  : (NSString *)text  Array: (NSMutableArray *)arr  tableView:(UITableView *)tableView  view: (UIView *)view;
+(void)emptyCollectionViewScreenText  : (NSString *)text  Array: (NSMutableArray *)arr  collectionView:(UICollectionView *)collectionView  view: (UIView *)view;
+(void)AlertControllerWithTitle :(NSString *)title message:(NSString *)message viewController:(UIViewController *)vc;
+(void)changeButtonBackgroundOnSelection : (UIButton *)sender :(UIView *)view;
+ (BOOL) validateEmail : (NSString *) email required : (BOOL) isRequired minChars : (NSInteger) min maxChars : (NSInteger) max;
+ (BOOL) validatePassword : (NSString *) pass required : (BOOL) isRequired minChars : (NSInteger) min maxChars : (NSInteger) max;
+ (BOOL) validateUserName : (NSString *) str required : (BOOL) isRequired minChars : (NSInteger) min maxChars : (NSInteger) max;
+(void)customBezierPath :(UIView *)view position:(int)x;
+ (BOOL)validatePhone:(NSString *)phoneNumber;
+(void)fetchGoogleAdds :(GADBannerView *)adBannerView onViewController:(UIViewController *)vc;
+(void)removeTapeDefaults;
+(NSString *)truncatedLabelString :(NSString *)temp charactersToLimit:(int)index;
+(UIImage*)imageWithImage: (UIImage*) sourceImage scaledToWidth: (float) i_width;
+(NSString *)databaseWithPath;
+(NSMutableArray *)getSavedTaoesFromDB :(FMDatabase *)database;
+(void)iTunesSearchAPI :(NSString *)mySongtitle;
@end


// TO DO : Create NSUserDefaults custom separate class and store userID in it and fetch tapes on home grid.
