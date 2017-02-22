//
//  NewUserModel.m
//  iMixedTape
//
//  Created by Mustafa Qutbuddin on 1/3/17.
//  Copyright © 2017 LemondeIT. All rights reserved.
//

#import "NewUserModel.h"




@implementation NewUserModel

+(void)postUserSessionWithName :(NSString *)fname
                          lname:(NSString *)lname
                          email:(NSString *)email
                       password:(NSString *)password
                         gender:(NSString *)gender
                            dob:(NSString *)dob
                       deviceID:(NSString *)deviceID
                    deviceToken:(NSString *)deviceToken
                       platform:(NSString *)platform
                        country:(NSString *)country
                           city:(NSString *)city
                          state:(NSString *)state
                          phone:(NSString *)phone
                 oauth_provider:(NSString *)oauth_provider
                      oauth_uid:(NSString *)oauth_uid
                        zipcode:(NSString *)zipcode
                 viewController:(UIViewController *)vc
                               : (void (^)(id ))callback
{
    [SVProgressHUD show];
    NSString *url = @"http://staging.imixedtape.com/api/users/create";//[NSString stringWithFormat:getReportListURL, offset, name, orderBy, search];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //    manager.securityPolicy.allowInvalidCertificates = YES;
    //    manager.securityPolicy.validatesDomainName = NO;
    [manager.requestSerializer setValue:@"Jmnx9P8p3Y0rRy7yxkaLa5oF7IQ1ir5Y" forHTTPHeaderField:@"X-API-KEY"];
    [manager.requestSerializer setTimeoutInterval:20];
    
    
    NSDictionary *params = @{@"first" : fname,
                             @"last" : lname,
                             @"email" : email,
                             @"password" : password,
                             @"gender" : gender,
                             @"dob" : dob,
                             @"device_id" : deviceID,
                             @"device_token" : deviceToken,
                             @"platform" : @"iOS",
                             @"country" : country,
                             @"city" : city,
                             @"state" : state,
                             @"phone" : phone,
                             @"zipcode" : zipcode,  
                             @"oauth_provider" : oauth_provider,
                             @"oauth_uid" : oauth_uid
                             };
    
    NSLog(@"%@",params);
    [manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        callback(responseObject[@"data"]);
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error.localizedDescription);
        [SharedHelper AlertControllerWithTitle:@"" message:[error localizedDescription] viewController:vc];
        [SVProgressHUD dismiss];
    }];

}
@end
