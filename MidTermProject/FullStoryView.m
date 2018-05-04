//
//  FullStoryView.m
//  MidTermProject
//
//  Created by Raman Singh on 2018-05-03.
//  Copyright © 2018 Tyler Boudreau. All rights reserved.
//

#import "FullStoryView.h"



@interface FullStoryView ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSMutableArray *storyArray;
@property (strong, nonatomic) IBOutlet UIButton *editButtonOutlet;
@property (strong, nonatomic) IBOutlet UIButton *backButtonOut;
@property (strong, nonatomic) IBOutlet UIView *editView;
@property (strong, nonatomic) IBOutlet UITextView *editStoryTextView;
@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) IBOutlet UIImageView *doneView;

@end

@implementation FullStoryView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.storyArray = [NSMutableArray new];
    [self.storyArray addObject:self.fullStoryLocal.storyTitle];
    NSArray *this = [self.fullStoryLocal.storyBody componentsSeparatedByString:@"\n"];
    [self.storyArray addObjectsFromArray:this];
    [self.tableView reloadData];
    [self configureTableView];
    self.editView.hidden = true;
    self.editStoryTextView.delegate = self;
    [self addKeyboardButtons];
    self.doneView.hidden = true;
    
    
    
    NSLog(@"MY BODY:::%@",self.fullStoryLocal.key);
//    NSLog(@"%@", self.storyArray);
    
}//load

#pragma Setup TableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.storyArray.count;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FullStoryTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier: @"Cell"];
    
    Stories *thisStory = [self.storyArray objectAtIndex:indexPath.row];
    
    if (indexPath.row == 0) {
    cell.label1.text = [self.storyArray objectAtIndex:0];
    cell.label2.text = @"";
        return cell;
    } else {
    cell.label1.text = @"";
    cell.label2.text = [self.storyArray objectAtIndex:indexPath.row];
        return cell;
    }
}

-(void)configureTableView {
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 120;
    
    
}//configureTableView


#pragma Hide Status Bar

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma Edit Button Action

- (IBAction)editButtonAction:(UIButton *)sender {
    self.editView.hidden = false;
    [self.backButtonOut setTitle:@"Hide" forState:UIControlStateNormal];
    [self.editStoryTextView becomeFirstResponder];

}//editButtonAction

#pragma Back Button Action

- (IBAction)backButtonAction:(id)sender {
    if (self.editView.isHidden) {
        [self performSegueWithIdentifier:@"takeMeBack" sender:self];
    } else {
        self.editView.hidden = true;
        [self.backButtonOut setTitle:@"Back" forState:UIControlStateNormal];
    }


}//backButtonAction

#pragma TextView Delegate Methods

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    return textView.text.length + (text.length - range.length) <= 300;
}//shouldChangeTextInRange

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
    self.editStoryTextView.inputAccessoryView = keyboardToolbar;
}//addKeyboardButtons


-(void)doneWithNumberPad {
    
    [self.editStoryTextView resignFirstResponder];
    
}//doneWithNumberPad

#pragma Publish Button

- (IBAction)publishAction:(UIButton *)sender {
    
    if (![self.editStoryTextView.text isEqual: @""]) {
        
        //publish story
        
        [self tryThis];
        self.doneView.hidden = false;
        
        [self performSelector:@selector(hideDoneScreen) withObject:nil afterDelay:1.0];
        self.editView.hidden = true;
        
        
        
        //update Story in this view
        
    }//if empty text
    
}//publishAction

-(void)hideDoneScreen {
    self.doneView.hidden = true;
    
}//hideDoneScreen




-(void) tryThis {
    NSString *key = self.fullStoryLocal.key;
    self.ref = [[FIRDatabase database] reference];
    NSString *storyBody = self.fullStoryLocal.storyBody;
    storyBody = [NSString stringWithFormat:@"%@\n%@", self.fullStoryLocal.storyBody, self.editStoryTextView.text];
    
    
    NSDictionary *post = @{@"Title": self.fullStoryLocal.storyTitle,
                           @"Body": storyBody,
                           @"Date": self.fullStoryLocal.storyDate,
                           @"Sender": self.fullStoryLocal.sender,
                           @"LastCollaborator": [[FIRAuth auth] currentUser].email,
                           @"Total Ratings": self.fullStoryLocal.totalRatings,
                           @"Total Raters": self.fullStoryLocal.totalRaters,
                           @"Key": key,
                           @"Comments": self.fullStoryLocal.comments,
                           @"Total Collaborators": self.fullStoryLocal.totalCollaborators,
                           @"Raters Array": self.fullStoryLocal.ratersString,
                           
                           
                           
                           
                           
                           };
    
        NSDictionary *childUpdates = @{[@"/Stories/" stringByAppendingString:key]: post};
        [self.ref updateChildValues:childUpdates];
    

    
    
    NSLog(@"I tried");
    
}//tryThis





@end
