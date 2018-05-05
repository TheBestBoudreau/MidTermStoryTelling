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

@interface DownloadManager : NSObject
-(void) downloadCommentsWithRef:(FIRDatabaseReference *)ref andStory:(Stories *)localStory;
@property (nonatomic) NSMutableArray *myArray;
@end
