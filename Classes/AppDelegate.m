#import "AppDelegate.h"
#import "TableDragRefreshController.h"
#import "TTTwitterSearchFeedViewController.h"
#import "ProcViewController.h"
#import "TabBarController.h"
#import	"QueueViewController.h"
#import "Atlas.h"
#import "HTTPServer.h"
#import "MyHTTPConnection.h"
#import "localhostAddresses.h"
#import "SFUSystem.h"
#import "procViewController.h"

@implementation AppDelegate
@synthesize window;
@synthesize albumController;
@synthesize tabBarController;
@synthesize procs;


///////////////////////////////////////////////////////////////////////////////////////////////////
// UIApplicationDelegate

///////////////////////////////////////////////////////////////////////////////////////////////////
/*
- (void)applicationDidFinishLaunching:(UIApplication*)application {
    TTNavigator* navigator = [TTNavigator navigator];
    navigator.persistenceMode = TTNavigatorPersistenceModeAll;
    navigator.window = [[UIWindow alloc] initWithFrame:TTScreenBounds()];
    
    TTURLMap* map = navigator.URLMap;
    
    // Any URL that doesn't match will fall back on this one, and open in the web browser
    [map from:@"*" toViewController:[TTWebController class]];
    
    // The tab bar controller is shared, meaning there will only ever be one created.  Loading
    // This URL will make the existing tab bar controller appear if it was not visible.
    [map from:@"tt://tabBar" toSharedViewController:[TabBarController class]];
    
    // Menu controllers are also shared - we only create one to show in each tab, so opening
    // these URLs will switch to the tab containing the menu
    [map from:@"tt://menu/(initWithMenu:)" toSharedViewController:[TableDragRefreshController class]];
    
  //  [map from:@"tt://twitter/(initWithFeed:)" toViewController:[TTTwitterSearchFeedViewController class]];
  
    
    // Before opening the tab bar, we see if the controller history was persisted the last time
    if (![navigator restoreViewControllers]) {
        // This is the first launch, so we just start with the tab bar
        [navigator openURLAction:[TTURLAction actionWithURLPath:@"tt://tabBar"]];
    }
}
*/

- (BOOL)application:(UIApplication *)application 
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 
{ 
      TTNavigator* navigator = [TTNavigator navigator]; 
    navigator.persistenceMode = TTNavigatorPersistenceModeAll; 
   // navigator.window = [[UIWindow alloc] initWithFrame:TTScreenBounds()];
     //                   autorelease]; 
    TTURLMap* map = navigator.URLMap; 
    
    NSManagedObjectContext *context = [self managedObjectContext];
	if (!context) {
		// Handle the error.
	}

    
	NSString *root = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0];
	
	httpServer = [HTTPServer new];
	[httpServer setType:@"_http._tcp."];
	[httpServer setConnectionClass:[MyHTTPConnection class]];
	[httpServer setDocumentRoot:[NSURL fileURLWithPath:root]];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayInfoUpdate:) name:@"LocalhostAdressesResolved" object:nil];
	[localhostAddresses performSelectorInBackground:@selector(list) withObject:nil];
	
	//[self startServer];
	

    
    // Any URL that doesn't match will fall back on this one, and open in the web browser
    [map from:@"*" toViewController:[TTWebController class]];
    
    // The tab bar controller is shared, meaning there will only ever be one created.  Loading
    // This URL will make the existing tab bar controller appear if it was not visible.
    [map from:@"tt://tabBar" toSharedViewController:[TabBarController class]];
    

    [map from:@"tt://FirstItem/Launcher" 
      toSharedViewController:[TableDragRefreshController  class]]; 
     // toSharedViewController:[TTTwitterSearchFeedViewController class]]; 
    

   
    [map from:@"tt://SecondItem/PrcTable" 
    toSharedViewController:[TTTwitterSearchFeedViewController class]]; 
    
    
    QueueViewController *queueViewController;
	queueViewController = [[QueueViewController alloc] initWithNibName:@"queueViewController" bundle:nil];
	queueViewController.managedObjectContext = context;

    
    [map from:@"tt://ThirdItem/QvcTable" 
         toViewController:queueViewController]; 
    
    SFUSystem *moreViewController;
	moreViewController = [[SFUSystem alloc] initWithNibName:@"moreViewController" bundle:nil];
	    [map from:@"tt://FourthItem/System" 
      toViewController:moreViewController]; 

    
    // Before opening the tab bar, we see if the controller history was persisted the last time
    if (![navigator restoreViewControllers]) {
        // This is the first launch, so we just start with the tab bar
        [navigator openURLAction:[TTURLAction actionWithURLPath:@"tt://tabBar"]];
    }
}

