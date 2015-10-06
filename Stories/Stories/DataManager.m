//
//  DataManager.m
//  Stories
//
//  Created by Alexandre THOMAS on 29/09/15.
//  Copyright © 2015 athomas. All rights reserved.
//

#import "DataManager.h"
#import "NSDictionary+Utilities.h"
#import "APIClient.h"
#import "NSDate+Utilities.h"

#define kBlogsFetchedDate @"kBlogsFetchedDate"

@interface DataManager()

@property (strong, nonatomic) APIClient *apiClient;
@property (strong, nonatomic) NSManagedObjectContext *insertionContext;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

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
    
    self.apiClient = [[APIClient alloc] init];
    
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
    if([prefs objectForKey:kBlogsFetchedDate] != nil)
        return;
    
    Blog *blogDeadspin = [self createBlog:@{@"displayName":@"Deadspin", @"host":@"deadspin.com", @"id":@(11), @"topic" : @"Sport"} withParentBlog:nil];
//    [self createBlog:@{@"displayName":@"Screengrabber", @"host":@"screengrabber.deadspin.com",  @"id":@(450670265)} withParentBlog:blogDeadspin];
//    [self createBlog:@{@"displayName":@"Regressing",    @"host":@"regressing.deadspin.com",     @"id":@(1070195507)} withParentBlog:blogDeadspin];
//    [self createBlog:@{@"displayName":@"The Concourse", @"host":@"theconcourse.deadspin.com",   @"id":@(1545464977)} withParentBlog:blogDeadspin];
//    [self createBlog:@{@"displayName":@"Screamer",      @"host":@"screamer.deadspin.com",       @"id":@(1578711919)} withParentBlog:blogDeadspin];
//    [self createBlog:@{@"displayName":@"Adequate Man",  @"host":@"adequateman.deadspin.com",    @"id":@(1634307700)} withParentBlog:blogDeadspin];
    
    Blog *blogGawker = [self createBlog:@{@"displayName":@"Gawker", @"host":@"gawker.com", @"id":@(7), @"topic" : @"Gossips"} withParentBlog:nil];
//    [self createBlog:@{@"displayName":@"Valleywag",     @"host":@"valleywag.gawker.com",    @"id":@(474833009)} withParentBlog:blogGawker];
//    [self createBlog:@{@"displayName":@"Defamer",       @"host":@"defamer.gawker.com",      @"id":@(512288369)} withParentBlog:blogGawker];
//    [self createBlog:@{@"displayName":@"Morning After", @"host":@"morningafter.gawker.com", @"id":@(1570534851)} withParentBlog:blogGawker];
//    [self createBlog:@{@"displayName":@"True Stories",  @"host":@"truestories.gawker.com",  @"id":@(1634311826)} withParentBlog:blogGawker];
//    [self createBlog:@{@"displayName":@"TKTK",          @"host":@"tktk.gawker.com",         @"id":@(1634311851)} withParentBlog:blogGawker];
    
    Blog *blogGizmodo = [self createBlog:@{@"displayName":@"Gizmodo", @"host":@"gizmodo.com", @"id":@(4), @"topic" : @"Tech"} withParentBlog:nil];
//    [self createBlog:@{@"displayName":@"Sploid",            @"host":@"sploid.gizmodo.com",@"id":@(487662860)} withParentBlog:blogGizmodo];
//    [self createBlog:@{@"displayName":@"Indefinitely Wild", @"host":@"indefinitelywild.gizmodo.com",@"id":@(1580652334)} withParentBlog:blogGizmodo];
//    [self createBlog:@{@"displayName":@"Field Guide",       @"host":@"fieldguide.gizmodo.com",@"id":@(1570534851)} withParentBlog:blogGizmodo];
//    [self createBlog:@{@"displayName":@"Toyland",           @"host":@"toyland.gizmodo.com",@"id":@(1624665724)} withParentBlog:blogGizmodo];
//    [self createBlog:@{@"displayName":@"Paleofuture",       @"host":@"paleofuture.gizmodo.com",@"id":@(510682837)} withParentBlog:blogGizmodo];
    
    Blog *blogiO9 = [self createBlog:@{@"displayName":@"iO9",   @"host":@"io9.com", @"id":@(8), @"topic" : @"Science Fiction"} withParentBlog:nil];
