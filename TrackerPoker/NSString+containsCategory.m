//
//  NSString+containsCategory.m
//  TrackerPoker
//
//  Created by Allan Davis on 1/26/12.
//  Copyright (c) 2012 CajunCode. All rights reserved.
//

#import "NSString+containsCategory.h"

@implementation NSString (containsCategory)
- (BOOL) containsString: (NSString*) substring
{    
    NSRange range = [self rangeOfString : substring];
    
    BOOL found = ( range.location != NSNotFound );
    
    return found;
}

@end
