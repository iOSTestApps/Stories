//
//  TopPostsForBlogViewController.h
//  Stories
//
//  Created by Alexandre Thomas on 06/10/15.
//  Copyright © 2015 athomas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Blog.h"

#define kPageControlChange @"kPageControlChange"
#define kPageIndexChange @"kPageIndexChange"
#define kPagePostNumber @"kPagePostNumber"

@interface TopPostsForBlogViewController : UIViewController

@property (strong, nonatomic) Blog *blog;

@end