//    [self createBlog:@{@"displayName":@"Earth & Space",         @"host":@"space.io9.com",       @"id":@(10011694)} withParentBlog:blogiO9];
//    [self createBlog:@{@"displayName":@"Animals",               @"host":@"animals.io9.com",     @"id":@(1537065437)} withParentBlog:blogiO9];
//    [self createBlog:@{@"displayName":@"Toybox",                @"host":@"toybox.io9.com",      @"id":@(1623827663)} withParentBlog:blogiO9];
//    [self createBlog:@{@"displayName":@"True Crime",            @"host":@"truecrime.io9.com",   @"id":@(1634183237)} withParentBlog:blogiO9];
    
    Blog *blogJalopnik = [self createBlog:@{@"displayName":@"Jalopnik", @"host":@"jalopnik.com", @"id":@(12), @"topic" : @"Cars"} withParentBlog:nil];
//    [self createBlog:@{@"displayName":@"/DRIVE",        @"host":@"drive.jalopnik.com",          @"id":@(468728290)} withParentBlog:blogJalopnik];
//    [self createBlog:@{@"displayName":@"Foxtrot Alpha", @"host":@"foxtrotalpha.jalopnik.com",   @"id":@(1527265188)} withParentBlog:blogJalopnik];
//    [self createBlog:@{@"displayName":@"Buyer's Guide", @"host":@"buyersguide.jalopnik.com",    @"id":@(1634521805)} withParentBlog:blogJalopnik];
//    [self createBlog:@{@"displayName":@"The Garage",    @"host":@"thegarage.jalopnik.com",      @"id":@(1593200293)} withParentBlog:blogJalopnik];
//    [self createBlog:@{@"displayName":@"Code 3",        @"host":@"code3.jalopnik.com",          @"id":@(1567547931)} withParentBlog:blogJalopnik];
    
    Blog *blogJezebel = [self createBlog:@{@"displayName":@"Jezebel", @"host":@"jezebel.com", @"id":@(39), @"topic" : @"Women"} withParentBlog:nil];
//    [self createBlog:@{@"displayName":@"kitchenette",           @"host":@"kitchenette.jezebel.com",         @"id":@(1474956711)} withParentBlog:blogJezebel];
//    [self createBlog:@{@"displayName":@"Flygirl",               @"host":@"flygirl.jezebel.com",             @"id":@(1508468098)} withParentBlog:blogJezebel];
//    [self createBlog:@{@"displayName":@"That's What She Said",  @"host":@"thatswhatshesaid.jezebel.com",    @"id":@(1603056322)} withParentBlog:blogJezebel];
//    [self createBlog:@{@"displayName":@"I Thee Dread",          @"host":@"itheedread.jezebel.com",          @"id":@(1633898259)} withParentBlog:blogJezebel];
//    [self createBlog:@{@"displayName":@"The Muse",              @"host":@"themuse.jezebel.com",             @"id":@(1633941729)} withParentBlog:blogJezebel];
    
    Blog *blogKotaku = [self createBlog:@{@"displayName":@"Kotaku", @"host":@"kotaku.com", @"id":@(9), @"topic" : @"Video Games"} withParentBlog:nil];
//    [self createBlog:@{@"displayName":@"Kotaku Selects",    @"host":@"selects.kotaku.com",          @"id":@(472201676)} withParentBlog:blogKotaku];
//    [self createBlog:@{@"displayName":@"Cosplay",           @"host":@"cosplay.kotaku.com",          @"id":@(1538697436)} withParentBlog:blogKotaku];
//    [self createBlog:@{@"displayName":@"TMI",               @"host":@"tmi.kotaku.com",              @"id":@(1549089574)} withParentBlog:blogKotaku];
//    [self createBlog:@{@"displayName":@"Pocket Monster",    @"host":@"pocketmonster.kotaku.com",    @"id":@(1597207345)} withParentBlog:blogKotaku];
//    [self createBlog:@{@"displayName":@"The Bests",         @"host":@"thebests.kotaku.com",         @"id":@(1633980057)} withParentBlog:blogKotaku];
    
    Blog *blogLifehacker = [self createBlog:@{@"displayName":@"Lifehacker", @"host":@"lifehacker.com", @"id":@(17), @"topic" : @"Hacker"} withParentBlog:nil];
