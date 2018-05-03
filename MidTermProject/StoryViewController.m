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







@property (strong, nonatomic) NSMutableArray *storyArray;
@end

@implementation StoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.storyTitleArray = [NSMutableArray new];
    self.storyArray = [NSMutableArray new];
    [self retriveMessages];
    
}//load

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:true];
    [self retriveMessages];
    [self.storyFeedTableView reloadData];
    [self configureTableView];
    
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
            newStory.isFinished = thisDict[@"Sender"];
            newStory.lastCollaborator = thisDict[@"LastCollaborator"];
            
            NSString *abc = [NSString stringWithFormat:@"%@%@%@", newStory.storyTitle, newStory.storyBody, newStory.storyDate];
            if (self.storyArray.count > 0) {
                
                if (![self.storyTitleArray containsObject:abc]) {
                    [self.storyTitleArray addObject:abc];
                    [self.storyArray insertObject:newStory atIndex:0];
                }
            }//0
            else {
                [self.storyArray insertObject:newStory atIndex:0];
            }
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









@end
