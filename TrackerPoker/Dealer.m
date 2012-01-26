//
//  Dealer.m
//  TrackerPoker
//
//  Created by Allan Davis on 12/6/11.
//  Copyright (c) 2011 CajunCode. All rights reserved.
//

#import "Dealer.h"

@interface Dealer()



@end

@implementation Dealer

NSString * const TOKEN_KEY = @"TrackerPokerAuthToken";
NSString * BASE_URL = @"http://localhost:3000";
NSString * LOGIN_PATH = @"/token/fetch";
NSString * ROOM_PATH = @"/room/%@/join"; // "/room/:id/join"
NSString * STORY_PATH = @"/room/%@/active_story"; // "/room/:id/active_story"
NSString * VOTE_PATH = @"/room/%@/story/%@/vote"; // "/room/:room_id/story/:id/vote"


@synthesize vote = _vote;
@synthesize room = _room;
@synthesize story = _story;
//@synthesize token = _token;

+ (id)sharedInstance
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init]; // or some other init method
    });
    return _sharedObject;
}

- (id) init{
    if (self = [super init]) {
        RKClient* client = [RKClient clientWithBaseURL: BASE_URL];
        if(self.token)
            [client.HTTPHeaders setObject: self.token forKey:@"auth_token"];
        NSLog(@"AuthToken %@", self.token);
    }
    return self;
}

- (void) setToken:(NSString *)token{
    [[NSUserDefaults standardUserDefaults] setObject: token forKey: TOKEN_KEY];
}
-(NSString*)token{
    return [[NSUserDefaults standardUserDefaults] objectForKey: TOKEN_KEY];
}
- (void) joinRoom{
    RKClient* client = [RKClient sharedClient];
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init ];
    NSString* roomUrl = [NSString stringWithFormat:ROOM_PATH, self.room];
    NSLog(@"Room URL: %@", roomUrl);
    [params setObject: self.token forKey:@"auth_token"];
    [client get: roomUrl queryParams: params delegate:self];

}
- (void) submitVote{
//    RKClient* client = [RKClient sharedClient];
//    NSMutableDictionary * params = [[NSMutableDictionary alloc] init ];
    

}
- (void) login:(NSString*)user WithPassword:(NSString *)password{
    
    RKClient* client = [RKClient sharedClient];
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init ];
    [params setObject: user forKey:@"username"];
    [params setObject: password forKey:@"password"];
//    NSLog(@"User: %@ Password: %@", user, password);
//    NSDictionary * params =  [NSDictionary dictionaryWithObjectsAndKeys: user, @"username", password, @"password", nil];
    [client post: LOGIN_PATH params:params delegate:self];
}

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {  
    NSString * response_url = [response.URL relativeString];
    NSLog(@"Response URL:  %@", response_url);
    if([response_url containsString: LOGIN_PATH]){
        NSString * body = [response bodyAsString];
        self.token = body;
        RKClient* client = [RKClient sharedClient];
        [client.HTTPHeaders setObject: self.token forKey:@"auth_token"];
        NSLog(@"AuthToken %@", body);
    }
    if (self.room){
        NSString* roomUrl = [NSString stringWithFormat:ROOM_PATH, self.room];
        if([response_url containsString: roomUrl]){
            NSString * body = [response bodyAsString];
            NSLog(@"Joined Room %@", body);
        }
    }
    
}
// *** Not Used with ARC ***

//+ (id)allocWithZone:(NSZone *)zone
//{
//    return [[self sharedInstance] retain];
//}
//
//- (id)copyWithZone:(NSZone *)zone
//{
//    return self;
//}
//
//- (id)retain
//{
//    return self;
//}
//
//- (NSUInteger)retainCount
//{
//    return NSUIntegerMax;  //denotes an object that cannot be released
//}
//
//- (void)release
//{
//    //do nothing
//}
//
//- (id)autorelease
//{
//    return self;
//}


@end
