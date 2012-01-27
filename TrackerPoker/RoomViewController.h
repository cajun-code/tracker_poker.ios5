//
//  RoomViewController.h
//  TrackerPoker
//
//  Created by Allan Davis on 12/6/11.
//  Copyright (c) 2011 CajunCode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Dealer.h"
#import "ZBarSDK.h"

@interface RoomViewController : UIViewController
    < ZBarReaderDelegate >
@property (weak, nonatomic) IBOutlet UITextField *room;
- (IBAction)joinRoom:(UIButton *)sender;
- (IBAction)scanCode:(UIButton *)sender;
- (IBAction)cancelRoom:(UIButton *)sender;

@end
