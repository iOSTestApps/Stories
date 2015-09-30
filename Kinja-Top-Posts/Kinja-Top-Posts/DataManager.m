//
//  DataManager.m
//  Kinja Top Posts
//
//  Created by Alexandre THOMAS on 29/09/15.
//  Copyright © 2015 athomas. All rights reserved.
//

#import "DataManager.h"
#import "NSDictionary+Utilities.h"

#define kAreBlogsAlreadyStored @"kAreBlogsAlreadyStored"

@interface DataManager()
@property (strong, nonatomic) NSURLSession *urlSession;
@property (strong, nonatomic) NSManagedObjectContext *insertionContext;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic) BOOL nextPageAvailable;
@end

@implementation DataManager

#pragma mark - Initialization

- (void)createManagedObjectContextsWithPersistentStoreCoordinator:(NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    self.persistentStoreCoordinator = persistentStoreCoordinator;
    
    // create insertion context
    self.insertionContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    self.insertionContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
    self.insertionContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy;
    
    // create reading context
    self.readingContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    self.readingContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
    self.readingContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy;
}

- (instancetype)init
{
    self = [super init];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    self.urlSession = [NSURLSession sessionWithConfiguration:config];
    
    return self;
}

+ (instancetype)sharedInstance
{
    static DataManager *dataManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataManager = [[self alloc] init];
    });
    
    return dataManager;
}

- (NSArray *)parseAndGetArrayFromData:(NSData *)data withResponse:(NSURLResponse *)response withError:(NSError *)error
{
    NSArray *jsonResults;
    
    if (data.length && error == nil) {
        NSError *jsonError;
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        
        if ([json[@"data"] isKindOfClass:[NSArray class]]) {
            jsonResults = json[@"data"];
        } else {
            NSLog(@"Malformed server response");
        }
        
    } else {
        NSLog(@"There was an error");
    }
    
    return jsonResults;
}

- (NSDictionary *)parseAndGetDictionaryFromData:(NSData *)data withResponse:(NSURLResponse *)response withError:(NSError *)error
{
    NSDictionary *jsonResults;
    
    if (data.length && error == nil) {
        NSError *jsonError;
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        
        if ([json[@"data"] isKindOfClass:[NSDictionary class]]) {
            jsonResults = json[@"data"];
        } else {
            NSLog(@"Malformed server response");
        }
        
    } else {
        NSLog(@"There was an error");
    }
    
    return jsonResults;
}

#pragma mark data management


- (void)createDefaultGMGBlogs
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if([prefs objectForKey:kAreBlogsAlreadyStored] != nil)
        return;
    
    Blog *blogDeadspin = (Blog *)[NSEntityDescription insertNewObjectForEntityForName:@"Blog" inManagedObjectContext:self.insertionContext];
    blogDeadspin.blogDisplayName = @"Deadspin";
    blogDeadspin.blogHost = @"deadspin.com";
    blogDeadspin.blogID = @(11);
    
    Blog *blogGawker = (Blog *)[NSEntityDescription insertNewObjectForEntityForName:@"Blog" inManagedObjectContext:self.insertionContext];
    blogGawker.blogDisplayName = @"Gawker";
    blogGawker.blogHost = @"gawker.com";
    blogGawker.blogID = @(7);
    
    Blog *blogGizmodo = (Blog *)[NSEntityDescription insertNewObjectForEntityForName:@"Blog" inManagedObjectContext:self.insertionContext];
    blogGizmodo.blogDisplayName = @"Gizmodo";
    blogGizmodo.blogHost = @"gizmodo.com";
    blogGizmodo.blogID = @(4);
    
    Blog *blogiO9 = (Blog *)[NSEntityDescription insertNewObjectForEntityForName:@"Blog" inManagedObjectContext:self.insertionContext];
    blogiO9.blogDisplayName = @"iO9";
    blogiO9.blogHost = @"io9.com";
    blogiO9.blogID = @(8);
    
    Blog *blogJalopnik = (Blog *)[NSEntityDescription insertNewObjectForEntityForName:@"Blog" inManagedObjectContext:self.insertionContext];
    blogJalopnik.blogDisplayName = @"Jalopnik";
    blogJalopnik.blogHost = @"jalopnik.com";
    blogJalopnik.blogID = @(12);
    
    Blog *blogJezebel = (Blog *)[NSEntityDescription insertNewObjectForEntityForName:@"Blog" inManagedObjectContext:self.insertionContext];
    blogJezebel.blogDisplayName = @"Jezebel";
    blogJezebel.blogHost = @"jezebel.com";
    blogJezebel.blogID = @(39);
    
    Blog *blogKotaku = (Blog *)[NSEntityDescription insertNewObjectForEntityForName:@"Blog" inManagedObjectContext:self.insertionContext];
    blogKotaku.blogDisplayName = @"Kotaku";
    blogKotaku.blogHost = @"kotaku.com";
    blogKotaku.blogID = @(9);
    
    Blog *blogLifehacker = (Blog *)[NSEntityDescription insertNewObjectForEntityForName:@"Blog" inManagedObjectContext:self.insertionContext];
    blogLifehacker.blogDisplayName = @"Lifehacker";
    blogLifehacker.blogHost = @"lifehacker.com";
    blogLifehacker.blogID = @(17);
    
    NSError *saveError = nil;
    BOOL success = [self.insertionContext save:&saveError];
    
    if(success) {
        [prefs setObject:[NSDate date] forKey:kAreBlogsAlreadyStored];
        [prefs synchronize];
    }
}

