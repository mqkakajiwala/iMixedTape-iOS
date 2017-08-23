//
//  AppDelegate.m
//  iMixedTape
//
//  Created by Mustafa on 17/10/2016.
//  Copyright © 2016 LemondeIT. All rights reserved.
//

#import "AppDelegate.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "TabBarControllerSubClass.h"
#import "MeshVC.h"
#import "HomeGridVC.h"


@interface AppDelegate (){
    
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    //copy Database file
    [self copyDataBaseIfNeeded];
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
    //integrate FABRIC.IO
    [Fabric with:@[[Crashlytics class]]];
    
    //facebook login
    [FBSDKLoginButton class];
    
    
    [self meshScreenLoader];
    
    //register for push notification
    
    float ver = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    
    if (ver >=9){
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        
        
    }else{
        
        UNUserNotificationCenter *notifiCenter = [UNUserNotificationCenter currentNotificationCenter];
        notifiCenter.delegate = self;
        [notifiCenter requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
            if( !error ){
                [[UIApplication sharedApplication] registerForRemoteNotifications];
            }
        }];
        
    }
    
    
    //Google Sign in
    NSError* configureError;
    [[GGLContext sharedInstance] configureWithError: &configureError];
    if (configureError != nil) {
        NSLog(@"We have an error : %@",configureError.localizedDescription);
    }
    
    [FBSDKLoginButton class];
    [GIDSignIn sharedInstance].delegate = self;
    
    
    
    [self initialSettings];
    
    
    //Google ad banner registeration
    [GADMobileAds configureWithApplicationID:key_adBanner];
    
    return YES;
}

#pragma mark - Copy Data Base Method
-(void)copyDataBaseIfNeeded
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    
    
    BOOL success = [fileManager fileExistsAtPath:[SharedHelper databaseWithPath]];
    NSLog(@"%@",[SharedHelper databaseWithPath]);
    
    if (!success) {
        NSString *defaultDBPath = [[[NSBundle mainBundle]resourcePath]stringByAppendingPathComponent:DBNAME];
        success = [fileManager copyItemAtPath:defaultDBPath toPath:[SharedHelper databaseWithPath] error:&error];
        
        if (!success) {
            NSAssert1(0, @"Failed to create writable database file with message %@", [error localizedDescription]);
        }
    }
    
}

#pragma mark - Google signin methods
-(void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error
{
    if (error !=nil) {
        NSLog(@"%@",error.localizedDescription);
    }else{
        NSLog(@"%@",user);
    }
}

#pragma mark - Push Notification methods
//-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
//
//    //Do Your Code.................Enjoy!!!!
//}


-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *dToken = [NSString stringWithFormat:@"DEVICE TOKEN = %@",deviceToken];
    [[NSUserDefaults standardUserDefaults]setValue:dToken forKey:key_deviceToken];
    NSLog(@"%@",dToken);
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    NSString *str = [NSString stringWithFormat: @"Error: %@", err];
    NSLog(@"%@",str);
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"%@",userInfo);
    NSLog(@"%ld",(long)[[NSUserDefaults standardUserDefaults]integerForKey:@"test"]);
    UITabBarController *tabBar = (UITabBarController *)self.window.rootViewController;
    HomeGridVC *hg = tabBar.viewControllers[0].childViewControllers[0];
    [hg getWebserviceDataOnLoad];

    
}

#pragma mark - Facebook SDK Method

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    BOOL GoogleHandled = [[GIDSignIn sharedInstance]handleURL:url
                                            sourceApplication:sourceApplication
                                                   annotation:annotation];
    
    
    BOOL fbHandled = [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                    openURL:url
                                                          sourceApplication:sourceApplication
                                                                 annotation:annotation
                      ];
    // Add any custom logic here.
    
    
    return GoogleHandled || fbHandled;
}




- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
 
    [self setStatusBarBackgroundColor:[UIColor blackColor]];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    [CreateTapeModel resetCreateTapeModel];
    
}

#pragma mark - Status Bar Background Color

-(void)setStatusBarBackgroundColor :(UIColor *)color
{
    UIView *barView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 20)];
    barView.backgroundColor = color;
    [self.window.rootViewController.view addSubview:barView];
    
    [[UINavigationBar appearance]setTintColor:[UIColor blackColor]];
}

#pragma mark - Initial Settings
-(void)initialSettings
{
    NSMutableArray *tempArr = [[NSMutableArray alloc]init];
    [[NSUserDefaults standardUserDefaults]setObject:tempArr forKey:key_createTapeSongs];
    
}

-(void)meshScreenLoader {
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    TabBarControllerSubClass *tabVc = [sb instantiateViewControllerWithIdentifier:@"TABVC"];
    MeshVC *meshVc = [sb instantiateViewControllerWithIdentifier:@"MESHVC"];
    NSLog(@"%d",[[NSUserDefaults standardUserDefaults]boolForKey:@"mesh"]);
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"mesh"]) {
        self.window.rootViewController = tabVc;
    }else{
        self.window.rootViewController = meshVc;
    }
}

-(BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler {
    
    NSLog(@"%@",userActivity);
    
    NSURL *webPageUrl = [NSURL URLWithString:@"http://staging.imixedtape.com"];
    [[UIApplication sharedApplication]openURL:webPageUrl];
    return NO;
}

@end