-(void)getBSDProcessList {
    int                 err;
    static const int    name[] = { CTL_KERN, KERN_PROC, KERN_PROC_ALL, 0 };
    size_t              length;
	int					count;
	NSMutableArray		*procArray = [[NSMutableArray alloc] init];
	
	self.procs = procArray;
	length = 0;
	err = sysctl( (int *) name, (sizeof(name) / sizeof(*name)) - 1, NULL, &length, NULL, 0);
	if (err == -1) {
		err = errno;
	}
	
	
	if (err == 0) {
		struct kinfo_proc	*procBuffer;
		procBuffer = malloc(length);
		if(procBuffer == NULL){
			return;
		}
				err = sysctl( (int *) name, (sizeof(name) / sizeof(*name)) - 1, procBuffer, &length, NULL, 0);
		if (err == -1) {
			err = errno;
		}
		if (err == 0) {
		} else if (err == ENOMEM) {
        err = 0;
		}
        count = length / sizeof(struct kinfo_proc);
		for(int i = 0; i < count; i++){
			[procArray addObject:[[process alloc] initWithKInfo:&(procBuffer[i])]];
		}
		free(procBuffer);
	}
}

- (NSString *)displayInfoUpdate:(NSNotification *) notification
{
	
	
	if(notification)
	{
		
		addresses = [[notification object] copy];
		NSLog(@"addresses: %@", addresses);
	}
	
	if(addresses == nil)
	{
		return @"All Sharing Services Stopped";
	}
	
	NSString *info;
	UInt16 port = [httpServer port];
	
	NSString *localIP = nil;
	
	localIP = [addresses objectForKey:@"en0"];
	
	if (!localIP)
	{
		localIP = [addresses objectForKey:@"en1"];
	}
	
	if (!localIP)
		info = @"Wifi: No Connection!\n";
	else
		info = [NSString stringWithFormat:@"http://iphone.local:%d		http://%@:%d\n", port, localIP, port];
	
	NSString *wwwIP = [addresses objectForKey:@"www"];
	
	if (wwwIP)
		info = [info stringByAppendingFormat:@"Web: %@:%d\n", wwwIP, port];
	else
		info = [info stringByAppendingString:@"Web: Unable to determine external IP\n"];
	
	
	/*
	 
	 
	 UIAlertView *myAlert = [ [ UIAlertView alloc ]
	 initWithTitle:@"Sharing Status"
	 message:info
	 delegate:self
	 cancelButtonTitle: @"Stop Sharing"
	 otherButtonTitles: @"OK", nil];
	 [ myAlert show ];
	 
	 */
	
	return info;
	
}



- (IBAction)startStopServer:(id)sender
{
	if ([sender isOn])
	{
		// You may OPTIONALLY set a port for the server to run on.
		// 
		// If you don't set a port, the HTTP server will allow the OS to automatically pick an available port,
		// which avoids the potential problem of port conflicts. Allowing the OS server to automatically pick
		// an available port is probably the best way to do it if using Bonjour, since with Bonjour you can
		// automatically discover services, and the ports they are running on.
		//	[httpServer setPort:8080];
		
		NSError *error;
		if(![httpServer start:&error])
		{
			NSLog(@"Error starting HTTP Server: %@", error);
		}
		
		
	}
	else
	{
		[httpServer stop];
		
		
	}
}


- (void)startServer
{
	NSError *error;
	if(![httpServer start:&error])
	{
		NSLog(@"Error starting HTTP Server: %@", error);
	}
	
	//	[self displayInfoUpdate:nil];
}


- (void)stopServer
{
	
	if(![httpServer stop])
	{
		NSLog(@"Error stopping HTTP Server");
	}
	
	
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	
	
	if (buttonIndex == 0) {
		NSLog(@"server stopped");
		[self stopServer];
		NSLog(@"Button %d pressed", buttonIndex);
	}
  
}



#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *) managedObjectContext {
	
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return managedObjectContext;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel {
	
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];    
    return managedObjectModel;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
	
	
	NSString *storePath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"Streams2.sqlite"];
	/*
	 Set up the store.
	 For the sake of illustration, provide a pre-populated default store.
	 */
	NSFileManager *fileManager = [NSFileManager defaultManager];
	// If the expected store doesn't exist, copy the default store.
	if (![fileManager fileExistsAtPath:storePath]) {
		NSString *defaultStorePath = [[NSBundle mainBundle] pathForResource:@"Streams2" ofType:@"sqlite"];
		if (defaultStorePath) {
			[fileManager copyItemAtPath:defaultStorePath toPath:storePath error:NULL];
		}
	}
    
	NSURL *storeUrl = [NSURL fileURLWithPath:storePath];
	
	NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];	
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
    
	NSError *error;
	if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:options error:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
    }    
	
    return persistentStoreCoordinator;
}


#pragma mark -
#pragma mark Application's documents directory

/**
 Returns the path to the application's documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
	
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}




- (BOOL)application:(UIApplication*)application handleOpenURL:(NSURL*)URL {
  [[TTNavigator navigator] openURLAction:[TTURLAction actionWithURLPath:URL.absoluteString]];
  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
    [self stopServer];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
    [self stopServer];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    [self startServer];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
    [self stopServer];
}

 

@end
