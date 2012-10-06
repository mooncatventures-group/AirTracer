

#import "ProcessViewController.h"
#import "AppDelegate.h"
#import "process.h"

@interface ProcessViewController()
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) procViewController *procView;
@property (nonatomic, retain) systemViewController *systemView;

@end

@implementation ProcessViewController

@synthesize tableView;
@synthesize procView;
@synthesize systemView;


#define localizedString(key, str) [[NSBundle mainBundle] localizedStringForKey: (key) value: (str) table: @"InfoPlist"]

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle 
                                                       *)nibBundleOrNil { 
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) 
    { 
        UIToolbar* tools = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 70, 45)];      
        // create the array to hold the buttons, which then gets added to the toolbar
        NSMutableArray* buttons = [[NSMutableArray alloc] initWithCapacity:1];
        
        UIBarButtonItem *bi = [[UIBarButtonItem alloc] initWithTitle:@"Update" style:UIBarButtonItemStylePlain target:self action:@selector(refreshTable)];
         bi.style = UIBarButtonItemStyleBordered;
         [buttons addObject:bi];
         
        // stick the buttons in the toolbar
        [tools setItems:buttons animated:NO];
        
        
        
        // and put the toolbar in the nav bar
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:tools];
        

        self.title = @"Processes"; 
        //self.navigationBarTintColor = [UIColor blackColor]; 
        UIImage* image = [UIImage imageNamed:@"Settings.png"]; 
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:self.title 
                                                        image:image tag:0]; 
    } 
    return self; 
} 




- (void)viewDidLoad {
	// Add the following line if you want the list to be editable
	// self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
	NSLog(@"didReceiveMemoryWarning");
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}

- (void)dealloc {
	}

#pragma mark UIViewController



-(void)viewWillAppear:(BOOL)animated {
	//NSLog(@"[RootViewController viewWillAppear]");
	AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	[appDelegate getBSDProcessList];
    [self.tableView reloadData];
}


-(void)info: (id)sender{
	}


-(procViewController*)procView{
	if(procView == nil){
		procView = [[procViewController alloc] initWithNibName: @"procView" bundle: nil];
	}
	return procView;
}


-(systemViewController*)systemView{
	if(systemView == nil){
		systemView = [[systemViewController alloc] initWithNibName: @"systemView" bundle: nil];
	}
	return systemView;
}



#pragma mark UITableViewDelegate and dataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	switch(section){
		case 0: return 1;
		case 1: return appDelegate.procs.count;
	}
	return 0;
}


- (NSString *)tableView:(UITableView *)tv titleForHeaderInSection:(NSInteger)section {
	switch(section){
		case 0: return localizedString(@"rtag0", @"system");
		case 1: return localizedString(@"rtag1", @"running process list");
	}
	return @"";
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *MyIdentifier = @"MyIdentifier";
	
	UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:MyIdentifier];
	}
	
	// Set up the cell
	AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	if(indexPath.section == 0){
		cell.text = [NSString stringWithFormat:@"%@: %d", localizedString(@"procscell", @"procs"), appDelegate.procs.count];
	}else{
		process *procp = [appDelegate.procs objectAtIndex:indexPath.row];
		cell.text = [procp cellName];
	}
	return cell;
}

- (void)refreshTable {
     [self.tableView reloadData];
}



/*
 Override if you support editing the list
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
		
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		// Delete the row from the data source
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
	}	
	if (editingStyle == UITableViewCellEditingStyleInsert) {
		// Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
	}	
}
*/


/*
 Override if you support conditional editing of the list
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	// Return NO if you do not want the specified item to be editable.
	return YES;
}
*/


/*
 Override if you support rearranging the list
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
 Override if you support conditional rearranging of the list
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
	// Return NO if you do not want the item to be re-orderable.
	return YES;
}
 */ 


- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	//return (interfaceOrientation == UIInterfaceOrientationPortrait);
	return YES;
}


@end

