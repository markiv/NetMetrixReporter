//
//  FlipsideViewController.h
//  NetMetrixTest
//
//  Created by Vikram Kriplaney on 28.11.2012.
//  Copyright (c) 2012 iPhonso GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FlipsideViewController;

@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
@end

@interface FlipsideViewController : UIViewController

@property (weak, nonatomic) id <FlipsideViewControllerDelegate> delegate;

- (IBAction)done:(id)sender;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;

@end
