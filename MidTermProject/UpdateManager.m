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
                NSLog(@"Dictionary is %@",dict);
        [dict setValue:storyBody forKey:@"Body"];
        [dict setValue:[[FIRAuth auth] currentUser].email forKey:@"LastCollaborator"];
        NSString *path2 = [NSString stringWithFormat:@"Stories/%@", key];
        FIRDatabaseReference *myID2 = [ref child:path2];
        [myID2 updateChildValues:dict];
        
       
        
    } withCancelBlock:^(NSError * _Nonnull error) {
        NSLog(@"%@", error.localizedDescription);
    }];
    
    
    
    
    
    
    
    
    
    
    

   
    //    self.ref = [[FIRDatabase database] reference];
    //    NSString *storyBody = self.fullStoryLocal.storyBody;
    //    storyBody = [NSString stringWithFormat:@"%@\n%@", self.fullStoryLocal.storyBody, self.editStoryTextView.text];
    //
    //
    //    NSDictionary *post = @{@"Title": self.fullStoryLocal.storyTitle,
    //                           @"Body": self.editStoryTextView.text,
    //                           @"Date": self.fullStoryLocal.storyDate,
    //                           @"Sender": self.fullStoryLocal.sender,
    //                           @"LastCollaborator": [[FIRAuth auth] currentUser].email,
    //                           @"Total Ratings": self.fullStoryLocal.totalRatings,
    //                           @"Total Raters": self.fullStoryLocal.totalRaters,
    //                           @"Key": key,
    //                           @"Comments": self.fullStoryLocal.comments,
    //                           @"Total Collaborators": self.fullStoryLocal.totalCollaborators,
    //                           @"Raters Array": self.fullStoryLocal.ratersString,
    //                           };
    //
    //        NSDictionary *childUpdates = @{[@"/Stories/" stringByAppendingString:key]: post};
    //        [self.ref updateChildValues:childUpdates];












}//tryThis







@end
