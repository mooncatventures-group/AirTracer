//

#import "SFUSystemDetail.h"


@implementation SFUSystemDetail

- (void)setDetailType:(SFUDetailType)type {
	[super setDetailType:type];
	
	switch (type) {
		case NoneType:
			self.title = @"";
			break;
			
		case BurnabySystem:
			self.dataSource = [TTSectionedDataSource dataSourceWithObjects:
							   @"Burnaby System Information",
							   [TTTableGrayTextItem itemWithText:@"Registrar and Information Services: 3000 level, Maggie Benston Centre\nOffice Hours:\nMon - Thu: 9:00am - 6:00pm\nFri: 10:00am - 4:30pm\nPhone: (778)-782-4356\nFax: (778)-782-4969"],
							   [TTTableSubtitleItem itemWithText:@"Security" 
														subtitle:@"(778)-782-4500"
															 URL:@"tel:7787824500"],
							   [TTTableSubtitleItem itemWithText:@"Safe Walk" 
														subtitle:@"(778)-782-3100"
															 URL:@"tel:7787823100"],
							   [TTTableSubtitleItem itemWithText:@"Registrar" 
														subtitle:@"(778)-782-4356"
															 URL:@"tel:7787824356"],
							   [TTTableSubtitleItem itemWithText:@"Burnaby Road Conditions" 
														subtitle:@"http://www.sfu.ca/security/sfuroadconditions/"
															 URL:@"http://www.sfu.ca/security/sfuroadconditions/"],
							   @"",
							   [TTTableTextItem itemWithText:@"System Maps" URL:@"SFUBeedie://maps/1"],
							   @"Parking at SFU Burnaby",
							   [TTTableGrayTextItem itemWithText:@"Parking Services: West Mall Centre - Room 3110\n\nOffice Hours:\nWeekdays: 8:30am – 4:30pm\nPhone: (778)-782-5534\nFax: (778)-782-5386\nE-Mail: parking@sfu.ca"],
							   [TTTableSubtitleItem itemWithText:@"Parking Services" 
														subtitle:@"(778)-782-5534"
															 URL:@"tel:7787825534"],
							   [TTTableSubtitleItem itemWithText:@"Email Parking Services" 
														subtitle:@"parking@sfu.ca"
															 URL:@"mailto:parking@sfu.ca"],
							   [TTTableSubtitleItem itemWithText:@"Current Parking Rates" 
														subtitle:@"http://www.sfu.ca/security/Parking/New_Permit_Rates.html"
															 URL:@"http://www.sfu.ca/security/Parking/New_Permit_Rates.html"],
							   nil];
			break;
			
		case SurreySystem:
			self.dataSource = [TTSectionedDataSource dataSourceWithObjects:
							   @"Surrey System Information",
							   [TTTableGrayTextItem itemWithText:@"Registrar and Information Services:\nOffice Hours:\nMon: 10:00am - 4:30pm\nTue - Fri: 9:00am - 4:30pm\nPhone: (778)-782-7400\nFax: (778)-782-7403"],
							   [TTTableSubtitleItem itemWithText:@"Security" 
														subtitle:@"(778)-782-7511"
															 URL:@"tel:7787827511"],
							   [TTTableSubtitleItem itemWithText:@"Safe Walk" 
														subtitle:@"(778)-782-7070"
															 URL:@"tel:7787827070"],
							   [TTTableSubtitleItem itemWithText:@"Central City Mall Security" 
														subtitle:@"(604)-219-4066"
															 URL:@"tel:6042194066"],
							   [TTTableSubtitleItem itemWithText:@"Registrar" 
														subtitle:@"(778)-782-7400"
															 URL:@"tel:7787827400"],
							   @"",
							   [TTTableTextItem itemWithText:@"System Maps" URL:@"SFUBeedie://maps/2"],
							   @"Parking at SFU Surrey",
							   [TTTableGrayTextItem itemWithText:@"There are no parking privileges at Central City and the SFU Surrey System unless a valid decal is on display.\n\nThere is no free parking for SFU Surrey. Mall parking is for the use of retail shoppers only. All other vehicles will be ticketed or towed at the owner’s expense. The three hour time limit is posted for shoppers only. SFU students and visitors do not qualify in this category of parking.\n\nSFU Surrey has been provided a limited number of Surrey System parking decals for students. In order to obtain a decal a student must enter the parking lottery each term.\n\nVisitor parking is available on level P5 of the parkade for guests coming to SFU Surrey for lectures and special events. Weekdays parking costs $2.50 per hour from 6 til 6. Weekends the flat rate is $6 from 6 til 6. Monday thru Sunday from 6 til 6, flat rate of $4.00. Visitors are required to enter the stall number into the meter that is inside the stair/elevator vestibule on level P5. The meter accepts coins or credit cards. Voucher tickets are dispensed to be displayed on the dashboard of the vehicle.\n\nDiamond Parking patrols and enforces all parking areas at Central City.	 Vehicles with no paid voucher ticket or authorized parking decal will be ticketed. Violations cost $45 if paid within 10 days, and $60 if paid after 10 days."],
							   nil];
			break;
			
		case VancouverSystem:
			self.dataSource = [TTSectionedDataSource dataSourceWithObjects:
							   @"Vancouver System Information",
							   [TTTableGrayTextItem itemWithText:@"Registrar and Information Services:\nOffice Hours:\nMon - Thu: 10:00am - 7:00pm\nFri: 10:00am - 5:00pm\nPhone: (778)-782-5000\nFax: (778)-782-5060"],
							   [TTTableSubtitleItem itemWithText:@"Security" 
														subtitle:@"(778)-782-5252"
															 URL:@"tel:7787825252"],
							   [TTTableSubtitleItem itemWithText:@"Safe Walk" 
														subtitle:@"(777)-782-5029"
															 URL:@"tel:7787825029"],
							   [TTTableSubtitleItem itemWithText:@"Registrar" 
														subtitle:@"(778)-782-5000"
															 URL:@"tel:7787825000"],
							   @"",
							   [TTTableTextItem itemWithText:@"System Maps" URL:@"SFUBeedie://maps/3"],
							   @"Parking at SFU Vancouver",
							   [TTTableGrayTextItem itemWithText:@"Harbour Centre:\nNearby parking lots include the one beneath the Harbour Centre complex at 515 West Hastings (weekdays only after 6, all day Saturday and Sunday and statutory holidays) and the lot at 400 West Cordova . The 400 West Cordova lot offers reduced rates after 4 for students, faculty and staff with valid SFU identification or a parking pass available from Continuing Studies.\n\nMorris J Wosk Centre for Dialogue:\nThe most convenient parking is at the Conference Plaza (Segal Court at Seymour street).\n\nSegal Graduate School of Business:\nThe most convenient parking is at 443 Seymour (Pender at Seymour).\n\nAccessible Parking in Nearby Lots for the Harbour Centre System:\nAt this lot, there are three designated accessible parking stalls on levels P3 and P4. From there, the most convenient access to the System is to go up on the elevator one floor to level 5 (also called Bridge level) and enter via the Skybridge. The individual should call the Operations Department at (778)-782-7891 at least a day in advance. At this time we will determine an approximate time of arrival and exit, so that Security will be available."],
							   nil];
			break;
			
		case SchoolWide:
			self.title = @"Security & Conditions";
			self.dataSource = [TTSectionedDataSource dataSourceWithObjects:
							   @"System Security & Emergency Services",
							   [TTTableSubtitleItem itemWithText:@"Burnaby Security" 
														subtitle:@"(778)-782-4500"
															 URL:@"tel:7787824500"],
							   [TTTableSubtitleItem itemWithText:@"Surrey Security" 
														subtitle:@"(778)-782-7511"
															 URL:@"tel:7787827511"],
							   [TTTableSubtitleItem itemWithText:@"Central City Mall Security" 
														subtitle:@"(604)-219-4066"
															 URL:@"tel:6042194066"],
							   [TTTableSubtitleItem itemWithText:@"Vancouver Security" 
														subtitle:@"(778)-782-5252"
															 URL:@"tel:7787825252"],
							   @"System Road Conditons",
							   [TTTableSubtitleItem itemWithText:@"Burnaby Road Conditions" 
														subtitle:@"(604)-444-4929"
															 URL:@"tel:6044444929"],
							   [TTTableSubtitleItem itemWithText:@"Burnaby Road Conditions" 
														subtitle:@"http://www.sfu.ca/security/sfuroadconditions/"
															 URL:@"http://www.sfu.ca/security/sfuroadconditions/"],
							   [TTTableSubtitleItem itemWithText:@"Surrey Road Conditions" 
														subtitle:@"(778)-782-7511"
															 URL:@"tel:7787827511"],
							   [TTTableSubtitleItem itemWithText:@"Vancouver Road Conditions" 
														subtitle:@"(778)-782-5029"
															 URL:@"tel:7787825029"],
							   nil];
			break;
			
		case OtherType:
			self.title = @"SFU Info";
			self.dataSource = [TTSectionedDataSource dataSourceWithObjects:
							   @"SFU Student Services",
							   [TTTableSubtitleItem itemWithText:@"SFU Nightline" 
														subtitle:@"(604)-857-7148"
															 URL:@"tel:6048577158"],
							   [TTTableSubtitleItem itemWithText:@"Health & Counselling Services" 
														subtitle:@"(778)-782-4615"
															 URL:@"tel:7787824615"],
							   @"SFU Libraries",
							   [TTTableSubtitleItem itemWithText:@"Bennett Library (Burnaby)" 
														subtitle:@"(778)-782-3869"
															 URL:@"tel:7787823869"],
							   [TTTableSubtitleItem itemWithText:@"Fraser Library (Surrey)" 
														subtitle:@"(778)-782-7411"
															 URL:@"tel:7787827411"],
							   [TTTableSubtitleItem itemWithText:@"Belzberg Library (Vancouver)" 
														subtitle:@"(778)-782-5050"
															 URL:@"tel:7787825050"],
							   @"Work Integrated Learning (WIL)",
							   [TTTableSubtitleItem itemWithText:@"Career Services" 
														subtitle:@"(778)-782-3106"
															 URL:@"tel:7787823106"],
							   [TTTableSubtitleItem itemWithText:@"Co-Op & Volunteer Services" 
														subtitle:@"(778)-782-2667"
															 URL:@"tel:7787822667"],
							   @"SFU Recreation & Athletics",
							   [TTTableSubtitleItem itemWithText:@"SFU Recreation" 
														subtitle:@"(778)-782-4096"
															 URL:@"tel:7787824096"],
							   [TTTableSubtitleItem itemWithText:@"SFU Athletics" 
														subtitle:@"(778)-782-4056"
															 URL:@"tel:7787824056"],
							   [TTTableSubtitleItem itemWithText:@"University Life" 
														subtitle:@"(778)-782-2138"
															 URL:@"tel:7787822138"],
							   @"Other Services",
							   [TTTableSubtitleItem itemWithText:@"SFU International" 
														subtitle:@"(778)-782-4232"
															 URL:@"tel:7787824232"],
							   [TTTableSubtitleItem itemWithText:@"Residence & Housing Services" 
														subtitle:@"(778)-782-4201"
															 URL:@"tel:7787824201"],
							   nil];
							   
							   
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
							   [TTTableTextItem itemWithText:@"E-Mail" URL:@"http//"],
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
