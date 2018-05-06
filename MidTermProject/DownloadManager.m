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
                }
        }//forLoop
        
        
        }//check if null
        
    } withCancelBlock:^(NSError * _Nonnull error) {
        NSLog(@"%@", error.localizedDescription);
    }];
    
}//downloadCommentsWithRef












@end
