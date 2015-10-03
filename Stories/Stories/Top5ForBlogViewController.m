//
//  Top5ForBlogViewController.m
//  Stories
//
//  Created by Alexandre THOMAS on 28/09/15.
//  Copyright © 2015 athomas. All rights reserved.
//

#import "Top5ForBlogViewController.h"
#import "ChoseBlogViewController.h"
#import "HeadlineViewController.h"
#import "UIViewController+Utilities.h"
#import "ArticleViewController.h"
#import "DataManager.h"

#define kCurrentBlog @"kCurrentBlog"\

@interface Top5ForBlogViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate, ChoseBlogViewControllerDelegate, HeadlineViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIButton *blogNameButton;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) UIPageViewController *pageController;
@property (assign) NSUInteger toViewIndex;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) Blog *blog;
@property (strong, nonatomic) HeadlineViewController *currentVC;
@property (strong, nonatomic) NSDate *lastFetchDate;

@end

@implementation Top5ForBlogViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
 
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postDownloaded:) name:kTopPostsFetched object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkConnectionLost) name:kAPINetworkConnectionError object:nil];
    
    [self loadBlog];
    self.fetchedResultsController = [self getFetchedResultsController];
    [self fetchFromDB];
    [self updateBlogButton];
    [self initPageControl];
    [self fetchFromAPI:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self fetchFromAPI:NO];
}

- (void)initPageControl
{
    self.toViewIndex = 0;
    
    [self.pageControl addTarget:self action:@selector(pageAction) forControlEvents:UIControlEventValueChanged];
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageController.view.backgroundColor = [UIColor colorWithRed:40.0/255.0 green:40.0/255.0 blue:40.0/255.0 alpha:1];
    self.pageController.dataSource = self;
    self.pageController.delegate = self;
    [[self.pageController view] setFrame:self.contentView.bounds];
    
    self.currentVC = (HeadlineViewController *)[self viewControllerAtIndex:0];
    
    NSArray *viewControllers = [NSArray arrayWithObject:self.currentVC];
    
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:self.pageController];
    [self addChildViewFullView:[self.pageController view] toView:self.contentView];
    [self.pageController didMoveToParentViewController:self];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = viewController.view.tag;
    
    if (index == 0) {
        return nil;
    }
    
    index--;
    
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = viewController.view.tag;
    
    index++;
    
    if (index == [self presentationCountForPageViewController:self.pageController]) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index
{
    return [self allocNewPostVC:index];
}

- (UIViewController *)allocNewPostVC:(NSUInteger)index
{
    NSArray *objects = [[self fetchedResultsController] fetchedObjects];
    HeadlineViewController *headlineViewController = [[HeadlineViewController alloc] initWithNibName:@"HeadlineViewController" bundle:nil];
    headlineViewController.post = index < [objects count] ? objects[index] : nil;
    headlineViewController.view.tag = index;
    headlineViewController.delegate = self;
    return headlineViewController;
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    // The number of items reflected in the page indicator.
    return 5;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if(completed && finished) {
        self.currentVC = (HeadlineViewController *)[pageViewController.viewControllers lastObject];
        [self.pageControl setCurrentPage:self.currentVC.view.tag];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"showBlogList"]) {
        ChoseBlogViewController *vc = (ChoseBlogViewController *)segue.destinationViewController;
        vc.delegate = self;
    } else if([segue.identifier isEqualToString:@"showArticle"]) {
        ArticleViewController *vc = (ArticleViewController *)segue.destinationViewController;
        NSArray *objects = [[self fetchedResultsController] fetchedObjects];
        vc.post = self.pageControl.currentPage < [objects count] ? objects[self.pageControl.currentPage] : nil;
    }
}

- (void)blogHasBeenSelected:(NSNumber *)blogID
{
    NSNumber *currentBlogID = [[NSUserDefaults standardUserDefaults] objectForKey:kCurrentBlog];
    if(currentBlogID != nil && [blogID isEqualToNumber:currentBlogID]) // we selected the same, do nothing
        return;
    
    [self saveBlog:blogID];
    
    [self loadBlog];
    self.fetchedResultsController = [self getFetchedResultsController];
    [self fetchFromDB];
    [self updateBlogButton];
    [self fetchFromAPI:YES];
}

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers
{
    for(UIViewController *vc in pendingViewControllers) {
        self.toViewIndex = vc.view.tag;
    }
}

- (void)pageAction
{
    UIPageViewControllerNavigationDirection direction = self.pageControl.currentPage > self.toViewIndex ?
                        UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse;
    UIViewController *initialViewController= [self viewControllerAtIndex:self.pageControl.currentPage];
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    [self.pageController setViewControllers:viewControllers direction:direction animated:YES completion:nil];
    self.toViewIndex = self.pageControl.currentPage;
}

- (void)articleHasBeenSelected:(HeadlineViewController *)controller
{
    [self performSegueWithIdentifier:@"showArticle" sender:nil];
}

- (NSFetchedResultsController *)getFetchedResultsController
{
    DataManager *dataManager = [DataManager sharedInstance];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Post" inManagedObjectContext:dataManager.readingContext];
    fetchRequest.entity = entity;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ANY blog = %@ AND score > 0", self.blog];
    fetchRequest.predicate = predicate;
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"score" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSString *cacheName = [NSString stringWithFormat:@"mem.athomas.%@", self.blog.blogID];
    NSFetchedResultsController *controller = [[NSFetchedResultsController alloc]
                                              initWithFetchRequest:fetchRequest
                                              managedObjectContext:dataManager.readingContext
                                              sectionNameKeyPath:nil
                                              cacheName:cacheName];
    
    return controller;
}

- (void)fetchFromDB
{
    NSError *error = nil;
    [[self fetchedResultsController] performFetch:&error];
}

- (void)fetchFromAPI:(BOOL)force
{
    if(!force) {
        NSDate *currentDate = [NSDate date];
        NSTimeInterval interval = [currentDate timeIntervalSinceDate:self.lastFetchDate];
        int numberOFMInutes =  interval / 60;
        if(numberOFMInutes < 10) // fetch more thatn 10 minutes ago, dont refresh
            return;
    }
    
    [[DataManager sharedInstance] fetchPostsForBlog:self.blog];
    self.lastFetchDate = [NSDate date];
}

- (void)postDownloaded:(NSNotification *)notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self fetchFromDB];
        NSArray *objects = [[self fetchedResultsController] fetchedObjects];
        if(objects != nil && [objects count] > 0) {
            Post *firstPost = objects[0];
            if([self.currentVC.post.postID isEqual:firstPost.postID])
                return;
        }
        
        UIViewController *initialViewController = [self viewControllerAtIndex:0];
        NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
        [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
        self.toViewIndex = 0;
        self.pageControl.currentPage = 0;
        
    });
}

- (void)networkConnectionLost
{
    // Something to do at some point
}

- (void)saveBlog:(NSNumber *)blogID
{
    [[NSUserDefaults standardUserDefaults] setObject:blogID forKey:kCurrentBlog];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)loadBlog
{
    NSNumber *blogID = [[NSUserDefaults standardUserDefaults] objectForKey:kCurrentBlog];
    if(blogID == nil)
        blogID = @(4); // Default blog is going to be gizmodo
    
    self.blog = [[DataManager sharedInstance] getBlogWithID:blogID];
}

- (void)updateBlogButton
{
    [self.blogNameButton setTitle:[self.blog.blogDisplayName uppercaseString] forState:UIControlStateNormal];
}

@end
