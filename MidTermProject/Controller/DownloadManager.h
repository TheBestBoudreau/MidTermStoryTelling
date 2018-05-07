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


@protocol DownloadMethod <NSObject>
-(void)addNewStory:(Stories *)story;
-(void)updateLocalStoriesArray:(NSMutableArray *)freshStoriesArray;
@end

@protocol UpdateComments <NSObject>
-(void)downloadCommentsWithArray:(NSMutableArray *)array;
@end



@interface DownloadManager : NSObject

@property (nonatomic) NSMutableArray *myArray;
@property (nonatomic) NSMutableArray *storiesArray;
@property id <DownloadMethod> delegate;
@property id <UpdateComments> commentDelegate;

-(void) downloadStoriesWithRef:(FIRDatabaseReference *)ref;
-(void) downloadCommentsWithRef:(FIRDatabaseReference *)ref andStory:(Stories *)localStory;
-(void) updateStoriesWithRef:(FIRDatabaseReference *)ref andArray:(NSMutableArray *)storiesArray;

@end
