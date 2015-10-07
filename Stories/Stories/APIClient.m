//
//  APIClient.m
//  Stories
//
//  Created by Alexandre Thomas on 06/10/15.
//  Copyright © 2015 athomas. All rights reserved.
//

#import "APIClient.h"

@interface APIClient ()

@property (strong, nonatomic) NSURLSession *urlSession;

@end

@implementation APIClient

- (instancetype)init
{
    self = [super init];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    self.urlSession = [NSURLSession sessionWithConfiguration:config];
    
    return self;
}

- (void)runTaskWithURL:(NSURL *)url completion:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler
{
    if(url == nil) {
        NSLog(@"Url is nil so we cant connect to the API. %@", [NSThread description]);
    } else {
        NSLog(@"API Call: %@", [url absoluteString]);
    }
    
    NSURLSessionDataTask *dataTask = [self.urlSession dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        completionHandler(data, response, error);
    }];
    
    [dataTask resume];
}

- (NSString *)getPostsIDsWithIdsArray:(NSArray *)postIDs
{
    NSString *ids = @"";
    NSMutableArray *paramBuffer = [[NSMutableArray alloc] init];
    
    for (NSNumber *postID in postIDs) {
        [paramBuffer addObject: [NSString stringWithFormat:@"id=%@", [(NSNumber *)postID stringValue]]];
    }
    
    ids = [paramBuffer componentsJoinedByString:@"&"];
    return ids;
}

- (void)fetchChildrenBlogsForBlog:(NSNumber*) blogID completion:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler
{
    static NSString *kinjaChildrenBaseURL = @"http://kinja.com/api/profile/subblog/views/childrenOf?blogId=%@";
    
    NSString *kinjaChildrenForBlogURL = [NSString stringWithFormat:kinjaChildrenBaseURL, blogID];
    NSURL *url = [NSURL URLWithString:kinjaChildrenForBlogURL];
    [self runTaskWithURL:url completion:completionHandler];
}

- (void)fetchBlogsDetailsWithIDs:(NSArray *)blogIDs completion:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler
{
    if([blogIDs count] == 0)
        return;
    
    NSString *kinjaBlogsDetailsURL = @"http://kinja.com/api/profile/blogs?";
    
    for(int i = 0; i < [blogIDs count]; i++){
        NSString *blogID = blogIDs[i];
        if(i > 0)
            kinjaBlogsDetailsURL = [kinjaBlogsDetailsURL stringByAppendingFormat:@"&"];
        kinjaBlogsDetailsURL = [kinjaBlogsDetailsURL stringByAppendingFormat:@"ids=%@", blogID];
    }
    
    NSURL *url = [NSURL URLWithString:kinjaBlogsDetailsURL];
    [self runTaskWithURL:url completion:completionHandler];
}

- (void)fetchTopPostsForBlog:(NSString *)blogHost withSection:(NSString *)section withLimit:(NSUInteger)limit completion:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler
{
    if(blogHost == nil)
    {
        int a = 0;
    }
    static NSString *topPostBase = @"http://kinja.com/api/chartbeat/toppostsextended?host=%@&limit=%lu";
    static NSString *topPostBaseSection = @"http://kinja.com/api/chartbeat/toppostsextended?host=%@&limit=%lu&section=%@";
    NSString *topPostForHost = section == nil ?
        [NSString stringWithFormat:topPostBase, blogHost, (unsigned long)limit]:
        [NSString stringWithFormat:topPostBaseSection, blogHost, (unsigned long)limit, section];
    NSURL *url = [[NSURL alloc] initWithString:topPostForHost];
    [self runTaskWithURL:url completion:completionHandler];
}

- (void)fetchPostsContent:(NSArray *)postIds completion:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler
{
    NSString *ids = [self getPostsIDsWithIdsArray:postIds];
    static NSString *kinjaPostListBaseURL = @"https://kinja.com/api/core/corepost/getList?%@&include=id,display,aboveHeadline,leftOfHeadline";
    NSString *topPostList = [NSString stringWithFormat:kinjaPostListBaseURL, ids];
    NSURL *url = [[NSURL alloc] initWithString:topPostList];
    [self runTaskWithURL:url completion:completionHandler];
}

@end
