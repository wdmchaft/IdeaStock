//
//  BulletinBoardDelegate.h
//  IdeaStock
//
//  Created by Ali Fathalian on 4/1/12.
//  Copyright (c) 2012 University of Washington. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BulletinBoardDelegate <NSObject>

/*---------------------------------
 * Creation behavior
 *--------------------------------*/
/**---------------------------------
 * Deletion behavior
 *--------------------------------**/
/*---------------------------------
 * Updating behavior
 *--------------------------------**/
/**---------------------------------
 * Query behavior
 *--------------------------------**/

/*
 This method returns a property list of all the note's information at the 
 individual level. The property list is keyed on noteID and each value that
 is keyed is another dictionary containing a propert name and a property value
 
 The basic information include name, positionX, positionY, and isVisible.
 
 If a note does not have a required property the dictionary key for that will 
 be empty.
 
 For example;
 {noteID1 = {name = "Note1", PositionX = 200 , PositionY = 200, isVisible = true"}
 */
- (NSDictionary *) getNoteAllNoteBasicInformation;

/*
 Returns a property list of all the attributes of type attributeType for note
 with noteID. The property list is keyed on the attributeNames and for each
 attribute name the value is another property list containing (key,value) 
 pairs for that attribute. 
 
 If the note is not valid or does not contain any attribute of type 
 attributeType, the returned dictionary is empty. 
 
The caller is responsible for knowing all the information about the particular
 Attribute that he asked for and retrieving its individual parts.
 
 For example: 
 { linkage1 = {
 
 */
- (NSDictionary *) getAllNoteAttributeOfType: (NSString *) attributeType 
                                     ForNote: (NSString *) noteID;




@end
