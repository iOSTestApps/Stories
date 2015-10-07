//
//  DetailPost+CoreDataProperties.h
//  Stories
//
//  Created by Alexandre Thomas on 07/10/15.
//  Copyright © 2015 athomas. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "DetailPost.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailPost (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *display;
@property (nullable, nonatomic, retain) Post *post;

@end

NS_ASSUME_NONNULL_END
