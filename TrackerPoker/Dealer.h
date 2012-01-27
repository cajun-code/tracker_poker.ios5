//
//  Dealer.h
//  TrackerPoker
//
//  Created by Allan Davis on 12/6/11.
//  Copyright (c) 2011 CajunCode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import "NSString+containsCategory.h"

@interface Dealer : NSObject <RKRequestDelegate>

@property (nonatomic, strong) NSString * token;
@property (nonatomic, strong) NSString * email;
@property (nonatomic, strong) NSString * vote;
@property (nonatomic, strong) NSString * room;
@property (nonatomic, strong) NSString * story;

- (void) submitVote;
- (void) login:(NSString*)user WithPassword:(NSString *)password;
- (void) joinRoom;
+ (id) sharedInstance;

@end
