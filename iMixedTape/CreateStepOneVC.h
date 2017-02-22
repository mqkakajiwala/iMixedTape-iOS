//
//  CreateStepOneVC.h
//  iMixedTape
//
//  Created by Mustafa on 22/12/2016.
//  Copyright © 2016 LemondeIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RadioButton.h"

@interface CreateStepOneVC : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UITextViewDelegate,CNContactPickerDelegate>

@property (strong, nonatomic) IBOutlet UITextField *titleTextField;
@property (strong, nonatomic) IBOutlet UIImageView *albumArtImage;
@property (strong, nonatomic) IBOutlet UITextView *messageTextView;
@property (strong, nonatomic) IBOutlet UITextField *sendToTextField;
@property (strong, nonatomic) IBOutlet UITextField *emailORmobileTextField;
@property (strong, nonatomic) IBOutlet UITextField *fromTextField;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *scrollViewBottonConstraint;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *parentViewHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *scrollConstraint;
@property (weak, nonatomic) IBOutlet RadioButton *emailRadButton;
@property (weak, nonatomic) IBOutlet RadioButton *phoneRadButton;
//@property (nonatomic) BOOL isSaved;


- (IBAction)openCamButton:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *viewTopConstraint;
@end
