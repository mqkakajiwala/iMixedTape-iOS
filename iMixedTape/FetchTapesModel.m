//
//  FetchTapesModel.m
//  iMixedTape
//
//  Created by Mustafa on 05/01/2017.
//  Copyright © 2017 LemondeIT. All rights reserved.
//

#import "FetchTapesModel.h"

@implementation FetchTapesModel

-(instancetype)initWithArray :(NSArray *)tapesArray
{
    if (self = [super init]) {
        
        self.myTapesArray = tapesArray.mutableCopy;
        NSLog(@"%@",self.myTapesArray);
    }
    
    return self;
}
+(void)fetchUserTapesWithPagination :(int)offset userID:(NSString *)userID :(void (^)(NSArray *))callback
{
    [SVProgressHUD show];
    NSString *url = [NSString stringWithFormat:@"http://staging.imixedtape.com/api/tape/paginate/%d/%@",offset,userID];
    
    NSLog(@"%@",url);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager.requestSerializer setValue:@"Jmnx9P8p3Y0rRy7yxkaLa5oF7IQ1ir5Y" forHTTPHeaderField:@"X-API-KEY"];
    
    
    [manager GET:url
      parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
          
      } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          NSLog(@"%@",responseObject);
          callback([[responseObject objectForKey:@"data"]objectForKey:@"data"]);
          [SVProgressHUD dismiss];
      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          NSLog(@"%@",error.localizedDescription);
          [SVProgressHUD dismiss];
      }];
    
    
}

+(void)mySharedTapesWihPagination :(int)offset userID:(NSString *)userID :(void (^)(NSArray *))callback
{
    [SVProgressHUD show];
    NSString *url = [NSString stringWithFormat:@"http://staging.imixedtape.com/api/sharedtapes/paginate/%d/%@",offset,userID];
    
    NSLog(@"%@",url);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager.requestSerializer setValue:@"Jmnx9P8p3Y0rRy7yxkaLa5oF7IQ1ir5Y" forHTTPHeaderField:@"X-API-KEY"];
    
    
    [manager GET:url
      parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
          
      } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          NSLog(@"%@",responseObject);
          callback([[responseObject objectForKey:@"data"]objectForKey:@"data"]);
          [SVProgressHUD dismiss];
      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          NSLog(@"%@",error.localizedDescription);
          [SVProgressHUD dismiss];
      }];

}

 
     
     @end
