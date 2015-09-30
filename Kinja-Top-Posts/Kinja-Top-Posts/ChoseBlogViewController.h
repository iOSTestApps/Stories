//
//  ChoseBlogViewController.h
//  Kinja Top Posts
//
//  Created by Alexandre THOMAS on 28/09/15.
//  Copyright © 2015 athomas. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ChoseBlogViewControllerDelegate <NSObject>

- (void)blogHasBeenSelected:(NSNumber *)blogID;

@end

@interface ChoseBlogViewController : UIViewController

@property (nonatomic, weak) id<ChoseBlogViewControllerDelegate> delegate;

@end


