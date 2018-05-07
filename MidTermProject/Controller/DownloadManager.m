//
//  DownloadManager.m
//  MidTermProject
//
//  Created by Raman Singh on 2018-05-05.
//  Copyright © 2018 Tyler Boudreau. All rights reserved.
//

#import "DownloadManager.h"


@implementation DownloadManager

-(void) downloadCommentsWithRef:(FIRDatabaseReference *)ref andStory:(Stories *)localStory {
    
    NSMutableArray *commentsArray = [NSMutableArray new];
    _myArray = [NSMutableArray new];
    ref = [[FIRDatabase database] reference];
    NSString *key = localStory.key;
    NSString *path = [NSString stringWithFormat:@"Stories/%@/commenters", key];
    
    [[ref child:path] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        NSDictionary *dict = snapshot.value;
        
        if (dict != NULL) {
            
            for (NSString* thisString in dict) {
                
                if (![thisString isEqual:@"IgnoreMe"]) {
                    NSDictionary *thisDict = dict[thisString];
                    Comments *thisComment = [Comments new];
                    thisComment.comments = thisDict[@"CommentBodee"];
                    thisComment.username = thisDict[@"ComentSenderGuy"];
                    [commentsArray addObject:thisComment];
                    
                    [self.myArray addObject:thisComment];
                    
                }//if
                
            }//forLoop
        
            [self.commentDelegate downloadCommentsWithArray:self.myArray];
            
        }//check if null
        
    } withCancelBlock:^(NSError * _Nonnull error) {
        NSLog(@"%@", error.localizedDescription);
    }];
    
}//downloadCommentsWithRef


-(void) downloadStoriesWithRef:(FIRDatabaseReference *)ref {
    
    NSLog(@"downloadStoriesWithRef");
    [[ref child:@"Stories"] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSDictionary *dict = snapshot.value;
        NSLog(@"%lu is cit count",dict.count);
        
        for (NSString* thisString in dict) {

            NSDictionary *thisDict = dict[thisString];
            Stories *newStory = [Stories new];
            
            newStory.storyTitle = thisDict[@"Title"];
            newStory.storyBody = thisDict[@"Body"];
            newStory.storyDate = thisDict[@"Date"];
            newStory.sender = thisDict[@"Sender"];
            newStory.lastCollaborator = thisDict[@"LastCollaborator"];
            newStory.totalRaters = thisDict[@"Total Raters"];
            newStory.totalRatings = thisDict[@"Total Ratings"];
            newStory.comments = thisDict[@"Comments"];
            newStory.totalCollaborators = thisDict[@"Total Collaborators"];
            newStory.key = thisDict[@"Key"];
            newStory.ratersString = thisDict[@"Raters Array"];
            
            NSDictionary *ratingsDictionary = thisDict[@"Raters"];
            
            newStory.totalRaters = [NSString stringWithFormat:@"%lu", ratingsDictionary.count - 1];
            
            for (NSString *this in ratingsDictionary) {
                
                NSDictionary *thisDict = ratingsDictionary[this];
                
                Ratings *newRating = [Ratings new];
                newRating.raterName = thisDict[@"Rater Name"];
                newRating.raterRating = thisDict[@"Rater Rating"];
                newRating.ratingKey = thisDict[@"Key"];
                
                if (![newRating.raterRating isEqualToString:@"4 out of 5"]) {
                    [newStory.ratersArray addObject:newRating];
                    
                    int initialRatings = [newStory.totalRatings intValue];
                    int thisRating = [newRating.raterRating intValue];
                    int finalRating = initialRatings + thisRating;
                    
                    newStory.totalRatings = [NSString stringWithFormat:@"%d", finalRating];
                    
                    int averageValue = [newStory.totalRatings intValue]/[newStory.totalRaters intValue];
                    
                    newStory.averageRatings = averageValue;
                    
                    double averageDouble = [newStory.totalRatings doubleValue]/[newStory.totalRaters doubleValue];
                    newStory.doubleRatings = [NSString stringWithFormat:@"%.1f", averageDouble];
                    
                }//if sample ratings
                
            }//ratingsDictionary for loop
            
            [self.delegate addNewStory:newStory];
            
        }//forLoop
    
    } withCancelBlock:^(NSError * _Nonnull error) {
        NSLog(@"%@", error.localizedDescription);
    }];
    
}//downloadStoriesWithRef


