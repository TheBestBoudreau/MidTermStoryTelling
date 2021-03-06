//
//  CommentsViewController.m
//  MidTermProject
//
//  Created by Raman Singh on 2018-05-04.
//  Copyright © 2018 Tyler Boudreau. All rights reserved.
//

#import "CommentsViewController.h"
#import "CommentTableViewCell.h"
#import "UpdateManager.h"
#import "DownloadManager.h"


@interface CommentsViewController ()
@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) IBOutlet UITableView *commentTableView;
@property (strong, nonatomic) IBOutlet UITextField *commentTextField;
@property (nonatomic) NSMutableArray *commentsArray;
@property (nonatomic) NSMutableArray *testArray;
@property  CGFloat kbH;
@property (strong, nonatomic) IBOutlet UIView *commentUIView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomContraint;
@property (strong, nonatomic) IBOutlet UIButton *commentPostButton;




@end

@implementation CommentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _commentsArray = [NSMutableArray new];
    _commentTextField.delegate = self;
    
    
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [self watchKeyboardNotifications:notificationCenter];
    self.commentPostButton.hidden = YES;
    self.commentPostButton.enabled = false;
    
    

    
    
    self.downMan = [DownloadManager new];
    [self.downMan downloadCommentsWithRef:self.ref andStory:self.commentsLocalStory];
    [self performSelector:@selector(downloadComments) withObject:nil afterDelay:1.0];
    
    
    
    
    
    
    
}//load

-(void)downloadComments {
    
    self.commentsArray = self.downMan.myArray;
    [self.commentTableView reloadData];
}





-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:
(NSString *)string {
    
    if([self.commentTextField.text isEqualToString:@""]){
        self.commentPostButton.enabled = FALSE;
    }else{
        self.commentPostButton.enabled = TRUE;
    }
    return textField.text.length + (string.length - range.length) <= 150;
}







-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CommentTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier: @"commentCell"];
    
    Comments *comments = [self.commentsArray objectAtIndex:indexPath.row];
    
    cell.userNameLabel.text = comments.username;
    cell.commentLabel.text = comments.comments;

    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.commentsArray.count;

}

-(void)configureTableView {
    self.commentTableView.rowHeight = UITableViewAutomaticDimension;
    self.commentTableView.estimatedRowHeight = 10;
    
}
- (void)watchKeyboardNotifications:(NSNotificationCenter *)notificationCenter {
    
    [notificationCenter addObserver:self
                           selector:@selector(keyboardDidShowNotificationReceived:)
                               name:UIKeyboardWillShowNotification
                             object:nil];
    
    [notificationCenter addObserver:self
                           selector:@selector(UIKeyboardDidHideNotification:)
                               name:UIKeyboardWillHideNotification
                             object:nil];
    
}
- (void)keyboardDidShowNotificationReceived:(NSNotification *)notification {
    NSLog(@"In keyboardDidShowNotificationReceived: %@", notification.name);
    
    
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    self.kbH = kbSize.height;
    [self.view layoutIfNeeded];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.bottomContraint.constant = -kbSize.height;
        [self.view layoutIfNeeded];

    } completion:^(BOOL finished){
    }];
    
    
    self.commentPostButton.hidden = false;
    
}
- (void)UIKeyboardDidHideNotification:(NSNotification *)notification {
    
    [self.commentTextField layoutIfNeeded];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.bottomContraint.constant = 0;
        [self.commentUIView layoutIfNeeded];
    
    } completion:^(BOOL finished){
        
        self.commentsArray = [NSMutableArray new];
        [self.downMan downloadCommentsWithRef:self.ref andStory:self.commentsLocalStory];
        [self performSelector:@selector(downloadComments) withObject:nil afterDelay:1.0];
        [self.commentTableView reloadData];

    }];
    
    self.commentPostButton.hidden = TRUE;
    self.commentPostButton.enabled = false;

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (![self.commentTextField.text isEqual:@""]) {
        UpdateManager *newUpdateManager = [UpdateManager new];
        [newUpdateManager addNewCommentWith:self.ref withObj:self.commentsLocalStory withCommentBody:self.commentTextField.text andUsername:[[FIRAuth auth] currentUser].email];
        self.commentTextField.text = @"";
    }
     [self.commentTextField resignFirstResponder];
    return YES;
}

- (IBAction)postAction:(UIButton *)sender {
    if (![self.commentTextField.text isEqual:@""]) {
        UpdateManager *newUpdateManager = [UpdateManager new];
        [newUpdateManager addNewCommentWith:self.ref withObj:self.commentsLocalStory withCommentBody:self.commentTextField.text andUsername:[[FIRAuth auth] currentUser].email];
        self.commentTextField.text = @"";
        [self.commentTextField resignFirstResponder];
    }
    
}//postAction








-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (IBAction)backAction:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}





@end
