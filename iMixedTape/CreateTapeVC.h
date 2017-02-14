//
//  ViewController.h
//  iMixedTape
//
//  Created by Mustafa on 17/10/2016.
//  Copyright © 2016 LemondeIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateTapeVC : UIViewController<UITextFieldDelegate,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *messageTextView;
@property (weak, nonatomic) IBOutlet UITextField *sendToTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailOrMobileTextField;
@property (weak, nonatomic) IBOutlet UITextField *fromTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *animateViewTopWhenKeyboardAppearsConstraint;

@property (strong, nonatomic) IBOutlet UIView *parentView;
- (IBAction)nextButton:(UIButton *)sender;
- (IBAction)previousButton:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIButton *prevButtonOutlet;
- (IBAction)createButton:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIButton *nextButtonOutlet;
@property (strong, nonatomic) IBOutlet UIButton *createButtonOutlet;
@property (strong, nonatomic) IBOutlet UIImageView *createStepsImageView;
- (IBAction)step1MelodyButton:(UIButton *)sender;
- (IBAction)step2MelodyButton:(UIButton *)sender;
- (IBAction)step3MelodyButton:(UIButton *)sender;

@end

