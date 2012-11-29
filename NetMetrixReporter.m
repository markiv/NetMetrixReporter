//
//  NetMetrixReporter.m
//  NetMetrixTest
//
//  Created by Vikram Kriplaney on 28.11.2012.
//  Copyright (c) 2012 iPhonso GmbH. All rights reserved.
//

#import "NetMetrixReporter.h"

@implementation NetMetrixReporter

static NSString *offerID;
static NSString *device;
static NSString *appID;
static NSURL    *baseURL;
static NSString *userAgent;


// Sets the NetMetrix offer ID (Angebotskennung)
+ (void)setOfferID:(NSString *)anOfferID
{
    offerID = anOfferID;
    [self rebuildBaseURL];
}

// Sets the app ID
+ (void)setAppID:(NSString *)anAppID
{
    appID = anAppID;
    [self rebuildBaseURL];
}


/* Rebuilds the NET-Metrix URL
 * E.g. http://iphonso.wemfbox.ch/cgi-bin/ivw/CP/apps/NetMetrixTest/ios/universal/phone
 * See: http://www.net-metrix.ch/produkte/net-metrix-audit/technisches/skript-generator?angebot=netmx&kontingent=apps/newsapp/iphone&tag=audit&submit=Skript+erstellen
 * Die Struktur des Skripts wird wie folgt aussehen:
 * [angebotskennung].wemfbox.ch/cgi-bin/ivw/CP/apps/[appname]/[plattform]/[device]
 */
+ (void)rebuildBaseURL
{
    baseURL = [NSURL URLWithString:[NSString stringWithFormat:
        @"http://%@.wemfbox.ch/cgi-bin/ivw/CP/apps/%@/ios/%@", offerID, appID, device]];
}

// Introspects the current device and app bundle in order to set up reasonable defaults
+ (void)initialize
{
    // What are we running on?
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        device    = @"tablet";
        userAgent = @"Mozilla/5.0 (iOS-tablet; U; CPU iPad OS like Mac OS X)";
    } else {
        device    = @"phone";
        userAgent = @"Mozilla/5.0 (iOS-phone; U; CPU iPhone OS like Mac OS X)";
    }

    NSBundle *bundle = [NSBundle mainBundle];

    // Is this a universal app?
    id deviceFamily = [bundle objectForInfoDictionaryKey:@"UIDeviceFamily"];
    BOOL isUniversalApp = [deviceFamily isKindOfClass:[NSArray class]] && [deviceFamily count] > 1;
    if (isUniversalApp) {
        device    = [@"universal/" stringByAppendingString:device];
        userAgent = @"Mozilla/5.0 (iOS-universal; U; CPU OS like Mac OS X)";
    }
    
    /* By default, use the bundle ID to guess the required Net-Metrix "offer ID" and app name
     * E.g. for the bundle ID "com.iphonso.NetMetrixTest", offerID will be "iphonso"
     * and appID will be "NetMetrixTest" (they can be overridden afterwards).
     */
    NSString *bundleID     = [bundle objectForInfoDictionaryKey:@"CFBundleIdentifier"];
    NSArray *bundleIdParts = [bundleID componentsSeparatedByString:@"."];
    offerID = [bundleIdParts count] > 1 ? bundleIdParts[1] : bundleID;
    appID   = [bundleIdParts lastObject];
    
    [self rebuildBaseURL];
}

// Fetches the famous 1-pixel GIF, thereby reporting a "page view" to NET-Metrix
+ (void)report
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        // Create a request
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:baseURL
                                        cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:10];
        
        // Set the required custom user agent
        [request setValue:userAgent forHTTPHeaderField:@"User-Agent"];

        // Make the connection
        NSHTTPURLResponse *response;
        NSError *error;
        [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        if (error) {
            NSLog(@"Error reporting to NET-Metrix: %@", error);
        } else {
            NSLog(@"NET-Metrix response: Status = %i; Headers = %@", response.statusCode,
                  [response allHeaderFields]);
        }
    });
}

@end
