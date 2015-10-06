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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *menuToToolBarConstraint;
@property (strong, nonatomic) NSArray *blogs;
@property (strong, nonatomic) Blog *currentBlog;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pageControlRightConstraint;
@property (weak, nonatomic) IBOutlet UIView *blogsMenuView;
@property (weak, nonatomic) IBOutlet UIButton *blackBackgroundButton;

@property (weak, nonatomic) IBOutlet UIButton *blog0Button;
@property (weak, nonatomic) IBOutlet UIButton *blog1Button;
@property (weak, nonatomic) IBOutlet UIButton *blog2Button;
@property (weak, nonatomic) IBOutlet UIButton *blog3Button;
@property (weak, nonatomic) IBOutlet UIButton *blog4Button;
@property (weak, nonatomic) IBOutlet UIButton *blog5Button;
@property (weak, nonatomic) IBOutlet UIButton *blog6Button;

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.blogsMenuView.hidden = YES;
    self.blackBackgroundButton.hidden = YES;
    
    [self initContentView];
    
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"MainViewController"];
    
    self.blogs = [[DataManager sharedInstance] getGMGBlogs];
    
    [self.pageControl addTarget:self action:@selector(pageAction) forControlEvents:UIControlEventValueChanged];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pageIndexChanged:) name:kPageIndexChange object:nil];
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

- (void)setBlogInfo:(Blog *)blog forButton:(UIButton *)button
{
    [button setTitle:[/*blog.topic != nil ? blog.topic :*/ blog.blogDisplayName uppercaseString] forState:UIControlStateNormal];
}

- (void)blogHasChanged:(Blog *)blog
{
    [self setBlogInfo:blog forButton:self.blogButton];
    [self saveBlog:blog.blogID];
    self.currentBlog = blog;
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

- (IBAction)chosenBlogButtonDidPress:(id)sender
{
    UIButton *button = (UIButton *)sender;
    [self hideMenu];
    
    Blog *selectedBlog = self.blogs[button.tag];
    [self blogHasBeenSelected:selectedBlog.blogID];
    self.pageControl.currentPage = 0;
}

- (IBAction)blogButtonDidPress:(id)sender
{
    if(self.blogsMenuView.hidden) {
        [self showMenu];
    } else {
        [self hideMenu];
    }
}

- (IBAction)backgroundButtonDidPress:(id)sender
{
    [self hideMenu];
}

- (void)showMenu
{
    [self updateBlogNamesInMenu];
    self.menuToToolBarConstraint.constant = -self.blogsMenuView.frame.size.height;
    self.blogsMenuView.hidden = NO;
    self.blackBackgroundButton.alpha = 0;
    self.blackBackgroundButton.hidden = NO;
    [self.blogsMenuView setNeedsLayout];
    [self.blogsMenuView layoutIfNeeded];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.menuToToolBarConstraint.constant = 0;
        self.blackBackgroundButton.alpha = 0.7;
        [self.blogsMenuView setNeedsLayout];
        [self.blogsMenuView layoutIfNeeded];
        self.pageControlRightConstraint.constant = -self.pageControl.frame.size.width;
        self.pageControl.alpha = 0;
        [self.pageControl setNeedsLayout];
        [self.pageControl layoutIfNeeded];
    }];
}

- (void)hideMenu
{
    [UIView animateWithDuration:0.3 animations:^{
        self.menuToToolBarConstraint.constant = -self.blogsMenuView.frame.size.height;
        [self.blogsMenuView setNeedsLayout];
        [self.blogsMenuView layoutIfNeeded];
        self.blackBackgroundButton.alpha = 0;
        self.pageControlRightConstraint.constant = 0;
        self.pageControl.alpha = 1;
        [self.pageControl setNeedsLayout];
        [self.pageControl layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.blogsMenuView.hidden = YES;
        self.blackBackgroundButton.hidden = YES;
    }];
}

- (void)updateBlogNamesInMenu
{
    NSArray *buttons = @[self.blog0Button, self.blog1Button, self.blog2Button, self.blog3Button, self.blog4Button, self.blog5Button, self.blog6Button];
    
    int buttonIndex = 0;
    int blogIndex = 0;
    for(;blogIndex < [self.blogs count]; blogIndex++) {
        Blog *blog = self.blogs[blogIndex];
        if([blog.blogID isEqualToNumber:self.currentBlog.blogID]){
            continue;
        }
        UIButton *button = buttons[buttonIndex];
        [self setBlogInfo:blog forButton:button];
        button.tag = blogIndex;
        buttonIndex++;
    }
}

- (void)pageAction
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kPageControlChange object:nil userInfo:@{@"pageIndex": [NSNumber numberWithInteger:self.pageControl.currentPage]}];
}

- (void)pageIndexChanged:(NSNotification *)notification
{
    NSInteger pageIndex = [notification.userInfo[@"pageIndex"] integerValue];
    self.pageControl.currentPage = pageIndex;
}

@end
