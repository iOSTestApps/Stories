//
//  Post+CoreDataProperties.h
//  Kinja Top Posts
//
//  Created by Alexandre THOMAS on 29/09/15.
//  Copyright © 2015 athomas. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@class Blog, Image;

@interface Post (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *authorName;
@property (nullable, nonatomic, retain) NSString *display;
@property (nullable, nonatomic, retain) NSString *postHeadline;
@property (nullable, nonatomic, retain) NSNumber *postID;
@property (nullable, nonatomic, retain) NSDate *publishTime;
@property (nullable, nonatomic, retain) NSNumber *score;
@property (nullable, nonatomic, retain) NSString *permalink;
@property (nullable, nonatomic, retain) Blog *blog;
@property (nullable, nonatomic, retain) Image *image;

@end

NS_ASSUME_NONNULL_END
