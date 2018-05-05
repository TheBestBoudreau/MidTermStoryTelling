//
//  StoryViewController.m
//  MidTermProject
//
//  Created by Raman Singh on 2018-05-02.
//  Copyright © 2018 Tyler Boudreau. All rights reserved.
//

#import "StoryViewController.h"
#import "TableViewCell.h"

#import "MidTermProject-Swift.h"
#import "FullStoryView.h"

@interface StoryViewController ()

@property (strong, nonatomic) IBOutlet UITableView *storyFeedTableView;

@property (strong, nonatomic) FIRDatabaseReference *ref;

@property (nonatomic) NSMutableArray *storyTitleArray;

@property (nonatomic) NSMutableArray *originalIndexArray;

@property (nonatomic) NSMutableArray *changedIndexArray;

@property (nonatomic) NSMutableArray *staticStoryArray;

@property (nonatomic) Stories * myStoryProperty;




@property (strong, nonatomic) NSMutableArray *storyArray;
@end

@implementation StoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _staticStoryArray = [NSMutableArray new];
    self.storyTitleArray = [NSMutableArray new];
    self.storyArray = [NSMutableArray new];
    
    
    
}//load

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:true];
    [self retriveMessages];
    self.storyArray = [NSMutableArray new];
    [self.storyFeedTableView reloadData];
    [self configureTableView];
    
    
    
    _originalIndexArray = [[NSMutableArray alloc] init];
    _changedIndexArray = [[NSMutableArray alloc] init];
//    [self tryThis];
}//viewDidAppear


#pragma Setup TableView


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.storyArray.count;
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TableViewCell * cell = [tableView dequeueReusableCellWithIdentifier: @"storyCell"];
    
    Stories *thisStory = [self.storyArray objectAtIndex:indexPath.row];
    
    cell.titleLabel.text = thisStory.storyTitle;
    cell.dateLabel.text = thisStory.storyDate;
    cell.bodyLabel.text = thisStory.storyBody;
    cell.ratingsLabel.text = thisStory.doubleRatings;
    cell.cellView.layer.cornerRadius = 15;
    cell.cellView.layer.masksToBounds = true;
    
    
    
    return cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Stories *staticStory = [Stories new];
    self.myStoryProperty = [_storyArray objectAtIndex:indexPath.row];
    
    [self performSegueWithIdentifier:@"fullStory" sender:self];
    
    
}



-(void) retriveMessages {
    self.ref = [[FIRDatabase database] reference];
    [[self.ref child:@"Stories"] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSDictionary *dict = snapshot.value;
//        NSLog(@"%@",dict);

        
        
        for (NSString* thisString in dict) {
            NSDictionary *thisDict = dict[thisString];
            Stories *newStory = [Stories new];


            newStory.storyTitle = thisDict[@"Title"];
            newStory.storyBody = thisDict[@"Body"];
            newStory.storyDate = thisDict[@"Date"];
            newStory.sender = thisDict[@"Sender"];
            newStory.lastCollaborator = thisDict[@"LastCollaborator"];
            newStory.totalRaters = thisDict[@"Total Raters"];
            newStory.totalRatings = thisDict[@"Total Ratings"];
            newStory.comments = thisDict[@"Comments"];
            newStory.totalCollaborators = thisDict[@"Total Collaborators"];
            newStory.key = thisDict[@"Key"];
            newStory.ratersString = thisDict[@"Raters Array"];
            
            NSDictionary *ratingsDictionary = thisDict[@"Raters"];
            
            newStory.totalRaters = [NSString stringWithFormat:@"%lu", ratingsDictionary.count - 1];
            
            
            NSLog(@"Total raters are %@", newStory.totalRaters);
            
            for (NSString *this in ratingsDictionary) {
                
                NSDictionary *thisDict = ratingsDictionary[this];
                
                Ratings *newRating = [Ratings new];
                newRating.raterName = thisDict[@"Rater Name"];
                newRating.raterRating = thisDict[@"Rater Rating"];
                newRating.ratingKey = thisDict[@"Key"];
                
                if (![newRating.raterRating isEqualToString:@"4 out of 5"]) {
                    NSLog(@"%@", newRating.raterRating);
                [newStory.ratersArray addObject:newRating];
                    
                    int initialRatings = [newStory.totalRatings intValue];
                    int thisRating = [newRating.raterRating intValue];
                    
                    int finalRating = initialRatings + thisRating;
                    newStory.totalRatings = [NSString stringWithFormat:@"%d", finalRating];
                    NSLog(@"newStory.totalRatings is %@", newStory.totalRatings);
                    int averageValue = [newStory.totalRatings intValue]/[newStory.totalRaters intValue];
                    newStory.averageRatings = averageValue;
                    
                    double averageDouble = [newStory.totalRatings doubleValue]/[newStory.totalRaters doubleValue];
                    newStory.doubleRatings = [NSString stringWithFormat:@"%.1f", averageDouble];
                    
                    
                    NSLog(@"Double value is %@", newStory.doubleRatings);
                    
                }

            
                
                
            }//ratingsDictionary for loop
            
            
            
            [self.storyArray insertObject:newStory atIndex:0];
            [self.storyFeedTableView reloadData];
            [self configureTableView];
            
            
            
            
        }//forLoop
        
        
        
        //experimentation
        
        
//        for (int i = 0; i < )
        
        
        //experimentation
        

        
    } withCancelBlock:^(NSError * _Nonnull error) {
        NSLog(@"%@", error.localizedDescription);
    }];

    
    
    
}//retriveMessages

-(void)configureTableView {
    self.storyFeedTableView.rowHeight = UITableViewAutomaticDimension;
    self.storyFeedTableView.estimatedRowHeight = 120;
    
    
}//configureTableView


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"fullStory"]) {
        
        
        FullStoryView * fvc = segue.destinationViewController;
        fvc.fullStoryLocal = self.myStoryProperty;
    }
    
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


-(void) createUserNameArraysFromRatings {
    
}//createUserNameArraysFromRatings


@end
