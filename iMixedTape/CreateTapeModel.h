//
//  CreateTapeModel.h
//  iMixedTape
//
//  Created by Mustafa on 14/01/2017.
//  Copyright © 2017 LemondeIT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CreateTapeModel : NSObject{
    
    NSString *tapeID;
    NSInteger selectedTapeIndex;
    NSString *title;
    NSString *uploadImageAccessToken;
    NSString *uploadImageID;
    NSString *message;
    NSString *sendTo;
    NSString *emailOrMobile;
    NSString *from;
    UIImage *albumImage;
    NSData *imageData;
    BOOL isEmail;
    BOOL isCloned;
    NSMutableArray *songsAddedArray;
}

+(CreateTapeModel *)sharedInstance;

@property (strong,nonatomic) NSString *tapeID;
@property (nonatomic) NSInteger selectedTapeIndex;
@property (strong,nonatomic) NSString *title;
@property (strong,nonatomic) NSData *imageData;
@property (strong,nonatomic) NSString *uploadImageID;
@property (strong,nonatomic) NSString *uploadImageAccessToken;
@property (strong,nonatomic) NSString *message;
@property (strong,nonatomic) NSString *sendTo;
@property (strong,nonatomic) NSString *emailOrMobile;
@property (strong,nonatomic) NSString *from;
@property (strong,nonatomic) UIImage *albumImage;
@property (nonatomic) BOOL isEmail;
@property (nonatomic) BOOL isCloned;
@property (strong,nonatomic) NSMutableArray *songsAddedArray;


+(void)resetCreateTapeModel;
+(void)uploadFileWithAttachnment :(NSString *)base64String viewController:(UIViewController *)vc callback :(void (^)(id))callback;
-(void)postFinalTapeToServer :(NSString *)tapeTitle message:(NSString *)tapeMessage userID:(NSString *)userID uploadImageID:(NSString *)uploadID savedSongsArray:(NSMutableArray *)savedSongsArray viewController:(UIViewController *)vc callback:(void (^)(id))callback;
@end
