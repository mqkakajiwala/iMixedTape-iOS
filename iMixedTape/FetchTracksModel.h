//
//  FetchTracksModel.h
//  iMixedTape
//
//  Created by Mustafa on 24/01/2017.
//  Copyright © 2017 LemondeIT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FetchTracksModel : NSObject
+(void)fetchTracksForTapeID :(NSString *)tapeID offset:(int)offset callback:(void (^)(id))callback;

+(void)hitLikeOnTrackWithID :(NSString *)trackID userID:(NSString *)userID callback:(void(^)(id))callback;
@end
