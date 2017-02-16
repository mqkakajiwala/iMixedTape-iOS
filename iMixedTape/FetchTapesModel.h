//
//  FetchTapesModel.h
//  iMixedTape
//
//  Created by Mustafa on 05/01/2017.
//  Copyright © 2017 LemondeIT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FetchTapesModel : NSObject{
    NSMutableArray *myCretedTapesArray;
    NSMutableArray *sharedTapesArray;
}

+(FetchTapesModel *)sharedInstance;


@property (strong,nonatomic) NSMutableArray *myCretedTapesArray;
@property (strong,nonatomic) NSMutableArray *sharedTapesArray;


+(void)fetchUserTapesWithPagination :(int)offset userID:(NSString *)userID :(void (^)(NSArray *))callback;
+(void)mySharedTapesWihPagination :(int)offset userID:(NSString *)userID :(void (^)(NSArray *))callback;
@end
