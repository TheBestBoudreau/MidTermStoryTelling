//
//  CommentsViewController.h
//  MidTermProject
//
//  Created by Raman Singh on 2018-05-04.
//  Copyright © 2018 Tyler Boudreau. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MidTermProject-Swift.h"
@import Firebase;

@interface CommentsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (nonatomic) Stories *commentsLocalStory;
@end
