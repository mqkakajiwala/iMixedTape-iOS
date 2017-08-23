//
//  CreateTapeModel.m
//  iMixedTape
//
//  Created by Mustafa on 14/01/2017.
//  Copyright © 2017 LemondeIT. All rights reserved.
//

#import "CreateTapeModel.h"

@implementation CreateTapeModel

@synthesize tapeID;
@synthesize selectedTapeIndex;
@synthesize title;
@synthesize uploadImageID;
@synthesize uploadImageAccessToken;
@synthesize message;
@synthesize sendTo;
@synthesize emailOrMobile;
@synthesize from;
@synthesize albumImage;
@synthesize isEmail;
@synthesize songsAddedArray;
@synthesize imageData;
@synthesize isCloned;
@synthesize stockImageString;
@synthesize stockImagesArray;

static CreateTapeModel *instance = nil;

+(CreateTapeModel *)sharedInstance
{
    @synchronized (self) {
        if (instance == nil) {
            instance = [CreateTapeModel new];
            
        }
    }
    
    return instance;
}

-(id)init
{
    if (self) {
        self = [super init];
        
        self.tapeID = @"";
        self.albumImage = [UIImage imageNamed:@"imgicon"];
        self.uploadImageID = @"";
        self.uploadImageAccessToken = @"";
        self.songsAddedArray = [[NSMutableArray alloc]init];
        self.title = @"";
        self.uploadImageID = @"";
        self.message = @"";
        self.sendTo = @"";
        self.emailOrMobile = @"";
        self.from = @"";
        self.isEmail = YES;
        self.isCloned = NO;
        self.stockImageString = @"";
        stockImagesArray = @[@"stock1", @"stock2", @"stock3", @"stock4", @"stock5", @"stock6", @"stock7"];
        

    }
    
    return self;
}

+(void)resetCreateTapeModel
{
    instance = nil;
}
+(void)uploadFileWithAttachnment :(NSString *)base64String viewController:(UIViewController *)vc callback :(void (^)(id))callback
{
    [SVProgressHUD showWithStatus:@"Uploading .."];

    
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
                                                       timeoutInterval:20];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPBody:postData];
    [request setTimeoutInterval:15];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        NSLog(@"%@", error);
                                                        [SharedHelper AlertControllerWithTitle:@"" message:[error localizedDescription] viewController:vc];
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


-(void)postFinalTapeToServer :(NSString *)tapeTitle message:(NSString *)tapeMessage userID:(NSString *)userID uploadImageID:(NSString *)uploadID stockid:(NSString *)stockID savedSongsArray:(NSMutableArray *)savedSongsArray viewController:(UIViewController *)vc callback:(void (^)(id))callback
{
    
    NSString *url = @"http://staging.imixedtape.com/api/tape/create";
    
    NSLog(@"%@",userID);    
    NSLog(@"%@",url);
    
    NSString *key;
    NSString *errMsg;
    if (self.isEmail) {
        key = @"to_user_email";
        errMsg = @"Please specify Email of the person you want to share mixedtape.";
    }else{
        key = @"to_user_phone";
        errMsg = @"Please specify Phone of the person you want to share mixedtape.";
    }
    
    if ([tapeTitle isEqualToString:@""]) {
        [SharedHelper AlertControllerWithTitle:@"" message:@"Please add title for your mixedtape." viewController:vc];
    }
    else if ([self.emailOrMobile isEqualToString:@""]){
        [SharedHelper AlertControllerWithTitle:@"" message:errMsg viewController:vc];
    }else{
    
        [SVProgressHUD show];
        
    NSDictionary *params = @{@"title" : tapeTitle,
                             @"message" : message,
                             @"user_id" : userID,
                             @"upload_id" : uploadID,
                             @"stock_cover_id" : stockID
                             };
    
    NSLog(@"%@",params);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:@"Jmnx9P8p3Y0rRy7yxkaLa5oF7IQ1ir5Y" forHTTPHeaderField:@"X-API-KEY"];
    [manager.requestSerializer setTimeoutInterval:20];
    [manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        
        //===============================================>>
        
        //Share MixedTape
        NSString *url = @"http://staging.imixedtape.com/api/tape/share";
        
        NSLog(@"%@",url);
        
        NSLog(@"%@",key);
        NSLog(@"%@",self.emailOrMobile);
        
        NSDictionary *params = @{@"imixed_tape_id" : [[responseObject objectForKey:@"data"]objectForKey:@"id"],
                                 @"user_id" : userID,
                                 key : self.emailOrMobile
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
            [SharedHelper AlertControllerWithTitle:@"" message:[error localizedDescription] viewController:vc];
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
                                                           timeoutInterval:20.0];
        [request setHTTPMethod:@"POST"];
        [request setAllHTTPHeaderFields:headers];
        [request setHTTPBody:postData];
        
        
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                        if (error) {
                                                            NSLog(@"%@", error);
                                                            [SharedHelper AlertControllerWithTitle:@"" message:[error localizedDescription] viewController:vc];
                                                        } else {
                                                           
                                                            id responseObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                                            NSLog(@"%@",responseObject);
                                                            callback(responseObject);
                                                            
                                                            
                                                            
                                                            
                                                        }
                                                        
                                                        
                                                    }];
        [dataTask resume];

        
        
        
        
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error.localizedDescription);
        [SharedHelper AlertControllerWithTitle:@"" message:[error localizedDescription] viewController:vc];
        
        [SVProgressHUD dismiss];
    }];

    }
}
@end
