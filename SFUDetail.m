//

#import "SFUDetail.h"


@implementation SFUDetail

@synthesize detailType = _detailType;

// Override to customize depending on the detailType.
- (void)setDetailType:(SFUDetailType)type {
	_detailType = type;
	
	switch (type) {
		case NoneType:
			self.title = @"";
			break;
			
		case BurnabySystem:
			self.title = @"Burnaby";
			break;
			
		case SurreySystem:
			self.title = @"Surrey";
			break;
			
		case VancouverSystem:
			self.title = @"Vancouver";
			break;
			
		case SchoolWide:
			self.title = @"SFU";
			break;
			
		case OtherType:
			self.title = @"";
			break;
			
		case FacebookType:
			self.title = @"";
			break;
			
		case TwitterType:
			self.title = @"";
			break;
			
		case SocialType:
			self.title = @"";
			break;
			
		default:
			self.title = @"Uh-oh!";
			self.dataSource = [TTSectionedDataSource dataSourceWithObjects:
							   @"You borked it!",
							   [TTTableGrayTextItem itemWithText:@"Something went wrong! Please contact us with exactly how you got here!"],
							   [TTTableTextItem itemWithText:@"E-Mail" URL:@"https//"],
							   [TTTableTextItem itemWithText:@"Website" URL:@"https://code.google.com/p/cmpt275-group9/"],
							   [TTTableTextItem itemWithText:@"File a bug report!" URL:@"http://code.google.com/p/cmpt275-group9/issues/entry"],
							   nil];
			break;
	}
	
}

#pragma mark -
#pragma mark Initialization

// The designated initializer.	Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		_detailType = NoneType;
	}
	return self;
}

// Initializes based on detailType. Customizes the object based on type.
- (id)initWithDetailType:(SFUDetailType)detail {
	if (self = [super init]) {
		self.detailType = detail;
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
	
	// Set the Status Bar to Black
	self.statusBarStyle = UIStatusBarStyleBlackOpaque;
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
