//
//  XoomlNote.m
//  IdeaStock
//
//  Created by Ali Fathalian on 3/28/12.
//  Copyright (c) 2012 University of Washington. All rights reserved.
//

#import "XoomlNote.h"
#import "XoomlNoteParser.h"

@implementation XoomlNote
@synthesize noteText = _noteText;
@synthesize noteTextID = _noteID;
@synthesize  creationDate = _creationDate;
@synthesize modificationDate = _modificationDate;

//Factory method for creating a note by reading an XML file
//The returned note is a note with all the properties filled
+(XoomlNote *) xoomlNoteFromXML:(NSData *)xml{
    return [XoomlNoteParser xoomlNoteFromXML:xml];
}

//Constructor for creating an empty note with the creationDate
-(XoomlNote *) initWithCreationDate: (NSString *) date{
    XoomlNote * note = [[XoomlNote alloc] init];
    note.creationDate = date;
    return note;
}

-(NSData *) convertToXooml{
    return [XoomlNoteParser convertNoteToXooml: self];
    
}

- (NSString *) description{
    return self.noteText;
}
@end
