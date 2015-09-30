//
//  UIViewController+Utilities.h
//  Kinja Top Posts
//
//  Created by Alexandre THOMAS on 29/09/15.
//  Copyright © 2015 athomas. All rights reserved.
//
@import UIKit;
#import "NSString+Utilities.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Utilities)

- (NSString *)util_unescapeXML {
    return [[[[[[[[self stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"]
                  stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""]
                 stringByReplacingOccurrencesOfString:@"&#27;" withString:@"'"]
                stringByReplacingOccurrencesOfString:@"&#39;" withString:@"'"]
               stringByReplacingOccurrencesOfString:@"&#92;" withString:@"'"]
              stringByReplacingOccurrencesOfString:@"&#96;" withString:@"'"]
             stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"]
            stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
}


- (NSString *)cleanHtmlTags
{
    return [[[[[[self stringByReplacingOccurrencesOfString:@"<i>" withString:@""]
            stringByReplacingOccurrencesOfString:@"</i>" withString:@""]
            stringByReplacingOccurrencesOfString:@"<b>" withString:@""]
            stringByReplacingOccurrencesOfString:@"</b>" withString:@""]
            stringByReplacingOccurrencesOfString:@"<em>" withString:@""]
            stringByReplacingOccurrencesOfString:@"</em>" withString:@""];
    
}


@end
