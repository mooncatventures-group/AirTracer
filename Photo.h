//
//  Photo.h
//  Streams2
//
//  Created by Michelle on 11/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Event;

@interface Photo :  NSManagedObject  
{
}

@property (nonatomic, retain) id image;
@property (nonatomic, retain) Event * event;

@end



