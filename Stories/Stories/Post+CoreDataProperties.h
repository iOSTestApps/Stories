//
//  Post+CoreDataProperties.h
//  Stories
//
//  Created by Alexandre Thomas on 07/10/15.
//  Copyright © 2015 athomas. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Post.h"

@class Blog, Image, DetailPost;

NS_ASSUME_NONNULL_BEGIN

@interface Post (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *authorName;
@property (nullable, nonatomic, retain) NSString *permalink;
@property (nullable, nonatomic, retain) NSString *postHeadline;
@property (nullable, nonatomic, retain) NSNumber *postID;
@property (nullable, nonatomic, retain) NSDate *publishTime;
@property (nullable, nonatomic, retain) NSNumber *score;
@property (nullable, nonatomic, retain) NSDate *fetchedDate;
@property (nullable, nonatomic, retain) Blog *blog;
@property (nullable, nonatomic, retain) Image *image;
@property (nullable, nonatomic, retain) DetailPost *detailPost;

@end

NS_ASSUME_NONNULL_END
