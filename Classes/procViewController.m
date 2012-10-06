#import "procViewController.h"
#import "AppDelegate.h"
#import <sys/sysctl.h>
#import <UIKit/UIDevice.h>
#import <pwd.h>
#include <mach/mach.h>
#include <mach/task_info.h>

@interface procViewController()
@property (nonatomic, retain) UITableView *tableView;
-(void)segAdjust;
@end;

@implementation procViewController
@synthesize tableView;
@synthesize selectedIndexPath;
@synthesize proc;
@synthesize segment;

#define localizedString(key, str) [[NSBundle mainBundle] localizedStringForKey: (key) value: (str) table: @"InfoPlist"]


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle 
                                                       *)nibBundleOrNil { 
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) 
    { 
        self.title = @"Processes"; 
        //self.navigationBarTintColor = [UIColor blackColor]; 
        UIImage* image = [UIImage imageNamed:@"settings.png"]; 
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:self.title 
                                                        image:image tag:0]; 
   		NSArray *segmentTextContent = [NSArray arrayWithObjects: localizedString(@"prev", @"prev"), localizedString(@"next", @"next"), nil];
		UISegmentedControl *seg = [[UISegmentedControl alloc] initWithItems: segmentTextContent];
		seg.frame = CGRectMake(0, 0, 86, 34);
		seg.segmentedControlStyle = UISegmentedControlStyleBar;
		[seg addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
		self.segment = seg;
		UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithCustomView: seg];
		self.navigationItem.rightBarButtonItem = button;
	}
	return self;
}

-(void)segAdjust {
	//NSLog(@"index:%d", selectedIndexPath.row);
	AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	if(selectedIndexPath.row == 0){
		[segment setEnabled: NO forSegmentAtIndex: 0];
	}else	{
		[segment setEnabled: YES forSegmentAtIndex: 0];
	}
	if((selectedIndexPath.row + 1) == appDelegate.procs.count){
		[segment setEnabled: NO forSegmentAtIndex: 1];
	}else	{
		[segment setEnabled: YES forSegmentAtIndex: 1];
	}
}

-(void)dealloc {
   
}


-(void)viewWillAppear:(BOOL)animated{
	// self.title = proc.name;
	AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	self.title = [NSString stringWithFormat: @"%d/%d", (self.selectedIndexPath.row + 1), appDelegate.procs.count];
	[self segAdjust];
	[tableView reloadData];

	struct extern_proc *kp_proc;
	task_t task;
	struct task_basic_info tinf;
	unsigned int count;
	kp_proc = proc.kp_proc;
	task_for_pid(mach_task_self(), kp_proc->p_pid, &task);
	count = TASK_BASIC_INFO_COUNT; task_info(task, TASK_BASIC_INFO, (task_info_t) &tinf, &count);
	NSLog(@"u=%d %d\n", tinf.user_time.seconds, tinf.user_time.microseconds);
	NSLog(@"s=%d %d\n", tinf.system_time.seconds, tinf.system_time.microseconds);
	NSLog(@"sz=%d %d\n", tinf.virtual_size, tinf.resident_size);

	{ 
		struct eproc *kp_eproc = proc.kp_eproc;
		struct extern_proc *kp_proc = proc.kp_proc;
				NSLog(@"kp_proc.user_stack :%d", kp_proc->user_stack );
	}

}

#pragma mark -
#pragma mark <UITableViewDelegate, UITableViewDataSource> Methods


-(NSInteger)numberOfSectionsInTableView:(UITableView*)tv {
	return 5;
}


- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
	
    switch (section) {
        case 0:	
			break;
        case 1:	
			break;
		case 2:	
			break;
        case 3:
			return 3;
			break;
        case 4:	
			return 3;
			break;
    }
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	struct extern_proc *kp_proc;
	struct eproc *kp_eproc;
	static NSString *MyIdentifier = @"MyIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:MyIdentifier];
    }
	
	kp_proc = proc.kp_proc;
	kp_eproc = proc.kp_eproc;
	
    switch (indexPath.section) {
        case 0:	
			cell.text = [proc name];
			break;
        case 1:	
			switch(kp_proc->p_stat){
				case SIDL : cell.text = localizedString(@"SIDL", @"IDLE"); break;
				case SRUN : cell.text = localizedString(@"SRUN", @"RUN"); break;
				case SSLEEP : cell.text = localizedString(@"SSLEEP", @"SLEEP"); break;
				case SSTOP : cell.text = localizedString(@"SSTOP", @"STOP"); break;
				case SZOMB : cell.text = localizedString(@"SZOMB", @"ZOMBIE"); break;
				default : cell.text = localizedString(@"nullstring", @"-");
			}
			break;
		case 2: {	
			
			NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
			[dateFormatter setDateStyle: NSDateFormatterNoStyle];
			[dateFormatter setTimeStyle: NSDateFormatterLongStyle];
			
			NSDate *date = [NSDate dateWithTimeIntervalSince1970: kp_proc->p_starttime.tv_sec];
			cell.text = [dateFormatter stringFromDate: date];
		} break;
        case 3:
			switch(indexPath.row){
				case 0 : cell.text = [NSString stringWithFormat: @"PID : %d", kp_proc->p_pid]; break;
				case 1 : cell.text = [NSString stringWithFormat: @"PPID : %d", kp_proc->p_oppid ]; break;
				case 2 : cell.text = [NSString stringWithFormat: @"PGID : %d", kp_eproc->e_pgid ]; break;
			}
			break;
        case 4:	
			switch(indexPath.row){
				case 0 : cell.text = [NSString stringWithFormat: @"RUID : %d", kp_eproc->e_pcred.p_ruid]; break;
				case 1 : cell.text = [NSString stringWithFormat: @"RGID : %d", kp_eproc->e_pcred.p_rgid]; break;
				case 2 : cell.text = [NSString stringWithFormat: @"EUID : %d", kp_eproc->e_ucred.cr_uid]; break;
			}
			break;
    }
    return cell;
}


- (NSString *)tableView:(UITableView *)tv titleForHeaderInSection:(NSInteger)section {
    switch (section) {
			
        case 0: return localizedString(@"prctag0", @"name");
        case 1: return localizedString(@"prctag1", @"running status");
        case 2: return localizedString(@"prctag2", @"start time");
        case 3: return localizedString(@"prctag3", @"process id");
        case 4: return localizedString(@"prctag4", @"user id");
    }
    return nil;
}


- (UITableViewCellAccessoryType)tableView:(UITableView *)tv accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 2:	
			return UITableViewCellAccessoryDetailDisclosureButton;
	}
    return UITableViewCellAccessoryNone;
}


- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 2:	{
			
			NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
			[dateFormatter setDateStyle: NSDateFormatterFullStyle];
			[dateFormatter setTimeStyle: NSDateFormatterFullStyle];
			
			NSDate *date = [NSDate dateWithTimeIntervalSince1970: proc.kp_proc->p_starttime.tv_sec];
			
			UIAlertView *openURLAlert = [[UIAlertView alloc] initWithTitle:localizedString(@"prctag2", @"start time") message: [dateFormatter stringFromDate:date] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
			
		}break;
	}
	return nil;
}

#pragma mark UISegmentedControl
- (void)segmentAction:(id)sender
{
	float	delay = 0.6;
	if([sender selectedSegmentIndex] == UISegmentedControlNoSegment){ return; }
	int	num = [self.selectedIndexPath row];
	UISegmentedControl *seg = self.segment;
	UIViewAnimationTransition transition;
	AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	switch([sender selectedSegmentIndex]){
		case 0: // up
			num--;
			if(num < 0){
				seg.selectedSegmentIndex = UISegmentedControlNoSegment;
				return;
			}
			delay = 0.8;
			transition = UIViewAnimationTransitionCurlDown;
			break;
		case 1: // down
			num++;
			if(num >= appDelegate.procs.count){
				seg.selectedSegmentIndex = UISegmentedControlNoSegment;
				return;
			}
			transition = UIViewAnimationTransitionCurlUp;
			break;
	}
	
	self.selectedIndexPath = [NSIndexPath indexPathForRow: num inSection: self.selectedIndexPath.section];
	self.proc = [appDelegate.procs objectAtIndex: num];
	[self segAdjust];

	UIView *view = self.view;
	UIView *superView = self.view.superview;
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration: delay];
	[UIView setAnimationTransition: transition forView:superView cache:YES];
	[self.view removeFromSuperview];
	[superView addSubview: view];
	[UIView commitAnimations];

	seg.selectedSegmentIndex = UISegmentedControlNoSegment;
	self.title = [NSString stringWithFormat: @"%d/%d", (self.selectedIndexPath.row + 1), appDelegate.procs.count];
	[tableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	//return (interfaceOrientation == UIInterfaceOrientationPortrait);
	return YES;
}

@end
