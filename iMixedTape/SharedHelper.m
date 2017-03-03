//
//  SharedHelper.m
//  iMixedTape
//
//  Created by Mustafa Qutbuddin on 1/4/17.
//  Copyright © 2017 LemondeIT. All rights reserved.
//

#import "SharedHelper.h"

@implementation SharedHelper
@synthesize savedTapesArray;
#pragma mark - empty table screen

+(SharedHelper *)sharedInstance
{
    static SharedHelper *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc]init];
        shared.savedTapesArray = [[NSMutableArray alloc]init];
    });
    
    return shared;
}

-(id)init{
    
    if (self = [super init]) {
        
        NSData *data = [[NSUserDefaults standardUserDefaults]objectForKey:key_savedTapesArray];
        
        self.savedTapesArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        NSLog(@"%@",self.savedTapesArray);
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

+(NSString *)databaseWithPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths[0];
    
    NSString *dbPath = [documentsDirectory stringByAppendingPathComponent:DBNAME];
    
    return dbPath;
}

+(NSMutableArray *)getSavedTaoesFromDB :(FMDatabase *)database
{
    FMResultSet *results = [database executeQuery:@"select id as tapeID, title as title, image_token as image, imageUploadID as imageID, message as message, sendto as sendto, sendvia as emailORmobile, sendFrom as sendFrom, tapeSongs as songs, saved as isSaved from saved_tapes_table"];
    
    NSMutableArray *savedTapeTempArray = [[NSMutableArray alloc]init];
    NSDictionary *dict = [[NSDictionary alloc]init];
    
    while ([results next]) {
        NSLog(@"%@",results);
        
        NSString *tapeID = [NSString stringWithFormat:@"%@",[results stringForColumn:@"tapeID"]];
        NSString *tapeTitle = [NSString stringWithFormat:@"%@",[results stringForColumn:@"title"]];
        
        NSString *image_token = [NSString stringWithFormat:@"%@",[results stringForColumn:@"image"]];
        
        NSString *imageID = [NSString stringWithFormat:@"%@",[results stringForColumn:@"imageID"]];
        
        NSString *tapeMessage = [NSString stringWithFormat:@"%@",[results stringForColumn:@"message"]];
        
        NSString *tapeSendto = [NSString stringWithFormat:@"%@",[results stringForColumn:@"sendto"]];
        
        NSString *tapeSendVia = [NSString stringWithFormat:@"%@",[results stringForColumn:@"emailORmobile"]];
        
        NSString *tapeFrom = [NSString stringWithFormat:@"%@",[results stringForColumn:@"sendFrom"]];
        
        NSArray *tapeSongs = [NSKeyedUnarchiver unarchiveObjectWithData:[results dataForColumn:@"songs"]];
        
        if (tapeSongs == nil) {
            tapeSongs = [[NSArray alloc]init];
        }
        
        BOOL isSaved = [[NSString stringWithFormat:@"%@",[results stringForColumn:@"isSaved"]]boolValue];
                
                      NSLog(@"%ld",(long)tapeID);
        NSLog(@"%d",isSaved);
        
        dict = @{@"title" : tapeTitle,
                 @"image_token" : image_token,
                 @"tapeImageUploadId" : imageID,
                 @"message" : tapeMessage,
                 @"sendto" : tapeSendto,
                 @"sendVia" : tapeSendVia,
                 @"signed" : tapeFrom,
                 @"tapeSongs" : tapeSongs,
                 @"saved" : @"YES",
                 @"tapeID" : tapeID
                 };
        
        NSLog(@"%@",dict);
        
        [savedTapeTempArray addObject:dict];
    }
    
    
    NSLog(@"%@",savedTapeTempArray);
    
    if (savedTapeTempArray == nil) {
        savedTapeTempArray = [[NSMutableArray alloc]init];
    }

    return savedTapeTempArray;
}

+(void)iTunesSearchAPI :(NSString *)mySongtitle
{
    [SVProgressHUD showWithStatus:@"Song Adding .."];
    NSString *url = [NSString stringWithFormat:@"https://itunes.apple.com/search?term=%@&limit=1",mySongtitle];
    //    NSString *url = [link stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    
    NSString *encoded = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",url);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:@"Jmnx9P8p3Y0rRy7yxkaLa5oF7IQ1ir5Y" forHTTPHeaderField:@"X-API-KEY"];
    [manager GET:encoded
      parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
          
      } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          NSLog(@"%@",responseObject);
          
          if ([[responseObject objectForKey:@"resultCount"]intValue] == 1) {
              
              
              NSDictionary *dict = @{@"title"  : mySongtitle,
                                     @"song_id": [[[responseObject objectForKey:@"results"]valueForKey:@"trackId"]firstObject],
                                     @"genre"  : [[[responseObject objectForKey:@"results"]valueForKey:@"primaryGenreName"]firstObject],
                                     @"album"  : @"",
                                     @"artist" : [[[responseObject objectForKey:@"results"]valueForKey:@"artistName"]firstObject],
                                     @"language" : @"English",
                                     @"albumArt" : [[[responseObject objectForKey:@"results"]valueForKey:@"artworkUrl60"]firstObject]
                                     };
              
              NSLog(@"%@",dict);
              
              [[CreateTapeModel sharedInstance].songsAddedArray addObject:dict];
              //          [[NSUserDefaults standardUserDefaults]setObject:helper.tapeSongsArray forKey:key_createTapeSongs];
              NSLog(@"%@",[CreateTapeModel sharedInstance].songsAddedArray);
              
          }
          [SVProgressHUD dismiss];
      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          NSLog(@"%@",error.localizedDescription);
          [SVProgressHUD dismiss];
      }];
}

