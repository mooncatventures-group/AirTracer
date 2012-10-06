//
//  RootViewController.h
//  plist
//
//  Created by 藤川 宏之 on 08/08/17.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "procViewController.h"
#import "systemViewController.h"


@interface ProcessViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource> {
	IBOutlet UITableView *tableView;
	procViewController *procView;
	systemViewController *systemView;

}

-(void)info: (id)sender;

@end
