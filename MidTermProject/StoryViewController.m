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
@property (strong, nonatomic) IBOutlet UITextView *storyTextField;
@property (strong, nonatomic) DatabaseReference *ref;





@property (strong, nonatomic) NSArray *storyArray;
@end

@implementation StoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    numberToolbar.barStyle = UIBarStyleDefault;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    [numberToolbar sizeToFit];
    self.storyTextField.inputAccessoryView = numberToolbar;
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.storyArray.count;
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier: @"storyCell"];
    cell.textLabel.text = [self.storyArray objectAtIndex:indexPath.row];
    
    return cell;
    
}

-(BOOL)prefersStatusBarHidden {
    return true;
}

-(void)cancelNumberPad {
    self.storyTextField.resignFirstResponder;
}//cancelNumberPad

-(void)doneWithNumberPad {
    self.storyTextField.resignFirstResponder;
    
    
    
    self.ref = [[Database database] reference];
    
    
    
    Database *messageDB = Database.database().reference().child("Messages")
    var array = ["A", "B"]
    let messageDictionary = ["Sender":FIRAuth.auth()?.currentUser?.email, "MessageBody":storyTextField.text!, "TimeStamp":"Today", "Collaborators":array, "Title":"Story Title"]
    
    messageDB.childByAutoId().setValue(messageDictionary) {
        (error, reference) in
        if error != nil {
            print(error)
        } else {
            print("Message saved succesfully")
            self.messageTextfield.isEnabled = true
            self.sendButton.isEnabled = true
            self.messageTextfield.text = ""
        }
        
    }
}//doneWithNumberPad


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
 {
     return textView.text.length + (text.length - range.length) <= 150;
    
}



@end