- (Blog *)getBlogWithID:(NSNumber *)blogID
{
    return [self getBlogWithID:blogID inManagedObjectContext:self.readingContext];
}

- (Blog *)getBlogWithID:(NSNumber *)blogID inManagedObjectContext:(NSManagedObjectContext *)moc
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"blogID = %@", blogID];
    NSArray *result = [self doFetchRequestForEntityWithName:@"Blog" withPredicate:predicate withSortDescriptors:nil withBatchSize:nil inManagedObjectContext:moc];
    
    return (0 != result.count) ? result[0] : nil;
}

- (Post *)getPostWithID:(NSNumber *)postID inManagedObjectContext:(NSManagedObjectContext *)moc
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"postID = %@", postID];
    NSArray *result = [self doFetchRequestForEntityWithName:@"Post" withPredicate:predicate withSortDescriptors:nil withBatchSize:nil inManagedObjectContext:moc];
    
    return (0 != result.count) ? result[0] : nil;
}

#pragma mark - Data request

- (NSFetchRequest *)createFetchRequestForEntityWithName:(NSString *)entityName withPredicate:(NSPredicate *)predicate withSortDescriptors:(NSArray *)sortDescriptors withBatchSize:(NSNumber *)batchSize inManagedObjectContext:(NSManagedObjectContext *)moc
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:moc];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = entity;
    
    if (nil != predicate) {
        fetchRequest.predicate = predicate;
    }
    
    if (nil != sortDescriptors) {
        [fetchRequest setSortDescriptors:sortDescriptors];
    }
    
    if (nil != batchSize) {
        fetchRequest.fetchBatchSize = (int)batchSize;
    }
    
    return fetchRequest;
}


- (NSArray *)doFetchRequestForEntityWithName:(NSString *)entityName withPredicate:(NSPredicate *)predicate withSortDescriptors:(NSArray *)sortDescriptors withBatchSize:(NSNumber *)batchSize inManagedObjectContext:(NSManagedObjectContext *)moc
{
    @try {
        NSFetchRequest *fetchRequest = [self createFetchRequestForEntityWithName:entityName withPredicate:predicate withSortDescriptors:sortDescriptors withBatchSize:batchSize inManagedObjectContext:moc];
        NSError *error;
        NSArray *results = [moc executeFetchRequest:fetchRequest error:&error];
        
        if (nil != results) {
            return results;
        } else {
            NSLog(@"%@", [NSString stringWithFormat:@"%@ %@", error, error.localizedDescription]);
            return nil;
        }
    }
    @catch (NSException * e) {
        NSLog(@"%@", [NSString stringWithFormat:@"Exeption: %@", e]);
        NSLog(@"%@", [NSString stringWithFormat:@"Entity: %@ %@ %@", entityName, predicate, [NSThread description]]);
    }
    @finally {
        
    }
    
    return nil;
}

- (void)fetchPostsForBlog:(Blog *)blog
{
    
    static NSString *topPostBase = @"http://kinja.com/api/chartbeat/toppostsextended?host=%@&limit=5";
    NSString *topPostForHost = [NSString stringWithFormat:topPostBase, blog.blogHost];
    NSURL *topPostUrl = [[NSURL alloc] initWithString:topPostForHost];
    NSURLSessionDataTask *dataTask = [self.urlSession dataTaskWithRequest:[NSURLRequest requestWithURL:topPostUrl]
        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (nil != error) {
                [[NSNotificationCenter defaultCenter] postNotificationName:kAPINetworkConnectionError object:nil];
            } else {
                [self resetPostScore];
                NSArray *results = [self parseAndGetArrayFromData:data withResponse:response withError:error];
                NSString *postsIds = [self createPostsFromResults:results withBlogID:blog.blogID];
                
                static NSString *kinjaPostListBaseURL = @"https://kinja.com/api/core/corepost/getList?%@&include=id,display,aboveHeadline,leftOfHeadline";
                NSString *topPostList = [NSString stringWithFormat:kinjaPostListBaseURL, postsIds];
                NSURL *topPostUrl = [[NSURL alloc] initWithString:topPostList];
                NSLog(@"%@",topPostUrl);
                NSURLSessionDataTask *dataTask = [self.urlSession dataTaskWithRequest:[NSURLRequest requestWithURL:topPostUrl]
                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                    if (nil != error) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:kAPINetworkConnectionError object:nil];
                    } else {
                        NSArray *results = [self parseAndGetArrayFromData:data withResponse:response withError:error];
                        [self updatePostContent:results];
                        [[NSNotificationCenter defaultCenter] postNotificationName:kTopPostsFetched object:nil userInfo:nil];
                    }
                    
                }];
                [dataTask resume];
            }
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


