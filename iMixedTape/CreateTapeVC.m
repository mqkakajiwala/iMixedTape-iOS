//
//  ViewController.m
//  iMixedTape
//
//  Created by Mustafa on 17/10/2016.
//  Copyright © 2016 LemondeIT. All rights reserved.
//

#import "CreateTapeVC.h"
#import "HomeGridVC.h"
#import "FetchTapesModel.h"

@interface CreateTapeVC (){
    NSString *childVCIdentifier;
    int vcIndexCount;
    CreateTapeModel *tapeModel;
    FetchTapesModel *fetchTapeModel;
    
}

@end

@implementation CreateTapeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboardOnTap)];
    
    //  [self addViewControllerAsChildVC:@"createStep1VC"];
    //self.createStepsImageView.image = [UIImage imageNamed:@"step1"];
    
    [self.view addGestureRecognizer:tap];
    [self setDelegate];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    tapeModel = [CreateTapeModel sharedInstance];
    fetchTapeModel = [FetchTapesModel sharedInstance];
    
    vcIndexCount = 0;
    self.prevButtonOutlet.hidden = YES;
    self.createButtonOutlet.hidden = YES;
    self.nextButtonOutlet.hidden = NO;
    [self childVCAtIndex];
}

#pragma mark - Child ViewControllers

-(void)addViewControllerAsChildVC :(NSString *)identifier
{
    
    childVCIdentifier = identifier;
    
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
    
    
    [self addChildViewController:vc];
    
    [self.parentView addSubview:vc.view];
    
    
    vc.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth |
                                UIViewAutoresizingFlexibleHeight);
    vc.view.frame = self.parentView.bounds;
    
    
}

#pragma mark - TextView and TextField Delegate Method

-(void)setDelegate
{
    self.messageTextView.delegate = self;
    self.sendToTextField.delegate = self;
    self.emailOrMobileTextField.delegate = self;
    self.fromTextField.delegate = self;
}

#pragma mark - Dismiss Keyboard on tap
-(void)dismissKeyboardOnTap
{
    [self.messageTextView resignFirstResponder];
    [self.sendToTextField resignFirstResponder];
    [self.emailOrMobileTextField resignFirstResponder];
    [self.fromTextField resignFirstResponder];
    
    [self animateViewWhenKeyboardAppear:0];
}

#pragma mark - Animate View When Keyboard Appears

-(void)animateViewWhenKeyboardAppear :(int)constant
{
    [UIView animateWithDuration:2.0
                     animations:^{
                         self.animateViewTopWhenKeyboardAppearsConstraint.constant = constant;
                     }];
}

#pragma mark - TextView Delegate Method

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [self animateViewWhenKeyboardAppear:-100];
    
    return YES;
}

#pragma mark - TextField Delegate Method

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self animateViewWhenKeyboardAppear:-200];
    
    return YES;
}

