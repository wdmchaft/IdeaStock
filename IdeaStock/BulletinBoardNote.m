//
//  XoomlNote.m
//  IdeaStock
//
//  Created by Ali Fathalian on 3/28/12.
//  Copyright (c) 2012 University of Washington. All rights reserved.
//

#import "BulletinBoardNote.h"
#import "XoomlParser.h"

@implementation BulletinBoardNote
@synthesize noteText = _noteText;
@synthesize noteTextID = _noteID;
@synthesize  creationDate = _creationDate;
@synthesize modificationDate = _modificationDate;


//Constructor for creating an empty note with the creationDate
-(BulletinBoardNote *) initWithCreationDate: (NSString *) date{
    BulletinBoardNote * note = [[BulletinBoardNote alloc] init];
    note.creationDate = date;
    return note;
}


- (NSString *) description{
    return self.noteText;
}
@end
