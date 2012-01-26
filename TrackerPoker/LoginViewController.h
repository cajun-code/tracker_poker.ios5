//
//  LoginViewController.h
//  TrackerPoker
//
//  Created by Allan Davis on 12/6/11.
//  Copyright (c) 2011 CajunCode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Dealer.h"

@interface LoginViewController : UIViewController
- (IBAction)processLogin:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *password;

@end
