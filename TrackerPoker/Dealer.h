//
//  Dealer.h
//  TrackerPoker
//
//  Created by Allan Davis on 12/6/11.
//  Copyright (c) 2011 CajunCode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Dealer : NSObject


@property (nonatomic, strong) NSString * vote;
@property (nonatomic, strong) NSString * room;

- (void) submitVote;
- (BOOL) login:(NSString*)user WithPassword:(NSString *)password;
+ (id) sharedInstance;

@end
