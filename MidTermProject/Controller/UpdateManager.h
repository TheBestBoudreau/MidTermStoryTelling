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

@protocol UpdateUserAbility <NSObject>
-(void)refreshArray:(Stories *)fullStoryLocal;
@end

@interface UpdateManager : NSObject

@property (nonatomic) Comments *dmComment;
@property id <UpdateUserAbility> delegate;

-(void) addNewCommentWith:(FIRDatabaseReference *)ref withObj:(Stories *)thisStory withCommentBody:(NSString *)commentBody andUsername:(NSString *)username;
-(void) tryThisWithStory:(Stories *)fullStoryLocal andRef:(FIRDatabaseReference *)ref andStoryBody:(NSString *)storyBody;
-(void) addNewRatings:(FIRDatabaseReference *)ref withObj:(Stories *)thisStory withRating:(NSString *)userRating andUsername:(NSString *)username;
-(void) updateRating:(FIRDatabaseReference *)ref withObj:(Stories *)thisStory withRating:(NSString *)userRating andUsername:(NSString *)username andRatersKey:(NSString *)raterKey;
-(void)updateUserWithRef:(FIRDatabaseReference *)ref andKey:(NSString *)key andStory:(Stories *)fullStoryLocal;

@end
