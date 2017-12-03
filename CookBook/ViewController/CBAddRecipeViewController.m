//
//  CBAddRecipeViewController.m
//  CookBook
//
//  Created by Xiaoxi Dai on 12/2/17.
//  Copyright © 2017 Xiaoxi Dai. All rights reserved.
//

#import "CBAddRecipeViewController.h"

@interface CBAddRecipeViewController () <UITextViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate>
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
    if(self.titleText && self.contentText && self.imageText)
    {
        self.titleTextField.text = self.titleText;
        self.contentTextView.text = self.contentText;
        //set up the image
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        
        NSString *documentsDirectory = paths[0];
        NSString *helper = [[NSString alloc] initWithFormat:@"%@", self.imageText];
        self.filepath = [documentsDirectory stringByAppendingPathComponent:helper];
        NSLog(@"%@", self.imageText);
        
        UIImage* tempImage = [UIImage imageWithContentsOfFile:self.filepath];
        UIGraphicsBeginImageContext(tempImage.size);
        [tempImage drawInRect:CGRectMake(0, 0, tempImage.size.width, tempImage.size.height)];
        self.image = [UIImage imageWithCGImage:[UIGraphicsGetImageFromCurrentImageContext() CGImage]];
        [self.imageView setImage:self.image];
        UIGraphicsEndImageContext();
    }
    // Do any additional setup after loading the view.
//        NSLog(@"%@", self.imageText);
//        UIImage *tempImage = [UIImage imageWithContentsOfFile:self.imageText];
//        UIGraphicsBeginImageContext(tempImage.size);
//        [tempImage drawInRect:CGRectMake(0, 0, tempImage.size.width, tempImage.size.height)];
//        self.image = [UIImage imageWithCGImage:[UIGraphicsGetImageFromCurrentImageContext() CGImage]];
//        [self.imageView setImage:self.image];
    self.saveButton.enabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)saveButtonPressed:(UIBarButtonItem *)sender {
    // Create path.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *fileName = [NSString stringWithFormat: @"%@.png", self.titleTextField.text];
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:fileName];
    // Save image.
    [UIImagePNGRepresentation(self.image) writeToFile:filePath atomically:YES];
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
        UIAlertAction *chooseExistingAction = [UIAlertAction actionWithTitle:@"Choose Existing" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
            self.picker = [[UIImagePickerController alloc] init];
            self.picker.delegate = self;
            self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:self.picker animated:YES completion:NULL];
        }];
        [alertController addAction:chooseExistingAction];
    }
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:NULL];
        [alertController addAction:cancelAction];
    }
    
    [self presentViewController:alertController animated:YES completion:nil];
}
#pragma mark - textfield and textview delegate methods

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

// Enabled the save button when data is in all 3 textfields
- (void) enableSaveButtonForInput1: (NSString *) tf1
                            Input2: (NSString *) tf2{
    self.saveButton.enabled = (tf1.length > 0 && tf2.length > 0);
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
    UIGraphicsEndImageContext();
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
