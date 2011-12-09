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
    
    [self performSegueWithIdentifier: @"card" sender:self ];
    
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
