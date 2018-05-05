//
//  CommentsViewController.m
//  MidTermProject
//
//  Created by Raman Singh on 2018-05-04.
//  Copyright © 2018 Tyler Boudreau. All rights reserved.
//

#import "CommentsViewController.h"
#import "CommentTableViewCell.h"


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
    _testArray = [[NSMutableArray alloc] initWithObjects:@"a",@"b",@"c", nil];
    _commentsArray = [NSMutableArray new];
    _commentTextField.delegate = self;
    
    NSLog(@"%@", self.commentsLocalStory.storyTitle);

    
    [self addCommentObjects];
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [self watchKeyboardNotifications:notificationCenter];
    self.commentPostButton.hidden = YES;
    self.commentPostButton.enabled = false;
    
    
}//load

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:
(NSString *)string {
    
    
    if([self.commentTextField.text isEqualToString:@""]){
        self.commentPostButton.enabled = FALSE;
        
    }else{
        self.commentPostButton.enabled = TRUE;
    }
    return textField.text.length + (string.length - range.length) <= 150;
    
    
    
}



-(void) tryThis:(NSString *)comment {
    NSString *key = self.commentsLocalStory.key;
    self.ref = [[FIRDatabase database] reference];
    NSDictionary *post = @{@"Title": self.commentsLocalStory.storyTitle,
                           @"Body": self.commentsLocalStory.storyBody,
                           @"Date": self.commentsLocalStory.storyDate,
                           @"Sender": self.commentsLocalStory.sender,
                           @"LastCollaborator": [[FIRAuth auth] currentUser].email,
                           @"Total Ratings": self.commentsLocalStory.totalRatings,
                           @"Total Raters": self.commentsLocalStory.totalRaters,
                           @"Key": key,
                           @"Comments": comment,
                           @"Total Collaborators": self.commentsLocalStory.totalCollaborators,
                           @"Raters Array": self.commentsLocalStory.ratersString,
                           };
    
    NSDictionary *childUpdates = @{[@"/Stories/" stringByAppendingString:key]: post};
    [self.ref updateChildValues:childUpdates];
    
    NSLog(@"Posted Comment");
    
    
}//tryThis



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


-(void)unzipComments{
    
    
}

-(void)addCommentObjects{
    NSArray *bigStringArray = [NSArray new];
    NSString *commentString = self.commentsLocalStory.comments;
    
    bigStringArray = [commentString componentsSeparatedByString:@"BushFinallyAchievedit"];
    
//    NSLog(@" In This Array %@",bigStringArray);
    
    for (int i = 0 ; i< bigStringArray.count-1 ; i++){
        Comments *newComment = [Comments new];
        NSString *individualCommentString = [bigStringArray objectAtIndex:i];
        NSArray *combineStringArray = [[NSArray alloc] init];
        combineStringArray = [individualCommentString componentsSeparatedByString:@"BushDid911:"];
        
        newComment.username = [combineStringArray objectAtIndex:1];
        newComment.comments = [combineStringArray objectAtIndex:3];
        newComment.commentDate = [combineStringArray objectAtIndex:2];
        
        [self.commentsArray addObject:newComment];
        [self.commentTableView reloadData];
        [self configureTableView];
        
        NSLog(@"THIS IS THE COMMENTS ARRAY COUNT :  %lu",self.commentsArray.count);
        
    }
}

//commentCell

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
        //            self.calculateBottomConstraint.constant = 10 +  kbSize.height;
        
    }];
    
    
    self.commentPostButton.hidden = false;
    
}
- (void)UIKeyboardDidHideNotification:(NSNotification *)notification {
    NSLog(@"%@", notification.name);
    
    
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    [self.commentTextField layoutIfNeeded];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.bottomContraint.constant = 0;
        [self.commentUIView layoutIfNeeded];
    } completion:^(BOOL finished){
        
        
    }];
    
    self.commentPostButton.hidden = TRUE;
    self.commentPostButton.enabled = false;

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.commentTextField resignFirstResponder];
    return YES;
}

- (IBAction)postAction:(UIButton *)sender {

    NSString *commentString = [self updateCommentsAndReturnString];
    NSString *userName = [[FIRAuth auth] currentUser].email;
    NSString *time = [self getDate];
    NSString *comment = self.commentTextField.text;
    
    NSString *addCommentString = [NSString stringWithFormat:@"BushDid911:%@BushDid911:%@BushDid911:%@BushFinallyAchievedit", userName, time, comment];
    commentString = [NSString stringWithFormat:@"%@%@", commentString,addCommentString];
    [self tryThis:commentString];
    
}//postAction


-(NSString *)updateCommentsAndReturnString {
    self.ref = [[FIRDatabase database] reference];
    NSString *key = self.commentsLocalStory.key;
    [[self.ref child:[@"/Stories/" stringByAppendingString:key]] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSDictionary *thisDict = snapshot.value;
        
        
        self.commentsLocalStory.storyTitle = thisDict[@"Title"];
        self.commentsLocalStory.storyBody = thisDict[@"Body"];
        self.commentsLocalStory.storyDate = thisDict[@"Date"];
        self.commentsLocalStory.sender = thisDict[@"Sender"];
        self.commentsLocalStory.lastCollaborator = thisDict[@"LastCollaborator"];
        self.commentsLocalStory.totalRaters = thisDict[@"Total Raters"];
        self.commentsLocalStory.totalRatings = thisDict[@"Total Ratings"];
        self.commentsLocalStory.comments = thisDict[@"Comments"];
        self.commentsLocalStory.totalCollaborators = thisDict[@"Total Collaborators"];
        self.commentsLocalStory.key = thisDict[@"Key"];
        self.commentsLocalStory.ratersString = thisDict[@"Raters Array"];
        
    
        
        
    } withCancelBlock:^(NSError * _Nonnull error) {
        NSLog(@"%@", error.localizedDescription);
        
    }];
    NSLog(@"%@",  self.commentsLocalStory.comments);
    return  self.commentsLocalStory.comments;
    

}//updateComments


-(NSString *) getDate {
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    return [dateFormatter stringFromDate:[NSDate date]];
}

@end
