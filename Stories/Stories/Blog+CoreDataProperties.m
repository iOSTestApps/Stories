//
//  Blog+CoreDataProperties.m
//  Stories
//
//  Created by Alexandre Thomas on 06/10/15.
//  Copyright © 2015 athomas. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Blog+CoreDataProperties.h"

@implementation Blog (CoreDataProperties)

@dynamic blogDisplayName;
@dynamic blogHost;
@dynamic blogID;
@dynamic posts;
@dynamic childrenBlogs;
@dynamic parentBlog;

@end
