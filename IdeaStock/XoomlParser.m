//
//  XoomlNoteParser.m
//  IdeaStock
//
//  Created by Ali Fathalian on 3/28/12.
//  Copyright (c) 2012 University of Washington. All rights reserved.
//

#import "XoomlParser.h"
#import "DDXML.h"
#import "XoomlAttributeHelper.h"

@interface XoomlParser()

@end

@implementation XoomlParser


#define NOTE_ID  @"ID"
#define NOTE_TEXT  @"displayText"
#define NOTE_CREATION_DATE @"createdOn"
#define NOTE_MODIFICATION_DATE @"modifiedOn"

+ (XoomlNote *) xoomlNoteFromXML:(NSData *)data{
    
    //open the XML document
    NSError *err = nil;
    DDXMLDocument * document = [[DDXMLDocument alloc] initWithData:data options:0 error:&err];
    
    //TODO right now im ignoring err. I should use it 
    //to determine the error
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
#define IDEA_STOCK_NAMESPACE @"http://ischool.uw.edu/xmlns/ideastock"
#define XOOML_SCHEMA_LOCATION @"http://kftf.ischool.washington.edu/xmlns/xooml http://kftf.ischool.washington.edu/XMLschema/0.41/XooML.xsd"
#define XOOML_SCHEMA_VERSION @"0.41"

#define XOOML_FRAGMENT @"xooml:fragment"
#define XOOML_ASSOCIATION @"xooml:association"

#define ATTRIBUTE_ID @"ID"
#define ATTRIBUTE_TYPE @"type"
#define ATTRIBUTE_NAME @"name"
#define ATTRIBUTE_TOOL @"toolName"
#define ATTRIBUTE_TOOL_VERSION @"toolVersion"



#define APP_NAME @"IdeaStock"
#define APP_VERSION @"0.1"

#define XOOML_NOTE_TOOL_ATTRIBUTE @"xooml:associationToolAttributes"
#define XOOML_BULLETINBOARD_TOOL_ATTRIBUTE @"xooml:fragmentToolAttributes"
#define ATTRIBUTE_NAME @"name"
#define NOTE_REF_ELEMENT_NAME @"is:note"
#define REF_ID @"refID"

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

+ (NSData *) getEmptyBulletinBoardXooml{
    //create the root element (xooml:fragment) and fill out its attributes
    DDXMLElement * root = 
    [[DDXMLElement alloc] initWithName: XOOML_FRAGMENT];
    
    [root addNamespace: [DDXMLNode namespaceWithName:@"xsi" stringValue: XSI_NAMESPACE]];
    [root addNamespace: [DDXMLNode namespaceWithName:@"xooml" stringValue: XOOML_NAMESPACE]];
    [root addNamespace: [DDXMLNode namespaceWithName:@"is" stringValue:IDEA_STOCK_NAMESPACE]];
    
    [root addAttribute: [DDXMLNode attributeWithName:@"xsi:schemaLocation" stringValue: XOOML_SCHEMA_LOCATION]];
    [root addAttribute: [DDXMLNode attributeWithName:@"schemaVersion" stringValue: XOOML_SCHEMA_VERSION]];
    [root addAttribute: [DDXMLNode attributeWithName:@"defaultApplication" stringValue:@""]];
    [root addAttribute: [DDXMLNode attributeWithName:@"relatedItem" stringValue:@""]];
    
    //because I can't use the method [[DDXMLDocument alloc] initWithRootElement:] 
    //since its not available in KissXML , I have to provide this hack
    //Make a string from the root element add XML headers to it, convert it to
    //data and initialize the document with that NSData
    NSString *xmlString = [root description];
    NSString *xmlHeader = XML_HEADER;
    xmlString = [xmlHeader stringByAppendingString:xmlString];
    
    return [xmlString dataUsingEncoding:NSUTF8StringEncoding];
}



/*xooml:associationToolAttributes xmlns="http://ischool.uw.edu/xmlns/ideastock"
ID="d391c321-4f25-4128-8a82-13dd5f268035" type="linkage" name="link1" toolName="IdeaStock"
toolVersion="0.1">*/
+ (DDXMLElement *) xoomlForAssociationToolAttributeWithName: (NSString *) attributeName 
                                         andType: (NSString *) attributeType{
    
    DDXMLElement *element = [DDXMLNode elementWithName:XOOML_NOTE_TOOL_ATTRIBUTE];
    
    [element addAttribute:[DDXMLNode attributeWithName:@"xmlns" stringValue:IDEA_STOCK_NAMESPACE]];
    [element addAttribute:[DDXMLNode attributeWithName:ATTRIBUTE_ID stringValue: [XoomlAttributeHelper generateUUID]]];
    [element addAttribute: [DDXMLNode attributeWithName:ATTRIBUTE_TYPE stringValue:attributeType]];
    [element addAttribute: [DDXMLNode attributeWithName:ATTRIBUTE_NAME stringValue:attributeName]];
    [element addAttribute: [DDXMLNode attributeWithName:ATTRIBUTE_TOOL stringValue:APP_NAME]];
    [element addAttribute: [DDXMLNode attributeWithName:ATTRIBUTE_TOOL_VERSION stringValue:APP_VERSION]];
    
    return  element;
}



+ (DDXMLElement *) xoomlForFragmentToolAttributeWithName: (NSString *) attributeName 
                                                 andType: (NSString *) attributeType{
    
    DDXMLElement *element = [DDXMLNode elementWithName:XOOML_BULLETINBOARD_TOOL_ATTRIBUTE];
    
    [element addAttribute:[DDXMLNode attributeWithName:@"xmlns" stringValue:IDEA_STOCK_NAMESPACE]];
    [element addAttribute:[DDXMLNode attributeWithName:ATTRIBUTE_ID stringValue: [XoomlAttributeHelper generateUUID]]];
    [element addAttribute: [DDXMLNode attributeWithName:ATTRIBUTE_TYPE stringValue:attributeType]];
    [element addAttribute: [DDXMLNode attributeWithName:ATTRIBUTE_NAME stringValue:attributeName]];
    [element addAttribute: [DDXMLNode attributeWithName:ATTRIBUTE_TOOL stringValue:APP_NAME]];
    [element addAttribute: [DDXMLNode attributeWithName:ATTRIBUTE_TOOL_VERSION stringValue:APP_VERSION]];
    
    return  element;

}
+ (DDXMLNode *) xoomlForNoteRef: (NSString *) refID{
    //make the note reference element
    DDXMLElement * noteRef = [DDXMLElement elementWithName:NOTE_REF_ELEMENT_NAME];
    DDXMLNode * attribute = [DDXMLElement attributeWithName:REF_ID stringValue:refID];
    [noteRef addAttribute: attribute];  
    return noteRef;
}

+ (NSString *) xPathforNote: (NSString *) noteID{
    return [NSString stringWithFormat:@"//xooml:association[@ID = \"%@\"]",noteID];
}

//xooml:fragmentToolAttributes[@type = "stacking" and @name="Stacking1"]
+ (NSString *) xPathForFragmentAttributeWithName: (NSString *) attributeName
                                         andType: (NSString *) attributeType{
    return [NSString stringWithFormat:@"//xooml:fragmentToolAttributes[@type = \"%@\" and @name=\"%@\"]", attributeType, attributeName];
}
////xooml:fragmentToolAttributes[@type = "stacking"]
+ (NSString *) xPathForBulletinBoardAttribute: (NSString *) attributeType{
    return [NSString stringWithFormat:@"//xooml:fragmentToolAttributes[@type = \"%@\"]", attributeType];
}

@end