+(NSDictionary *)getCountryCodeDictionary
{
    return [NSDictionary dictionaryWithObjectsAndKeys:@"972", @"IL",
            @"93", @"AF", @"355", @"AL", @"213", @"DZ", @"1", @"AS",
            @"376", @"AD", @"244", @"AO", @"1", @"AI", @"1", @"AG",
            @"54", @"AR", @"374", @"AM", @"297", @"AW", @"61", @"AU",
            @"43", @"AT", @"994", @"AZ", @"1", @"BS", @"973", @"BH",
            @"880", @"BD", @"1", @"BB", @"375", @"BY", @"32", @"BE",
            @"501", @"BZ", @"229", @"BJ", @"1", @"BM", @"975", @"BT",
            @"387", @"BA", @"267", @"BW", @"55", @"BR", @"246", @"IO",
            @"359", @"BG", @"226", @"BF", @"257", @"BI", @"855", @"KH",
            @"237", @"CM", @"1", @"CA", @"238", @"CV", @"345", @"KY",
            @"236", @"CF", @"235", @"TD", @"56", @"CL", @"86", @"CN",
            @"61", @"CX", @"57", @"CO", @"269", @"KM", @"242", @"CG",
            @"682", @"CK", @"506", @"CR", @"385", @"HR", @"53", @"CU",
            @"537", @"CY", @"420", @"CZ", @"45", @"DK", @"253", @"DJ",
            @"1", @"DM", @"1", @"DO", @"593", @"EC", @"20", @"EG",
            @"503", @"SV", @"240", @"GQ", @"291", @"ER", @"372", @"EE",
            @"251", @"ET", @"298", @"FO", @"679", @"FJ", @"358", @"FI",
            @"33", @"FR", @"594", @"GF", @"689", @"PF", @"241", @"GA",
            @"220", @"GM", @"995", @"GE", @"49", @"DE", @"233", @"GH",
            @"350", @"GI", @"30", @"GR", @"299", @"GL", @"1", @"GD",
            @"590", @"GP", @"1", @"GU", @"502", @"GT", @"224", @"GN",
            @"245", @"GW", @"595", @"GY", @"509", @"HT", @"504", @"HN",
            @"36", @"HU", @"354", @"IS", @"91", @"IN", @"62", @"ID",
            @"964", @"IQ", @"353", @"IE", @"972", @"IL", @"39", @"IT",
            @"1", @"JM", @"81", @"JP", @"962", @"JO", @"77", @"KZ",
            @"254", @"KE", @"686", @"KI", @"965", @"KW", @"996", @"KG",
            @"371", @"LV", @"961", @"LB", @"266", @"LS", @"231", @"LR",
            @"423", @"LI", @"370", @"LT", @"352", @"LU", @"261", @"MG",
            @"265", @"MW", @"60", @"MY", @"960", @"MV", @"223", @"ML",
            @"356", @"MT", @"692", @"MH", @"596", @"MQ", @"222", @"MR",
            @"230", @"MU", @"262", @"YT", @"52", @"MX", @"377", @"MC",
            @"976", @"MN", @"382", @"ME", @"1", @"MS", @"212", @"MA",
            @"95", @"MM", @"264", @"NA", @"674", @"NR", @"977", @"NP",
            @"31", @"NL", @"599", @"AN", @"687", @"NC", @"64", @"NZ",
            @"505", @"NI", @"227", @"NE", @"234", @"NG", @"683", @"NU",
            @"672", @"NF", @"1", @"MP", @"47", @"NO", @"968", @"OM",
            @"92", @"PK", @"680", @"PW", @"507", @"PA", @"675", @"PG",
            @"595", @"PY", @"51", @"PE", @"63", @"PH", @"48", @"PL",
            @"351", @"PT", @"1", @"PR", @"974", @"QA", @"40", @"RO",
            @"250", @"RW", @"685", @"WS", @"378", @"SM", @"966", @"SA",
            @"221", @"SN", @"381", @"RS", @"248", @"SC", @"232", @"SL",
            @"65", @"SG", @"421", @"SK", @"386", @"SI", @"677", @"SB",
            @"27", @"ZA", @"500", @"GS", @"34", @"ES", @"94", @"LK",
            @"249", @"SD", @"597", @"SR", @"268", @"SZ", @"46", @"SE",
            @"41", @"CH", @"992", @"TJ", @"66", @"TH", @"228", @"TG",
            @"690", @"TK", @"676", @"TO", @"1", @"TT", @"216", @"TN",
            @"90", @"TR", @"993", @"TM", @"1", @"TC", @"688", @"TV",
            @"256", @"UG", @"380", @"UA", @"971", @"AE", @"44", @"GB",
            @"1", @"US", @"598", @"UY", @"998", @"UZ", @"678", @"VU",
            @"681", @"WF", @"967", @"YE", @"260", @"ZM", @"263", @"ZW",
            @"591", @"BO", @"673", @"BN", @"61", @"CC", @"243", @"CD",
            @"225", @"CI", @"500", @"FK", @"44", @"GG", @"379", @"VA",
            @"852", @"HK", @"98", @"IR", @"44", @"IM", @"44", @"JE",
            @"850", @"KP", @"82", @"KR", @"856", @"LA", @"218", @"LY",
            @"853", @"MO", @"389", @"MK", @"691", @"FM", @"373", @"MD",
            @"258", @"MZ", @"970", @"PS", @"872", @"PN", @"262", @"RE",
            @"7", @"RU", @"590", @"BL", @"290", @"SH", @"1", @"KN",
            @"1", @"LC", @"590", @"MF", @"508", @"PM", @"1", @"VC",
            @"239", @"ST", @"252", @"SO", @"47", @"SJ", @"963", @"SY",
            @"886", @"TW", @"255", @"TZ", @"670", @"TL", @"58", @"VE",
            @"84", @"VN", @"1", @"VG", @"1", @"VI", nil];
}

@end
