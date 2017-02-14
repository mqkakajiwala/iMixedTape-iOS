//
//  CreateStepOneVC.m
//  iMixedTape
//
//  Created by Mustafa on 22/12/2016.
//  Copyright © 2016 LemondeIT. All rights reserved.
//

#import "CreateStepOneVC.h"
#import "RadioButton.h"
#import <Contacts/Contacts.h>

@interface CreateStepOneVC (){
    NSString *imageUploadID;
    CNContactPickerViewController *contactPicker;
    BOOL ifEmail;
}

@end

@implementation CreateStepOneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([[NSUserDefaults standardUserDefaults]boolForKey:key_ifemail]) {
        [self.emailRadButton setSelected:YES];
    }else{
        [self.phoneRadButton setSelected:YES];
    }
    
    if (IS_IPHONE_5) {
        self.scrollViewBottonConstraint.constant = 200;
        self.parentViewHeightConstraint.constant = 200;
        self.scrollConstraint.constant = -200;
    }
    else if (IS_IPHONE_6){
        self.scrollViewBottonConstraint.constant = 130;
        self.parentViewHeightConstraint.constant = 150;
        self.scrollConstraint.constant = -150;
    }else {
        self.scrollViewBottonConstraint.constant = 100;
        self.parentViewHeightConstraint.constant = 100;
        self.scrollConstraint.constant = -100;
    }
    
    [self setDelegateOfTextFields];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    
    
    
    [self loadDefaultValues];
    
    
}

-(void)loadDefaultValues
{
    CreateTapeModel *createTapeModel = [[CreateTapeModel alloc]init];
    
    self.titleTextField.text = createTapeModel.title;
    self.messageTextView.text = createTapeModel.message;
    self.sendToTextField.text = createTapeModel.sendTo;
    self.emailORmobileTextField.text = createTapeModel.emailOrMobile;
    self.fromTextField.text = createTapeModel.from;
    if (createTapeModel.albumImage !=nil) {
        self.albumArtImage.image = createTapeModel.albumImage;
    }else{
        self.albumArtImage.image = [UIImage imageNamed:@"imgicon"];
    }
    
    
    imageUploadID = createTapeModel.uploadImageID;
}


-(void)setDelegateOfTextFields
{
    self.titleTextField.delegate = self;
    self.messageTextView.delegate = self;
    self.sendToTextField.delegate = self;
    self.emailORmobileTextField.delegate = self;
    self.fromTextField.delegate = self;
    
}

-(void)dismissKeyboard
{
    [self.titleTextField resignFirstResponder];
    [self.messageTextView resignFirstResponder];
    [self.sendToTextField resignFirstResponder];
    [self.emailORmobileTextField resignFirstResponder];
    [self.fromTextField resignFirstResponder];
    
}

- (IBAction)openStockImagesButton:(UIButton *)sender {
}

- (IBAction)openCamLibraryRollButton:(UIButton *)sender
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (IBAction)openCamButton:(UIButton *)sender
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *choosenImage = info[UIImagePickerControllerEditedImage];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.albumArtImage.image = choosenImage;
    });
    
    NSString *base64str = [self encodeToBase64String:choosenImage];
    [CreateTapeModel uploadFileWithAttachnment:base64str callback:^(id callback) {
        
        if ([[callback objectForKey:@"error"]boolValue] == NO) {
            imageUploadID = [[callback objectForKey:@"data"]objectForKey:@"id"];
            [[NSUserDefaults standardUserDefaults]setValue:imageUploadID forKey:key_createTapeUploadImageID];
            [[NSUserDefaults standardUserDefaults]setObject:UIImagePNGRepresentation(self.albumArtImage.image) forKey:key_createTapeImage];
            
            
            NSLog(@"%@", base64str);
            
        }
        else{
            [SharedHelper AlertControllerWithTitle:@"Error" message:@"Image cannot be uploaded" viewController:self];
        }
        
    }];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Textfield delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    if (textField == _titleTextField) {
        
    }
    else if (textField == _sendToTextField){
        
        self.viewTopConstraint.constant = -250;
    }
    else {
        
        self.viewTopConstraint.constant = -350;
    }
    
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    self.viewTopConstraint.constant = 0;
    
    if (textField == _titleTextField) {
        [[NSUserDefaults standardUserDefaults]setValue:textField.text forKey:key_createTapeTitle];
    }
    else if (textField == _sendToTextField){
        [[NSUserDefaults standardUserDefaults]setValue:textField.text forKey:key_createTapeSendTo];
        
    }
    else if (textField == _fromTextField){
        [[NSUserDefaults standardUserDefaults]setValue:textField.text forKey:key_createTapeFrom];
        
    }else if (textField == _emailORmobileTextField){
        [[NSUserDefaults standardUserDefaults]setValue:textField.text forKey:key_createTapeEmailOrMobile];
        
    }
    
}



#pragma mark - TextView Delegates

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    
    if (textView == self.messageTextView) {
        self.viewTopConstraint.constant = -200;
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    
    self.viewTopConstraint.constant = 0;
    if (textView == _messageTextView) {
        [[NSUserDefaults standardUserDefaults]setValue:textView.text forKey:key_createTapeMessage];
    }
}



- (NSString *)encodeToBase64String:(UIImage *)image {
    return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

#pragma mark - Radio Buttons
- (IBAction)emailPhoneRadioButton:(RadioButton *)sender
{
    if (sender.tag == 100) {
        NSLog(@"EMAIL");
        ifEmail = YES;
        
        
    }else{
        ifEmail = NO;
        NSLog(@"PHONE");
    }
    [[NSUserDefaults standardUserDefaults]setBool:ifEmail forKey:key_ifemail];
    NSLog(@"%d",[[NSUserDefaults standardUserDefaults]boolForKey:key_ifemail]);
    
}

#pragma mark - Open Contact Button

- (IBAction)openContact:(UIButton *)sender
{
    [self openContactBook];
}

-(void)getContactRequest
{
    
    
    if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusNotDetermined ) {
        CNContactStore *store = [[CNContactStore alloc]init];
        
        [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                
            }
        }];
    } else if( [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts]== CNAuthorizationStatusAuthorized)
    {
        
    }
}

-(void)getAllContacts
{
    
}

-(void)openContactBook
{
    contactPicker = [[CNContactPickerViewController alloc]init];
    contactPicker.delegate = self;
    [self presentViewController:contactPicker animated:YES completion:nil];
}

-(void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact
{
    NSLog(@"%@",contact);
    NSLog(@"%@",contact.emailAddresses);
    
    
    
    if (!ifEmail) {
        if (contact.phoneNumbers > 0) {
            
            
            for (CNLabeledValue *pnum  in contact.phoneNumbers) {
                CNPhoneNumber *pn = pnum.value;
                
                NSLog(@"%@",pn.stringValue);
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.emailORmobileTextField.text = pn.stringValue;
                    
                });
                
            }
        }else{
            self.emailORmobileTextField.placeholder = @"Phone not available for this contact.";
        }
    }else{
        if (contact.emailAddresses.count > 0) {
            
            
            for (CNLabeledValue *email  in contact.emailAddresses) {
                
                
                NSLog(@"%@",email.value);
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.emailORmobileTextField.text = email.value;
                });
            }
        }else{
            self.emailORmobileTextField.placeholder = @"Email not available for this contact.";
            
        }
        
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"%@",self.emailORmobileTextField.text);
        [[NSUserDefaults standardUserDefaults]setValue:self.emailORmobileTextField.text forKey:key_createTapeEmailOrMobile];
        NSLog(@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:key_createTapeEmailOrMobile]);
    });
   
}

@end
