//
//  PlayTapeModel.m
//  iMixedTape
//
//  Created by Mustafa Qutbuddin on 6/19/17.
//  Copyright © 2017 LemondeIT. All rights reserved.
//

#import "PlayTapeModel.h"

@implementation PlayTapeModel

@synthesize tapeMessageStr;
@synthesize albumArtImage;
@synthesize nextSongStr;
@synthesize currentSongStr;
@synthesize songDurationStr;
@synthesize artistStr;
@synthesize nextSongMPMediaItem;
@synthesize songID;
@synthesize tapeTitleStr;
@synthesize queueSongArray;
@synthesize imgToken;


static PlayTapeModel *instance = nil;

+(PlayTapeModel *)sharedInstance {
    @synchronized (self) {
        if (instance == nil) {
            instance = [PlayTapeModel new];
        }
    }
    
    return instance;
}

//-(id)init {
//    if (self) {
//        self = [super init];
//        
//        self.tapeMessageStr = @"";
//        self.albumArtImage = [UIImage imageNamed:@"imgicon"];
//        self.nextSongStr = @"";
//        self.currentSongStr = @"";
//        self.songDurationStr = @"";
//        self.artistStr = @"";
//        self.songID = @"";
//        self.tapeTitleStr = @"";
//        self.queueSongArray = [[NSArray alloc]init];
//        self.imgToken = @"";
//        
//    }
//    
//    return self;
//}

-(void)createSessionForKey :(NSString *)key value:(id)value {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (![value isKindOfClass:[NSNull class]]) {
    [defaults setObject:value forKey:key];
    }
    
}

-(id)getUserSessionForKey: (NSString *)key {
    return [[NSUserDefaults standardUserDefaults]objectForKey:key];
}



@end
