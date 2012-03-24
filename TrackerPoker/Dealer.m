//
//  Dealer.m
//  TrackerPoker
//
//  Created by Allan Davis on 12/6/11.
//  Copyright (c) 2011 CajunCode. All rights reserved.
//

#import "Dealer.h"

@interface Dealer()

-(void)postMessage:(NSString*)message;

@end

@implementation Dealer

NSString * const TOKEN_KEY = @"TrackerPokerAuthToken";
NSString * const EMAIL_KEY = @"TrackerPokerAuthEmail";
//NSString * BASE_URL = @"http://localhost:3000";
NSString * BASE_URL = @"http://tracker-poker.herokuapp.com";
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
- (void) setEmail:(NSString *)email{
    [[NSUserDefaults standardUserDefaults] setObject: email forKey: EMAIL_KEY];
}
-(NSString*)email{
    return [[NSUserDefaults standardUserDefaults] objectForKey: EMAIL_KEY];
}
- (void) joinRoom{
    if (self.token) {
        RKClient* client = [RKClient sharedClient];
        NSMutableDictionary * params = [[NSMutableDictionary alloc] init ];
        NSString* roomUrl = [NSString stringWithFormat:ROOM_PATH, self.room];
        NSLog(@"Room URL: %@", roomUrl);
        [params setObject: self.token forKey:@"auth_token"];
        [client get: roomUrl queryParams: params delegate:self];
    }else{
        [self postMessage:@"Log-in Required"];
    }

}
- (void) postVote{
    if (!([self.story isEqualToString:@"-1"])){
        RKClient* client = [RKClient sharedClient];
        NSMutableDictionary * params = [[NSMutableDictionary alloc] init ];
        NSString* voteUrl = [NSString stringWithFormat:VOTE_PATH, self.room, self.story];
        NSLog(@"Vote URL: %@", voteUrl);
        [params setObject: self.token forKey:@"auth_token"];
        [params setObject: self.vote forKey:@"score"];
        [client post: voteUrl params: params delegate:self];
    }else{
        [self postMessage:@"Voting is not open"];
    }

}
- (void) submitVote{
    if (self.token){ 
        if(self.room){
            RKClient* client = [RKClient sharedClient];
            NSMutableDictionary * params = [[NSMutableDictionary alloc] init ];
            NSString* storyUrl = [NSString stringWithFormat:STORY_PATH, self.room];
            NSLog(@"Story URL: %@", storyUrl);
            [params setObject: self.token forKey:@"auth_token"];
            [client get: storyUrl queryParams: params delegate:self];
        }else{
            [self postMessage:@"Joining a Room Required"];
        }
    }else{
        [self postMessage:@"Log-in Required"];
    }
    
}

- (void) login:(NSString*)user WithPassword:(NSString *)password{
    
    RKClient* client = [RKClient sharedClient];
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init ];
    [params setObject: user forKey:@"username"];
    self.email = user;
    [params setObject: password forKey:@"password"];
//    NSLog(@"User: %@ Password: %@", user, password);
//    NSDictionary * params =  [NSDictionary dictionaryWithObjectsAndKeys: user, @"username", password, @"password", nil];
    [client post: LOGIN_PATH params:params delegate:self];
}

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {  
    NSString * response_url = [response.URL relativeString];
    NSLog(@"Response URL:  %@", response_url);
    if([response_url containsString: LOGIN_PATH]){
        if(response.statusCode == 200){
            NSString * body = [response bodyAsString];
            self.token = body;
            NSString * message = [NSString stringWithFormat: @"Logged in as %@", self.email];
            [self postMessage:message];
            self.room = nil;
            self.story = nil;
        }else{
            [self postMessage:@"Log-in Failed"];
        }
    }
    // process room response
    NSString* roomUrl = [NSString stringWithFormat:ROOM_PATH, self.room];
    if([response_url containsString: roomUrl] && response.statusCode == 200){
        NSString * body = [response bodyAsString];
        NSString * message = [NSString stringWithFormat: @"Joining Room %@ was a %@", self.room, body];
        [self postMessage:message];
        
    }
    // Process get story submit
    NSString* storyUrl = [NSString stringWithFormat:STORY_PATH, self.room];
    if([response_url containsString: storyUrl] && response.statusCode == 200){
        NSString * body = [response bodyAsString];
        self.story = body;
        NSString * message = [NSString stringWithFormat: @"Posting vote to story %@", self.story];
        [self postMessage:message];
        [self postVote];
        
    }
    NSString* voteUrl = [NSString stringWithFormat:VOTE_PATH, self.room, self.story];
    if ([response_url containsString:voteUrl] && response.statusCode == 200) {
        NSString * body = [response bodyAsString];
        NSString * message = [NSString stringWithFormat: @"Vote %@ to story %@ was a %@",self.vote, self.story, body];
        [self postMessage:message];
        
    }
}

-(void)postMessage:(NSString*)message{
    NSLog(@"%@",message);
    NSDictionary* params = [NSDictionary dictionaryWithObject:message
                                                       forKey:@"message"];
    
    NSNotification *note = [NSNotification notificationWithName:@"TrackerPokerMessage"
                                                         object:self
                                                       userInfo:params];
    [[NSNotificationCenter defaultCenter] postNotification:note];
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
