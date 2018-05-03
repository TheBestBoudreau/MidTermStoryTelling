//
//  StoryViewController.m
//  MidTermProject
//
//  Created by Raman Singh on 2018-05-02.
//  Copyright © 2018 Tyler Boudreau. All rights reserved.
//

#import "StoryViewController.h"
#import "CollectionViewCell.h"


@interface StoryViewController ()

@property (strong, nonatomic) IBOutlet UITableView *storyFeedTableView;

@property (strong, nonatomic) FIRDatabaseReference *ref;







@property (strong, nonatomic) NSArray *storyArray;
@end

@implementation StoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self addKeyboardButtns];
    
    
    [self retriveMessages];
    
    
    
    
}//load


#pragma Setup TableView


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.storyArray.count;
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier: @"storyCell"];
    cell.textLabel.text = [self.storyArray objectAtIndex:indexPath.row];
    
    return cell;
    
}
/*

#pragma Setup CollectionView

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.collectionItems.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.label.text = [self.storyArray objectAtIndex:indexPath.row];
    
    return cell;
    
    
}



-(BOOL)prefersStatusBarHidden {
    return true;
}

-(void)cancelNumberPad {
    [self.storyTextField resignFirstResponder];
    self.storyTextField.hidden = true;
    self.textViewContainer.hidden = true;
    
}//cancelNumberPad

-(void)doneWithNumberPad {
    [self.storyTextField resignFirstResponder];
    self.storyTextField.hidden = true;
    self.textViewContainer.hidden = true;
    
    self.ref = [[FIRDatabase database] reference];
    
    NSMutableDictionary *myDict = [NSMutableDictionary new];
    [myDict setObject:@"Me" forKey:@"Sender"];
    [myDict setObject:@"You" forKey:@"Reciever"];
    
    [[[_ref child:@"Stories"] childByAutoId] setValue:myDict];
    
    
    
}//doneWithNumberPad


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
 {
     return textView.text.length + (text.length - range.length) <= 150;
    
}//shouldChangeTextInRange

-(void) addKeyboardButtns {
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    numberToolbar.barStyle = UIBarStyleDefault;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    [numberToolbar sizeToFit];
    self.storyTextField.inputAccessoryView = numberToolbar;
}//addKeyboardButtns


- (IBAction)addStoryButton:(UIButton *)sender {
    if (self.addStoryView.isHidden) {
    [self.storyTextField becomeFirstResponder];
    self.storyTextField.hidden = false;
    self.textViewContainer.hidden = false;
    self.addStoryView.hidden = false;
    [self.bigAssButton setImage:[UIImage imageNamed:@"bigAssButton2"] forState:UIControlStateNormal];
    } else {
        [self.storyTextField resignFirstResponder];
        self.storyTextField.hidden = true;
        self.textViewContainer.hidden = true;
        self.addStoryView.hidden = true;
        [self.bigAssButton setImage:[UIImage imageNamed:@"bigAssButton"] forState:UIControlStateNormal];
    }
}//addStoryButton

*/
-(void) retriveMessages {
    self.ref = [[FIRDatabase database] reference];
    [[self.ref child:@"Stories"] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSDictionary *dict = snapshot.value;
        NSLog(@"%@",dict);
        
        if (dict) {
            
        }
        
        
        
    } withCancelBlock:^(NSError * _Nonnull error) {
        NSLog(@"%@", error.localizedDescription);
    }];
    
    
    
}//retriveMessages











@end
