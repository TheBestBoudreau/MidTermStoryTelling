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




@end
