//
//  AcceptTapeModel.m
//  iMixedTape
//
//  Created by Mustafa Qutbuddin on 2/9/17.
//  Copyright © 2017 LemondeIT. All rights reserved.
//

#import "AcceptTapeModel.h"

@implementation AcceptTapeModel

+(void)acceptSharedTapeWithID :(NSString *)tapeID status:(NSString *)tapeStatus callback:(void(^)(id))callback
{
    [SVProgressHUD show];
    NSString *url = @"http://staging.imixedtape.com/api/tape/accept";//[NSString stringWithFormat:getReportListURL, offset, name, orderBy, search];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //    manager.securityPolicy.allowInvalidCertificates = YES;
    //    manager.securityPolicy.validatesDomainName = NO;
    [manager.requestSerializer setValue:@"Jmnx9P8p3Y0rRy7yxkaLa5oF7IQ1ir5Y" forHTTPHeaderField:@"X-API-KEY"];
    [manager.requestSerializer setTimeoutInterval:10];
    
    NSDictionary *params = @{@"shared_id" : tapeID,
                             @"status" : tapeStatus
                             };
    
    NSLog(@"%@",params);
    [manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        callback (responseObject);
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error.localizedDescription);
        [SVProgressHUD dismiss];
    }];
}

@end
