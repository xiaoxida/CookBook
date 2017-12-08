//
//  CBAddRecipeViewController.m
//  CookBook
//Email: xiaoxida@usc.edu
//  Created by Xiaoxi Dai on 12/2/17.
//  Copyright © 2017 Xiaoxi Dai. All rights reserved.
//

#import "CBAddRecipeViewController.h"
#import <FBSDKShareKit/FBSDKShareKit.h>

@interface CBAddRecipeViewController () <UITextViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet FBSDKShareButton *shareButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImagePickerController *picker;
@property (strong, nonatomic) NSString* filepath;
@end

@implementation CBAddRecipeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //if we have all information
    if(self.titleText && self.contentText && self.imageText)
    {
        self.titleTextField.text = self.titleText;
        self.contentTextView.text = self.contentText;
        //if we have a image
        if(![self.imageText isEqualToString:@"noimage"])
        {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = paths[0];
            NSString *helper = [[NSString alloc] initWithFormat:@"%@", self.imageText];
            //get the file path of the image
            self.filepath = [documentsDirectory stringByAppendingPathComponent:helper];
            NSLog(@"%@", self.imageText);
            //convert to UIImage
            UIImage* tempImage = [UIImage imageWithContentsOfFile:self.filepath];
            
            //prepare for share photo
            FBSDKSharePhoto *photo = [[FBSDKSharePhoto alloc] init];
            photo.caption = self.titleTextField.text;
            photo.image = tempImage;
            photo.userGenerated = YES;
            FBSDKSharePhotoContent *content = [[FBSDKSharePhotoContent alloc] init];
            content.photos = @[photo];
            self.shareButton.shareContent = content;
            
            //display the image
            UIGraphicsBeginImageContext(tempImage.size);
            [tempImage drawInRect:CGRectMake(0, 0, tempImage.size.width, tempImage.size.height)];
            self.image = [UIImage imageWithCGImage:[UIGraphicsGetImageFromCurrentImageContext() CGImage]];
            [self.imageView setImage:self.image];
            UIGraphicsEndImageContext();
        }
    }
    self.saveButton.enabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveButtonPressed:(UIBarButtonItem *)sender {
    // Create path.
    NSString *fileName;
    if(self.image)  //if we have select an image, save it
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        fileName = [NSString stringWithFormat: @"%@.png", self.titleTextField.text];
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:fileName];
        // Save image.
        [UIImagePNGRepresentation(self.image) writeToFile:filePath atomically:YES];
    }
    else
    {
        fileName = @"noimage";
    }
    //set up the compeletion block
    if (self.addRecipe) {
        self.addRecipe(self.titleTextField.text, self.contentTextView.text, fileName);
    }
    self.titleTextField.text = nil;
    self.contentTextView.text = nil;
}

- (IBAction)cancelButtonPressed:(UIBarButtonItem *)sender {
    if (self.addRecipe)
    {
        self.addRecipe(nil, nil, nil);
    }
}

- (IBAction)selectImageButtonPressed:(UIButton *)sender {
    //set up an action sheet provide:"take photo" and "choose existing photos"
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:@"Take Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
            self.picker = [[UIImagePickerController alloc] init];
            self.picker.delegate = self;
            self.picker.allowsEditing = YES;
            self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:self.picker animated:YES completion:NULL];
        }];
        [alertController addAction:takePhotoAction];
    }
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIAlertAction *chooseExistingAction = [UIAlertAction actionWithTitle:@"Choose Existing Photos" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
            self.picker = [[UIImagePickerController alloc] init];
            self.picker.delegate = self;
            self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:self.picker animated:YES completion:NULL];
        }];
        [alertController addAction:chooseExistingAction];
    }
    //if user did not choose a photo or take a photo
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:NULL];
        [alertController addAction:cancelAction];
    }
    
    [self presentViewController:alertController animated:YES completion:nil];
}
#pragma mark - textfield and textview delegate methods
//properly dismiss the keyboard when the user touch the background or hit the return button

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (BOOL) textFieldShouldEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL) textViewShouldEndEditing:(UITextView *)textView{
    [textView resignFirstResponder];
    return YES;
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *changedString = [textField.text
                               stringByReplacingCharactersInRange:range
                               withString:string];
    [self enableSaveButtonForInput1:self.contentTextView.text Input2:changedString];
    return YES;
}

- (BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    NSString *changedString = [textView.text
                               stringByReplacingCharactersInRange:range
                               withString:text];
    [self enableSaveButtonForInput1:changedString Input2:self.titleTextField.text];
    return YES;
}

// Enabled the save button when data is in all textfields
- (void) enableSaveButtonForInput1: (NSString *) tf1
                            Input2: (NSString *) tf2{
    self.saveButton.enabled = (tf1.length > 0 && tf2.length > 0 && self.image);
    //prepare for sharing if  both textfield is not empty
    if(tf1.length > 0 && tf2.length > 0)
    {
        FBSDKSharePhoto *photo = [[FBSDKSharePhoto alloc] init];
        photo.caption = self.titleTextField.text;
        photo.image = self.image;
        photo.userGenerated = YES;
        FBSDKSharePhotoContent *content = [[FBSDKSharePhotoContent alloc] init];
        content.photos = @[photo];
        self.shareButton.shareContent = content;
    }
    else
    {
        self.shareButton.shareContent = nil;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UIImagePickerControllerDelegate

//process the result of taking photo or choose a photo
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary*)info
{
    //if you take a new photo
    if(picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        UIImage *tempImage = [info objectForKey:UIImagePickerControllerEditedImage];
        UIGraphicsBeginImageContext(tempImage.size);
        [tempImage drawInRect:CGRectMake(0, 0, tempImage.size.width, tempImage.size.height)];
        self.image = [UIImage imageWithCGImage:[UIGraphicsGetImageFromCurrentImageContext() CGImage]];
    }
    else
    {
        self.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    [self.imageView setImage:self.image];
    //prepare for sharing
    if(self.titleTextField.text.length > 0 && self.contentTextView.text.length > 0)
    {
        self.saveButton.enabled = true;
        FBSDKSharePhoto *photo = [[FBSDKSharePhoto alloc] init];
        photo.caption = self.titleTextField.text;
        photo.image = self.image;
        photo.userGenerated = YES;
        FBSDKSharePhotoContent *content = [[FBSDKSharePhotoContent alloc] init];
        content.photos = @[photo];
        self.shareButton.shareContent = content;
    }
    else
    {
        self.shareButton.shareContent = nil;
    }
    UIGraphicsEndImageContext();
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
