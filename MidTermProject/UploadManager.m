//
//  UploadManager.m
//  MidTermProject
//
//  Created by Raman Singh on 2018-05-06.
//  Copyright © 2018 Tyler Boudreau. All rights reserved.
//

#import "UploadManager.h"


@implementation UploadManager

-(void) uploadStoryWithRef:(FIRDatabaseReference *)ref withStoryTitle:(NSString *)storyTitle andStoryBody:(NSString *)storyBody {
    
    ref = [[FIRDatabase database] reference];
    NSMutableDictionary *myDict = [NSMutableDictionary new];
    [myDict setObject:storyTitle forKey:@"Title"];
    [myDict setObject:storyBody forKey:@"Body"];
    [myDict setObject:[self getDate] forKey:@"Date"];
    [myDict setObject:[[FIRAuth auth] currentUser].email forKey:@"Sender"];
    [myDict setObject:[[FIRAuth auth] currentUser].email forKey:@"LastCollaborator"];
    [myDict setObject:@"0" forKey:@"Total Raters"];
    [myDict setObject:@"0" forKey:@"Total Ratings"];
    [myDict setObject:@"" forKey:@"Comments"];
    [myDict setObject:@"" forKey:@"Total Collaborators"];
    [myDict setObject:@"" forKey:@"Raters Array"];
    
    //commenters
    NSMutableDictionary *commentDictionary = [NSMutableDictionary new];
    NSMutableDictionary *IgnoreMe = [NSMutableDictionary new];
    [IgnoreMe setObject:@"daddaa" forKey:@"ComentSenderGuy"];
    [IgnoreMe setObject:@"dadada" forKey:@"CommentBodee"];
    [IgnoreMe setObject:@"dadaada" forKey:@"key"];
    [commentDictionary setObject:IgnoreMe forKey:@"IgnoreMe"];
    [myDict setObject:commentDictionary forKey:@"commenters"];
    
    //raters
    NSMutableDictionary *ratersDictionary = [NSMutableDictionary new];
    NSMutableDictionary *plsIgnoreMe = [NSMutableDictionary new];
    [plsIgnoreMe setObject:@"tyler" forKey:@"Rater Name"];
    [plsIgnoreMe setObject:@"4 out of 5" forKey:@"Rater Rating"];
    [plsIgnoreMe setObject:@"key?" forKey:@"key"];
    [ratersDictionary setObject:plsIgnoreMe forKey:@"IgnoreMe"];
    [myDict setObject:ratersDictionary forKey:@"Raters"];
    
    
    
    FIRDatabaseReference *myID2 = [[ref child:@"Stories"] childByAutoId];
    [myDict setObject:myID2.key forKey:@"Key"];
    [myID2 setValue:myDict];
    
    
}//uploadStoryWithRef

-(NSString *) getDate {
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    return [dateFormatter stringFromDate:[NSDate date]];
}//getDate


@end
