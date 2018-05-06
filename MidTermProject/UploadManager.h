//
//  UploadManager.h
//  MidTermProject
//
//  Created by Raman Singh on 2018-05-06.
//  Copyright © 2018 Tyler Boudreau. All rights reserved.
//

#import <Foundation/Foundation.h>
@import Firebase;


@interface UploadManager : NSObject
-(void) uploadStoryWithRef:(FIRDatabaseReference *)ref withStoryTitle:(NSString *)storyTitle andStoryBody:(NSString *)storyBody;
-(NSString *) getDate;
@end
