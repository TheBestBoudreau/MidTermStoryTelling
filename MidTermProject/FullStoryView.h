//
//  FullStoryView.h
//  MidTermProject
//
//  Created by Raman Singh on 2018-05-03.
//  Copyright © 2018 Tyler Boudreau. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MidTermProject-Swift.h"
#import "FullStoryTableViewCell.h"
@import Firebase;

@interface FullStoryView : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>
@property (nonatomic) Stories* fullStoryLocal;
@end
