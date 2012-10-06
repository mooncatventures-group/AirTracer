#import <Three20/Three20.h>

typedef enum {
    MenuPageNone
} MenuPage;


@interface TableDragRefreshController :  TTTableViewController <UISearchBarDelegate, TTTableViewDelegate> {
	UISearchBar *filterSearchBar;
    MenuPage _page; 
    IBOutlet UIButton *button;
}
@property (nonatomic, retain) UISearchBar *filterSearchBar;
@property(nonatomic) MenuPage page;
-(id)initWithTabBar;

@end

