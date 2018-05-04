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
@property (strong, nonatomic) IBOutlet UIView *commentRateView;




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
    self.editStoryTextView.text = self.fullStoryLocal.storyBody;
    
    
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
    self.commentRateView.hidden = true;
    
    self.fullStoryLocal.storyBody = self.editStoryTextView.text;
//    self.editStoryTextView.text = self.fullStoryLocal.storyBody;

}//editButtonAction

#pragma Back Button Action

- (IBAction)backButtonAction:(id)sender {
    if (self.editView.isHidden) {
        [self performSegueWithIdentifier:@"takeMeBack" sender:self];
    } else {
        self.editView.hidden = true;
        [self.backButtonOut setTitle:@"Back" forState:UIControlStateNormal];
    }
    
    [self.editStoryTextView resignFirstResponder];
    self.commentRateView.hidden = false;
}//backButtonAction

#pragma TextView Delegate Methods

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (range.location < self.fullStoryLocal.storyBody.length){
        return NO;
    }
    
    return textView.text.length + (text.length - range.length) <= self.fullStoryLocal.storyBody.length + 300;
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
//    NSLog(@"Beginning %@", self.editStoryTextView.text);
    if (![self.editStoryTextView.text isEqual: @""]) {
        
        //publish story
        
        [self tryThis];
        self.doneView.hidden = false;
        
        [self performSelector:@selector(hideDoneScreen) withObject:nil afterDelay:1.0];
        self.editView.hidden = true;
        
        
        
        //update Story in this view
        self.commentRateView.hidden = false;
        
        
        [self.backButtonOut setTitle:@"Back" forState:UIControlStateNormal];
        [self.storyArray addObject:self.editStoryTextView.text];
        [self.storyArray removeObjectAtIndex:1];
//        NSLog(@"Ending %@", self.editStoryTextView.text);
        [self.tableView reloadData];
        NSLog(@"%@", self.storyArray);
        NSLog(@"%lu", self.storyArray.count);
        
    }//if empty text
    [self checkLastCollaborator];
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
                           @"Body": self.editStoryTextView.text,
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
    

    
    
    [self.tableView reloadData];
//    self.editStoryTextView.text = @"";
    
    
    
}//tryThis

-(void) checkLastCollaborator {
    if ([[[FIRAuth auth] currentUser].email isEqualToString:self.fullStoryLocal.lastCollaborator]) {
        self.editButtonOutlet.enabled = false;
    } else {
        self.editButtonOutlet.enabled = true;
    }
}//checkLastCollaborator


@end
