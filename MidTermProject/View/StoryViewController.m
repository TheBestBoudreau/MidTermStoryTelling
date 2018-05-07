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
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(checkCount) userInfo:nil repeats:true];
    
}//load

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:true];
    
    [self downloadStories];
    self.storyArray = [NSMutableArray new];
    
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

#pragma Download Stories
-(void) downloadStories {
    
    DownloadManager *newDownMan = [DownloadManager new];
    newDownMan.delegate = self;
    self.ref = [[FIRDatabase database] reference];
    [newDownMan downloadStoriesWithRef:self.ref];
    
}//downloadStories

-(void)configureTableView {
    
    self.storyFeedTableView.rowHeight = UITableViewAutomaticDimension;
    self.storyFeedTableView.estimatedRowHeight = 120;
    
}//configureTableView

#pragma Prepare For Segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"fullStory"]) {
        
        FullStoryView * fvc = segue.destinationViewController;
        fvc.fullStoryLocal = self.myStoryProperty;
    }//if
    
}//prepareForSegue

#pragma StatusBarStyle
-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


#pragma Delegate Method
-(void)addNewStory:(Stories *)story {
    NSLog(@"Added story");
    [self.storyArray addObject:story];
    [self.storyFeedTableView reloadData];
    [self configureTableView];
}//addNewStory

-(void)updateLocalStoriesArray:(NSMutableArray *)freshStoriesArray {
    self.storyArray = freshStoriesArray;
    [self.storyFeedTableView reloadData];
    [self configureTableView];
}//updateLocalStoriesArray


#pragma Check Timer
-(void) checkCount {
    DownloadManager *newDownMan = [DownloadManager new];
    newDownMan.delegate = self;
    self.ref = [[FIRDatabase database] reference];
    [newDownMan updateStoriesWithRef:self.ref andArray:self.storyArray];
    
}//checkCount







@end
