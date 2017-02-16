//
//  SharedHelper.m
//  iMixedTape
//
//  Created by Mustafa Qutbuddin on 1/4/17.
//  Copyright © 2017 LemondeIT. All rights reserved.
//

#import "SharedHelper.h"

@implementation SharedHelper
@synthesize tapeSongsArray;
#pragma mark - empty table screen

+(SharedHelper *)sharedInstance
{
    static SharedHelper *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc]init];
        shared.tapeSongsArray = [[NSMutableArray alloc]init];
    });
    
    return shared;
}

-(id)init{
    
    if (self = [super init]) {
        
        self.tapeSongsArray = [[[NSUserDefaults standardUserDefaults]objectForKey:key_createTapeSongs]mutableCopy];
        NSLog(@"%@",self.tapeSongsArray);
    }
    
    return self;
}

+(void)emptyTableScreenText  : (NSString *)text  Array: (NSMutableArray *)arr  tableView:(UITableView *)tableView  view: (UIView *)view
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UILabel *label = [[UILabel alloc]initWithFrame:view.frame];
        
        label.text = text;
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 10;
        label.center = view.center;
        label.textColor = [UIColor lightGrayColor];
        tableView.backgroundView = label;
        
        if (arr.count <= 0) {
            label.hidden = NO;
            tableView.separatorColor = [UIColor clearColor];
        }else{
            label.hidden = YES;
            
        }
    });
    
}

+(void)emptyCollectionViewScreenText  : (NSString *)text  Array: (NSMutableArray *)arr  collectionView:(UICollectionView *)collectionView  view: (UIView *)view
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UILabel *label = [[UILabel alloc]initWithFrame:view.frame];
        
        label.text = text;
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 10;
        label.center = view.center;
        label.textColor = [UIColor lightGrayColor];
        collectionView.backgroundView = label;
        
        if (arr.count <= 0) {
            label.hidden = NO;
//            collectionView.separatorColor = [UIColor clearColor];
        }else{
            label.hidden = YES;
            
        }
    });
    
}

+(void)AlertControllerWithTitle :(NSString *)title message:(NSString *)message viewController:(UIViewController *)vc
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"OK"
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];
    
    [vc presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Change button background on selection
+(void)changeButtonBackgroundOnSelection : (UIButton *)sender :(UIView *)view
{
    
    for (UIView *button in view.subviews) {
        if ([button isKindOfClass:[UIButton class]]) {
            [(UIButton *)button setSelected:NO];
            [(UIButton*)button setBackgroundColor:[UIColor colorWithRed:0.745 green:0.102 blue:0.090 alpha:1.00]];
        }
    }
    [sender setBackgroundColor:[UIColor blackColor]];
    
}

+ (BOOL) validateEmail : (NSString *) email required : (BOOL) isRequired minChars : (NSInteger) min maxChars : (NSInteger) max
{
    // If email is required
    if (isRequired && ![email length])
        return NO;
    
    if (min && [email length] < min)
        return NO;
    else if (max && [email length] > max)
        return NO;
    
    
    NSError *err; // Error in case of invalid email address
    // Match pattern against email address
    NSRegularExpression *regExp = [NSRegularExpression regularExpressionWithPattern : @"^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}$"
                                                                            options : NSRegularExpressionCaseInsensitive
                                                                              error : &err];
    // Count the number of matches returned by regular expression
    NSUInteger numOfMatches = [regExp numberOfMatchesInString : email
                                                      options : 0
                                                        range : NSMakeRange(0, [email length])];
    // If the count of matches is zero
    if (!numOfMatches)
        return NO;
    
    // If successfully validated
    return YES;
}






+ (BOOL) validatePassword : (NSString *) pass required : (BOOL) isRequired minChars : (NSInteger) min maxChars : (NSInteger) max
{ 
    // If password is required
    if (isRequired && ![pass length])
        return NO;
    
    if (min && [pass length] < min)
        return NO;
    else if (max && [pass length] > max)
        return NO;
    
    // If successfully validated
    return YES;
}



+ (BOOL) validateUserName : (NSString *) str required : (BOOL) isRequired minChars : (NSInteger) min maxChars : (NSInteger) max
{
    // If string is required
    if (isRequired && ![str length])
        return NO;
    
    if (min && [str length] < min)
        return NO;
    else if (max && [str length] > max)
        return NO;
    
    NSError *err; // Error in case of invalid string
    // Match pattern against string
    NSRegularExpression *regExp = [NSRegularExpression regularExpressionWithPattern : @"^[A-Z0-9\\s\\-\\_\\.]+$"
                                                                            options : NSRegularExpressionCaseInsensitive
                                                                              error : &err];
    // Count the number of matches returned by regular expression
    NSUInteger numOfMatches = [regExp numberOfMatchesInString : str
                                                      options : 0
                                                        range : NSMakeRange(0, [str length])];
    // If the count of matches is zero
    if (!numOfMatches)
        return NO;
    
    // If successfully validated
    return YES;
    
}
+(void)customBezierPath :(UIView *)view position:(int)x
{
//    UIBezierPath *path = [UIBezierPath new];
//    [path moveToPoint:(CGPoint){0, 0}];
//    [path addLineToPoint:(CGPoint){0, x}];
//    [path addLineToPoint:(CGPoint){x, 0}];
//    [path addLineToPoint:(CGPoint){0, 0}];
//    
//    // Create a CAShapeLayer with this triangular path
//    // Same size as the original imageView
//    CAShapeLayer *mask = [CAShapeLayer new];
//    mask.frame = view.bounds;
//    mask.path = path.CGPath;
//    
//    // Mask the imageView's layer with this shape
//    view.layer.mask = mask;
    
    
    
    
}

+ (BOOL)validatePhone:(NSString *)phoneNumber
{
    if (phoneNumber.length >= 10) {
        return YES;
    }else{
        return NO;
    }
    
    
}

+(void)fetchGoogleAdds :(GADBannerView *)adBannerView onViewController:(UIViewController *)vc
{
    adBannerView.adUnitID = key_adBanner;
    adBannerView.rootViewController = vc;
    [adBannerView loadRequest:[GADRequest request]];
}

+(void)removeTapeDefaults
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:key_createTapeTitle];
    [defaults removeObjectForKey:key_createTapeUploadImageID];
    [defaults removeObjectForKey:key_createTapeMessage];
    [defaults removeObjectForKey:key_createTapeSendTo];
    [defaults removeObjectForKey:key_createTapeEmailOrMobile];
    [defaults removeObjectForKey:key_createTapeFrom];
    [defaults removeObjectForKey:key_createTapeImage];
    [defaults removeObjectForKey:key_createTapeSongs];
}

+(NSString *)truncatedLabelString :(NSString *)temp charactersToLimit:(int)index
{
    
    if ([temp length] > 15) {
        @try {
            temp = [temp substringToIndex:index];
            temp = [temp stringByAppendingString:@" …"];
        } @catch (NSException *exception) {
            NSLog(@"%@",exception);
        } @finally {
            
        }
        
    }
    return  temp;
    
}

#pragma mark - Resize Image
+(UIImage*)imageWithImage: (UIImage*) sourceImage scaledToWidth: (float) i_width
{
    float oldWidth = sourceImage.size.width;
    float scaleFactor = i_width / oldWidth;
    
    float newHeight = sourceImage.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
