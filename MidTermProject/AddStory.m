//
//  AddStory.m
//  MidTermProject
//
//  Created by Raman Singh on 2018-05-03.
//  Copyright © 2018 Tyler Boudreau. All rights reserved.
//

#import "AddStory.h"

@import Firebase;


@interface AddStory ()

@property (strong, nonatomic) IBOutlet UITextField *storyTitleTextField;
@property (strong, nonatomic) IBOutlet UITextView *storyTextView;
@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) IBOutlet UIButton *publishOut;
@property (weak, nonatomic) IBOutlet UILabel *characterCounter;




@end

@implementation AddStory

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.storyTitleTextField becomeFirstResponder];
    [self addKeyboardButtons];
    self.publishOut.enabled = false;
    self.ref = [[FIRDatabase database] reference];
    self.storyTitleTextField.delegate = self;
    self.storyTextView.delegate = self;
    
}//load


-(BOOL)prefersStatusBarHidden{
    return YES;
}

- (IBAction)titleDone:(UITextField *)sender {
   
    [self.storyTextView becomeFirstResponder];
    
    if ((![self.storyTitleTextField.text isEqual: @" "]) && (![self.storyTextView.text isEqual: @" "])) {
        
        self.publishOut.enabled = true;
        
    }//if empty text
    
}//titleDone

-(void) addKeyboardButtons {
    
    UIToolbar* keyboardToolbar = [[UIToolbar alloc] init];
    [keyboardToolbar sizeToFit];
    UIBarButtonItem *flexBarButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                      target:nil action:nil];
    UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                      target:self action:@selector(doneWithNumberPad)];
    keyboardToolbar.items = @[flexBarButton, doneBarButton];
    
    self.storyTextView.inputAccessoryView = keyboardToolbar;
    
}//addKeyboardButtons


-(void)doneWithNumberPad {
    
    [self.storyTextView resignFirstResponder];
    
    if ((![self.storyTitleTextField.text isEqual: @""]) && (![self.storyTextView.text isEqual: @""])) {
        
        self.publishOut.enabled = true;
        
    }//if empty text
    
}//doneWithNumberPad

- (IBAction)publishAction:(id)sender {
   
    if ((![self.storyTitleTextField.text isEqual: @""]) && (![self.storyTextView.text isEqual: @""])) {
        
        [self.storyTextView resignFirstResponder];
        UploadManager *newUploadManager = [UploadManager new];
        [newUploadManager uploadStoryWithRef:self.ref withStoryTitle:self.storyTitleTextField.text andStoryBody:self.storyTextView.text];
        [self dismissViewControllerAnimated:true completion:nil];
        
    }//if
    
}//publishAction



- (IBAction)cancelAction:(id)sender {
    
    [self dismissViewControllerAnimated:true completion:nil];
    
}//cancelAction

-(void)textViewDidChange:(UITextView *)textView{
    
    if ([[textView text] length] > 300){
        
        textView.text = [textView.text substringFromIndex:300];
        
    }
    
    self.characterCounter.text = [NSString stringWithFormat: @"Characters left : %lu", 300 - [[textView text]length]];
    
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    return textView.text.length + (text.length - range.length) <= 300;
    
}//shouldChangeTextInRange

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    return textField.text.length + (string.length - range.length) <= 50;
    
}//shouldChangeCharactersInRange
@end
