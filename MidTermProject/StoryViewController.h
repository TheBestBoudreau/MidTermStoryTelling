//
//  StoryViewController.h
//  MidTermProject
//
//  Created by Raman Singh on 2018-05-02.
//  Copyright © 2018 Tyler Boudreau. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Firebase;
#import "StoriesManager.h"
#import "DownloadManager.h"




@interface StoryViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,UITextViewDelegate, DownloadMethod>

@end
