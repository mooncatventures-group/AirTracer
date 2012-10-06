//

#import "SFUSystem.h"
#import "ProcessViewController.h"
#import "ServiceListViewController.h"
#import "RootViewController.h"


@implementation SFUSystem

#pragma mark -
#pragma mark Initialization

// The designated initializer.	Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		// Setup the page title
		self.title = @"System";
        
        TTNavigator* navigator = [TTNavigator navigator]; 
        navigator.persistenceMode = TTNavigatorPersistenceModeAll; 
       // navigator.window = [[UIWindow alloc] initWithFrame:TTScreenBounds()];
        //                   autorelease]; 
        TTURLMap* map = navigator.URLMap; 
        [map from:@"*" toViewController:[TTWebController class]];
        [map from:@"tt://FifthItem/PDDTable" 
          toSharedViewController:[ProcessViewController class]]; 
        
        [map from:@"tt://SixthItem/BJRTable" 
        toSharedViewController:[ServiceListViewController class]]; 
        
        [map from:@"tt://SeventhItem/ASCTable" 
        toSharedViewController:[RootViewController class]]; 
        

        
                
        UIImage *image = [UIImage imageNamed:@"Settings.png"];
		self.tabBarItem = [[UITabBarItem alloc] initWithTitle:self.title image:image tag:0];

		// Setup the data source
		self.dataSource = [TTSectionedDataSource dataSourceWithObjects:
						   @"General Information",
						   [TTTableTextItem itemWithText:@"Running Processes" URL:@"tt://FifthItem/PDDTable"],
						 //  [TTTableTextItem itemWithText:@"Storage" URL:@"SFUBeedie://maps/2"],
						  // [TTTableTextItem itemWithText:@"Battery State" URL:@"SFUBeedie://maps/3"],
						   @"Network Information",
						  // [TTTableTextItem itemWithText:@"Celluar" URL:@"SFUBeedie://System/1"],
						   [TTTableTextItem itemWithText:@"HTTP/TCP Mapping" URL:@"SFUBeedie://System/2"],
						   [TTTableTextItem itemWithText:@"Net Services Mapping" URL:@"tt://SixthItem/BJRTable"],
						   @"Attached Accessories",
						   [TTTableTextItem itemWithText:@"Accessory mapping" URL:@"tt://SeventhItem/ASCTable"],
						   nil];
	}
	return self;
}


#pragma mark -
#pragma mark View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	[super loadView];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    

}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return YES;
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
	[super didReceiveMemoryWarning];

	// Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
	[super viewDidUnload];
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	
}


@end
