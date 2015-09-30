//
//  UIViewController+Utilities.m
//  Stories
//
//  Created by Alexandre THOMAS on 29/09/15.
//  Copyright © 2015 athomas. All rights reserved.d.
//

#import "UIViewController+Utilities.h"

@implementation UIViewController (Utilities)

- (void)addChildViewFullView:(UIView *)childView toView:(UIView *)view
{
    [view addSubview:childView];
    childView.translatesAutoresizingMaskIntoConstraints = NO;
    
     [view addConstraint:[NSLayoutConstraint constraintWithItem:childView
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:view
                                                              attribute:NSLayoutAttributeTop
                                                             multiplier:1.0
                                                               constant:0.0]];
    
    
    [view addConstraint:[NSLayoutConstraint constraintWithItem:childView
                                                          attribute:NSLayoutAttributeLeading
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:view
                                                          attribute:NSLayoutAttributeLeading
                                                         multiplier:1.0
                                                           constant:0.0]];
    
    [view addConstraint:[NSLayoutConstraint constraintWithItem:childView
                                                          attribute:NSLayoutAttributeTrailing
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:view
                                                          attribute:NSLayoutAttributeTrailing
                                                         multiplier:1.0
                                                           constant:0.0]];
    
    [view addConstraint:[NSLayoutConstraint constraintWithItem:childView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0.0]];
}

@end
