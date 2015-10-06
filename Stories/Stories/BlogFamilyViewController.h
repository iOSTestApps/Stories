//
//  BlogFamilyViewController.h
//  Stories
//
//  Created by Alexandre Thomas on 06/10/15.
//  Copyright © 2015 athomas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Blog.h"
#import "TopPostsForBlogViewController.h"

#define kCurrentBlog @"kCurrentBlog"

@protocol BlogFamilyViewControllerDelegate;

@interface BlogFamilyViewController : UIViewController

@property (nonatomic, weak) id<BlogFamilyViewControllerDelegate> delegate;

- (void)loadBlogs;

@end

@protocol BlogFamilyViewControllerDelegate <NSObject>

- (void)blogHasChanged:(Blog *)blog;

@end
