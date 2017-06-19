//
//  PlayTapeModel.h
//  iMixedTape
//
//  Created by Mustafa Qutbuddin on 6/19/17.
//  Copyright © 2017 LemondeIT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlayTapeModel : NSObject {
    NSString *tapeMessageStr;
    UIImage *albumArtImage;
    NSString *nextSongStr;
    NSString *currentSongStr;
    NSString *songDurationStr;
    NSString *artistStr;
    MPMediaItem *nextSongMPMediaItem;
    NSString *songID;
    NSString *tapeTitleStr;
    NSArray *queueSongArray;
    NSString *imgToken;
    
}


@property (strong,nonatomic) NSString *tapeMessageStr;
@property (strong,nonatomic) UIImage *albumArtImage;
@property (strong,nonatomic) NSString *nextSongStr;
@property (strong,nonatomic) NSString *currentSongStr;
@property (strong,nonatomic) NSString *songDurationStr;
@property (strong,nonatomic) NSString *artistStr;
@property (strong,nonatomic) MPMediaItem *nextSongMPMediaItem;
@property(strong,nonatomic) NSString *songID;
@property (strong,nonatomic) NSString *tapeTitleStr;
@property (strong,nonatomic) NSArray *queueSongArray;
@property (strong,nonatomic) NSString *imgToken;


+(PlayTapeModel *)sharedInstance;
-(void)createSessionForKey :(NSString *)key value:(id)value;
-(id)getUserSessionForKey: (NSString *)key;
@end