#pragma mark - IBActions
- (IBAction)nextButton:(UIButton *)sender
{
    //    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //UserModel *userModel = [[UserModel alloc]init];
    
    
    // NSLog(@"%@", userModel.userID);
    
    
    
    //    if (tapeModel.title == nil || tapeModel.message == nil || tapeModel.sendTo == nil || tapeModel.emailOrMobile == nil) {
    //
    //        [SharedHelper AlertControllerWithTitle:@"" message:@"Please fill the required fields to continue." viewController:self];
    //        NSLog(@"EMPTY");
    //    }else{
    //
    //        if (tapeModel.isEmail) {
    //            NSString *email = [tapeModel.emailOrMobile stringByTrimmingCharactersInSet : [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    //
    //            BOOL emailValid = [SharedHelper validateEmail : email
    //                                                 required : YES
    //                                                 minChars : 1
    //                                                 maxChars : 100];
    //            if (emailValid) {
    //                self.prevButtonOutlet.hidden = NO;
    //                vcIndexCount++;
    //
    //                if (vcIndexCount == 2) {
    //                    self.createButtonOutlet.hidden = NO;
    //                    self.nextButtonOutlet.hidden = YES;
    //                }
    //                [self childVCAtIndex];
    //            }else{
    //                [SharedHelper AlertControllerWithTitle:@"" message:@"Please enter a valid email." viewController:self];
    //            }
    //
    //
    //
    //        }else{
    //            NSString *phone = [tapeModel.emailOrMobile stringByTrimmingCharactersInSet : [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    //
    //            BOOL phoneValid = [SharedHelper validatePhone:phone];
    //
    //            if (phoneValid) {
    //                self.prevButtonOutlet.hidden = NO;
    //                vcIndexCount++;
    //
    //                if (vcIndexCount == 2) {
    //                    self.createButtonOutlet.hidden = NO;
    //                    self.nextButtonOutlet.hidden = YES;
    //                }
    //                [self childVCAtIndex];
    //            }else{
    //                [SharedHelper AlertControllerWithTitle:@"" message:@"Please enter a valid phone number." viewController:self];
    //            }
    //        }
    //        // Validating username
    //    }
    
    
    //        }else{
    self.prevButtonOutlet.hidden = NO;
    vcIndexCount++;
    
    if (vcIndexCount == 2) {
        self.createButtonOutlet.hidden = NO;
        self.nextButtonOutlet.hidden = YES;
    }
    [self childVCAtIndex];
    //        }
    //    }
    
}

- (IBAction)previousButton:(UIButton *)sender
{
    vcIndexCount--;
    
    self.nextButtonOutlet.hidden = NO;
    self.createButtonOutlet.hidden = YES;
    
    if (vcIndexCount == 0) {
        self.prevButtonOutlet.hidden = YES;
    }else{
        self.prevButtonOutlet.hidden = NO;
    }
    
    
    [self childVCAtIndex];
    
}

