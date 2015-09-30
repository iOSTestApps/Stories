//
//  Image+CoreDataProperties.h
//  Stories
//
//  Created by Alexandre THOMAS on 29/09/15.
//  Copyright © 2015 athomas. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Image.h"

@class Post;

NS_ASSUME_NONNULL_BEGIN

@interface Image (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *imageURL;
@property (nullable, nonatomic, retain) NSString *imageID;
@property (nullable, nonatomic, retain) NSNumber *downloaded;
@property (nullable, nonatomic, retain) Post *post;

@end

NS_ASSUME_NONNULL_END
