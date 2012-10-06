/*
 
     File: RootViewController.m
 Abstract: n/a
  Version: 1.1
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2010 Apple Inc. All Rights Reserved.
 
 
 */

#import "RootViewController.h"
#import "EADSessionController.h"
#import "AccessoryDetailViewController.h"
#import <ExternalAccessory/ExternalAccessory.h>

@implementation RootViewController

- (void)dealloc
{

}

- (void)viewDidLoad {
	/*
	UIBarButtonItem *debug = [[UIBarButtonItem alloc] initWithTitle:@"Debug" 
															  style:UIBarButtonItemStyleBordered target:self action:@selector(debugView:)];
    self.navigationItem.rightBarButtonItem = debug;
  	*/
    // Create the view that gets shown when no accessories are connected
    _noExternalAccessoriesPosterView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [_noExternalAccessoriesPosterView setBackgroundColor:[UIColor whiteColor]];
    _noExternalAccessoriesLabelView = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, 240, 50)];
    [_noExternalAccessoriesLabelView setText:@"No Accessories Connected"];
    [_noExternalAccessoriesPosterView addSubview:_noExternalAccessoriesLabelView];
    [[self view] addSubview:_noExternalAccessoriesPosterView];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_accessoryDidConnect:) name:EAAccessoryDidConnectNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_accessoryDidDisconnect:) name:EAAccessoryDidDisconnectNotification object:nil];
    [[EAAccessoryManager sharedAccessoryManager] registerForLocalNotifications];

    _eaSessionController = [EADSessionController sharedController];
    _accessoryList = [[NSMutableArray alloc] initWithArray:[[EAAccessoryManager sharedAccessoryManager] connectedAccessories]];

    [self setTitle:@"Accessories"];

    if ([_accessoryList count] == 0) {
        [_noExternalAccessoriesPosterView setHidden:NO];
    } else {
        [_noExternalAccessoriesPosterView setHidden:YES];
    }

    [super viewDidLoad];
}

- (void)viewDidUnload {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EAAccessoryDidConnectNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EAAccessoryDidDisconnectNotification object:nil];
   
    _accessoryList = nil;

   
    _selectedAccessory = nil;

    
    _protocolSelectionActionSheet = nil;

   

    [super viewDidUnload];
}


#pragma mark UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}




// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_accessoryList count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *eaAccessoryCellIdentifier = @"eaAccessoryCellIdentifier";
    NSUInteger row = [indexPath row];

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:eaAccessoryCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:eaAccessoryCellIdentifier];
    }

    NSString *eaAccessoryName = [[_accessoryList objectAtIndex:row] name];
    if (!eaAccessoryName || [eaAccessoryName isEqualToString:@""]) {
        eaAccessoryName = @"unknown";
    }

	[[cell textLabel] setText:eaAccessoryName];
   // cell.textLabel.text = [aService name];
    cell.detailTextLabel.text  = [NSString stringWithFormat:EAAccessoryKey];	
    cell.imageView.image = [UIImage imageNamed:@"Settings.png"]; 
    
    [cell.detailTextLabel setFont:[UIFont systemFontOfSize:10.0]];
    [cell.detailTextLabel setTextColor:[UIColor darkGrayColor]];
    [cell.detailTextLabel setHighlightedTextColor:[UIColor whiteColor]];
    [cell.textLabel setFont:[UIFont systemFontOfSize:12.0]];	
    [cell.textLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
    [cell.textLabel setTextColor:[UIColor blackColor]];
    [cell.textLabel setHighlightedTextColor:[UIColor whiteColor]];
    
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    

	
    return cell;
}
 
#pragma mark UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
      NSUInteger row = [indexPath row];
    AccessoryDetailViewController *sdvc = [[AccessoryDetailViewController alloc] initWithNibName:@"AccessoryViewController" bundle:nil];
     _selectedAccessory = [_accessoryList objectAtIndex:row];
    sdvc.selectedAccessory = _selectedAccessory;
    [self.navigationController pushViewController:sdvc animated:YES];
}


#pragma mark Internal

- (void)_accessoryDidConnect:(NSNotification *)notification {
    EAAccessory *connectedAccessory = [[notification userInfo] objectForKey:EAAccessoryKey];
    [_accessoryList addObject:connectedAccessory];

    if ([_accessoryList count] == 0) {
        [_noExternalAccessoriesPosterView setHidden:NO];
    } else {
        [_noExternalAccessoriesPosterView setHidden:YES];
    }

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:([_accessoryList count] - 1) inSection:0];
    [[self tableView] insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
}

- (void)_accessoryDidDisconnect:(NSNotification *)notification {
    EAAccessory *disconnectedAccessory = [[notification userInfo] objectForKey:EAAccessoryKey];

    if (_selectedAccessory && [disconnectedAccessory connectionID] == [_selectedAccessory connectionID])
    {
        [_protocolSelectionActionSheet dismissWithClickedButtonIndex:-1 animated:YES];
    }

    int disconnectedAccessoryIndex = 0;
    for(EAAccessory *accessory in _accessoryList) {
        if ([disconnectedAccessory connectionID] == [accessory connectionID]) {
            break;
        }
        disconnectedAccessoryIndex++;
    }
    
    

    if (disconnectedAccessoryIndex < [_accessoryList count]) {
        [_accessoryList removeObjectAtIndex:disconnectedAccessoryIndex];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:disconnectedAccessoryIndex inSection:0];
        [[self tableView] deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
	} else {
        NSLog(@"could not find disconnected accessory in accessory list");
    }

    if ([_accessoryList count] == 0) {
        [_noExternalAccessoriesPosterView setHidden:NO];
    } else {
        [_noExternalAccessoriesPosterView setHidden:YES];
    }
}

@end
