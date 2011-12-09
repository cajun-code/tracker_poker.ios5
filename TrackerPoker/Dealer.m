//
//  Dealer.m
//  TrackerPoker
//
//  Created by Allan Davis on 12/6/11.
//  Copyright (c) 2011 CajunCode. All rights reserved.
//

#import "Dealer.h"

@interface Dealer()

@property (nonatomic, strong) NSString * token;

@end

@implementation Dealer


@synthesize vote = _vote;
@synthesize room = _room;
@synthesize token = _token;

+ (id)sharedInstance
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init]; // or some other init method
    });
    return _sharedObject;
}

- (void) submitVote{
    
}
- (BOOL) login:(NSString*)user WithPassword:(NSString *)password{
    return NO;
}


@end