- (NSString *)createPostsFromResults:(NSArray *)results withBlogID:(NSNumber *)blogID
{
    Blog *blog = [self getBlogWithID:blogID inManagedObjectContext:self.insertionContext];
    NSMutableArray *posts = [[NSMutableArray alloc] init];
    for(NSDictionary *postData in results) {
        NSNumber *postID = [postData valueForKey:@"id"];
        Post *post = [self getPostWithID:postID inManagedObjectContext:self.insertionContext];
        if(post == nil) {
            post = [NSEntityDescription insertNewObjectForEntityForName:@"Post" inManagedObjectContext:self.insertionContext];
            post.postID = postID;
            post.postHeadline = [postData valueForKey:@"headline"];
            post.permalink = [postData valueForKey:@"permalink"];
            post.authorName = [postData valueForKey:@"authorNameOrByline"];
            NSString *timestamp = [postData valueForKey:@"publishTimeMillis"];
            post.publishTime = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)[timestamp floatValue] / 1000.0];
            post.blog = blog;
            
        }
        post.score = postData[@"score"];
        
        [posts addObject:post.postID];
    }
 
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"blog = %@ AND score == 0", blog];
    NSArray *postsToDelete = [self doFetchRequestForEntityWithName:@"Post" withPredicate:predicate withSortDescriptors:nil withBatchSize:nil inManagedObjectContext:self.insertionContext];
    
    NSLog(@"Cleaning %lu posts", (unsigned long)[postsToDelete count]);
    for(Post *post in postsToDelete) {
        [self.insertionContext deleteObject:post];
    }

    NSError *saveError = nil;
    [self.insertionContext save:&saveError];
    
    return [self getPostsIDsWithIdsArray:posts];
}

- (void)updatePostContent:(NSArray *)results
{
    for(NSDictionary *postData in results) {
        NSNumber *postID = [postData valueForKey:@"id"];
        Post *post = [self getPostWithID:postID inManagedObjectContext:self.insertionContext];
        if(post == nil)
            continue;
        
        if(post.display == nil) {
            NSString *display = [postData valueForKey:@"display"];
            post.display = display;
        }
        
        if(post.image == nil) {
            NSDictionary *leftOfHeadlineData = [postData valueForKey:@"leftOfHeadline" withDefault:nil];
            NSDictionary *imageData = [postData valueForKey:@"aboveHeadline" withDefault:leftOfHeadlineData];
            if(imageData != nil) {
                Image *image = [NSEntityDescription insertNewObjectForEntityForName:@"Image" inManagedObjectContext:self.insertionContext];
                image.imageID = [imageData valueForKey:@"id"];
                image.imageURL = [imageData valueForKey:@"src"];
                post.image = image;
            }
        }
    }
    
    NSError *saveError = nil;
    [self.insertionContext save:&saveError];
}

- (void)resetPostScore
{
    NSArray *posts = [self doFetchRequestForEntityWithName:@"Post" withPredicate:nil withSortDescriptors:nil withBatchSize:nil inManagedObjectContext:self.insertionContext];
    for(Post *post in posts) {
        post.score = @(0);
    }
}

//- (void)loadImage:(Image *)image
//{
//    if(image.imageID == nil)
//        return;
//    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//
//        NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", image.imageID]];
//        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
//            NSData *imageData = [[NSFileManager defaultManager] contentsAtPath:filePath];
//            [self imageHasBeenLoaded:imageData withImageID:image.imageID];
//            return;
//        }
//        
//        NSString *imageURL = [NSString stringWithFormat:@"https://i.kinja-img.com/gawker-media/image/upload/%@.jpg", image.imageID];
//        NSURL *url = [NSURL URLWithString:imageURL];
//        NSURLSessionDataTask *dataTask = [self.urlSession dataTaskWithURL:url completionHandler:^(NSData *imageData, NSURLResponse *response, NSError *error)
//          {
//              if (imageData != nil && [imageData length] > 0) {
//                  [self imageHasBeenLoaded:imageData withImageID:image.imageID];
//                  NSError *writeToFileError;
//                  [imageData writeToFile:filePath options:NSDataWritingFileProtectionNone error:&writeToFileError];
//              } else {
//                  NSLog(@"%@", [NSString stringWithFormat:@"Issue Downloading image %@; %@ : %@", error, url, image.imageID]);
//              }
//          }];
//        
//        [dataTask resume];
//    });
//}
//
//- (void)imageHasBeenLoaded:(NSData *)imageData withImageID:(NSString *)imageID
//{
//    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
//    [notificationCenter postNotificationName:kDidReceivedImageDataNotification
//                                      object:self
//                                    userInfo:@{
//                                               @"imageData": imageData,
//                                               @"imageID": imageID
//                                               }];
//}

@end
