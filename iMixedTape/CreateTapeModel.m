//
//  CreateTapeModel.m
//  iMixedTape
//
//  Created by Mustafa on 14/01/2017.
//  Copyright © 2017 LemondeIT. All rights reserved.
//

#import "CreateTapeModel.h"

@implementation CreateTapeModel

-(instancetype)init
{
    if (self) {
        self = [super init];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        self.title = [defaults valueForKey:key_createTapeTitle];
        self.uploadImageID = [defaults valueForKey:key_createTapeUploadImageID];
        self.message = [defaults valueForKey:key_createTapeMessage];
        self.sendTo = [defaults valueForKey:key_createTapeSendTo];
        self.emailOrMobile = [defaults valueForKey:key_createTapeEmailOrMobile];
        self.from = [defaults valueForKey:key_createTapeFrom];
        NSData *imgData = [defaults objectForKey:key_createTapeImage];
        self.albumImage = [UIImage imageWithData:imgData];
        self.isEmail = [defaults boolForKey:key_createTapeIfEmailMobileBOOL];
        self.songsAddedArray = [defaults objectForKey:key_createTapeSongs];
    }
    
    return self;
}
+(void)uploadFileWithAttachnment :(NSString *)base64String callback :(void (^)(id))callback
{
    [SVProgressHUD showWithStatus:@"Uploading .."];
//    NSString *url = @"http://staging.imixedtape.com/api/upload/file";
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    //    manager.securityPolicy.allowInvalidCertificates = YES;
//    //    manager.securityPolicy.validatesDomainName = NO;
//    [manager.requestSerializer setValue:@"Jmnx9P8p3Y0rRy7yxkaLa5oF7IQ1ir5Y" forHTTPHeaderField:@"X-API-KEY"];
//    [manager.requestSerializer setTimeoutInterval:10];
//    
//    NSDictionary *params = @{@"attachment" : base64String,
//                             };
//    
//    NSLog(@"%@",params);
//    [manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@",responseObject);
//        [SVProgressHUD dismiss];
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"%@",error.localizedDescription);
//        [SVProgressHUD dismiss];
//    }];
    
    
    NSDictionary *headers = @{ @"content-type": @"multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW",
                               @"x-api-key": @"Jmnx9P8p3Y0rRy7yxkaLa5oF7IQ1ir5Y",
                               @"cache-control": @"no-cache",
                               @"postman-token": @"71d1604a-f1e0-2df1-6159-3aa515e82745" };
    
    NSArray *parameters = @[ @{ @"name": @"attachment", @"value": base64String} ];
    NSString *boundary = @"----WebKitFormBoundary7MA4YWxkTrZu0gW";
    
    NSError *error;
    NSMutableString *body = [NSMutableString string];
    for (NSDictionary *param in parameters) {
        [body appendFormat:@"--%@\r\n", boundary];
        if (param[@"fileName"]) {
            [body appendFormat:@"Content-Disposition:form-data; name=\"%@\"; filename=\"%@\"\r\n", param[@"name"], param[@"fileName"]];
            [body appendFormat:@"Content-Type: %@\r\n\r\n", param[@"contentType"]];
            [body appendFormat:@"%@", [NSString stringWithContentsOfFile:param[@"fileName"] encoding:NSUTF8StringEncoding error:&error]];
            if (error) {
                NSLog(@"%@", error);
            }
        } else {
            [body appendFormat:@"Content-Disposition:form-data; name=\"%@\"\r\n\r\n", param[@"name"]];
            [body appendFormat:@"%@", param[@"value"]];
        }
    }
    [body appendFormat:@"\r\n--%@--\r\n", boundary];
    NSData *postData = [body dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://staging.imixedtape.com/api/upload/file"]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:200];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPBody:postData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        NSLog(@"%@", error);
                                                        [SVProgressHUD dismiss];
                                                        
                                                    } else {
                                                        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                                        NSLog(@"%@", httpResponse);
                                                        id responseObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                                        
                                                        NSLog(@"%@",responseObject);
                                                        callback(responseObject);
                                                        
                                                        [SVProgressHUD dismiss];
                                                    }
                                                }];
    [dataTask resume];
}

