//
//  DataManager.h
//  Kinja Top Posts
//
//  Created by Alexandre THOMAS on 29/09/15.
//  Copyright © 2015 athomas. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreData;
#import "Blog.h"
#import "Post.h"
#import "Image.h"

#define kAPINetworkConnectionError @"APINetworkConnectionError"
#define kTopPostsFetched @"kTopPostsFetched"
//#define kDidReceivedImageDataNotification @"kDidReceivedImageDataNotification"

@interface DataManager : NSObject

@property (strong, nonatomic) NSManagedObjectContext *readingContext;

+ (instancetype)sharedInstance;
- (void)createManagedObjectContextsWithPersistentStoreCoordinator:(NSPersistentStoreCoordinator *)persistentStoreCoordinator;

- (void)createDefaultGMGBlogs;
- (Blog *)getBlogWithID:(NSNumber *)blogID;
- (void)fetchPostsForBlog:(Blog *)blog;

@end
