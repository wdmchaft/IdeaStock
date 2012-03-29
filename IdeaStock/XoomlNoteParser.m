//
//  XoomlNoteParser.m
//  IdeaStock
//
//  Created by Ali Fathalian on 3/28/12.
//  Copyright (c) 2012 University of Washington. All rights reserved.
//

#import "XoomlNoteParser.h"
#import "DDXML.h"

@implementation XoomlNoteParser


#define NOTE_ID  @"ID"
#define NOTE_TEXT  @"displayText"
#define NOTE_CREATION_DATE @"createdOn"
#define NOTE_MODIFICATION_DATE @"modifiedOn"

+ (XoomlNote *) XoomlNoteFromXML:(NSData *)data{
    
    //open the XML document
    NSError *err = nil;
    DDXMLDocument * document = [[DDXMLDocument alloc] initWithData:data options:0 error:&err];
    
    if (document == nil){
        NSLog(@"Error reading the note XML File");
        return nil;
    }
    
    //get the note fragment using xpath
    NSString * xPath = @"./xooml:association";
    NSArray *notes = [document nodesForXPath: xPath error: &err];
    if (notes == nil){
        NSLog(@"Error reading the content from XML");
        return nil;
    }
    if ([notes count] == 0 ){
        NSLog(@"No Note Content exist for the given note");
        return nil;
    }

    DDXMLElement * noteXML = (DDXMLElement *)[notes objectAtIndex:0];

    //TODO handle tool specific note properties by looking up the child nodes of the noteXML here
    
    //get note properties from the attributes
    XoomlNote * note = [[XoomlNote alloc] init];
    note.noteText = [[noteXML attributeForName: NOTE_TEXT] stringValue];
    note.noteID = [[noteXML attributeForName: NOTE_ID] stringValue];
    note.creationDate = [[noteXML attributeForName: NOTE_CREATION_DATE] stringValue];
    note.modificationDate = [[noteXML attributeForName:NOTE_MODIFICATION_DATE] stringValue];
    
    return note;

}
@end
