//
//  FetchTapesModel.h
//  iMixedTape
//
//  Created by Mustafa on 05/01/2017.
//  Copyright © 2017 LemondeIT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FetchTapesModel : NSObject

@property (strong,nonatomic) NSMutableArray *myTapesArray;

-(instancetype)initWithArray :(NSArray *)tapesArray;
+(void)fetchUserTapesWithPagination :(int)offset userID:(NSString *)userID :(void (^)(NSArray *))callback;
+(void)mySharedTapesWihPagination :(int)offset userID:(NSString *)userID :(void (^)(NSArray *))callback;
@end
