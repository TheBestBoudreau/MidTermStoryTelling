//
//  FriendsViewController.m
//  MidTermProject
//
//  Created by Raman Singh on 2018-05-02.
//  Copyright © 2018 Tyler Boudreau. All rights reserved.
//

#import "FriendsViewController.h"

@interface FriendsViewController ()

@property (strong, nonatomic) IBOutlet UITableView *myFriendsTableView;
@property (strong, nonatomic) NSMutableArray <NSString *> * friendsList;
@end

@implementation FriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.friendsList.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier: @"Cell"];
    cell.textLabel.text = [self.friendsList objectAtIndex:indexPath.row];
    
    return cell;
    
}

@end
