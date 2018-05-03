//
//  StoryViewController.m
//  MidTermProject
//
//  Created by Raman Singh on 2018-05-02.
//  Copyright © 2018 Tyler Boudreau. All rights reserved.
//

#import "StoryViewController.h"

@interface StoryViewController ()

@property (strong, nonatomic) IBOutlet UITableView *storyFeedTableView;
@property (strong, nonatomic) NSArray *storyArray;
@end

@implementation StoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.storyArray.count;
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier: @"storyCell"];
    cell.textLabel.text = [self.storyArray objectAtIndex:indexPath.row];
    
    return cell;
    
}

@end
