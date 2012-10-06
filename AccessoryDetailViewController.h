//
//

#import <UIKit/UIKit.h>
#import <ExternalAccessory/ExternalAccessory.h>

@interface AccessoryDetailViewController : UITableViewController {
    EAAccessory *_selectedAccessory;
    
}

@property (nonatomic, retain) EAAccessory *selectedAccessory;


@end
