//
//  FullStoryView.m
//  MidTermProject
//
//  Created by Raman Singh on 2018-05-03.
//  Copyright © 2018 Tyler Boudreau. All rights reserved.
//

#import "FullStoryView.h"
#import "CommentsViewController.h"
#import "UpdateManager.h"
#import "DownloadManager.h"



@interface FullStoryView ()

@property (weak, nonatomic) IBOutlet UILabel *editCharacterCounter;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSMutableArray *storyArray;
@property (strong, nonatomic) IBOutlet UIButton *editButtonOutlet;
@property (strong, nonatomic) IBOutlet UIButton *backButtonOut;
@property (strong, nonatomic) IBOutlet UIView *editView;
@property (strong, nonatomic) IBOutlet UITextView *editStoryTextView;
@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) IBOutlet UIImageView *doneView;
@property (strong, nonatomic) IBOutlet UIView *commentRateView;
@property (nonatomic) NSTimer *timer;
@property (nonatomic) NSUInteger previousTextLength;

@property (strong, nonatomic) IBOutlet UIView *rateView;
@property (strong, nonatomic) IBOutlet UIButton *oneStarOutlet;
@property (strong, nonatomic) IBOutlet UIButton *twoStarOutlet;
@property (strong, nonatomic) IBOutlet UIButton *threeStarOutlet;
@property (strong, nonatomic) IBOutlet UIButton *fourStarOutlet;
@property (strong, nonatomic) IBOutlet UIButton *fiveStarOutlet;
@property (nonatomic) int starCount;
@property (nonatomic) BOOL alreadyRated;
@property (nonatomic) NSString *ratedKey;



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
    
    self.timer = [[NSTimer alloc] init];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateLocalUser) userInfo:nil repeats:true];
    
    _previousTextLength = self.fullStoryLocal.storyBody.length;
    
    [self updateLocalUser];
    [self checkIfAlreadyRated];
    
}//load

#pragma Setup TableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.storyArray.count;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FullStoryTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier: @"Cell"];
    
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

-(void)textViewDidChange:(UITextView *)textView{
    NSUInteger length = textView.text.length - self.previousTextLength;

        self.editCharacterCounter.text = [NSString stringWithFormat:@"Characters Left: %lu", 300 - length];
}


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
        [self tryThis];
        self.doneView.hidden = false;
        [self performSelector:@selector(hideDoneScreen) withObject:nil afterDelay:1.0];
        self.editView.hidden = true;
        self.commentRateView.hidden = false;
        [self.backButtonOut setTitle:@"Back" forState:UIControlStateNormal];
        [self.storyArray addObject:self.editStoryTextView.text];
        [self.storyArray removeObjectAtIndex:1];
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
    
    UpdateManager *newUpdateManager = [UpdateManager new];
    [newUpdateManager tryThisWithStory:self.fullStoryLocal andRef:self.ref andStoryBody:self.editStoryTextView.text];
    [self.tableView reloadData];

}//tryThis

-(void) checkLastCollaborator {
    if ([[[FIRAuth auth] currentUser].email isEqualToString:self.fullStoryLocal.lastCollaborator]) {
        self.editButtonOutlet.enabled = false;
    } else {
        self.editButtonOutlet.enabled = true;
    }
}//checkLastCollaborator

-(void) updateLocalUser {
    
    self.ref = [[FIRDatabase database] reference];
    NSString *key = self.fullStoryLocal.key;
    
    UpdateManager *newUpdateManager = [UpdateManager new];
    newUpdateManager.delegate = self;
    [newUpdateManager updateUserWithRef:self.ref andKey:key andStory:self.fullStoryLocal];
    
}//updateLocalUser
#pragma Comments Action

- (IBAction)commentsAction:(UIButton *)sender {

    [self performSegueWithIdentifier:@"toComments" sender:self];

}//commentsAction


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"toComments"]) {
        
        CommentsViewController *cvf = segue.destinationViewController;
        cvf.commentsLocalStory = self.fullStoryLocal;
        
    }//if
    
}//prepareForSegue



#pragma stars

- (IBAction)oneStarAction:(id)sender {
    
    self.starCount = 1;
    [self renderStars];
    
}

- (IBAction)twoStarAction:(id)sender {
    self.starCount = 2;
    [self renderStars];
}

- (IBAction)threeStarAction:(id)sender {
    self.starCount = 3;
    [self renderStars];
}

- (IBAction)fourStarAction:(id)sender {
    self.starCount = 4;
    [self renderStars];
}

- (IBAction)fiveStarAction:(id)sender {
    self.starCount = 5;
    [self renderStars];
}




-(void)renderStars {
    [self checkIfAlreadyRated];
    
    switch (self.starCount) {
        case 1:
            {
                [self oneGold];
                [self sendRatings];
                break;
            }
            
        case 2:
        {
            [self twoGold];
            [self sendRatings];
            break;
        }
            
        case 3:
        {
            [self threeGold];
            [self sendRatings];
            break;
        }
            
        case 4:
        {
            [self fourGold];
            [self sendRatings];
            break;
        }
            
        case 5:
        {
            
            [self fiveGold];
            [self sendRatings];
            break;
        }
            
        default:
            break;
    }
    
}//renderStars