+(void)createTapeWithTitle :(NSString *)title message:(NSString *)message userID :(NSString *)userID imageUploadedID :(NSString *)imageID uploadType:(NSString *)uploadType
{
    
}

-(void)postFinalTapeToServer :(NSString *)title message:(NSString *)message userID:(NSString *)userID uploadImageID:(NSString *)uploadID savedSongsArray:(NSMutableArray *)savedSongsArray callback:(void (^)(id))callback
{
    [SVProgressHUD show];
    NSString *url = @"http://staging.imixedtape.com/api/tape/create";
    
    NSLog(@"%@",url);
    
    
    
    
    NSDictionary *params = @{@"title" : title,
                             @"message" : message,
                             @"user_id" : userID,
                             @"upload_id" : uploadID
                             };
    
    

    
    NSLog(@"%@",params);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //    manager.securityPolicy.allowInvalidCertificates = YES;
    //    manager.securityPolicy.validatesDomainName = NO;
    [manager.requestSerializer setValue:@"Jmnx9P8p3Y0rRy7yxkaLa5oF7IQ1ir5Y" forHTTPHeaderField:@"X-API-KEY"];
    [manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        
        //===============================================>>
        
        //Share MixedTape
        NSString *url = @"http://staging.imixedtape.com/api/tape/share";
        
        NSLog(@"%@",url);
        
        NSString *key;
        if ([[NSUserDefaults standardUserDefaults]boolForKey:key_ifemail]) {
            key = @"to_user_email";
        }else{
            key = @"to_user_phone";
        }
        
        CreateTapeModel *cModel = [[CreateTapeModel alloc]init];
        NSLog(@"%@", cModel.emailOrMobile);
        
         NSLog(@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:key_createTapeEmailOrMobile]);
        NSDictionary *params = @{@"imixed_tape_id" : [[responseObject objectForKey:@"data"]objectForKey:@"id"],
                                 @"user_id" : userID,
                                 key : [[NSUserDefaults standardUserDefaults]valueForKey:key_createTapeEmailOrMobile]
                                 };
        
        NSLog(@"%@",params);
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        //    manager.securityPolicy.allowInvalidCertificates = YES;
        //    manager.securityPolicy.validatesDomainName = NO;
        [manager.requestSerializer setValue:@"Jmnx9P8p3Y0rRy7yxkaLa5oF7IQ1ir5Y" forHTTPHeaderField:@"X-API-KEY"];
        [manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"%@",responseObject);
            
            [SVProgressHUD dismiss];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error.localizedDescription);
            [SVProgressHUD dismiss];
        }];

        
        
        //===============================================>>
        
        
        //Add Songs To MixedTape API
        NSDictionary *headers = @{ @"x-api-key": @"Jmnx9P8p3Y0rRy7yxkaLa5oF7IQ1ir5Y",
                                   @"content-type": @"application/json",
                                   @"cache-control": @"no-cache",
                                   @"postman-token": @"db030530-dc21-8957-400d-871ecb2b2a5b" };
        
        NSDictionary *parameters = @{@"imixed_tape_id" : [[responseObject objectForKey:@"data"]objectForKey:@"id"],
                                     @"tracks" : savedSongsArray
                                     
                                     };
        NSLog(@"%@",parameters);
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://staging.imixedtape.com/api/tape/addmixedtapetracks"]
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                           timeoutInterval:10.0];
        [request setHTTPMethod:@"POST"];
        [request setAllHTTPHeaderFields:headers];
        [request setHTTPBody:postData];
        
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                        if (error) {
                                                            NSLog(@"%@", error);
                                                        } else {
                                                            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                                            NSLog(@"%@", httpResponse);
                                                            id responseObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                                            NSLog(@"%@",responseObject);
                                                            callback(responseObject);
                                                        }
                                                    }];
        [dataTask resume];

        
        
        
        
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error.localizedDescription);
        [SVProgressHUD dismiss];
    }];

}
@end
