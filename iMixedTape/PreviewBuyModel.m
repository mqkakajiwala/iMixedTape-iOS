//
//  PreviewBuyModel.m
//  iMixedTape
//
//  Created by Mustafa on 24/01/2017.
//  Copyright © 2017 LemondeIT. All rights reserved.
//

#import "PreviewBuyModel.h"

@implementation PreviewBuyModel

+(void)iTunesAPiForPreviewBuyForSongID :(NSString *)songID viewController:(UIViewController *)vc callback:(void(^)(id))callback
{
    [SVProgressHUD showWithStatus:@"Please Wait .."];
    NSString *url = [NSString stringWithFormat:@"https://itunes.apple.com/lookup?id=%@",songID];
    
    
    NSString *encoded = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",url);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:@"Jmnx9P8p3Y0rRy7yxkaLa5oF7IQ1ir5Y" forHTTPHeaderField:@"X-API-KEY"];
    [manager.requestSerializer setTimeoutInterval:20];
    
    [manager GET:encoded
      parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
          
      } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          NSLog(@"%@",responseObject);
          callback(responseObject);
          [SVProgressHUD dismiss];
      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          NSLog(@"%@",error.localizedDescription);
          [SharedHelper AlertControllerWithTitle:@"" message:[error localizedDescription] viewController:vc];
          [SVProgressHUD dismiss];
      }];
}

@end
