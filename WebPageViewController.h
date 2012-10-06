//
//  WebPageViewController.h
//  BonjourWebBrowser
//

#import <UIKit/UIKit.h>



@interface WebPageViewController : UIViewController <UIWebViewDelegate> {
	IBOutlet UIWebView *webView;
	IBOutlet UILabel *urlLabel;
	IBOutlet UIActivityIndicatorView *resolutionActivityIndicator;
	NSMutableData *responseData;
	NSString *urlString;
	
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil netService:(NSNetService *)discoveredService;

@end
