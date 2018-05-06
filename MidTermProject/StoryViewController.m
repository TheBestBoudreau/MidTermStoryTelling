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
@property (nonatomic) Stories * myStoryProperty;
@property (strong, nonatomic) NSMutableArray *storyArray;
@property (nonatomic) NSTimer *timer;
@end

@implementation StoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.storyArray = [NSMutableArray new];
    
}//load

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:true];
    
    [self retriveMessages];
    self.storyArray = [NSMutableArray new];
    [self.storyFeedTableView reloadData];
    [self configureTableView];
    
}//viewWillAppear


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
    cell.ratingsLabel.text = [NSString stringWithFormat:@"Rating %@",thisStory.doubleRatings];
    cell.cellView.layer.cornerRadius = 15;
    cell.cellView.layer.masksToBounds = true;
    
    if ([cell.ratingsLabel.text isEqualToString:[NSString stringWithFormat:@"Rating "]]){
        cell.ratingsLabel.text = @"Not Rated";
    }
    
    
    return cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    self.myStoryProperty = [_storyArray objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"fullStory" sender:self];
    
}



-(void) retriveMessages {
    
    DownloadManager *newDownMan = [DownloadManager new];
    newDownMan.delegate = self;
    self.ref = [[FIRDatabase database] reference];
    [newDownMan downloadStoriesWithRef:self.ref];
    
    
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

-(void)addStoriesToArray:(Stories *)story {
    
    [self.storyArray insertObject:story atIndex:0];
    [self.storyFeedTableView reloadData];
    [self configureTableView];
    
    NSLog(@"addStoriesToArray");
}//addStoriesToArray

-(void)keepRunningdownloadManager {
    
    
    
    
    NSLog(@"Stories array is %lu", self.storyArray.count);
    
    
    if (self.storyArray.count > 0) {
        [self.timer invalidate];
        NSLog(@"Im invalidated");
    }
}//keepRunningdownloadManager


-(void)updateStoriesArray:(DownloadManager *)newDownManger {
    self.storyArray = newDownManger.storiesArray;
}


-(void)addNewStory:(Stories *)story {
    NSLog(@"Added story");
    [self.storyArray insertObject:story atIndex:0];
                    [self.storyFeedTableView reloadData];
                    [self configureTableView];
}


-(void)makeItPrint {
    NSLog(@"delegate runs");
}








@end
