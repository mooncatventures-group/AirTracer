

#import "QueueViewController.h"
#import "Event.h"



@implementation QueueViewController


@synthesize eventsArray, managedObjectContext, addButton;


#pragma mark -
#pragma mark View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle 
                                                       *)nibBundleOrNil { 
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) 
    { 
        self.title = @"Snapshots"; 
        //self.navigationBarTintColor = [UIColor blackColor]; 
        UIImage* image = [UIImage imageNamed:@"streaming.png"]; 
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:self.title 
                                                        image:image tag:0]; 
    }
	return self;
}


- (void)viewDidLoad {
	
    [super viewDidLoad];
	
	
	
	// Set the title.
    self.title = @"Snapshots";
    
	//create a toolbar to have two buttons in the right
	UIToolbar* tools = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 55, 45)];
	
	// create the array to hold the buttons, which then gets added to the toolbar
	NSMutableArray* buttons = [[NSMutableArray alloc] initWithCapacity:1];
	
	;
	
    /* create a standard "add" button
	UIBarButtonItem* bi = [[UIBarButtonItem alloc]
                           initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self  action:@selector(addEvent)];
	bi.style = UIBarButtonItemStyleBordered;
	[buttons addObject:bi];
*/
	
	// stick the buttons in the toolbar
	[tools setItems:buttons animated:NO];
	
	
	
	// and put the toolbar in the nav bar
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:tools];
	
	
	
	/*
	 Fetch existing events.
	 Create a fetch request, add a sort descriptor, then execute the fetch.
	 */
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:managedObjectContext];
	[request setEntity:entity];
	
	// Order the events by creation date, most recent first.
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"creationDate" ascending:NO];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	[request setSortDescriptors:sortDescriptors];
	
	
	// Execute the fetch -- create a mutable copy of the result.
	NSError *error = nil;
	NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
	if (mutableFetchResults == nil) {
		// Handle the error.
	}
	
	// Set self's events array to the mutable array, then clean up.
	[self setEventsArray:mutableFetchResults];
	
	
}


- (void)viewWillAppear:(BOOL)animated {
	
	[super viewWillAppear:animated];
	[self.tableView reloadData];
}


- (void)viewDidUnload {
	// Release any properties that are loaded in viewDidLoad or can be recreated lazily.
	self.eventsArray = nil;
		self.addButton = nil;
	

}


#pragma mark -
#pragma mark Table view data source methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	tableView.rowHeight = 50.0;

	// Only one section.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	// As many rows as there are obects in the events array.
    return [eventsArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	// A date formatter for the creation date.
    static NSDateFormatter *dateFormatter = nil;
	if (dateFormatter == nil) {
		dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
		[dateFormatter setDateStyle:NSDateFormatterShortStyle];
	}
		
   static NSString *CellIdentifier = @"Cell";


	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		
    }
    
	// Get the event corresponding to the current index path and configure the table view cell.
	Event *event = (Event *)[eventsArray objectAtIndex:indexPath.row];
	
	
	
	cell.textLabel.text = @"Time Index for:";
    cell.detailTextLabel.text = [dateFormatter stringFromDate:[event creationDate]];
	
	[cell.detailTextLabel setFont:[UIFont systemFontOfSize:12.0]];
	[cell.detailTextLabel setTextColor:[UIColor darkGrayColor]];
	[cell.detailTextLabel setHighlightedTextColor:[UIColor whiteColor]];
		
	
	
	
	[cell.textLabel setFont:[UIFont systemFontOfSize:12.0]];	
	[cell.textLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
	[cell.textLabel setTextColor:[UIColor blackColor]];

	[cell.textLabel setHighlightedTextColor:[UIColor whiteColor]];
	
	
	cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
	cell.imageView.image = event.thumbnail;
	//tableView.rowHeight = 150.0;
    
	return cell;

}

-(NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section
{
	return @"System Snapshots";  
	}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
}
		
/**
 Handle deletion of an event.
 */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		
       //First delete the document file
				
		
		// Delete the managed object at the given index path.
		NSManagedObject *eventToDelete = [eventsArray objectAtIndex:indexPath.row];
		Event *event = (Event *)[eventsArray objectAtIndex:indexPath.row];
		NSMutableString *photoFile = [NSMutableString stringWithString:event.document];
				
		fileManager = [NSFileManager defaultManager];
	
		//NSLog(@"remove1");
		//NSLog(photoFile);
		
		[fileManager removeItemAtPath:photoFile  error:NULL];
		
		[photoFile replaceOccurrencesOfString:@"-Small.png" withString:@".jpg"
									  options:NSLiteralSearch
										range:NSMakeRange(0U, [photoFile length])];
		
		//NSLog(@"remove2");
	//	NSLog(photoFile);
		
		[fileManager removeItemAtPath:photoFile  error:NULL];
		

		[managedObjectContext deleteObject:eventToDelete];
		
		// Update the array and table view.
        [eventsArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
		
		// Commit the change.
		NSError *error;
		if (![managedObjectContext save:&error]) {
			// Handle the error.
		}
    }   
}


