//
//  APIClient.h
//  Stories
//
//  Created by Alexandre Thomas on 06/10/15.
//  Copyright © 2015 athomas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIClient : NSObject

- (void)fetchChildrenBlogsForBlog:(NSNumber*) blogID completion:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler;
- (void)fetchBlogsDetailsWithIDs:(NSArray *)blogIDs completion:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler;
- (void)fetchTopPostsForBlog:(NSString *)blogHost withSection:(NSString *)section withLimit:(NSUInteger)limit completion:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler;
- (void)fetchPostsContent:(NSArray *)postIds completion:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler;

@end
