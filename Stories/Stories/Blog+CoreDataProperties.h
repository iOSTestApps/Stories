//
//  Blog+CoreDataProperties.h
//  Stories
//
//  Created by Alexandre THOMAS on 29/09/15.
//  Copyright © 2015 athomas. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Blog.h"

NS_ASSUME_NONNULL_BEGIN

@interface Blog (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *blogDisplayName;
@property (nullable, nonatomic, retain) NSString *blogHost;
@property (nullable, nonatomic, retain) NSNumber *blogID;
@property (nullable, nonatomic, retain) NSSet<Post *> *posts;

@end

@interface Blog (CoreDataGeneratedAccessors)

- (void)addPostsObject:(Post *)value;
- (void)removePostsObject:(Post *)value;
- (void)addPosts:(NSSet<Post *> *)values;
- (void)removePosts:(NSSet<Post *> *)values;

@end

NS_ASSUME_NONNULL_END
