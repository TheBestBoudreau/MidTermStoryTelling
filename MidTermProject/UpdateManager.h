//
//  DownloadManager.h
//  MidTermProject
//
//  Created by Raman Singh on 2018-05-04.
//  Copyright © 2018 Tyler Boudreau. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MidTermProject-Swift.h"
@import Firebase;



@interface UpdateManager : NSObject
@property (nonatomic) Comments *dmComment;

-(void) addNewCommentWith:(FIRDatabaseReference *)ref withObj:(Stories *)thisStory withCommentBody:(NSString *)commentBody andUsername:(NSString *)username;
-(void) tryThisWithStory:(Stories *)fullStoryLocal andRef:(FIRDatabaseReference *)ref andStoryBody:(NSString *)storyBody;
-(void) addNewRatings:(FIRDatabaseReference *)ref withObj:(Stories *)thisStory withRating:(NSString *)userRating andUsername:(NSString *)username;
-(void) updateRating:(FIRDatabaseReference *)ref withObj:(Stories *)thisStory withRating:(NSString *)userRating andUsername:(NSString *)username andRatersKey:(NSString *)raterKey;


@end
