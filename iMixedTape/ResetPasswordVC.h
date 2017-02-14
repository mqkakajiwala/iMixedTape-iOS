//
//  ResetPasswordVC.h
//  iMixedTape
//
//  Created by Mustafa Qutbuddin on 1/27/17.
//  Copyright © 2017 LemondeIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResetPasswordVC : UIViewController

@property(strong,nonatomic) NSString *emailStr;
@property (weak, nonatomic) IBOutlet UITextField *emailTF;
@property (weak, nonatomic) IBOutlet UITextField *resetTokenTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UITextField *confirmPassTF;
@end
