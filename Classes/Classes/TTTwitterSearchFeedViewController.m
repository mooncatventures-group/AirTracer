//
// Copyright 2009-2011 Facebook
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "TTTwitterSearchFeedViewController.h"

#import "TTTwitterSearchFeedDataSource.h"


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation TTTwitterSearchFeedViewController


///////////////////////////////////////////////////////////////////////////////////////////////////

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle 
                                                       *)nibBundleOrNil { 
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) 
    { 
        self.title = @"Chat"; 
        //self.navigationBarTintColor = [UIColor blackColor]; 
        UIImage* image = [UIImage imageNamed:@"chat.png"]; 
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:self.title 
                                                        image:image tag:0]; 
    } 
    return self; 
} 


- (id)initWithFeed:(FeedPage)page {
    if (self = [super init]) {
        self.page = page;
    }
    return self;
}

- (void)setPage:(FeedPage)page {
    _page = page;
    
    self.title = @"Share";
    UIImage* image = [UIImage imageNamed:@"tab.png"];
    self.tabBarItem = [[UITabBarItem alloc] initWithTitle:self.title image:image tag:0];
    
}




///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)createModel {
  self.dataSource = [[TTTwitterSearchFeedDataSource alloc]
                      initWithSearchQuery:@"michelle_cat"];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id<UITableViewDelegate>)createDelegate {
  return [[TTTableViewDragRefreshDelegate alloc] initWithController:self];
}


@end