- (IBAction)cancelButtonPressed:(UIButton *)sender
{
    UIAlertController *discardTapeAlert = [UIAlertController alertControllerWithTitle:@"" message:@"Are you sure you want to discard the tape? " preferredStyle:UIAlertControllerStyleAlert];
    
    [discardTapeAlert addAction:[UIAlertAction actionWithTitle:@"DISCARD" style:UIAlertActionStyleDestructive  handler:^(UIAlertAction * _Nonnull action) {
        
        if (tapeModel.selectedTapeIndex > 0) {
            
            [fetchTapeModel.myCretedTapesArray removeObjectAtIndex:tapeModel.selectedTapeIndex];
            HomeGridVC *hg = self.tabBarController.viewControllers[0].childViewControllers[0];
            
            FMDatabase *database = [FMDatabase databaseWithPath:[SharedHelper databaseWithPath]];
            [database open];
            
         BOOL b = [database executeUpdate:@"delete from saved_tapes_table WHERE id=?",tapeModel.tapeID];
            NSLog(@"%d",b);
            
            [hg.collectionView reloadData];
        }
        vcIndexCount = 0;
        [self childVCAtIndex];
        
        [CreateTapeModel resetCreateTapeModel];
        
        
        self.tabBarController.selectedIndex = 0;
        
    }]];
    
    [discardTapeAlert addAction:[UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:discardTapeAlert animated:YES completion:nil];
}

- (IBAction)createButton:(UIButton *)sender
{
    
    UserModel *userModel = [[UserModel alloc]init];
    //    SharedHelper *helper = [[SharedHelper alloc]init];
    //    NSMutableArray *tempArr = helper.tapeSongsArray;
    
    
    if (!userModel.isLoggedIn) {
        [SharedHelper AlertControllerWithTitle:@"" message:@"You need to login to create tape." viewController:self];
    }
    else if (tapeModel.songsAddedArray.count == 0){
        [SharedHelper AlertControllerWithTitle:@"" message:@"Please add atleast 1 song to the mixedtape." viewController:self];
    }
    else{
        
        for (int i = 0; i<tapeModel.songsAddedArray.count; i++) {
            NSMutableDictionary *dict = [[tapeModel.songsAddedArray objectAtIndex:i]mutableCopy];
            [dict removeObjectForKey:@"duration"];
            [dict removeObjectForKey:@"albumArt"];
            
            
            [tapeModel.songsAddedArray replaceObjectAtIndex:i withObject:dict];
        }
        NSLog(@"%@",tapeModel.songsAddedArray);
        
        [tapeModel postFinalTapeToServer:tapeModel.title
                                 message:tapeModel.message
                                  userID:userModel.userID
                           uploadImageID:tapeModel.uploadImageID
                         savedSongsArray:tapeModel.songsAddedArray
                          viewController:self
                                callback:^(id callback) {
                                    NSLog(@"%@",callback);
                                    if ([callback isKindOfClass:[NSDictionary class]]) {
                                        if ([[callback valueForKey:@"error"]boolValue] == NO) {
                                            
                                            
                                            if (tapeModel.selectedTapeIndex > 0) {
                                                
                                                [fetchTapeModel.myCretedTapesArray removeObjectAtIndex:tapeModel.selectedTapeIndex];
                                                HomeGridVC *hg = self.tabBarController.viewControllers[0].childViewControllers[0];
                                                
                                                FMDatabase *database = [FMDatabase databaseWithPath:[SharedHelper databaseWithPath]];
                                                [database open];
                                                
                                                BOOL b = [database executeUpdate:@"delete from saved_tapes_table WHERE id=?",tapeModel.tapeID];
                                                NSLog(@"%d",b);
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    [hg getWebserviceDataOnLoad];
                                                    [hg.collectionView reloadData];
                                                });
                                                
                                            }
                                            
                                            
                                            tapeModel.albumImage = nil;
                                            
                                            
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                [self addViewControllerAsChildVC:@"createStep1VC"];
                                            });
                                            
                                            
                                            [CreateTapeModel resetCreateTapeModel];
                                            
                                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                self.tabBarController.selectedIndex = 0;
                                                vcIndexCount = 0;
                                                
                                            });
                                            
                                            [SharedHelper AlertControllerWithTitle:@"" message:@"Mixed tape sent successfully" viewController:self];
                                            
                                        }
                                    }
                                    
                                    
                                    
                                }];
        
    }
}
- (IBAction)saveTapeButton:(UIButton *)sender
{
    UserModel *userModel = [[UserModel alloc]init];
    //    SharedHelper *helper = [[SharedHelper alloc]init];
    //    NSMutableArray *tempArr = helper.tapeSongsArray;
    
    
    if (userModel.isLoggedIn) {
    fetchTapeModel = [FetchTapesModel sharedInstance];
    
    UIAlertController *discardTapeAlert = [UIAlertController alertControllerWithTitle:@"" message:@"Your changes have been saved." preferredStyle:UIAlertControllerStyleAlert];
    
    //    NSMutableArray *ArrayOfDicts = [[NSMutableArray alloc]init];
    
    
    
    
    //    [ArrayOfDicts addObject:dict];
    
    FMDatabase *database = [FMDatabase databaseWithPath:[SharedHelper databaseWithPath]];
    [database open];
    
    //    BOOL b = [database executeUpdate:@"insert into saved_tapes_table(title,image_token,imageUploadID,message,sendto,sendvia,from,tapeSongs,saved) values (?,?,?,?,?,?,?,?,?)",tapeModel.title,tapeModel.albumImage,tapeModel.uploadImageID,tapeModel.message,tapeModel.sendTo,tapeModel.emailOrMobile,tapeModel.from,tapeModel.songsAddedArray,YES];
    
    @try {
        NSLog(@"%@",tapeModel.songsAddedArray);
        
        NSData *sOngsData = [NSKeyedArchiver archivedDataWithRootObject:tapeModel.songsAddedArray];
//        NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithData:sOngsData];
//        NSLog(@"%@",arr);
        
        BOOL b;
        NSLog(@"%@",tapeModel.tapeID);
        NSLog(@"%@",tapeModel.title);
        if (![tapeModel.tapeID isEqualToString:@""]) {
            b = [database executeUpdate:@"update saved_tapes_table SET title=?, image_token=?, imageUploadID=?, message=?, sendto=?, sendvia=?, tapeSongs=?, saved=?, sendFrom=? WHERE id=?",tapeModel.title,tapeModel.uploadImageAccessToken,tapeModel.uploadImageID,tapeModel.message,tapeModel.sendTo,tapeModel.emailOrMobile,sOngsData,0,tapeModel.from,tapeModel.tapeID];
            
            for (int i =0; i < [SharedHelper getSavedTaoesFromDB:database].count; i++) {
                if ([[[[SharedHelper getSavedTaoesFromDB:database]valueForKey:@"tapeID"]objectAtIndex:i] isEqualToString:tapeModel.tapeID]) {
                    
                    [fetchTapeModel.myCretedTapesArray replaceObjectAtIndex:tapeModel.selectedTapeIndex withObject:[[SharedHelper getSavedTaoesFromDB:database]objectAtIndex:i]];
                }
            }
            
        }else{
            
            
            b = [database executeUpdate:@"insert into saved_tapes_table(title,image_token,imageUploadID,message,sendto,sendvia,tapeSongs,saved,sendFrom) VALUES (?,?,?,?,?,?,?,?,?)",tapeModel.title,tapeModel.uploadImageAccessToken,tapeModel.uploadImageID,tapeModel.message,tapeModel.sendTo,tapeModel.emailOrMobile,sOngsData,[NSNumber numberWithInt:1],tapeModel.from];
            
            [fetchTapeModel.myCretedTapesArray addObject:[[SharedHelper getSavedTaoesFromDB:database]lastObject]];
            
            NSLog(@"%d",b);
            
        }
        
        
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    } @finally {
        
    }
    
    
    
    
    
    
    NSLog(@"%@",[SharedHelper getSavedTaoesFromDB:database]);
    
    
    
    HomeGridVC *hg = self.tabBarController.viewControllers[0].childViewControllers[0];
    [hg.collectionView reloadData];
    
    
    [discardTapeAlert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        
        self.tabBarController.selectedIndex = 0;
        vcIndexCount = 0;
        [self childVCAtIndex];
    }]];
    
    [CreateTapeModel resetCreateTapeModel];
    
    [self presentViewController:discardTapeAlert animated:YES completion:nil];
        
    }
    
}
#pragma mark - Create Step Child VC's at index
-(void)childVCAtIndex
{
    
    switch (vcIndexCount) {
        case 0:
            [self addViewControllerAsChildVC:@"createStep1VC"];
            self.createStepsImageView.image = [UIImage imageNamed:@"step1"];
            break;
        case 1:
            [self addViewControllerAsChildVC:@"createStep2VC"];
            self.createStepsImageView.image = [UIImage imageNamed:@"step2"];
            break;
        case 2:
            [self addViewControllerAsChildVC:@"createStep3VC"];
            self.createStepsImageView.image = [UIImage imageNamed:@"step3"];
            break;
        default:
            break;
    }
}

- (IBAction)step1MelodyButton:(UIButton *)sender
{
//    vcIndexCount = 0;
//    [self childVCAtIndex];
}

- (IBAction)step2MelodyButton:(UIButton *)sender
{
//    vcIndexCount = 1;
//    [self childVCAtIndex];
}

- (IBAction)step3MelodyButton:(UIButton *)sender
{
//    vcIndexCount = 2;
//    [self childVCAtIndex];
}
@end