#pragma StarMethods
-(void) allWhiteStars {
    [self.oneStarOutlet setImage:[UIImage imageNamed:@"starBlue.png"] forState:UIControlStateNormal];
    [self.twoStarOutlet setImage:[UIImage imageNamed:@"starBlue.png"] forState:UIControlStateNormal];
    [self.threeStarOutlet setImage:[UIImage imageNamed:@"starBlue.png"] forState:UIControlStateNormal];
    [self.fourStarOutlet setImage:[UIImage imageNamed:@"starBlue.png"] forState:UIControlStateNormal];
    [self.fiveStarOutlet setImage:[UIImage imageNamed:@"starBlue.png"] forState:UIControlStateNormal];
}

-(void) oneGold {
    [self allWhiteStars];
    [self.oneStarOutlet setImage:[UIImage imageNamed:@"starGold.png"] forState:UIControlStateNormal];
}

-(void) twoGold {
    [self allWhiteStars];
    [self.oneStarOutlet setImage:[UIImage imageNamed:@"starGold.png"] forState:UIControlStateNormal];
    [self.twoStarOutlet setImage:[UIImage imageNamed:@"starGold.png"] forState:UIControlStateNormal];
}

-(void) threeGold {
    [self allWhiteStars];
    [self.oneStarOutlet setImage:[UIImage imageNamed:@"starGold.png"] forState:UIControlStateNormal];
    [self.twoStarOutlet setImage:[UIImage imageNamed:@"starGold.png"] forState:UIControlStateNormal];
    [self.threeStarOutlet setImage:[UIImage imageNamed:@"starGold.png"] forState:UIControlStateNormal];
}

-(void) fourGold {
    [self allWhiteStars];
    [self.oneStarOutlet setImage:[UIImage imageNamed:@"starGold.png"] forState:UIControlStateNormal];
    [self.twoStarOutlet setImage:[UIImage imageNamed:@"starGold.png"] forState:UIControlStateNormal];
    [self.threeStarOutlet setImage:[UIImage imageNamed:@"starGold.png"] forState:UIControlStateNormal];
    [self.fourStarOutlet setImage:[UIImage imageNamed:@"starGold.png"] forState:UIControlStateNormal];
}

-(void) fiveGold {
    [self.oneStarOutlet setImage:[UIImage imageNamed:@"starGold.png"] forState:UIControlStateNormal];
    [self.twoStarOutlet setImage:[UIImage imageNamed:@"starGold.png"] forState:UIControlStateNormal];
    [self.threeStarOutlet setImage:[UIImage imageNamed:@"starGold.png"] forState:UIControlStateNormal];
    [self.fourStarOutlet setImage:[UIImage imageNamed:@"starGold.png"] forState:UIControlStateNormal];
    [self.fiveStarOutlet setImage:[UIImage imageNamed:@"starGold.png"] forState:UIControlStateNormal];
}

#pragma Ratings
-(void)sendRatings {
    NSString *localRating = [NSString stringWithFormat:@"%d", self.starCount];
    UpdateManager *newUM = [UpdateManager new];
    
    if (self.alreadyRated) {
        NSLog(@"Raters key is %@", self.ratedKey);
        [newUM updateRating:self.ref withObj:self.fullStoryLocal withRating:localRating andUsername:[[FIRAuth auth] currentUser].email andRatersKey:self.ratedKey];
    } else {
    [newUM addNewRatings:self.ref withObj:self.fullStoryLocal withRating:localRating andUsername:[[FIRAuth auth] currentUser].email];
    }
    
    Ratings *thisRating = [Ratings new];
    thisRating.raterName = [[FIRAuth auth] currentUser].email;
    thisRating.raterRating = localRating;
    thisRating.ratingKey = self.ratedKey;
    
    [self.fullStoryLocal.ratersArray addObject:thisRating];
    [self checkIfAlreadyRated];
    
}//sendRatings

-(void)checkIfAlreadyRated {
    self.alreadyRated = false;
    for  (int i = 0; i<self.fullStoryLocal.ratersArray.count; i++) {
        Ratings *thisRating = [self.fullStoryLocal.ratersArray objectAtIndex:i];
        
        
        if ([thisRating.raterName isEqual:[[FIRAuth auth] currentUser].email]) {
            [self applyRatingsToButtons:thisRating.raterRating];
            self.ratedKey = thisRating.ratingKey;
            self.alreadyRated = true;
        }
        
    }//forLoop
}//checkIf

#pragma Delegate Method
-(void)refreshArray:(Stories *)fullStoryLocal {
    
    [self checkLastCollaborator];
    
    if (self.editView.isHidden) {
        self.storyArray = [NSMutableArray new];
        [self.storyArray addObject:self.fullStoryLocal.storyTitle];
        NSArray *this = [self.fullStoryLocal.storyBody componentsSeparatedByString:@"\n"];
        [self.storyArray addObjectsFromArray:this];
        [self.tableView reloadData];
        [self configureTableView];
        self.editStoryTextView.text = self.fullStoryLocal.storyBody;
    }//self.editView.isHidden
    
}//refreshArray


#pragma Apply Ratings
-(void)applyRatingsToButtons:(NSString *)rating {
    
    if ([rating isEqualToString:@"1"]) {
        [self oneGold];
    }
    
    else if ([rating isEqualToString:@"2"]) {
        [self twoGold];
    }
    
    else if ([rating isEqualToString:@"3"]) {
        [self threeGold];
    }
    
    else if ([rating isEqualToString:@"4"]) {
        [self fourGold];
    }
    
    else if ([rating isEqualToString:@"5"]) {
        [self fiveGold];
    }
    
    else {
        [self allWhiteStars];
    }
    
}//applyRatingsToButtons


#pragma Hide StatusBar
-(BOOL)prefersStatusBarHidden {
    return true;
}





@end
