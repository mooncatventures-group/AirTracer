
#import "DataSource.h"

@interface Logger ()
- (void) loadMessages;

@end

///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation Logger

@synthesize messages = _messages, searchDuration = _searchDuration, loadingDuration = _loadingDuration;



///////////////////////////////////////////////////////////////////////////////////////////////////
// class public

+ (NSMutableArray*)loggerMessages {
    NSMutableArray *consoleLog = [NSMutableArray array];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *logFile = [documentsDirectoryPath  stringByAppendingPathComponent:@"logfile.html"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
   
    if ([fileManager fileExistsAtPath:logFile]) {
        [fileManager removeItemAtPath:logFile error:nil];
    }
    if (![fileManager createFileAtPath:logFile contents:nil attributes:nil]) {
        NSLog(@"Could not create file at %@", logFile);
    }

    NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:logFile];
    
    NSMutableString *outdata = [NSMutableString new];
        
    [outdata appendString:@"<!DOCTYPE HTML>\n<html>\n <head>\n"];
    [outdata appendString:@"<meta http-equiv='Content-Type' content='text/html; charset=UTF-8'>\n<title>Untitled Document</title>\n"];
    [outdata appendString:@" </head>\n<body>\n<table width='100%' border='1'>\n"];
    
    [fileHandle writeData:[outdata dataUsingEncoding:NSUTF8StringEncoding]];
           
    aslmsg query;
    query = asl_new (ASL_TYPE_QUERY);
    asl_set_query (query, ASL_KEY_SENDER, "", ASL_QUERY_OP_TRUE);
      // Perform the search.
    aslresponse results = asl_search (NULL, query);
    aslmsg message;
    NSString *string;
    NSString *envelope=@"";
    NSString *htmlelement=@"";
        while ((message = aslresponse_next(results))) {
        const char *key, *value;
        
        uint32_t i = 0;
        while ((key = asl_key (message, i))) {
            value = asl_get (message, key);
            //printf ("%u: %s -> %s\n", i, key, value);
           
            if (strcmp(key, "Time")==0) {
                NSString *nsdate = [NSString stringWithUTF8String:value]; 
                NSTimeInterval _interval=[nsdate doubleValue];
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
                NSDateFormatter *_formatter=[[NSDateFormatter alloc]init];
                [_formatter setDateFormat:@"EEE, dd MMMM yyyy HH:mm:ss"];
                NSString *_date=[_formatter stringFromDate:date];
                value = [_date cStringUsingEncoding:NSASCIIStringEncoding];
                string = [[NSString alloc] initWithFormat:@"%s ", value];
            }else{
                string = [[NSString alloc] initWithFormat:@"%s -> %s ",  key, value];
            }
        
            envelope = [envelope stringByAppendingString:string];
            i++;
        }
        [consoleLog addObject:envelope];
        
        
          htmlelement = [[NSString alloc] initWithFormat:@"<tr><td>%@</td></tr>\n",envelope];   
         [fileHandle writeData:[htmlelement dataUsingEncoding:NSUTF8StringEncoding]];
        envelope=@"";
        htmlelement=@"";
        
            
    }
    
    NSMutableString *enddata = [NSMutableString new];
    
    [enddata appendString:@"</body>\n</html>"];
        
    [fileHandle writeData:[enddata dataUsingEncoding:NSUTF8StringEncoding]];
    [fileHandle closeFile];

    return [[consoleLog reverseObjectEnumerator] allObjects];
   
   // return consoleLog;
}

const char *
fatalError(const char *string)
{
}

    
   

///////////////////////////////////////////////////////////////////////////////////////////////////
// private

- (void)loggerSearch:(NSString*)text {
  self.messages = [NSMutableArray array];

  if (text.length) {
    text = [text lowercaseString];
    for (NSString* name in _allMessages) {
      if ([[text lowercaseString] rangeOfString:text].location == 0) {
        [_messages addObject:name];
      }
    }
  }

  [_delegates perform:@selector(modelDidFinishLoad:) withObject:self];
}

