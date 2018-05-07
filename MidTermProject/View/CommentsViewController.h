//
//  CommentsViewController.h
//  MidTermProject
//
//  Created by Raman Singh on 2018-05-04.
//  Copyright © 2018 Tyler Boudreau. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MidTermProject-Swift.h"
#import "DownloadManager.h"
#import "UploadManager.h"
@import Firebase;

@interface CommentsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UpdateComments>
@property (nonatomic) Stories *commentsLocalStory;





@end
