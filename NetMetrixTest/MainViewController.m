//
//  MainViewController.m
//  NetMetrixTest
//
//  Created by Vikram Kriplaney on 28.11.2012.
//  Copyright (c) 2012 iPhonso GmbH. All rights reserved.
//

#import "MainViewController.h"
#import "NetMetrixReporter.h"


@interface MainViewController ()
@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.log.text = @"";
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.iPhoneInfoButton.hidden = YES;
    } else {
        self.iPadInfoButton.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.mango.alpha = 0.0;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [NetMetrixReporter report];

    self.mango.transform = CGAffineTransformMakeScale(0.9, 0.9);
    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.mango.transform = CGAffineTransformIdentity;
        self.mango.alpha = 1.0;
    } completion:nil];
}


#pragma mark - Flipside View Controller

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.flipsidePopoverController dismissPopoverAnimated:YES];
        self.flipsidePopoverController = nil;
    }
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.flipsidePopoverController = nil;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        [[segue destinationViewController] setDelegate:self];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            UIPopoverController *popoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
            self.flipsidePopoverController = popoverController;
            popoverController.delegate = self;
        }
    }
}

- (IBAction)togglePopover:(id)sender
{
    if (self.flipsidePopoverController) {
        [self.flipsidePopoverController dismissPopoverAnimated:YES];
        self.flipsidePopoverController = nil;
    } else {
        [self performSegueWithIdentifier:@"showAlternate" sender:sender];
    }
}

- (IBAction)mangoTapped:(id)sender {
    [NetMetrixReporter reportWithCompletionHandler:^(NSHTTPURLResponse *response, NSError *error) {
        NSString *time = [NSDateFormatter localizedStringFromDate:[NSDate date]
                            dateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterMediumStyle];
        NSString *info = @"";
        if (error) {
            info = [error localizedDescription];
            NSString *url = [error.userInfo objectForKey:NSURLErrorFailingURLErrorKey];
            if (url) {
                info = [info stringByAppendingFormat:@" (%@)", url];
            }
        } else {
            info = [NSString stringWithFormat:@"Response status %i", response.statusCode];
            id contentLength = [[response allHeaderFields] objectForKey:@"Content-Length"];
            if (contentLength) {
                info = [info stringByAppendingFormat:@" (%@ bytes)", contentLength];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.log.text = [self.log.text stringByAppendingFormat:@"%@: %@\n", time, info];
            [self.log scrollRectToVisible:CGRectMake(0, self.log.contentSize.height-1, 1, 1) animated:YES];
        });
    }];
}
@end