//    [self createBlog:@{@"displayName":@"Lifehacker After Hours",    @"host":@"afterhours.lifehacker.com",   @"id":@(1502188174)} withParentBlog:blogLifehacker];
//    [self createBlog:@{@"displayName":@"Two Cents",                 @"host":@"twocents.lifehacker.com",     @"id":@(1535289086)} withParentBlog:blogLifehacker];
//    [self createBlog:@{@"displayName":@"Vitals",                    @"host":@"vitals.lifehacker.com",       @"id":@(1634294947)} withParentBlog:blogLifehacker];
//    [self createBlog:@{@"displayName":@"Skillet",                   @"host":@"skillet.lifehacker.com",      @"id":@(1634384901)} withParentBlog:blogLifehacker];
//    [self createBlog:@{@"displayName":@"Workshop",                  @"host":@"workshop.lifehacker.com",     @"id":@(1613506815)} withParentBlog:blogLifehacker];
    
    BOOL success = [self saveInsertionContext];
    if(success) {
        [prefs setObject:[NSDate date] forKey:kBlogsFetchedDate];
        [prefs synchronize];
    }
}

- (Blog *)createBlog:(NSDictionary *)data withParentBlog:(Blog *)parentBlog
{
    Blog *blog = [self getBlogWithID:data[@"id"] inManagedObjectContext:self.insertionContext];
    if(blog == nil) {
        blog = (Blog *)[NSEntityDescription insertNewObjectForEntityForName:@"Blog" inManagedObjectContext:self.insertionContext];
        blog.blogDisplayName = data[@"displayName"];
        blog.blogHost = data[@"host"];
        blog.blogID = data[@"id"];
        blog.topic = [data valueForKey:@"topic" withDefault:nil];
        blog.parentBlog = parentBlog;
    }
    
    return blog;
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

- (NSArray *)getBlogsAndSubBlogsWithID:(NSNumber *)blogID
{
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(ANY parentBlog.childrenBlogs.blogID = %@) OR (ANY childrenBlogs.blogID = %@) OR (blogID = %@) OR (parentBlog.blogID = %@)", blogID, blogID, blogID, blogID];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"blogID = %@", blogID];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"blogDisplayName" ascending:YES];
    return [self doFetchRequestForEntityWithName:@"Blog" withPredicate:predicate withSortDescriptors:@[sortDescriptor] withBatchSize:nil inManagedObjectContext:self.readingContext];
}

- (NSArray *)getGMGBlogs
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"parentBlog = nil"];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"blogDisplayName" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
    return [self doFetchRequestForEntityWithName:@"Blog" withPredicate:predicate withSortDescriptors:@[sortDescriptor] withBatchSize:nil inManagedObjectContext:self.readingContext];
}

- (Post *)getPostWithID:(NSNumber *)postID inManagedObjectContext:(NSManagedObjectContext *)moc
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"postID = %@", postID];
    NSArray *result = [self doFetchRequestForEntityWithName:@"Post" withPredicate:predicate withSortDescriptors:nil withBatchSize:nil inManagedObjectContext:moc];
    
    return (0 != result.count) ? result[0] : nil;
}

- (NSArray *)getPostsForBlog:(Blog *)blog
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ANY blog = %@ AND score > 0", blog];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"score" ascending:YES];
    return [self doFetchRequestForEntityWithName:@"Post" withPredicate:predicate withSortDescriptors:@[sortDescriptor] withBatchSize:nil inManagedObjectContext:self.readingContext];
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