- (void)searchReady:(NSTimer*)timer {
  _searchTimer = nil;

  NSString* text = timer.userInfo;
  [self loggerSearch:text];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// NSObject

- (id)initWithMessages:(NSArray*)messages {
  if (self = [super init]) {
    _delegates = nil;
    _allMessages = [messages copy];
    _messages = nil;
    _searchTimer = nil;
    _searchDuration = 0;
  }
  return self;
}

- (void)dealloc {
 
 

}

///////////////////////////////////////////////////////////////////////////////////////////////////
// TTModel

- (NSMutableArray*)delegates {
  if (!_delegates) {
    _delegates = TTCreateNonRetainingArray();
  }
  return _delegates;
}

- (BOOL)isLoadingMore {
  return NO;
}

- (BOOL)isOutdated {
  return NO;
}

- (BOOL)isLoaded {
  return !!_messages;
}

- (BOOL)isLoading {
  return !!_searchTimer || !!_loadingTimer;
}

- (BOOL)isEmpty {
  return !_messages.count;
}

- (void) loadingReady {
  _loadingTimer = nil;
    
  [self loadMessages];

  [_delegates perform:@selector(modelDidFinishLoad:) withObject:self];
}

- (void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more {
  [_delegates perform:@selector(modelDidStartLoad:) withObject:self];
  if (_loadingDuration) {
    TT_INVALIDATE_TIMER(_loadingTimer);
    _loadingTimer = [NSTimer scheduledTimerWithTimeInterval:_loadingDuration target:self
                                                       selector:@selector(loadingReady) userInfo:nil repeats:NO];
    [_delegates perform:@selector(modelDidStartLoad:) withObject:self];
  } else {
    [self loadMessages];
    [_delegates perform:@selector(modelDidFinishLoad:) withObject:self];
  }
}

- (void)invalidate:(BOOL)erase {
}

- (void)cancel {
  if (_searchTimer) {
    TT_INVALIDATE_TIMER(_searchTimer);
    [_delegates perform:@selector(modelDidCancelLoad:) withObject:self];
  } else if(_loadingTimer) {
    TT_INVALIDATE_TIMER(_loadingTimer);
    [_delegates perform:@selector(modelDidCancelLoad:) withObject:self];    
  }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// public

- (void)loadMessages {
 
  _messages = [Logger loggerMessages];
}

- (void)search:(NSString*)text {
  [self cancel];

 
  if (text.length) {
    if (_searchDuration) {
      TT_INVALIDATE_TIMER(_searchTimer);
      _searchTimer = [NSTimer scheduledTimerWithTimeInterval:_searchDuration target:self
                                selector:@selector(searchReady:) userInfo:text repeats:NO];
      [_delegates perform:@selector(modelDidStartLoad:) withObject:self];
    } else {
      [self loggerSearch:text];
      [_delegates perform:@selector(modelDidFinishLoad:) withObject:self];
    }
  } else {
    [_delegates perform:@selector(modelDidChange:) withObject:self];
  }
}

@end

///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation DataSource

@synthesize logger = _logger;


///////////////////////////////////////////////////////////////////////////////////////////////////
// NSObject

- (id)init {
  if (self = [super init]) {
    _logger = [[Logger alloc] initWithMessages:[Logger loggerMessages]];
    self.model = _logger;
  }
  return self;
}

- (void)dealloc {

 
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// UITableViewDataSource


///////////////////////////////////////////////////////////////////////////////////////////////////
// TTTableViewDataSource
- (void)tableViewDidLoadModel:(UITableView*)tableView {
    self.items = [NSMutableArray array];
  
    for (NSString* messages in _logger.messages) {
        
              
        TTStyledText* styledText = [TTStyledText textFromXHTML:
                                    [NSString stringWithFormat:@"%@<b></b>",
                                     [[messages stringByReplacingOccurrencesOfString:@"&"
                                                                            withString:@"&amp;"]
                                      stringByReplacingOccurrencesOfString:@"<"
                                      withString:@"&lt;"]]
                                                    lineBreaks:NO URLs:NO];
         
        // If this asserts, it's likely that the tweet.text contains an HTML character that caused
        // the XML parser to fail.
        
     
        [styledText setFont:[UIFont systemFontOfSize:12]];
        [styledText layoutIfNeeded];
        [_items addObject:[TTTableStyledTextItem itemWithText:styledText]];

        
        
       // TTTableItem* item = [TTTableTextItem itemWithText:messages];
       // [_items addObject:item];
    }
}


@end

///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation SearchDataSource

@synthesize logger = _logger;
@synthesize searchTerms = _searchTerms;

///////////////////////////////////////////////////////////////////////////////////////////////////
// NSObject

- (id)initWithDuration:(NSTimeInterval)duration {
  if (self = [super init]) {
    _logger = [[Logger alloc] initWithMessages:[Logger loggerMessages]];
    _logger.searchDuration = duration;
    self.model = _logger;
  }
  return self;
}

- (id)init {
  return [self initWithDuration:0];
}

- (void)dealloc {

}

///////////////////////////////////////////////////////////////////////////////////////////////////
// TTTableViewDataSource

- (void)tableViewDidLoadModel:(UITableView*)tableView {
  self.items = [NSMutableArray array];
  BOOL searching = (_searchTerms == nil || [_searchTerms length] == 0) ? FALSE : TRUE ;
  NSArray *terms = [_searchTerms componentsSeparatedByString: @" "];
  
    for (NSString* messages in _logger.messages) {
      
      
      if (searching) {
          BOOL found = FALSE;
          
          for(NSString *str in terms){
              
              // Search the body
              NSRange range = [[messages lowercaseString] rangeOfString:[str lowercaseString]];
              
              if (range.location != NSNotFound) {
                  found = TRUE;
                  break;
              }
              
              /* Search the name
               range = [[article.na lowercaseString] rangeOfString:[str lowercaseString]];
               
               if (range.location != NSNotFound) {
               found = TRUE;
               break;
               }
               */
          }
          if (!found) {
              continue;
          }
      }
      
 
      
      TTStyledText* styledText = [TTStyledText textFromXHTML:
                                  [NSString stringWithFormat:@"%@\n",
                                   [[messages stringByReplacingOccurrencesOfString:@"&"
                                                                          withString:@"&amp;"]
                                    stringByReplacingOccurrencesOfString:@"<"
                                    withString:@"&lt;"]]
                                                  lineBreaks:YES URLs:YES];
      // If this asserts, it's likely that the tweet.text contains an HTML character that caused
      // the XML parser to fail.
      TTDASSERT(nil != styledText);
      [_items addObject:[TTTableStyledTextItem itemWithText:styledText]];
  }
    
         
      
   // TTTableItem* item = [TTTableTextItem itemWithText:messages URL:@"http://google.com"];
   // [_items addObject:item];
 // }
}

- (void)search:(NSString*)text {
  [_logger search:text];
}

- (NSString*)titleForLoading:(BOOL)reloading {
  return @"Searching...";
}

- (NSString*)titleForNoData {
  return @"No names found";
}

@end
