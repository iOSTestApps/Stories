//
//  BlogFamilyViewController.m
//  Stories
//
//  Created by Alexandre Thomas on 06/10/15.
//  Copyright © 2015 athomas. All rights reserved.
//

#import "BlogFamilyViewController.h"
#import "UIViewController+Utilities.h"
#import "Blog.h"
#import "DataManager.h"

@interface BlogFamilyViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (strong, nonatomic) UIPageViewController *pageController;
@property (strong, nonatomic) TopPostsForBlogViewController *currentVC;
@property (strong, nonatomic) NSArray *blogs;
@property (assign) NSUInteger currentIndex;

@end

@implementation BlogFamilyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadBlogs];
    [self initPageControl];
}

- (void)initPageControl
{
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationVertical options:nil];
    self.pageController.view.backgroundColor = [UIColor colorWithRed:40.0/255.0 green:40.0/255.0 blue:40.0/255.0 alpha:1];
    self.pageController.dataSource = self;
    self.pageController.delegate = self;
    [[self.pageController view] setFrame:self.view.bounds];
    
    self.currentVC = (TopPostsForBlogViewController *)[self viewControllerAtIndex:self.currentIndex];
    
    NSArray *viewControllers = [NSArray arrayWithObject:self.currentVC];
    
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:self.pageController];
    [self addChildViewFullView:[self.pageController view] toView:self.view];
    [self.pageController didMoveToParentViewController:self];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = viewController.view.tag;
    NSInteger maxBlogs = [self presentationCountForPageViewController:self.pageController];
    
    if (index == 0) {
        if(maxBlogs == 1)
            return nil;
        
        index = [self presentationCountForPageViewController:pageViewController];
    }
    
    index--;
    
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = viewController.view.tag;
    NSInteger maxBlogs = [self presentationCountForPageViewController:self.pageController];
    index++;
    
    if (index == maxBlogs) {
        if(maxBlogs == 1)
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
    TopPostsForBlogViewController *topPostsForBlogViewController = [[TopPostsForBlogViewController alloc] initWithNibName:@"TopPostsForBlogViewController" bundle:nil];
    if(index < [self.blogs count])
        topPostsForBlogViewController.blog = self.blogs[index];
    topPostsForBlogViewController.view.tag = index;
    return topPostsForBlogViewController;
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.blogs count];
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if(completed && finished) {
        self.currentVC = (TopPostsForBlogViewController *)[pageViewController.viewControllers lastObject];
        self.currentIndex = (long)self.currentVC.view.tag;
        if(self.delegate && [self.delegate respondsToSelector:@selector(blogHasChanged:)]) {
            [self.delegate blogHasChanged:self.blogs[self.currentIndex]];
        }
    }
}

- (void)loadBlogs
{
    NSNumber *blogID = [[NSUserDefaults standardUserDefaults] objectForKey:kCurrentBlog];
    if(blogID == nil)
        blogID = @(4); // Default blog is going to be gizmodo
    
    self.blogs = [[DataManager sharedInstance] getBlogsAndSubBlogsWithID:blogID];
    for(Blog *b in self.blogs) {
        NSLog(@"%@ %@ %@", b.blogDisplayName, b.blogHost, b.blogID);
    }
    
    for(int i = 0; i < [self.blogs count]; i++) {
        Blog *blog = self.blogs[i];
        if([blogID isEqualToNumber:blog.blogID]) {
            if(self.delegate && [self.delegate respondsToSelector:@selector(blogHasChanged:)]) {
                self.currentIndex = i;
                [self.delegate blogHasChanged:blog];
                [self openFamily:blog];
            }
            break;
        }
    }
}

- (void)openFamily:(Blog *)blog
{
    if(self.pageController == nil)
        return;
    
    UIViewController *initialViewController = [self viewControllerAtIndex:self.currentIndex];
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
}


@end
