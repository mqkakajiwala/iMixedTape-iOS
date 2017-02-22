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
    UIImagePickerController *imagePicker;
    NSString *selectedContact;
    CreateTapeModel *tapeModel;
}

@end

@implementation CreateStepOneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"LOADING");
    
    
    
    
    tapeModel = [CreateTapeModel sharedInstance];
    
    if (tapeModel.isEmail) {
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
    self.titleTextField.text = tapeModel.title;
    self.messageTextView.text = tapeModel.message;
    self.sendToTextField.text = tapeModel.sendTo;
    self.emailORmobileTextField.text = tapeModel.emailOrMobile;
    self.fromTextField.text = tapeModel.from;
    NSData *imgData = tapeModel.imageData;
    
    
    if (![tapeModel.uploadImageAccessToken isEqualToString:@""]) {
        [self.albumArtImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://staging.imixedtape.com/image/%@/%dx%d",tapeModel.uploadImageAccessToken,100,100]] placeholderImage:[UIImage imageNamed:@"imgicon"]];
    }
    else{
        if (imgData !=nil) {
            self.albumArtImage.image = [UIImage imageWithData:imgData];
        }else{
            self.albumArtImage.image = [UIImage imageNamed:@"imgicon"] ;
        }
    }
    
    imageUploadID = tapeModel.uploadImageID;
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
    [self initiateImagePickerWithCamera:NO];
}

- (IBAction)openCamButton:(UIButton *)sender
{
    [self initiateImagePickerWithCamera:YES];
    
}

-(void)initiateImagePickerWithCamera :(BOOL)ifCamera
{
    imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    
    if (ifCamera) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }else{
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark - ImagePicker Delegate Method
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    
    //load your data here.
    
    UIImage *choosenImage = info[UIImagePickerControllerEditedImage];
    //    tapeModel.albumImage = choosenImage;
    tapeModel.imageData = UIImagePNGRepresentation(choosenImage);
 
    self.albumArtImage.image = [UIImage imageWithData:tapeModel.imageData];
    
    UIImage *resizedImage =[SharedHelper imageWithImage:choosenImage scaledToWidth:self.albumArtImage.frame.size.width];
    
    NSString *base64str = [self encodeToBase64String:resizedImage];
    [CreateTapeModel uploadFileWithAttachnment:base64str viewController:self callback:^(id callback) {
        
        if ([[callback objectForKey:@"error"]boolValue] == NO) {
            imageUploadID = [[callback objectForKey:@"data"]objectForKey:@"id"];
            
            tapeModel.uploadImageID = imageUploadID;
            tapeModel.uploadImageAccessToken = [[callback objectForKey:@"data"]objectForKey:@"access_token"];
            //                [[NSUserDefaults standardUserDefaults]setValue:imageUploadID forKey:key_createTapeUploadImageID];
            
            tapeModel.albumImage = self.albumArtImage.image;
            NSLog(@"%@",tapeModel.albumImage);
            //                self.albumArtImage.image = tapeModel.albumImage;
            //                [[NSUserDefaults standardUserDefaults]setObject:UIImagePNGRepresentation(self.albumArtImage.image) forKey:key_createTapeImage];
            
            
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
    
    if (textField == _emailORmobileTextField) {
        if (tapeModel.isEmail) {
            [textField setKeyboardType:UIKeyboardTypeDefault];
        }else{
            [textField setKeyboardType:UIKeyboardTypeNumberPad];
        }
    }
    
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    self.viewTopConstraint.constant = 0;
    
    if (textField == _titleTextField) {
        tapeModel.title = textField.text;
        //        [[NSUserDefaults standardUserDefaults]setValue:textField.text forKey:key_createTapeTitle];
    }
    else if (textField == _sendToTextField){
        tapeModel.sendTo = textField.text;
        //        [[NSUserDefaults standardUserDefaults]setValue:textField.text forKey:key_createTapeSendTo];
        
    }
    else if (textField == _fromTextField){
        tapeModel.from = textField.text;
        //        [[NSUserDefaults standardUserDefaults]setValue:textField.text forKey:key_createTapeFrom];
        
    }else if (textField == _emailORmobileTextField){
        tapeModel.emailOrMobile = textField.text;
        //        [[NSUserDefaults standardUserDefaults]setValue:textField.text forKey:key_createTapeEmailOrMobile];
        
    }
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == _titleTextField) {
        // Prevent crashing undo bug – see note below.
        if(range.length + range.location > textField.text.length)
        {
            return NO;
        }
        
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return newLength <= 6;
    }
    else
    {
        return YES;
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.titleTextField) {
        [self.messageTextView becomeFirstResponder];
    }
    else if (textField == self.sendToTextField){
        [self.emailORmobileTextField becomeFirstResponder];
    }
    else if (textField == self.emailORmobileTextField){
        [self.fromTextField becomeFirstResponder];
    }
    else if (textField == self.fromTextField){
        [self.fromTextField resignFirstResponder];
    }
    
    return YES;
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
        tapeModel.message = textView.text;
        //        [[NSUserDefaults standardUserDefaults]setValue:textView.text forKey:key_createTapeMessage];
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView == _messageTextView) {
        // Prevent crashing undo bug – see note below.
        if(range.length + range.location > textView.text.length)
        {
            return NO;
        }
        
        if ([text isEqualToString:@"\n"]) {
            [self.sendToTextField becomeFirstResponder];
        }
        
        NSUInteger newLength = [textView.text length] + [text length] - range.length;
        return newLength <= 50;
    }
    else
    {
        return YES;
    }
}




#pragma mark - Encode to base 64 string
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
    tapeModel.isEmail = ifEmail;
    //    [[NSUserDefaults standardUserDefaults]setBool:ifEmail forKey:key_ifemail];
    //    NSLog(@"%d",[[NSUserDefaults standardUserDefaults]boolForKey:key_ifemail]);
    
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
    
    
    
    if (!tapeModel.isEmail) {
        if (contact.phoneNumbers > 0) {
            
            
            for (CNLabeledValue *pnum  in contact.phoneNumbers) {
                CNPhoneNumber *pn = pnum.value;
                
                selectedContact = pn.stringValue;
                
                
                
            }
        }else{
            self.emailORmobileTextField.placeholder = @"Phone not available for this contact.";
        }
    }else{
        if (contact.emailAddresses.count > 0) {
            
            
            for (CNLabeledValue *email  in contact.emailAddresses) {
                selectedContact = email.value;
                
            }
        }else{
            self.emailORmobileTextField.placeholder = @"Email not available for this contact.";
            
        }
        
    }
    
    NSLog(@"%@",self.emailORmobileTextField.text);
    //    [[NSUserDefaults standardUserDefaults]setValue:selectedContact forKey:key_createTapeEmailOrMobile];
    tapeModel.emailOrMobile = selectedContact;
    //    NSLog(@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:key_createTapeEmailOrMobile]);
    self.emailORmobileTextField.text = tapeModel.emailOrMobile;//[[NSUserDefaults standardUserDefaults]valueForKey:key_createTapeEmailOrMobile];
    
    
}

@end
