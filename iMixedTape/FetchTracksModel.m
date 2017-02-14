//
//  FetchTracksModel.m
//  iMixedTape
//
//  Created by Mustafa on 24/01/2017.
//  Copyright © 2017 LemondeIT. All rights reserved.
//

#import "FetchTracksModel.h"

@implementation FetchTracksModel

+(void)fetchTracksForTapeID :(NSString *)tapeID offset:(int)offset callback:(void (^)(id))callback;
{
    [SVProgressHUD show];
    NSString *url = [NSString stringWithFormat:@"http://staging.imixedtape.com/api/tape/tracks/paginate/%d/%@",offset,tapeID];
    
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

+(void)hitLikeOnTrackWithID :(NSString *)trackID userID:(NSString *)userID callback:(void(^)(id))callback
{
    [SVProgressHUD show];
    NSString *url = @"http://staging.imixedtape.com/api/tape/like";//[NSString stringWithFormat:getReportListURL, offset, name, orderBy, search];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //    manager.securityPolicy.allowInvalidCertificates = YES;
    //    manager.securityPolicy.validatesDomainName = NO;
    [manager.requestSerializer setValue:@"Jmnx9P8p3Y0rRy7yxkaLa5oF7IQ1ir5Y" forHTTPHeaderField:@"X-API-KEY"];
    [manager.requestSerializer setTimeoutInterval:10];
    
    NSDictionary *params = @{@"track_id" : trackID,
                             @"user_id" : userID
                             };
    
    NSLog(@"%@",params);
    [manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        callback (responseObject[@"data"]);
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error.localizedDescription);
        [SVProgressHUD dismiss];
    }];
}

@end