#pragma mark -
#pragma mark Add an event

/**
 Add an event.
 */
- (void)addEvent {
	
	UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
	
	ipc.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
	ipc.mediaTypes =[UIImagePickerController availableMediaTypesForSourceType:ipc.sourceType];     
	ipc.delegate = self;
	ipc.allowsImageEditing = NO;
	[self presentModalViewController:ipc animated:YES];	
	
	
	}

-(IBAction)choosePic {
	UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
	ipc.sourceType =  UIImagePickerControllerSourceTypeCamera;
	ipc.mediaTypes =[UIImagePickerController availableMediaTypesForSourceType:ipc.sourceType];     
	ipc.delegate = self;
	ipc.allowsImageEditing = NO;
	[self presentModalViewController:ipc animated:YES];	
	
	
}

-(IBAction)takePic {
	
	UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
	ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
	ipc.mediaTypes =[UIImagePickerController availableMediaTypesForSourceType:ipc.sourceType];    
	ipc.delegate = self;
	ipc.allowsImageEditing = NO;
	
	[self presentModalViewController:ipc animated:YES];
}



-(id) initWithTabBar {
	if ([self init]) {
		//this is the label on the tab button itself
		self.title = @"Queue";
		
		//use whatever image you want and add it to your project
		self.tabBarItem.image = [UIImage imageNamed:@"Upcoming.png"];
		
		// set the long name shown in the navigation bar
		self.navigationItem.title=@"Smart Queue";
	}
	return self;
	
}


- (NSMutableString *) findUniqueSavePath
{
	int i = 1;
	NSMutableString *path; 
	do {
		// iterate until a name does not match an existing file
	    path = [NSMutableString stringWithFormat:@"%@/Documents/IMAGE_%04d.jpg", NSHomeDirectory(), i++];
	} while ([[NSFileManager defaultManager] fileExistsAtPath:path]);
	
	return path;
}

- (NSString *) findUniqueMoviePath
{
	int i = 1;
	NSString *path; 
	do {
		// iterate until a name does not match an existing file
	    path = [NSString stringWithFormat:@"%@/Documents/IMAGE_%04d.m4v", NSHomeDirectory(), i++];
	} while ([[NSFileManager defaultManager] fileExistsAtPath:path]);
	
	return path;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	
		Event *event = (Event *)[NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:managedObjectContext];
	
		
			 
	
	// Should be timestamp, but this will be constant for simulator.
	// [event setCreationDate:[location timestamp]];
	[event setCreationDate:[NSDate date]];
	
	// Commit the change.
	//NSError *error;
	//if (![managedObjectContext save:&error]) {
		// Handle the error
	//}
	
	
	/*
	 Since this is a new event, and events are displayed with most recent events at the top of the list,
	 add the new event to the beginning of the events array; then redisplay the table view.
	 */
    [eventsArray insertObject:event atIndex:0];
    [self.tableView reloadData];
	[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
	
	
	
	//Create a new photo object and associate it with the event.
	Photo *photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:event.managedObjectContext];
	event.photo = photo;
	NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
	if ([mediaType isEqualToString:@"public.image"]){
		//	UIImage *selectedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
		UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
		NSLog(@"found an image");
	// Set the image for the photo object.
	photo.image = image;
	
		NSMutableString *fFilePath = [self findUniqueSavePath];
		event.document = fFilePath;
		
		
		


		
		// Create a thumbnail version of the image for the event object.
		
		
		CGRect rect = CGRectMake(0.0, 0.0, 80, 80);
		
		UIGraphicsBeginImageContext(rect.size);
		[image drawInRect:rect];
		event.thumbnail = UIGraphicsGetImageFromCurrentImageContext();
		// Commit the change.
		NSError *error;
		if (![managedObjectContext save:&error]) {
			// Handle the error
		}
				
		    
		CGRect rectJpg = CGRectMake(0.0, 0.0, 320, 480);
		
		UIGraphicsBeginImageContext(rectJpg.size);
		[image drawInRect:rectJpg];
	
		
		     [UIImageJPEGRepresentation(UIGraphicsGetImageFromCurrentImageContext(), 0.9) writeToFile:fFilePath atomically:YES];
		
		
		     [fFilePath replaceOccurrencesOfString:@".jpg" withString:@"-Small.png"
									 options:NSLiteralSearch
									   range:NSMakeRange(0U, [fFilePath length])];
			//[UIImagePNGRepresentation(event.thumbnail) writeToFile:fFilePath atomically:YES];
		
		[UIImageJPEGRepresentation(event.thumbnail, 1.0) writeToFile:fFilePath atomically:YES];
		
			

	
	}
	
	
	
		[picker dismissModalViewControllerAnimated:YES];
}



#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	}

@end

