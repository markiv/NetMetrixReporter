//
//  NetMetrixReporter.h
//  NetMetrixTest
//
//  Created by Vikram Kriplaney on 28.11.2012.
//  Copyright (c) 2012 iPhonso GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^NetMetrixReporterCompletionHandler) (NSHTTPURLResponse *response, NSError *error);

@interface NetMetrixReporter : NSObject
+ (void)setOfferID:(NSString *)anOfferID;
+ (void)setAppID:(NSString *)anAppID;
+ (void)report;
+ (void)reportWithCompletionHandler:(NetMetrixReporterCompletionHandler)handler;

@end
