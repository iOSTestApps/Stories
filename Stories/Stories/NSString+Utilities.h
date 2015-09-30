//
//  UIViewController+Utilities.h
//  Stories
//
//  Created by Alexandre THOMAS on 29/09/15.
//  Copyright © 2015 athomas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Utilities)

- (NSString *)util_unescapeXML;
- (NSString *)cleanHtmlTags;

@end
