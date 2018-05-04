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


@interface StoryViewController ()

@property (strong, nonatomic) IBOutlet UITableView *storyFeedTableView;

@property (strong, nonatomic) FIRDatabaseReference *ref;

@property (nonatomic) NSMutableArray *storyTitleArray;

@property (nonatomic) NSMutableArray *originalIndexArray;

@property (nonatomic) NSMutableArray *changedIndexArray;

@property (nonatomic) NSMutableArray *staticStoryArray;






@property (strong, nonatomic) NSMutableArray *storyArray;
@end

@implementation StoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _staticStoryArray = [NSMutableArray new];
    self.storyTitleArray = [NSMutableArray new];
    self.storyArray = [NSMutableArray new];
    
    
    [self searchForIndexNum];
}//load

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:true];
    [self retriveMessages];
    self.storyArray = [NSMutableArray new];
    [self.storyFeedTableView reloadData];
    [self configureTableView];
    
    [self searchForIndexNum];
    
    _originalIndexArray = [[NSMutableArray alloc] init];
    _changedIndexArray = [[NSMutableArray alloc] init];

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
    cell.cellView.layer.cornerRadius = 15;
    cell.cellView.layer.masksToBounds = true;
    
    
    
    
    
    
    
    
    return cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Stories *staticStory = [Stories new];
    
    staticStory = [self.storyArray objectAtIndex:indexPath.row];
    int abc = [self.staticStoryArray indexOfObject:staticStory];
    NSLog(@"THIS IS THE INDEX %d", abc);
    NSLog(@"story array count is %lu", self.storyArray.count);
    NSLog(@"staic array count is %lu", self.staticStoryArray.count);
    Stories *story = [self.staticStoryArray objectAtIndex:abc];
    NSLog(@"Title should be %@", story.storyTitle);
    
    
    
    
}

-(void) retriveMessages {
    self.ref = [[FIRDatabase database] reference];
    [[self.ref child:@"Stories"] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSDictionary *dict = snapshot.value;
                NSLog(@"%@",dict);
        
        
        
        for (NSString* thisString in dict) {
            NSDictionary *thisDict = dict[thisString];
            Stories *newStory = [Stories new];
            NSLog(@"The key might be %@", self.ref.childByAutoId.key);
            
            newStory.storyTitle = thisDict[@"Title"];
            newStory.storyBody = thisDict[@"Body"];
            newStory.storyDate = thisDict[@"Date"];
            newStory.isFinished = thisDict[@"Sender"];
            newStory.lastCollaborator = thisDict[@"LastCollaborator"];
            
            
            
            
            
            
            NSString *abc = [NSString stringWithFormat:@"%@%@%@", newStory.storyTitle, newStory.storyBody, newStory.storyDate];
//            if (self.storyArray.count > 0) {
//
//                if (![self.storyTitleArray containsObject:abc]) {
//
//                    [self.originalIndexArray addObject:abc];
//                    [self.changedIndexArray insertObject:abc atIndex:0];
//                    [self.staticStoryArray addObject:newStory];
//                    [self.storyTitleArray addObject:abc];
//                    [self.storyArray insertObject:newStory atIndex:0];
//                }
//            }//0
//            else {
//
//                [self.originalIndexArray addObject:abc];
//                [self.storyTitleArray addObject:abc];
//                [self.changedIndexArray insertObject:abc atIndex:0];
//                [self.storyArray insertObject:newStory atIndex:0];
//                [self.staticStoryArray addObject:newStory];
//            }
            [self.staticStoryArray addObject:newStory];
            [self.storyArray insertObject:newStory atIndex:0];
            [self.storyFeedTableView reloadData];
            [self configureTableView];
        }//forLoop
        
        
    } withCancelBlock:^(NSError * _Nonnull error) {
        NSLog(@"%@", error.localizedDescription);
    }];
    
    

    
}//retriveMessages

-(void)configureTableView {
    self.storyFeedTableView.rowHeight = UITableViewAutomaticDimension;
    self.storyFeedTableView.estimatedRowHeight = 120;
    
    
}//configureTableView



-(void)searchForIndexNum{
    if (self.storyArray.count > 0) {
        Stories *story = [self.storyArray objectAtIndex:2];
        NSString *test = [NSString stringWithFormat:@"%@%@%@", story.storyTitle, story.storyBody, story.storyDate];
        int ab = [self.storyArray indexOfObject:story];
    } // if
    

} // searchForIndexNum




@end
