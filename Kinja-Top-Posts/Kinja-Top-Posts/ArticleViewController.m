//
//  ArticleViewController.m
//  Kinja Top Posts
//
//  Created by Alexandre THOMAS on 28/09/15.
//  Copyright © 2015 athomas. All rights reserved.
//

#import "ArticleViewController.h"
#import "ARSafariActivity.h"

@interface ArticleViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation ArticleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSString *display = [[[self.post.display stringByReplacingOccurrencesOfString:@"width=" withString:@"width=\"100%\" dummyWidth="]
                                            stringByReplacingOccurrencesOfString:@"height=" withString:@"dummyHeight="]
                                            stringByReplacingOccurrencesOfString:@"<iframe src=\"http://gawker-labs.com" withString:@"<iframe style=\"visibility: hidden;height:0;\" src=\"http://gawker-labs.com"];
    
    NSString *cssStyle = @"<style type=\"text/css\">body {padding-top:15px;font-family: Caecilia; color:#2C3037;padding-right: 10px;padding-left: 10px;line-height: 160%%;font-size: 120%%;background-color:#F8F9FA;} \
                    h1{font-family: SF UI Display;line-height: 120%%;font-size: 175%%;} \
                    h2{font-family: SF UI Display;line-height: 115%%;font-size: 130%%;} \
                    h3{font-family: SF UI Display;line-height: 110%%;font-size: 90%%;} \
                    h4{font-family: SF UI Display;line-height: 100%%;font-size: 80%%;} \
                    a:link{ color: #35509A; text-decoration: none; } \
                    a:visited{ color: #35509A; } \
                    a:hover{ color: #35509A; } \
                    a:active { color: #35509A; } \
                    blockquote {background: #f9f9f9;border-left: 10px solid #ccc;margin: 1.5em 5px;padding: 0.5em 10px; font-size: 90%;} \
                    blockquote p { display: inline;} \
        </style>";
    NSString *html = [NSString stringWithFormat:@"<html>%@<body><h1>%@</h1><h3>%@ • %@</h3>%@<body></html>", cssStyle, self.post.postHeadline, self.post.authorName, [self getDateAsEnglish], display];
    
    [self.webView loadHTMLString:html baseURL:nil];
}


- (NSString *)getDateAsEnglish
{
    int seconds = [[NSDate date] timeIntervalSinceDate:self.post.publishTime];
    int forHours = seconds / 3600;
    int remainder = seconds % 3600;
    int forMinutes = remainder / 60;
    //int forSeconds = remainder % 60;
    
    //NSLog(@"%d %d %d %d %d", seconds, forHours, remainder, forMinutes, forSeconds);
    
    NSString *ago;
    if(forHours > 1)
        ago = [NSString stringWithFormat:@"%d hours ago", forHours];
    else if(forHours == 1)
        ago = [NSString stringWithFormat:@"%d hour ago", forHours];
    else if(forMinutes > 1)
        ago = [NSString stringWithFormat:@"%d minutes ago", forMinutes];
    else if(forMinutes == 1)
        ago = [NSString stringWithFormat:@"%d minute ago", forMinutes];
    
    return ago;
}


- (BOOL)prefersStatusBarHidden
{
    return YES;
}
- (IBAction)closeDidPress:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)shareDidPress:(id)sender
{
    NSURL *urlPermalink = [NSURL URLWithString:self.post.permalink];
    
    NSArray *objectsToShare = @[urlPermalink];
    
    ARSafariActivity *safariActivity = [[ARSafariActivity alloc] init];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:@[safariActivity]];
    
    [activityVC setValue:@"PETER SAGAN WINS CYCLING WORLD CHAMPIONSHIP WITH LATE ATTACK" forKey:@"subject"];

    
    [self presentViewController:activityVC animated:YES completion:nil];
}

#pragma mark - webview delegate

-(BOOL) webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType
{
    if ( inType == UIWebViewNavigationTypeLinkClicked ) {
        [[UIApplication sharedApplication] openURL:[inRequest URL]];
        return NO;
    }
    
    return YES;
}

@end