- (void)fetchSubBlogForBlog:(Blog *)blog
{
    [self.apiClient fetchChildrenBlogsForBlog:blog.blogID completion:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(nil != error) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kAPINetworkConnectionError object:nil];
        } else {
            NSArray *results = [self parseAndGetArrayFromData:data withResponse:response withError:error];
            NSMutableArray *blogIds = [[NSMutableArray alloc] init];
            for(NSDictionary *childBlogData in results) {
                NSNumber *childBlogID = childBlogData[@"child"];
                [blogIds addObject:childBlogID];
            }
            
            [self.apiClient fetchBlogsDetailsWithIDs:blogIds completion:^(NSData *data, NSURLResponse *response, NSError *error) {
                NSArray *results = [self parseAndGetArrayFromData:data withResponse:response withError:error];
                
                for(NSDictionary *blogData in results) {
                    Blog *subBlog = (Blog *)[NSEntityDescription insertNewObjectForEntityForName:@"Blog" inManagedObjectContext:self.insertionContext];
                    subBlog.blogDisplayName = [blogData valueForKey:@"displayName"];
                    subBlog.blogHost = [blogData valueForKey:@"canonicalHost"];
                    subBlog.blogID = [blogData valueForKey:@"id"];
                    subBlog.parentBlog = blog;
                }
                
                [self saveInsertionContext];
            }];
        }
    }];
}

- (void)fetchPostsForBlog:(Blog *)blog
{
    NSString *blogHost = blog.parentBlog == nil ? blog.blogHost : blog.parentBlog.blogHost;
    NSString *blogSection = blog.parentBlog == nil ? nil : blog.blogHost;
    [self.apiClient fetchTopPostsForBlog:blogHost withSection:blogSection withLimit:5 completion:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (nil != error) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kAPINetworkConnectionError object:nil];
        } else {
            [self resetPostScoreForBlog:blog];
            NSArray *results = [self parseAndGetArrayFromData:data withResponse:response withError:error];
            NSArray *postsIds = [self createPostsFromResults:results withBlogID:blog.blogID];
            
            [self.apiClient fetchPostsContent:postsIds completion:^(NSData *data, NSURLResponse *response, NSError *error) {
                if (nil != error) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:kAPINetworkConnectionError object:nil];
                } else {
                    NSArray *results = [self parseAndGetArrayFromData:data withResponse:response withError:error];
                    [self updatePostContent:results];
                    [[NSNotificationCenter defaultCenter] postNotificationName:kTopPostsFetched object:nil userInfo:@{@"blogID": blog.blogID}];
                }
            }];
        }
    }];
}

- (NSArray *)createPostsFromResults:(NSArray *)results withBlogID:(NSNumber *)blogID
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
            post.fetchedDate = [NSDate date];
        }
        post.score = postData[@"score"]; 
        [posts addObject:post.postID];
    }
 
    [self saveInsertionContext];
    
    return posts;
}

- (void)cleaningPosts
{
    NSDate *currentDate = [NSDate date];
    NSDate *currentMinus2Days = [NSDate addDaysToDate:currentDate withDays:-2];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"score == 0 AND fetchedDate < %@", currentMinus2Days];
    NSArray *postsToDelete = [self doFetchRequestForEntityWithName:@"Post" withPredicate:predicate withSortDescriptors:nil withBatchSize:nil inManagedObjectContext:self.insertionContext];
    
    NSLog(@"Cleaning %lu posts", (unsigned long)[postsToDelete count]);
    for(Post *post in postsToDelete) {
        [self.insertionContext deleteObject:post];
    }
    
    
    [self saveInsertionContext];
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
    
    [self saveInsertionContext];
}

- (void)resetPostScoreForBlog:(Blog *)blog
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"blog = %@", blog];
    NSArray *posts = [self doFetchRequestForEntityWithName:@"Post" withPredicate:predicate withSortDescriptors:nil withBatchSize:nil inManagedObjectContext:self.insertionContext];
    for(Post *post in posts) {
        post.score = @(0);
    }
}

- (BOOL)saveInsertionContext
{
    NSError *saveError = nil;
    return [self.insertionContext save:&saveError];
}

@end
