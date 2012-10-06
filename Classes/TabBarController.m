#import "TabBarController.h"

@implementation TabBarController

///////////////////////////////////////////////////////////////////////////////////////////////////
// UIViewController


- (void)viewDidLoad { 
    [self setTabURLs:[NSArray arrayWithObjects:@"tt://FirstItem/Launcher", 
                      @"tt://SecondItem/PrcTable",
                      @"tt://ThirdItem/QvcTable", 
                      @"tt://FourthItem/System",
                                          nil]]; 

}
@end
