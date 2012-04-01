//
//  XoomlNoteParser.h
//  IdeaStock
//
//  Created by Ali Fathalian on 3/28/12.
//  Copyright (c) 2012 University of Washington. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XoomlNote.h"
#import "XoomlBulletinBoard.h"
#import "BulletinBoardAttributes.h"
@interface XoomlNoteParser : NSObject

+ (XoomlNote *) xoomlNoteFromXML: (NSData *)data;
+ (XoomlBulletinBoard *) xoomlBulletinBoardFromXML: (NSData *)data;
+ (NSData *) convertNoteToXooml: (XoomlNote *) note;
+ (NSData *) convertBulletinBoardToXooml: (XoomlBulletinBoard *) board;

@end
