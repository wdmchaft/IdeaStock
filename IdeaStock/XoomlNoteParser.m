//
//  XoomlNoteParser.m
//  IdeaStock
//
//  Created by Ali Fathalian on 3/28/12.
//  Copyright (c) 2012 University of Washington. All rights reserved.
//

#import "XoomlNoteParser.h"
#import "DDXML.h"
#import "XoomlAttributeHelper.h"

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
    NSString * xPath = @"//xooml:association";
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
    note.noteTextID = [[noteXML attributeForName: NOTE_ID] stringValue];
    note.creationDate = [[noteXML attributeForName: NOTE_CREATION_DATE] stringValue];
    note.modificationDate = [[noteXML attributeForName:NOTE_MODIFICATION_DATE] stringValue];
    
    return note;

}

#define XML_HEADER @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
#define XSI_NAMESPACE @"http://www.w3.org/2001/XMLSchema-instance"
#define XOOML_NAMESPACE @"http://kftf.ischool.washington.edu/xmlns/xooml"
#define XOOML_SCHEMA_LOCATION @"http://kftf.ischool.washington.edu/xmlns/xooml http://kftf.ischool.washington.edu/XMLschema/0.41/XooML.xsd"
#define XOOML_SCHEMA_VERSION @"0.41"

#define XOOML_FRAGMENT @"xooml:fragment"
#define XOOML_ASSOCIATION @"xooml:association"

#define APP_NAME @"IdeaStock"
+ (NSData *) convertNoteToXooml: (XoomlNote *) note{
    
    //create the root element (xooml:fragment) and fill out its attributes
    DDXMLElement * root = [[DDXMLElement alloc] initWithName: XOOML_FRAGMENT];
    
    [root addNamespace: [DDXMLNode namespaceWithName:@"xsi" stringValue: XSI_NAMESPACE]];
    [root addNamespace: [DDXMLNode namespaceWithName:@"xooml" stringValue: XOOML_NAMESPACE]];
    [root addAttribute: [DDXMLNode attributeWithName:@"xsi:schemaLocation" stringValue: XOOML_SCHEMA_LOCATION]];
    [root addAttribute: [DDXMLNode attributeWithName:@"schemaVersion" stringValue: XOOML_SCHEMA_VERSION]];
    [root addAttribute: [DDXMLNode attributeWithName:@"defaultApplication" stringValue:@""]];
    [root addAttribute: [DDXMLNode attributeWithName:@"relatedItem" stringValue:@""]];
    
    //TODO Add tool specific child of the root here 
    
    //create the association note and its attributes
    DDXMLElement * xoomlAssociation = [[DDXMLElement alloc] initWithName: XOOML_ASSOCIATION];
    [xoomlAssociation addAttribute:[DDXMLNode attributeWithName:@"ID" stringValue:note.noteTextID]];
    [xoomlAssociation addAttribute:[DDXMLNode attributeWithName:@"associatedItem" stringValue:@""]];
    [xoomlAssociation addAttribute:[DDXMLNode attributeWithName:@"associatediIcon" stringValue:@""]];
    [xoomlAssociation addAttribute:[DDXMLNode attributeWithName:@"associatedXooMLFragment" stringValue:@""]];
    [xoomlAssociation addAttribute:[DDXMLNode attributeWithName:@"levelOfSynchronization" stringValue:@""]];
    [xoomlAssociation addAttribute:[DDXMLNode attributeWithName:@"displayText" stringValue:note.noteText]];
    [xoomlAssociation addAttribute:[DDXMLNode attributeWithName:@"openWithDefault" stringValue:@""]];
    [xoomlAssociation addAttribute:[DDXMLNode attributeWithName:@"createdBy" stringValue:APP_NAME]];
    [xoomlAssociation addAttribute:[DDXMLNode attributeWithName:@"createdOn" stringValue:note.creationDate]];
    [xoomlAssociation addAttribute:[DDXMLNode attributeWithName:@"modifiedBy" stringValue:APP_NAME]];
    [xoomlAssociation addAttribute:[DDXMLNode attributeWithName:@"modifiedOn"stringValue:note.modificationDate]];

    //TODO Add tool specific child of the association here
    
    //Add association as a chile of root
    [root addChild:xoomlAssociation];
    
    //create the xml string by appending standard xml headers
    NSString *xmlString = [root description];
    NSString *xmlHeader = XML_HEADER;
    xmlString = [xmlHeader stringByAppendingString:xmlString];
    
    return [xmlString dataUsingEncoding:NSUTF8StringEncoding];

    
}


@end
