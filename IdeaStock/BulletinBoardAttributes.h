//
//  BulletinBoardAttributes.h
//  IdeaStock
//
//  Created by Ali Fathalian on 3/30/12.
//  Copyright (c) 2012 University of Washington. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * This is a class for holding all the attributes belonging to a bulletin board.
 * This attributes can belong to a single note or the whole bulletinBoard
 */


@interface BulletinBoardAttributes : NSObject

//returns all the attributes of Type attributeType as an NSDictionary keyed on
//attribute name
- (NSDictionary *) getAllAttributesForAttributeType: (NSString *) attributeType;

//returns an attribute with name of type attributetype. The return type is 
//an NSArray of noteIDs which are NSStrings
- (NSArray *) getAttributeWithName: (NSString *) attributeName
                  forAttributeType: (NSString *) attributeType;

//Creates and an empty attribute container for attribtue type of attribute type
- (void) createEmptyAttributeWithName: (NSString *) attributeName
                     forAttributeType:(NSString *) attributeType;

//adds a noteID to an attribute with the specified attribtueName and type
- (void) addNoteID: (NSString *) noteID 
       ToAttribute: (NSString *)attributeName
  forAttributeType: (NSString *) attributeType;

//removes a noteID from the attribute with name and type of attributeName and 
//attributeType
- (void) removeNoteID: (NSString *) noteID
        fromAttribute: (NSString *) attributeName
     forAttributeType: (NSString *) attributeType;

//removes the attribtue with name and type of attributeName and AttribtueType. Any noteID for that attribute name is also deleted
- (void) removeAttribute: (NSString *) attributeName
        forAttributeType: (NSString *)AttributeType;


@end
