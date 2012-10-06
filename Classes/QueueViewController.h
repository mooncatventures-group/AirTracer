

#import "Photo.h"
@class EventTableViewCell;





@interface QueueViewController : UITableViewController < UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
	
    NSMutableArray *eventsArray;

	NSManagedObjectContext *managedObjectContext;	    
    UIBarButtonItem *addButton;
    NSFileManager *fileManager;

	
}

@property (nonatomic, retain) NSMutableArray *eventsArray;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;	 

	    	    

@property (nonatomic, retain) UIBarButtonItem *addButton;


-(id)initWithTabBar;


- (void)addEvent;
-(void)choosePic;



@end


