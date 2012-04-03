//
//  XoomlNoteParser.h
//  IdeaStock
//
//  Created by Ali Fathalian on 3/28/12.
//  Copyright (c) 2012 University of Washington. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XoomlNote.h"
#import "AssociativeBulletinBoard.h"
#import "BulletinBoardAttributes.h"

/*
 This is helper that handles parsing and working 
 with Xooml syntax
 */
@interface XoomlParser : NSObject


/*
 Create a note object from the contents of Xooml file
 specified in data
 */
//TODO maybe I should just return NSData * here too.
+ (XoomlNote *) xoomlNoteFromXML: (NSData *)data;

/*
 Converst the contents of a note object to Xooml xml data
 */
+ (NSData *) convertNoteToXooml: (XoomlNote *) note;

/*
 Creates the boilerplate Xooml bulletin baord document
 and returns it as NSData
 */
+ (NSData *) getEmptyBulletinBoardXooml;


@end
