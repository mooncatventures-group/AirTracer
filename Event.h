//
//  Event.h
//  Streams2
//
//  Created by Michelle on 11/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Photo;

@interface Event :  NSManagedObject  
{
}

@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) NSString * document;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) id thumbnail;
@property (nonatomic, retain) Photo * photo;

@end



