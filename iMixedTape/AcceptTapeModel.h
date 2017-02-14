//
//  AcceptTapeModel.h
//  iMixedTape
//
//  Created by Mustafa Qutbuddin on 2/9/17.
//  Copyright © 2017 LemondeIT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AcceptTapeModel : NSObject

+(void)acceptSharedTapeWithID :(NSString *)tapeID status:(NSString *)tapeStatus callback:(void(^)(id))callback;
@end
