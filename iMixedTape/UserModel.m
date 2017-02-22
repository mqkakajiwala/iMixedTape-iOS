//
//  UserModel.m
//  iMixedTape
//
//  Created by Mustafa on 09/01/2017.
//  Copyright © 2017 LemondeIT. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel{
    
}

-(instancetype)init
{
    self = [super init];
    
    if (self) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:key_userData];
        NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        if (dict != nil) {
            
            [defaults setBool:YES forKey:key_isLoggedIn];
            [defaults setObject:dict[@"first"] forKey:key_firstName];
            [defaults setObject:dict[@"last"] forKey:key_lastName];
            [defaults setObject:[[dict objectForKey:@"id"]stringValue] forKey:key_userID];
            
            self.isLoggedIn = [defaults boolForKey:key_isLoggedIn];
            self.userData = [defaults objectForKey:key_userData];
            self.firstName = [defaults objectForKey:key_firstName];
            self.lastName = [defaults objectForKey:key_lastName];
            self.userID = [defaults objectForKey:key_userID];
        }
    }
    return self;    
}

-(void)logoutUserSession
{
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:key_isLoggedIn];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:key_userData];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:key_firstName];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:key_lastName];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:key_userID];
    
    self.isLoggedIn = NO;
    self.userData = nil;
    self.firstName = nil;
    self.lastName = nil;
    self.userID = nil;
    
    
}

+(void)postUserSessionWithEmail :(NSString *)email password :(NSString *)password viewController:(UIViewController *)vc success : (void (^)(id responseArray))success
{
    [SVProgressHUD show];
    NSString *url = @"http://staging.imixedtape.com/api/users/login";//[NSString stringWithFormat:getReportListURL, offset, name, orderBy, search];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager.requestSerializer setValue:@"Jmnx9P8p3Y0rRy7yxkaLa5oF7IQ1ir5Y" forHTTPHeaderField:@"X-API-KEY"];
    [manager.requestSerializer setTimeoutInterval:20];
    
    NSDictionary *params = @{@"email" : email,
                             @"password" : password
                             };
    
    NSLog(@"%@",params);
    [manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        success (responseObject);
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error.localizedDescription);
        [SharedHelper AlertControllerWithTitle:@"" message:[error localizedDescription] viewController:vc];
        [SVProgressHUD dismiss];
    }];
}

+(void)forgotPasswordAPIForEmail :(NSString *)email viewController:(UIViewController *)vc callback :(void (^)(id))callback
{
    [SVProgressHUD show];
    NSString *url = @"http://staging.imixedtape.com/api/forgot_password";
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:@"Jmnx9P8p3Y0rRy7yxkaLa5oF7IQ1ir5Y" forHTTPHeaderField:@"X-API-KEY"];
    [manager.requestSerializer setTimeoutInterval:20];
    
    NSDictionary *params = @{@"email" : email,
                             };
    
    NSLog(@"%@",params);
    [manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        callback (responseObject[@"data"]);
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error.localizedDescription);
        [SharedHelper AlertControllerWithTitle:@"" message:[error localizedDescription] viewController:vc];
        [SVProgressHUD dismiss];
    }];
}

+(void)resetPasswordForEmail :(NSString *)email resetToken :(NSString *)resetToken password:(NSString *)pass confirmPass :(NSString *)confirmPass viewController:(UIViewController *)vc callback :(void (^)(id))callback
{
    [SVProgressHUD show];
    NSString *url = @"http://staging.imixedtape.com/api/reset_password";
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:@"Jmnx9P8p3Y0rRy7yxkaLa5oF7IQ1ir5Y" forHTTPHeaderField:@"X-API-KEY"];
    [manager.requestSerializer setTimeoutInterval:20];
    
    NSDictionary *params = @{@"email" : email,
                             @"password" : pass,
                             @"password_confirmation" : confirmPass,
                             @"reset_token" : resetToken
                             };
    
    NSLog(@"%@",params);
    [manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        callback (responseObject[@"data"]);
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error.localizedDescription);
        [SharedHelper AlertControllerWithTitle:@"" message:[error localizedDescription] viewController:vc];
        [SVProgressHUD dismiss];
    }];

}

+(void)changeUserPassword : (NSString *)pass confirmPass :(NSString *)confirmPass viewController:(UIViewController *)vc callback :(void (^)(id))callback
{
    [SVProgressHUD show];
    NSString *url = @"http://staging.imixedtape.com/api/users/update";
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //    manager.securityPolicy.allowInvalidCertificates = YES;
    //    manager.securityPolicy.validatesDomainName = NO;
    [manager.requestSerializer setValue:@"Jmnx9P8p3Y0rRy7yxkaLa5oF7IQ1ir5Y" forHTTPHeaderField:@"X-API-KEY"];
    [manager.requestSerializer setTimeoutInterval:20];
    
    UserModel *model = [[UserModel alloc]init];
    NSDictionary *params = @{
                             @"user_id" : model.userID,
                             @"password" : pass,
                             
                             };
    
    NSLog(@"%@",params);
    [manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        callback (responseObject[@"data"]);
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error.localizedDescription);
        [SharedHelper AlertControllerWithTitle:@"" message:[error localizedDescription] viewController:vc];
        [SVProgressHUD dismiss];
    }];
    
}
@end