-(void) updateStoriesWithRef:(FIRDatabaseReference *)ref andArray:(NSMutableArray *)storiesArray {
    
    NSMutableArray *freshStories = [NSMutableArray new];
    [[ref child:@"Stories"] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSDictionary *dict = snapshot.value;
    
        
        for (NSString* thisString in dict) {
            
            NSDictionary *thisDict = dict[thisString];
            Stories *newStory = [Stories new];
            
            newStory.storyTitle = thisDict[@"Title"];
            newStory.storyBody = thisDict[@"Body"];
            newStory.storyDate = thisDict[@"Date"];
            newStory.sender = thisDict[@"Sender"];
            newStory.lastCollaborator = thisDict[@"LastCollaborator"];
            newStory.totalRaters = thisDict[@"Total Raters"];
            newStory.totalRatings = thisDict[@"Total Ratings"];
            newStory.comments = thisDict[@"Comments"];
            newStory.totalCollaborators = thisDict[@"Total Collaborators"];
            newStory.key = thisDict[@"Key"];
            newStory.ratersString = thisDict[@"Raters Array"];
            
            NSDictionary *ratingsDictionary = thisDict[@"Raters"];
            
            newStory.totalRaters = [NSString stringWithFormat:@"%lu", ratingsDictionary.count - 1];
            
            for (NSString *this in ratingsDictionary) {
                
                NSDictionary *thisDict = ratingsDictionary[this];
                
                Ratings *newRating = [Ratings new];
                newRating.raterName = thisDict[@"Rater Name"];
                newRating.raterRating = thisDict[@"Rater Rating"];
                newRating.ratingKey = thisDict[@"Key"];
                
                if (![newRating.raterRating isEqualToString:@"4 out of 5"]) {
                    [newStory.ratersArray addObject:newRating];
                    
                    int initialRatings = [newStory.totalRatings intValue];
                    int thisRating = [newRating.raterRating intValue];
                    int finalRating = initialRatings + thisRating;
                    
                    newStory.totalRatings = [NSString stringWithFormat:@"%d", finalRating];
                    
                    int averageValue = [newStory.totalRatings intValue]/[newStory.totalRaters intValue];
                    
                    newStory.averageRatings = averageValue;
                    
                    double averageDouble = [newStory.totalRatings doubleValue]/[newStory.totalRaters doubleValue];
                    newStory.doubleRatings = [NSString stringWithFormat:@"%.1f", averageDouble];
                    
                }//if sample ratings
                
            }//ratingsDictionary for loop
            
//            [self.delegate addNewStory:newStory];
            
            [freshStories addObject:newStory];
        
        }//forLoop
        
        if (freshStories.count != storiesArray.count) {
            NSLog(@"more stories were added");
            NSLog(@"stories array %lu", storiesArray.count);
            NSLog(@"freshStories array %lu", freshStories.count);
            
            [self.delegate updateLocalStoriesArray:freshStories];
            
        } else {
            
            for (int i=0;i<freshStories.count;i++) {
                
                Stories *freshStory = [freshStories objectAtIndex:i];
                Stories *fetchedStory = [storiesArray objectAtIndex:i];
                
                if (![freshStory.storyBody isEqual:fetchedStory.storyBody]) {
                    [self.delegate updateLocalStoriesArray:freshStories];
                }//if
            }//else
            
            
            
            
        }//else
        
    } withCancelBlock:^(NSError * _Nonnull error) {
        NSLog(@"%@", error.localizedDescription);
    }];
    
}//downloadStoriesWithRef

@end
