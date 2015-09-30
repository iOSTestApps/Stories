//
//  UIViewController+Utilities.h
//  Kinja Top Posts
//
//  Created by Alexandre THOMAS on 29/09/15.
//  Copyright © 2015 athomas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Utilities)

// Return the value for the key or the default value if cannot be found in the dictionary.
- (id)valueForKey:(NSString *)key withDefault:(id)defaultValue;

// Returns true of he key exists in the dictrionary.
- (BOOL)valueExistsForKey:(NSString *)key;

@end