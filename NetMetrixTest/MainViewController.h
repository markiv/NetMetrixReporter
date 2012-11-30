//
//  MainViewController.h
//  NetMetrixTest
//
//  Created by Vikram Kriplaney on 28.11.2012.
//  Copyright (c) 2012 iPhonso GmbH. All rights reserved.
//

#import "FlipsideViewController.h"

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate, UIPopoverControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextView *log;
@property (weak, nonatomic) IBOutlet UIButton *mango;
@property (strong, nonatomic) UIPopoverController *flipsidePopoverController;
@property (weak, nonatomic) IBOutlet UIButton *iPhoneInfoButton;
@property (weak, nonatomic) IBOutlet UIButton *iPadInfoButton;

@end
