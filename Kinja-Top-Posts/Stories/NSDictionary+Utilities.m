//
//  UIViewController+Utilities.h
//  Stories
//
//  Created by Alexandre THOMAS on 29/09/15.
//  Copyright © 2015 athomas. All rights reserved.
//

#import "NSDictionary+Utilities.h"

@implementation NSDictionary (Utilities)

- (id)valueForKey:(NSString *)key withDefault:(id)defaultValue
{
    id value = [self valueForKey:key];

    if (nil != value && value != [NSNull null]) {
        return value;
    }
    
    return defaultValue;
}

- (BOOL)valueExistsForKey:(NSString *)key
{
    return nil != [self valueForKey:key withDefault:nil];
}

@end