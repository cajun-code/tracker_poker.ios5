//
//  TrackerPokerViewController.m
//  TrackerPoker
//
//  Created by Allan Davis on 12/5/11.
//  Copyright (c) 2011 CajunCode. All rights reserved.
//

#import "TrackerPokerViewController.h"


@interface TrackerPokerViewController()
@property (readonly) Dealer * dealer;
@end

@implementation TrackerPokerViewController

@synthesize vote;

- (Dealer *) dealer{
    return [Dealer sharedInstance];
}

- (IBAction)votePressed:(UIButton *)sender {
    self.vote.text = sender.currentTitle;
    self.dealer.vote = self.vote.text;
    [self.dealer submitVote];
    
    // *** IOS 5 Change View with Segue ***
    [self performSegueWithIdentifier: @"card" sender:self ];
    
    // *** IOS <= 4 Change View with xib
//    UIViewController* cardViewController = [[UIViewController alloc] initWithNibName:@"card" bundle:[NSBundle mainBundle]];
//    [self.view addSubview:cardViewController.view];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self
           selector:@selector(showMessage:)
               name:@"TrackerPokerMessage"
             object:nil];
    self.vote.text = [NSString stringWithFormat: @"Logged in as %@", self.dealer.email];
}
-(void)showMessage: (NSNotification *)note{
//    id poster = [note object];
//    NSString *name = [note name];
    NSDictionary * extraInformation = [note userInfo];
    self.vote.text = [extraInformation objectForKey:@"message"];
}

- (void)viewDidUnload
{
    [self setVote:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
