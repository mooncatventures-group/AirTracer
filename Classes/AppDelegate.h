#import <Three20/Three20.h>
#import "TableDragRefreshController.h"
#import "System.h"
#import "ProcessViewController.h"
#import "process.h"
#import <assert.h>
#import <errno.h>
#import <stdbool.h>
#import <stdlib.h>
#import <stdio.h>
#import <sys/sysctl.h>
#import <sys/time.h>
#import <mach/host_info.h>
#import <mach/mach_init.h>
#import <mach/mach_host.h>
#import <SystemConfiguration/SystemConfiguration.h>

@class   HTTPServer;
@class TableDragRefreshController;
@interface AppDelegate : NSObject <UIApplicationDelegate>{
UIWindow *window;
HTTPServer *httpServer;
NSDictionary *addresses;
NSManagedObjectModel *managedObjectModel;
NSManagedObjectContext *managedObjectContext;	    
NSPersistentStoreCoordinator *persistentStoreCoordinator;
UITabBarController *tabBarController;
TTNavigator *navigationController;
TableDragRefreshController *albumController;
NSMutableArray *procs;

}
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@property (nonatomic, retain) UITabBarController *tabBarController;
@property (nonatomic, retain) TableDragRefreshController *albumController;
@property (nonatomic, retain) NSMutableArray *procs;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, readonly) NSString *applicationDocumentsDirectory;
- (void) startServer; 
- (void) stopServer; 
- (NSString *)displayInfoUpdate:(NSNotification *) notification;
-(void)getBSDProcessList;
-(System*)getBSDSystemResource;
-(void)setBSDMemoryResource: (System*)systemResource;
- (void)getNetworkInterfaceResource;



@end

