//
//  DataManager.h
//  Stories
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
- (NSArray *)getBlogsAndSubBlogsWithID:(NSNumber *)blogID;
- (NSArray *)getPostsForBlog:(Blog *)blog;
- (NSArray *)getGMGBlogs;
- (void)fetchPostsForBlog:(Blog *)blog;
- (void)cleaningPosts;

@end
