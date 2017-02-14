//
//  PreviewBuyModel.h
//  iMixedTape
//
//  Created by Mustafa on 24/01/2017.
//  Copyright © 2017 LemondeIT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PreviewBuyModel : NSObject

+(void)iTunesAPiForPreviewBuyForSongID :(NSString *)songID callback:(void(^)(id))callback;

@end
