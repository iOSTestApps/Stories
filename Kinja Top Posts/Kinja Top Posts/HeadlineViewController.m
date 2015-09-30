//
//  HeadlineViewController.m
//  Kinja Top Posts
//
//  Created by Alexandre THOMAS on 28/09/15.
//  Copyright © 2015 athomas. All rights reserved.
//

#import "HeadlineViewController.h"
#import "Post.h"
#import "Image.h"
#import "NSString+Utilities.h"
#import "DataManager.h"

@interface HeadlineViewController ()<NSURLSessionDataDelegate, NSURLSessionDelegate, NSURLSessionTaskDelegate>
@property (weak, nonatomic) IBOutlet UIView *blackBgView;
@property (weak, nonatomic) IBOutlet UILabel *headlineLabel;
@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;

@property (nonatomic, retain) NSMutableData *dataToDownload;
@property (nonatomic) float downloadSize;



@end

@implementation HeadlineViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addGeastureREcognizer:self.headlineLabel];
    [self addGeastureREcognizer:self.blackBgView];
    [self addGeastureREcognizer:self.mainImageView];
    
    NSString *headline = [[self.post.postHeadline util_unescapeXML] cleanHtmlTags];
    if(headline != nil)
        self.headlineLabel.text = headline;
    
    [self loadImage];
}

- (void)addGeastureREcognizer:(UIView *)view
{
    // Gesture to handle double tap on the image. Used for zoom in/out
    UITapGestureRecognizer *tapToShow = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToShow:)];
    tapToShow.numberOfTapsRequired = 1;
    [view addGestureRecognizer:tapToShow];
}

- (void)tapToShow:(UITapGestureRecognizer *)tap
{
    if(tap.numberOfTapsRequired > 1)
        return;
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(articleHasBeenSelected:)]) {
        [self.delegate articleHasBeenSelected:self];
    }    
}

- (void)imageHasBeenLoaded:(NSData *)imageData
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIImage *uiImage = uiImage = [[UIImage alloc] initWithData:imageData];
        self.mainImageView.image = uiImage;
    });
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    completionHandler(NSURLSessionResponseAllow);
    
    self.progressBar.progress = 0.0f;
    self.downloadSize = [response expectedContentLength];
    self.dataToDownload = [[NSMutableData alloc]init];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    [self.dataToDownload appendData:data];
    self.progressBar.progress = [self.dataToDownload length] / self.downloadSize;
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    self.progressBar.hidden = YES;
    if (self.dataToDownload != nil && [self.dataToDownload length] > 0) {
        [self imageHasBeenLoaded:self.dataToDownload];
        NSError *writeToFileError;
        [self.dataToDownload writeToFile:[self getImageFilePath] options:NSDataWritingFileProtectionNone error:&writeToFileError];
    } else {
        NSLog(@"%@", [NSString stringWithFormat:@"Issue Downloading image %@: %@", error, self.post.image.imageID]);
    }
}

- (void)loadImage
{
    if(![self loadImageFromCache]) {
        
        self.progressBar.hidden = NO;
        self.progressBar.progress = 0.0f;
        NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfigObject delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        
        NSString *imageURL = [NSString stringWithFormat:@"https://i.kinja-img.com/gawker-media/image/upload/%@.jpg", self.post.image.imageID];
        NSURL *url = [NSURL URLWithString: imageURL];

        NSURLSessionDataTask *dataTask = [defaultSession dataTaskWithURL: url];
        
        [dataTask resume];
    }
}

- (BOOL)loadImageFromCache
{
    NSString *filePath = [self getImageFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        NSData *imageData = [[NSFileManager defaultManager] contentsAtPath:filePath];
        [self imageHasBeenLoaded:imageData];
        return YES;
    }
    
    return NO;
}

- (NSString *)getImageFilePath
{
    NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", self.post.image.imageID]];
    return filePath;
}

@end
