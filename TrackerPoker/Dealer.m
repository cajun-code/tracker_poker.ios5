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

+ (id) initDealer{
    static Dealer * _dealer;
    if (!(_dealer)){
        _dealer = [[Dealer alloc]init];
    }
    return _dealer;
    
}



@end
