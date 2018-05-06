//
//  DownloadManager.h
//  MidTermProject
//
//  Created by Raman Singh on 2018-05-05.
//  Copyright © 2018 Tyler Boudreau. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MidTermProject-Swift.h"
@import Firebase;

//StoriesManager
@protocol DownloadMethod <NSObject>
-(void)addNewStory:(Stories *)story;
@end
//StoriesManager


@interface DownloadManager : NSObject

@property (nonatomic) NSMutableArray *myArray;
@property (nonatomic) NSMutableArray *storiesArray;
-(void) downloadCommentsWithRef:(FIRDatabaseReference *)ref andStory:(Stories *)localStory;


@property id <DownloadMethod> delegate;
-(void) downloadStoriesWithRef:(FIRDatabaseReference *)ref;




@end

//-(void) downloadCommentsWithRef2:(FIRDatabaseReference *)ref andStory:(Stories *)localStory completionHandler:(void(^)(NSMutableArray *returnDict, NSError *error))completion;
//-(void) downloadCommentsWithRef:(FIRDatabaseReference *)ref andStory:(Stories *)localStory;

