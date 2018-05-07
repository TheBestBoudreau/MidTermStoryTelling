//
//  DownloadManager.m
//  MidTermProject
//
//  Created by Raman Singh on 2018-05-04.
//  Copyright © 2018 Tyler Boudreau. All rights reserved.
//

#import "UpdateManager.h"

@implementation UpdateManager

-(void) addNewCommentWith:(FIRDatabaseReference *)ref withObj:(Stories *)thisStory withCommentBody:(NSString *)commentBody andUsername:(NSString *)username {
    
    ref = [[FIRDatabase database] reference];
    NSMutableDictionary *myDict = [NSMutableDictionary new];
    [myDict setObject:commentBody forKey:@"CommentBodee"];
    [myDict setObject:username forKey:@"ComentSenderGuy"];
    
    
    NSString *key = thisStory.key;
    NSString *path = [NSString stringWithFormat:@"Stories/%@/commenters", key];
    
    FIRDatabaseReference *myID2 = [[ref child:path] childByAutoId];
    [myDict setObject:myID2.key forKey:@"Key"];
    [myID2 setValue:myDict];
    
}//addNewComment


-(void) tryThisWithStory:(Stories *)fullStoryLocal andRef:(FIRDatabaseReference *)ref andStoryBody:(NSString *)storyBody {
    
    NSString *key = fullStoryLocal.key;
    ref = [[FIRDatabase database] reference];
    NSString *path = [NSString stringWithFormat:@"Stories/%@/", key];
    
    [[ref child:path] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        NSDictionary *dict = snapshot.value;
        [dict setValue:storyBody forKey:@"Body"];
        [dict setValue:[[FIRAuth auth] currentUser].email forKey:@"LastCollaborator"];
        NSString *path2 = [NSString stringWithFormat:@"Stories/%@", key];
        FIRDatabaseReference *myID2 = [ref child:path2];
        [myID2 updateChildValues:dict];
        
    } withCancelBlock:^(NSError * _Nonnull error) {
        NSLog(@"%@", error.localizedDescription);
    }];
    
}//tryThisWithStory



-(void) addNewRatings:(FIRDatabaseReference *)ref withObj:(Stories *)thisStory withRating:(NSString *)userRating andUsername:(NSString *)username {
   
    ref = [[FIRDatabase database] reference];
    NSMutableDictionary *myDict = [NSMutableDictionary new];
    [myDict setObject:username forKey:@"Rater Name"];
    [myDict setObject:userRating forKey:@"Rater Rating"];
    
    NSString *key = thisStory.key;
    NSString *path = [NSString stringWithFormat:@"Stories/%@/Raters", key];
    
    FIRDatabaseReference *myID2 = [[ref child:path] childByAutoId];
    [myDict setObject:myID2.key forKey:@"Key"];
    [myID2 setValue:myDict];
    
}//addNewRatings


-(void) updateRating:(FIRDatabaseReference *)ref withObj:(Stories *)thisStory withRating:(NSString *)userRating andUsername:(NSString *)username andRatersKey:(NSString *)raterKey {
    
    NSString *key = thisStory.key;
    ref = [[FIRDatabase database] reference];
    NSString *path = [NSString stringWithFormat:@"Stories/%@/Raters", key];
    
    [[ref child:path] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        NSDictionary *dict = snapshot.value;
        NSDictionary *ratingDict = dict[raterKey];
        
        NSLog(@"rating dict is %@", ratingDict);
        [ratingDict setValue:userRating forKey:@"Rater Rating"];
        FIRDatabaseReference *myID2 = [ref child:path];
        [myID2 updateChildValues:dict];
        
    } withCancelBlock:^(NSError * _Nonnull error) {
        NSLog(@"%@", error.localizedDescription);
    }];
    
}//addNewRatings


-(void)updateUserWithRef:(FIRDatabaseReference *)ref andKey:(NSString *)key andStory:(Stories *)fullStoryLocal {
    
    [[ref child:[@"/Stories/" stringByAppendingString:key]] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSDictionary *thisDict = snapshot.value;
        
        fullStoryLocal.storyTitle = thisDict[@"Title"];
        fullStoryLocal.storyBody = thisDict[@"Body"];
        fullStoryLocal.storyDate = thisDict[@"Date"];
        fullStoryLocal.sender = thisDict[@"Sender"];
        fullStoryLocal.lastCollaborator = thisDict[@"LastCollaborator"];
        fullStoryLocal.totalRaters = thisDict[@"Total Raters"];
        fullStoryLocal.totalRatings = thisDict[@"Total Ratings"];
        fullStoryLocal.comments = thisDict[@"Comments"];
        fullStoryLocal.totalCollaborators = thisDict[@"Total Collaborators"];
        fullStoryLocal.key = thisDict[@"Key"];
        fullStoryLocal.ratersString = thisDict[@"Raters Array"];
        
        [self.delegate refreshArray:fullStoryLocal];
        
    } withCancelBlock:^(NSError * _Nonnull error) {
        NSLog(@"%@", error.localizedDescription);
        
    }];
    
}//updateUser


@end
