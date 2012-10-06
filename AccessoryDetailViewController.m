//
//  ServiceDetailViewController.m
//  BonjourBrowser
//
//  Created by Justin Munger on 3/19/11.
//  Copyright 2011 Berkshire Software, LLC. All rights reserved.
//

#import "AccessoryDetailViewController.h"



@interface AccessoryDetailViewController () 


@end


@implementation AccessoryDetailViewController

@synthesize selectedAccessory = _selectedAccessory;

#pragma mark - 
#pragma mark View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.selectedAccessory.name;
   
    
  }

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   }

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Allow all orientations
    return YES;
}

- (void)dealloc
{
  
    
}

#pragma mark - 
#pragma mark UITableViewDataSource methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    int numberOfRows = 0;
    
    switch (section) {
        case 0:
            numberOfRows = 4;
            break;
        case 1:
            numberOfRows = 5;
            break;
        case 2:
        {
            numberOfRows = 0;
            if ([self.selectedAccessory protocolStrings] != nil) {
                numberOfRows = [[self.selectedAccessory protocolStrings] count];
            }
        }
            break;
        default:
            break;
    }
    
    return numberOfRows;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{
    NSString *headerName = @"";
    
    switch (section) {
        case 0:
            headerName = @"Accessory Information";
            break;
        case 1:
            headerName = @"Manufacturer Information";
            break;
        case 2:
            if ([self tableView:tableView numberOfRowsInSection:section] != 0) {
                headerName = @"Discovered Protocols";
            }
            break;
    }
    
    return headerName;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Value1CellIdentifier = @"Value1Cell";
    static NSString *DefaultCellIdentifier = @"DefaultCell";
    
    UITableViewCell *cell = nil;
    
    switch (indexPath.section) {
        case 0:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:Value1CellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:Value1CellIdentifier];
            }

            cell.textLabel.text = @"";
            cell.detailTextLabel.text = @"";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"Device Name";
                    cell.detailTextLabel.text = self.selectedAccessory.name;
                     cell.userInteractionEnabled = NO;
                    break;
                case 1:
                  //  cell.textLabel.text = @"Description";
                    cell.width=300;
                     cell.textLabel.text = self.selectedAccessory.description;
                     cell.userInteractionEnabled = NO;
                    break;
                case 2: 
                   // cell.textLabel.text = @"Debug Description";
                    cell.textLabel.text = self.selectedAccessory.debugDescription;
                     cell.userInteractionEnabled = NO;
                    break;
                case 3:
                    cell.textLabel.text = @"Connection Id";
                    cell.detailTextLabel.text =  [NSString stringWithFormat:@"%d",self.selectedAccessory.connectionID];
                    cell.userInteractionEnabled = NO;
                    break;
                    default:
                    break;
            }
        }
            break;
        case 1:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:DefaultCellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:DefaultCellIdentifier];
            }
            
            cell.textLabel.text = @"";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"Manufacturer";
                    cell.detailTextLabel.text = self.selectedAccessory.manufacturer;
                    cell.userInteractionEnabled = NO;
                    break;
                case 1:
                    cell.textLabel.text = @"Model Number";
                    cell.detailTextLabel.text = self.selectedAccessory.modelNumber;
                    cell.userInteractionEnabled = NO;
                    break;
                case 2: 
                    cell.textLabel.text = @"Serial Number";
                    cell.detailTextLabel.text = self.selectedAccessory.serialNumber;
                    cell.userInteractionEnabled = NO;
                    break;
                case 3:
                    cell.textLabel.text = @"Firmware Revision";
                    cell.detailTextLabel.text =  self.selectedAccessory.firmwareRevision;
                    cell.userInteractionEnabled = NO;
                    break;
                case 4:
                    cell.textLabel.text = @"Hardware Revision";
                    cell.detailTextLabel.text = self.selectedAccessory.hardwareRevision;
                    cell.userInteractionEnabled = NO;
                    break;
                    default:
                    break;
            }

            
        }
            break;
        case 2:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:Value1CellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:Value1CellIdentifier];
            }
            
            cell.textLabel.text = @"";
            cell.detailTextLabel.text = @""; 
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            if ([[self.selectedAccessory protocolStrings]count] != 0) {
                int i=0;
                for(NSString *s in self.selectedAccessory.protocolStrings)
                        {
                        cell.textLabel.text =  [NSString stringWithFormat:@"Protocol String %d",i++];
                        cell.detailTextLabel.text = s;
                        cell.userInteractionEnabled = NO;

                        }
                    }
                    
        }
            break;
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  }

	






#pragma mark - 
#pragma mark UITableViewDelegate methods
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.textLabel.font = [UIFont systemFontOfSize:12.0];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12.0];
}

@end
