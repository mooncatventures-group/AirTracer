#import <Three20/Three20.h>
#import <fcntl.h>
#import <stdio.h> 
#import "Asl.h"


/*
 * a searchable model which can be configured with a 
 * loading and/or search time
 */
@interface Logger : NSObject <TTModel> {
  NSMutableArray* _delegates;
  NSMutableArray* _messages;
  NSArray* _allMessages;
  NSTimer* _searchTimer;
  NSTimeInterval _searchDuration;
  NSTimer* _loadingTimer;
  NSTimeInterval _loadingDuration;
}

@property(nonatomic,retain) NSArray* messages;
@property(nonatomic) NSTimeInterval searchDuration;
@property(nonatomic) NSTimeInterval loadingDuration;
+ (NSString *)typeStringForLevel:(NSUInteger)level;

+ (NSMutableArray*)loggerMessages;

- (id)initWithMessages:(NSArray*)messages;



- (void)search:(NSString*)text;

@end

@interface DataSource : TTSectionedDataSource {
  Logger* _logger;
}
@property(nonatomic,readonly) Logger* logger;


@end

@interface SearchDataSource : TTSectionedDataSource {
  Logger* _logger;
  NSString *_searchTerms; 
}
@property (nonatomic, retain) NSString *searchTerms;
@property(nonatomic,readonly) Logger* logger;

- (id)initWithDuration:(NSTimeInterval)duration;


@end
