NetMetrixReporter
=================

An iOS helper class to simplify reporting app activity to Net-Metrix.

On initialization, introspects the current device and app bundle in order to set up reasonable defaults. Guesses the offer ID (Angebotskennung) and app ID from the app bundle (they can be overridden afterwards).

If we guess everything correctly (likely), then all your code needs to do is:

	[NetMetrixReporter report];
	
whener it wants to report a "page view" to Net-Metrix

If the guesswork doesn't work for your app, you can override the defaults:

    NetMetrixReporter.offerID = @"mycompany";
    NetMetrixReporter.appID = @"myapp";
	
    
