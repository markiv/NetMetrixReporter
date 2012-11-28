//
//  NetMetrixReporter.h
//  NetMetrixTest
//
//  Created by Vikram Kriplaney on 28.11.2012.
//  Copyright (c) 2012 iPhonso GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetMetrixReporter : NSObject
+ (void)setOfferID:(NSString *)anOfferID;
+ (void)setAppID:(NSString *)anAppID;
+ (void)report;

@end
