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

    
    [self.view addGestureRecognizer:tap];
    [self setDelegate];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    
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
    self.prevButtonOutlet.hidden = NO;
    vcIndexCount++;
    
    if (vcIndexCount == 2) {
        self.createButtonOutlet.hidden = NO;
        self.nextButtonOutlet.hidden = YES;
    }
    [self childVCAtIndex];

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
        
        if (tapeModel.selectedTapeIndex >= 0) {
            
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

    if (!userModel.isLoggedIn) {
       
        [self loginAlert :@"create "];
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
                                            
                                            HomeGridVC *hg;
                                            if (tapeModel.selectedTapeIndex > 0) {
                                                
                                                [fetchTapeModel.myCretedTapesArray removeObjectAtIndex:tapeModel.selectedTapeIndex];
                                                 hg = self.tabBarController.viewControllers[0].childViewControllers[0];
                                                
                                                
                                                FMDatabase *database = [FMDatabase databaseWithPath:[SharedHelper databaseWithPath]];
                                                [database open];
                                                
                                                BOOL b = [database executeUpdate:@"delete from saved_tapes_table WHERE id=?",tapeModel.tapeID];
                                                NSLog(@"%d",b);
    
                                            }
                                            
                                            [hg getWebserviceDataOnLoad];
                                            
                                            
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
    
    if (userModel.isLoggedIn) {
    fetchTapeModel = [FetchTapesModel sharedInstance];
    
    UIAlertController *discardTapeAlert = [UIAlertController alertControllerWithTitle:@"" message:@"Your changes have been saved." preferredStyle:UIAlertControllerStyleAlert];
        
    FMDatabase *database = [FMDatabase databaseWithPath:[SharedHelper databaseWithPath]];
    [database open];
    
        @try {
        NSLog(@"%@",tapeModel.songsAddedArray);
        
        NSData *sOngsData = [NSKeyedArchiver archivedDataWithRootObject:tapeModel.songsAddedArray];
       
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
        
    }else{
        [self loginAlert :@"save"];
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

#pragma mark - Login/Register alert

-(void)loginAlert : (NSString *)titleStr
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:[NSString stringWithFormat:@"You need to be signed in to %@ tapes.",titleStr] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *loginAction = [UIAlertAction actionWithTitle:@"Login" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.navigationController.navigationBar.hidden = NO;
        [self performSegueWithIdentifier:@"loginSegue" sender:self];
    }];
    
    UIAlertAction *registerAction = [UIAlertAction actionWithTitle:@"Register" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.navigationController.navigationBar.hidden = NO;
        [self performSegueWithIdentifier:@"registerSegue" sender:self];
    }];
    
    [alert addAction:loginAction];
    [alert addAction:registerAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}
@end
