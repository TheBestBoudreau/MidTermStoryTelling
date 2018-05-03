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


    

@end

@implementation AddStory

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.storyTitleTextField becomeFirstResponder];
    [self addKeyboardButtons];
    
//    FIRAuth.auth()?.currentUser?.email
    
    
    self.ref = [[FIRDatabase database] reference];
    
    
    
}//load


-(BOOL)prefersStatusBarHidden{
    return YES;
}

- (IBAction)titleDone:(UITextField *)sender {
     [self.storyTextView becomeFirstResponder];
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
    
//    if (([![self.storyTitleTextField.text isEqual: @" "]]) && (![self.storyTextView.text isEqualToString: @""])) {
    
    if ((![self.storyTitleTextField.text isEqual: @" "]) && (![self.storyTextView.text isEqual: @" "])) {
    
    
    [self.storyTextView resignFirstResponder];
    self.ref = [[FIRDatabase database] reference];
    NSMutableDictionary *myDict = [NSMutableDictionary new];
    [myDict setObject:self.storyTitleTextField.text forKey:@"Title"];
    [myDict setObject:self.storyTextView.text forKey:@"Body"];
    [myDict setObject:[self getDate] forKey:@"Date"];
    [myDict setObject:[[FIRAuth auth] currentUser].email forKey:@"Sender"];
        
    
    [[[_ref child:@"Stories"] childByAutoId] setValue:myDict];
    
    }//if empty text
    
}//doneWithNumberPad

-(NSString *) getDate {
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];

    [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm:ss a"];
    // or @"yyyy-MM-dd hh:mm:ss a" if you prefer the time with AM/PM
    NSLog(@"%@",[dateFormatter stringFromDate:[NSDate date]]);
    return [dateFormatter stringFromDate:[NSDate date]];
}




@end
