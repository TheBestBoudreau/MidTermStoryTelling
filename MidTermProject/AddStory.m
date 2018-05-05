//
//  AddStory.m
//  MidTermProject
//
//  Created by Raman Singh on 2018-05-03.
//  Copyright © 2018 Tyler Boudreau. All rights reserved.
//

#import "AddStory.h"
#import "CollectionViewCell.h"
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
    
    
    
    
    
    //deleteit
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    NSLog(@"%@", [dateFormatter stringFromDate:[NSDate date]]);
    
    
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

-(NSString *) getDate {
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    return [dateFormatter stringFromDate:[NSDate date]];
}

- (IBAction)publishAction:(id)sender {
    if ((![self.storyTitleTextField.text isEqual: @""]) && (![self.storyTextView.text isEqual: @""])) {
        
        [self.storyTextView resignFirstResponder];
        self.ref = [[FIRDatabase database] reference];
        NSMutableDictionary *myDict = [NSMutableDictionary new];
        [myDict setObject:self.storyTitleTextField.text forKey:@"Title"];
        [myDict setObject:self.storyTextView.text forKey:@"Body"];
        [myDict setObject:[self getDate] forKey:@"Date"];
        [myDict setObject:[[FIRAuth auth] currentUser].email forKey:@"Sender"];
        [myDict setObject:[[FIRAuth auth] currentUser].email forKey:@"LastCollaborator"];
        [myDict setObject:@"0" forKey:@"Total Raters"];
        [myDict setObject:@"0" forKey:@"Total Ratings"];
        [myDict setObject:@"" forKey:@"Comments"];
        [myDict setObject:@"" forKey:@"Total Collaborators"];
        [myDict setObject:@"" forKey:@"Raters Array"];
        
        
        
        
        FIRDatabaseReference *myID2 = [[self.ref child:@"Stories"] childByAutoId];
        [myDict setObject:myID2.key forKey:@"Key"];
        [myID2 setValue:myDict];
        [self dismissViewControllerAnimated:true completion:nil];
        
    }//if
}//publishAction



- (IBAction)cancelAction:(id)sender {
    
    //[self performSegueWithIdentifier:@"takeMeBack" sender:self];
    
    [self dismissViewControllerAnimated:true completion:nil];
    
    
    
    
}//cancelAction

-(void)textViewDidChange:(UITextView *)textView{
    
    if ([[textView text] length] > 300){
        
        textView.text = [textView.text substringFromIndex:300];
        
    }
    
    self.characterCounter.text = [NSString stringWithFormat: @"Characters left : %lu", 300 - [[textView text]length]];
    
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return textView.text.length + (text.length - range.length) <= 300;
    
    
    
}//shouldChangeTextInRange

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return textField.text.length + (string.length - range.length) <= 50;
    
}
@end
