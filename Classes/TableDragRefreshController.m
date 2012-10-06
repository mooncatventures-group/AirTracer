
#import "TableDragRefreshController.h"
#import "DataSource.h"

@implementation TableDragRefreshController

@synthesize filterSearchBar;


///////////////////////////////////////////////////////////////////////////////////////////////////
// private


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle 
                                                       *)nibBundleOrNil { 
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) 
    { 
        self.title = @"System Log"; 
        //self.navigationBarTintColor = [UIColor blackColor]; 
        UIImage* image = [UIImage imageNamed:@"photos.png"];
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:self.title 
                                                         image:image tag:0]; 
    } 
    return self; 
} 


- (id)initWithMenu:(MenuPage)page {
    if (self = [super init]) {
        self.page = page;
    }
    return self;
}

- (void)setPage:(MenuPage)page {
    _page = page;
    
    self.title = @"System Log";
    

}

-(id) initWithTabBar {
	if ([self init]) {
		//this is the label on the tab button itself
		self.title = @"BookMarks";
		
		//use whatever image you want and add it to your project
		self.tabBarItem.image = [UIImage imageNamed:@"tab.png"];
		
		// set the long name shown in the navigation bar
		self.navigationItem.title=@"BookMarks";
	}
	return self;
	
}




///////////////////////////////////////////////////////////////////////////////////////////////////
// UIViewController

- (void)loadView {
  [super loadView];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.tableView.frame = CGRectMake(0, 40, self.tableView.width, (self.tableView.height - 40));
	// Set the Status Bar to Black
	self.statusBarStyle = UIStatusBarStyleBlackOpaque;
		//This line breaks a lot of stuff...
	//self.tableView.delegate = self;
	// Setup the filterSearchBar
	filterSearchBar = [[UISearchBar alloc] init];
	filterSearchBar.frame = CGRectMake(0, 0, self.view.width, 40);
	filterSearchBar.autoresizingMask = (UIViewAutoresizingFlexibleWidth);
	filterSearchBar.delegate = self;
	filterSearchBar.showsCancelButton = YES;
    filterSearchBar.showsScopeBar=YES;
    filterSearchBar.placeholder = [@"Search " stringByAppendingString:self.title];
    filterSearchBar.tintColor = RGBCOLOR(0, 83, 155);
    
    for(UIView *subView in filterSearchBar.subviews){
     if([subView isKindOfClass:UIButton.class]){
        [(UIButton*)subView setTitle:@"Done" forState:UIControlStateNormal];
            }
        
    }
   
	// Add the bars to the subview
	[self.view addSubview:filterSearchBar];
	
	// Setup a refresh button
	//UIBarButtonItem *refresh = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh)] autorelease];
	//self.navigationItem.rightBarButtonItem = refresh;
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return YES;
}


- (void) createModel {
  SearchDataSource *ds = [[SearchDataSource alloc] init];
  ds.logger.loadingDuration = 1.0;
  self.dataSource = ds;
   
 
}



- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchText ==@""){
        [self reload];
        return;
    }
    ((SearchDataSource *)self.dataSource).searchTerms = [NSString stringWithString:searchText];
	[self reload];

}
                                                                                 


#pragma mark -
#pragma mark UISearchBarDelegate methods

- (void)searchBarSearchButtonClicked:(UISearchBar *)search {
	((SearchDataSource *)self.dataSource).searchTerms = [NSString stringWithString:search.text];
	[search resignFirstResponder];
	[self reload];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)search {
	((SearchDataSource *)self.dataSource).searchTerms = @"";
	[search resignFirstResponder];
	search.text = @"";
	[self reload];
}



- (id<TTTableViewDelegate>) createDelegate {
  
  TTTableViewDragRefreshDelegate *delegate = [[TTTableViewDragRefreshDelegate alloc] initWithController:self];
       

  return delegate;
}

@end

