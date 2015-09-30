//
//  HeadlineViewController.h
//  Kinja Top Posts
//
//  Created by Alexandre THOMAS on 28/09/15.
//  Copyright © 2015 athomas. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Post;

@protocol HeadlineViewControllerDelegate;

@interface HeadlineViewController : UIViewController

@property (strong, nonatomic) Post *post;
@property (nonatomic, weak) id<HeadlineViewControllerDelegate> delegate;

@end

@protocol HeadlineViewControllerDelegate <NSObject>


- (void)articleHasBeenSelected:(HeadlineViewController *)controller;

@end
