//
//  MainViewController.m
//  Stories
//
//  Created by Alexandre Thomas on 06/10/15.
//  Copyright © 2015 athomas. All rights reserved.
//

#import "MainViewController.h"
#import "BlogFamilyViewController.h"
#import "UIViewController+Utilities.h"
#import "DataManager.h"
#import "ChoseBlogViewController.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"

#define kCurrentMainBlog @"kCurrentMainBlog"

@interface MainViewController () <BlogFamilyViewControllerDelegate, ChoseBlogViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *blogButton;
@property (strong, nonatomic) BlogFamilyViewController *blogFamilyVC;

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initContentView];
    
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"MainViewController"];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)initContentView
{
    self.blogFamilyVC = [[BlogFamilyViewController alloc] initWithNibName:@"BlogFamilyViewController" bundle:nil];
    self.blogFamilyVC.delegate = self;
    [self addChildViewController:self.blogFamilyVC];
    [self addChildViewFullView:[self.blogFamilyVC view] toView:self.contentView];
    [self.blogFamilyVC didMoveToParentViewController:self];
}

-(void)blogHasChanged:(Blog *)blog
{
    [self.blogButton setTitle:[blog.blogDisplayName uppercaseString] forState:UIControlStateNormal];
    [self saveBlog:blog.blogID];
}

-(void)blogHasBeenSelected:(NSNumber *)blogID
{
    NSNumber *currentBlogID = [[NSUserDefaults standardUserDefaults] objectForKey:kCurrentBlog];
    if(currentBlogID != nil && [blogID isEqualToNumber:currentBlogID]) // we selected the same, do nothing
        return;
    
    [self saveBlog:blogID];
    [self.blogFamilyVC loadBlogs];
}

- (void)saveBlog:(NSNumber *)blogID
{
    [[NSUserDefaults standardUserDefaults] setObject:blogID forKey:kCurrentBlog];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"showBlogList"]) {
        ChoseBlogViewController *vc = (ChoseBlogViewController *)segue.destinationViewController;
        vc.delegate = self;
    }
}


@end
