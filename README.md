NetMetrixReporter
=================
 
An iOS helper class to simplify reporting app activity to [NET-Metrix](http://www.net-metrix.ch), a Swiss web and mobile usage agency.
 
On initialization, introspects the current device and app bundle in order to set up reasonable defaults. Guesses the offer ID (Angebotskennung) and app ID from the app bundle (they can be overridden afterwards).
 
For example, for the bundle ID "com.iphonso.NetMetrixTest", the offerID will be extracted as "iphonso" and the appID will be "NetMetrixTest". If the app is declared in the bundle as universal, and it's currently running on an iPhone, the resulting URL will be http://iphonso.wemfbox.ch/cgi-bin/ivw/CP/apps/NetMetrixTest/ios/universal/phone.
 
If we guess everything correctly (which is not unlikely), then all your code needs to do is call +[NetMetrixReporter report], typically in your viewDidAppear:

	- (void)viewDidAppear:(BOOL)animated
	{
	    [super viewDidAppear:animated];
	    [NetMetrixReporter report];
	}
     
whenever it wants to report a "page view" to NET-Metrix
 
If the guesswork doesn't work for your app, you can override the defaults:
 
    NetMetrixReporter.offerID = @"mycompany";
    NetMetrixReporter.appID = @"myapp";
    