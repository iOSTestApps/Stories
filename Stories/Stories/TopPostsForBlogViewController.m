//
//  TopPostsForBlogViewController.m
//  Stories
//
//  Created by Alexandre Thomas on 06/10/15.
//  Copyright © 2015 athomas. All rights reserved.
//

#import "TopPostsForBlogViewController.h"
#import "UIViewController+Utilities.h"
#import "HeadlineViewController.h"
#import "Post.h"
#import "DataManager.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"

@interface TopPostsForBlogViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (strong, nonatomic) UIPageViewController *pageController;
@property (strong, nonatomic) HeadlineViewController *currentVC;
@property (strong, nonatomic) NSArray *posts;
@property (assign) NSUInteger toViewIndex;

@end

@implementation TopPostsForBlogViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.toViewIndex = 0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postDownloaded:) name:kTopPostsFetched object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkConnectionLost) name:kAPINetworkConnectionError object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pageControlChanged:) name:kPageControlChange object:nil];
    
    [self fetchPostsFromDB];
    [self initPageControl];
    [self fetchPostsFromAPI];
}

- (void)initPageControl
{
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageController.view.backgroundColor = [UIColor colorWithRed:40.0/255.0 green:40.0/255.0 blue:40.0/255.0 alpha:1];
    self.pageController.dataSource = self;
    self.pageController.delegate = self;
    [[self.pageController view] setFrame:self.view.bounds];
    
    self.currentVC = (HeadlineViewController *)[self viewControllerAtIndex:0];
    
    NSArray *viewControllers = [NSArray arrayWithObject:self.currentVC];
    
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:self.pageController];
    [self addChildViewFullView:[self.pageController view] toView:self.view];
    [self.pageController didMoveToParentViewController:self];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = viewController.view.tag;
    NSInteger maxPage = [self presentationCountForPageViewController:self.pageController];
    
    if (index == 0) {
        if(maxPage == 1)
            return nil;
        
        index = maxPage;
    }
    
    index--;
    
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = viewController.view.tag;
    NSInteger maxPage = [self presentationCountForPageViewController:self.pageController];
    index++;
    
    if (index == maxPage) {
        if(maxPage == 1)
            return nil;
        
        index = 0;
    }
    
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index
{
    return [self allocNewPostVC:index];
}

- (UIViewController *)allocNewPostVC:(NSUInteger)index
{
    HeadlineViewController *headlineViewController = [[HeadlineViewController alloc] initWithNibName:@"HeadlineViewController" bundle:nil];
    if(index < [self.posts count])
        headlineViewController.post = self.posts[index];
    headlineViewController.view.tag = index;
    return headlineViewController;
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    // The number of items reflected in the page indicator.
    return [self.posts count];
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if(completed && finished) {
        self.currentVC = (HeadlineViewController *)[pageViewController.viewControllers lastObject];
        [[NSNotificationCenter defaultCenter] postNotificationName:kPageIndexChange object:nil userInfo:@{@"pageIndex": [NSNumber numberWithInteger:self.currentVC.view.tag]}];
        
    }
}

- (void)fetchPostsFromDB
{
    self.posts = [[DataManager sharedInstance] getPostsForBlog:self.blog];
//    for(Post *post in self.posts) {
//        NSLog(@"%@ %@", post.postID, post.postHeadline);
//    }
}

- (void)fetchPostsFromAPI
{
    [[DataManager sharedInstance] fetchPostsForBlog:self.blog];
    
    // Send Google Analytics Event
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Blog"     // Event category (required)
                                                          action:@"FetchContent"  // Event action (required)
                                                           label:self.blog.blogHost          // Event label
                                                           value:nil] build]];    // Event value
}

- (void)postDownloaded:(NSNotification *)notification
{
    NSNumber *blogID = notification.userInfo[@"blogID"];
    if(![blogID isEqualToNumber:self.blog.blogID])
        return;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self fetchPostsFromDB];
        if(self.posts != nil && [self.posts count] > 0) {
            Post *firstPost = self.posts[0];
            if([self.currentVC.post.postID isEqualToNumber:firstPost.postID])
                return;
        }
        
        [self openFirstArticle];
    });
}

- (void)networkConnectionLost
{
    // Something to do at some point
}

- (void)openFirstArticle
{
    UIViewController *initialViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
    self.toViewIndex = 0;
    [[NSNotificationCenter defaultCenter] postNotificationName:kPageIndexChange object:nil userInfo:@{@"pageIndex": [NSNumber numberWithInteger:self.toViewIndex]}];
    
}

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers
{
    for(UIViewController *vc in pendingViewControllers) {
        self.toViewIndex = vc.view.tag;
    }
}

- (void)pageControlChanged:(NSNotification *)notification
{
    NSInteger pageIndex = [notification.userInfo[@"pageIndex"] integerValue];
    
    UIPageViewControllerNavigationDirection direction = pageIndex > self.toViewIndex ?
    UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse;
    UIViewController *initialViewController= [self viewControllerAtIndex:pageIndex];
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    [self.pageController setViewControllers:viewControllers direction:direction animated:YES completion:nil];
    self.toViewIndex = pageIndex;
}


@end
