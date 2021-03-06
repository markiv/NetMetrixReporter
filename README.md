NetMetrixReporter
=================

An iOS helper class to simplify reporting app activity to [NET-Metrix](http://www.net-metrix.ch), a Swiss web and mobile usage monitoring agency.

On initialization, we introspect the current device and app bundle in order to set up reasonable defaults. We also guess the offer ID (Angebotskennung) and app ID from the app bundle (they can be overridden afterwards). Additionally, we set up the correct user agent as defined by NM.

For example, for the bundle ID "com.iphonso.NetMetrixTest", the offerID will be extracted as "iphonso" and the appID will be "NetMetrixTest". If the app is declared in the bundle as universal, and it's currently running on an iPhone, the resulting URL will be http://iphonso.wemfbox.ch/cgi-bin/ivw/CP/apps/NetMetrixTest/ios/universal/phone.

If we guess everything correctly (which is not unlikely), then all your code needs to do is call `+[NetMetrixReporter report]`, typically in your viewDidAppear:

    - (void)viewDidAppear:(BOOL)animated
    {
        [super viewDidAppear:animated];
        [NetMetrixReporter report];
    }

whenever it wants to report a "page view" to NET-Metrix. `report` returns immediately and performs the HTTP connection aynchronously. Fire and forget.

If the guesswork doesn't work for your app, you can override the defaults:

    NetMetrixReporter.offerID = @"mycompany";
    NetMetrixReporter.appID = @"myapp";

And if your app requires more control, use `+[NetMetrixReporter reportWithCompletionHandler:]`. See `MainViewController.m` in the sample code:

    [NetMetrixReporter reportWithCompletionHandler:^(NSHTTPURLResponse *response, NSError *error) {
        if (error) {
            ...
        }
    }];
