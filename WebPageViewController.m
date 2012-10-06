//
//  WebPageViewController.m
//  BonjourWebBrowser


#import "WebPageViewController.h"



@implementation WebPageViewController


NSTimeInterval RESOLUTION_TIMEOUT = 10; // 10 second timeout (arbitrary)


NSNetService *netService;

/* some of these items may be of debugging interest
 NSLog (@"service info:\n name:%@\n type:%@\n hostname:%@\n domain:%@\n TXTRecordData:%@\n port:%d\n addresses:%@\n",
 [netService name],
 [netService type],
 [netService hostName],	
 [netService domain],
 txtRecordDictionary,
 [netService port],
 [netService addresses]);
 */

//START:code.BonjourWebBrowser.loadPageFromService
-(void) loadPageFromService {
	// get path from the TXT record
	NSDictionary *txtRecordDictionary = //<label id="code.BonjourWebBrowser.startSearchingForWebServers.getpathfromtxtrecord.start"/>
		[NSNetService dictionaryFromTXTRecordData:
			[netService TXTRecordData]];
	NSData *pathData =
	(NSData*) [txtRecordDictionary objectForKey: @"path"];
	NSString *path = [[NSString alloc] initWithData: pathData
		encoding:NSUTF8StringEncoding];  //<label id="code.BonjourWebBrowser.startSearchingForWebServers.getpathfromtxtrecord.end"/>
	
	// see http://www.dns-sd.org/txtrecords.html#http for the rules
	// on getting url from service data
	
	// build URL from host, port, and path
	      urlString = [[NSString alloc]  //<label id="code.BonjourWebBrowser.startSearchingForWebServers.buildurl.start"/>
		   initWithFormat: @"http://%@:%d/%@",
		   [netService hostName],
		   [netService port],
		   path];
	
	
	//set the web view delegate for the web view to be itself
	[webView setDelegate:self];
	
	NSURL *url = [[NSURL alloc] initWithString: urlString];  //<label id="code.BonjourWebBrowser.startSearchingForWebServers.buildurl.end"/>
	urlLabel.text = urlString;
	self.title = [netService name];
	
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
	
	[webView loadRequest: request];
	// stop activity indictator; could also do this when web view either
	 //completes or errors, by providing UIWebView delegate
	[resolutionActivityIndicator stopAnimating];
	
  
	// pathData and txtRecordDictionary don't get released, because
	// they were merely "gotten" and not retained
}
//END:code.BonjourWebBrowser.loadPageFromService

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil netService:(NSNetService *)discoveredService {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		// Initialization code
	}
	netService = discoveredService;
	return self;
}


// resolution delegate methods 

- (void)netServiceDidResolveAddress:(NSNetService *)sender {
	[self loadPageFromService];
}

- (void)netService:(NSNetService *)sender didNotResolve:(NSDictionary *)errorDict {
	[resolutionActivityIndicator stopAnimating];
	NSError *bonjourError = [[NSError alloc]
							 initWithDomain: [errorDict objectForKey: NSNetServicesErrorDomain]
							 code: (NSInteger) [errorDict objectForKey: NSNetServicesErrorCode]
							 userInfo: NULL];
	UIAlertView *errorAlert = [[UIAlertView alloc]
							   initWithTitle: [bonjourError localizedDescription]
							   message: [bonjourError localizedFailureReason]
							   delegate:nil
							   cancelButtonTitle:@"OK"
							   otherButtonTitles:nil];
	[errorAlert show];
	}


/*
 Implement loadView if you want to create a view hierarchy programmatically
- (void)loadView {
}
 */

/*
 If you need to do additional setup after loading the view, override viewDidLoad.
 */
//START:code.BonjourWebBrowser.webPageViewControllerViewDidLoad
- (void)viewDidLoad {
	[super viewDidLoad];
	
	
	
	
	// start resolution if necessary, otherwise just get the path and show
	// page. see http://developer.apple.com/qa/qa2004/qa1389.html for more
	// on why this is necessary
	if ([netService hostName] != nil) {
		[self loadPageFromService];
	} else {
		[resolutionActivityIndicator startAnimating];
		[netService setDelegate: self];
		[netService resolveWithTimeout: RESOLUTION_TIMEOUT];
	}	
}
//END:code.BonjourWebBrowser.webPageViewControllerViewDidLoad


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}





- (void)dealloc {
	
}


@end
