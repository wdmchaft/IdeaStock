//  BulletinBoardDelegate.h
//  IdeaStock
//
//  Created by Ali Fathalian on 4/1/12.
//  Copyright (c) 2012 University of Washington. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 This protocol describes all the behavior that the bulletin board expects
 of a Xooml data to provide. 
 
 Any added functionality to the bulletin board should implement this protocol
 and add its own functionality to it.
 
 If you feel that the functionality to be added is abseloutly fundamental,
 feel free to add it here.
 
 */

//TODO the notes named with linkage, stacking, and grouping should be made private
//a function selector should be used in the public functions to select are run them
@protocol BulletinBoardDelegate <NSObject>

/*---------------------------------
 * Creation behavior
 *--------------------------------*/
/*
 Adds a note with properties specified in the properties dictioanry. 
 
 The required keys in this dictionary is "name" with the value
 of a string and "positionX" and "positionY" each with the value of String 
 that is an integer and "isVisible" with the value of a string that is true or
 false.
 
 The optional keys in this dictionary are linkage with the value of an NSDictionary
 with linkage names as the keys and an array of RefIds as the value.
 of RefIds which are strings each refrencing another note ID. 
 
 For example: 
 {name="Note4", ID="NoteID4", positionX= "100", positionY = "150", isVisible="true", linkage = {name="linkageName", refIDs = {NoteID1", "NoteID2"} , name=LinkageName2 = {NOTEDID3}}
 
 This method assumes that the noteIDs that may be passed in the linkage
 property are valid. 
 */
//TODO maybe the required properties should be passed as explicit attributes
//It is easy for the user of the API to make mistakes and not pass implicit
//properties

@required
- (void) addNoteWithID: (NSString *) id andProperties: (NSDictionary *)properties;

@optional

/*
 Creates an  attribute of the type attributeType for the note 
 with attributeName and noteID.
 
 This method just checks to see if attributeType is valid and based 
 on that calls an associated add method. 
 
 If the attributeName is invalid the method creates the attribute and then adds 
 the note to it. 
 
 If the attribute is position the values passed shuold be : 

 {positionX,positionY,isVisible}
 
 If the values is an empty array, this method only creates and empty attribute. 
 */

//TODO note position and other properties should be added here. 
- (void) addNoteAttribute: (NSString *) attributeName
                  forType: (NSString *) attributeType 
                  forNote: (NSString *)noteID 
               withValues:(NSArray *) values;

/*
 Creates an  attribute of the type attributeType for the note 
 with attributeName for the bulletinBoard.
 
 This method just checks to see if attributeType is valid and based 
 on that calls an associated add method. 
 
 If the attributeName is invalid the method creates the attribute. 
 
 If the values is an empty array, this method only creates and empty attribute. 
 */
- (void) addBulletinBoardAttribute: (NSString *) attributeName 
                           forType: (NSString *) attributeType 
                        withValues: (NSArray *) values;

/**---------------------------------
 * Deletion behavior
 *--------------------------------**/
/*
 Deletes the note with ID noteID from the bulletin board. Deleting the note
 includes removing any reference ID to it from the list of all the attribute
 values that point to it. 
 
 This deletion does not explicitly deletes the note from the data model but
 just deattaches it from the bulletin board. 
 
 If noteID is not a valid noteID this method returns without doing anything.
 */
@required
- (void) deleteNote: (NSString *) noteID;

/*
 Deletes the note specified by the target Note ID from the list of attributes with name
 and type attributeName and attributeType from sourceNoteID. 
 
 This method simply checks for the validity of attributeType and invokes the right delete
 method. 
 
 If the specified parameters are invalid the method returns without doing anything.
 */
@optional
- (void) deleteNote:(NSString *) targetNoteID 
  fromNoteAttribute: (NSString *) attributeName 
             ofType: (NSString *) attributeType 
            forNote: (NSString *) sourceNoteID;

/*
 Deletes the note specified by the noteID from the list of attributes with name
 and type attributeName and attributeType. 
 
 This method simply checks for the validity of attributeType and invokes the right delete
 method. 
 
 If the specified parameters are invalid the method returns without doing anything.
 */
@optional
-(void) deleteNote: (NSString *) noteID 
fromBulletinBoardAttribute: (NSString *) 
attributeName ofType:(NSString *) attributeType;

/*
 Deletes the note attribute with attributeName and attributeType from the 
 attributes of note with noteID
 
 This method simply checks for the validity of attributeType and invokes the right delete
 method. 
 
 Pay attention that a note Position cannot be deleted without deleting the entire note. 
 note position should be updated and will be deleted with note
 
 If the specified parameters are invalid the method returns without doing anything.
 */
@optional
- (void) deleteNoteAttribute: (NSString *) attributeName
                      ofType: (NSString *) attributeType 
                    fromNote: (NSString *) noteID;

/*
 Deletes the bulletin board attribute with attributeName and attributeType from the 
 attributes of the bulletin board. 
 
 This method simply checks for the validity of attributeType and invokes the right delete
 method. 
 
 If the specified parameters are invalid the method returns without doing anything.
 */
@optional
- (void) deleteBulletinBoardAttribute:(NSString *) attributeName 
                               ofType: (NSString *) attributeType;



/*---------------------------------
 * Updating behavior
 *--------------------------------**/

/*
 Updates the note with noteID with the new properties that are passed
 as newProperties. 
 
 This passed in properties may include only: "name", "positionX",
 "PositionY", and "isVisible". If any other property is passed in
 it will be ignored. 
 
 If the noteID is invalid the method returns without doing anything.
 */
@required
- (void) updateNote: (NSString *) noteID 
     withProperties: (NSDictionary *)  newProperties;

/* 
 Update the name of an attribute of type attributeType from old attributeName 
 to newAttributeName fot the note attribute of the note with noteID.
 
 This method just check the attributeType and calls the corresponding method 
 for it. 
 
 If noteID, attributeType, and oldAttributeName are invalid the method returns
 without doing anything. 
 */
@optional
- (void) updateNoteAttribute: (NSString *) oldAttributeName
                      ofType:(NSString *) attributeType 
                     forNote: (NSString *) noteID 
                 withNewName: (NSString *) newAttributeName;

/*
 Update the name of an attribute of type attributeType from old attributeName 
 to newAttributeName fot the bulletinboard.
 
 This method just checks the attributeType and calls the corresponding method 
 for it. 
 
 If attributeType, and oldAttributeName are invalid the method returns
 without doing anything. 
 */
@optional
- (void) updateBulletinBoardAttributeName: (NSString *) oldAttributeName
                                   ofType: (NSString *) attributeType 
                              withNewName: (NSString *) newAttributeName;

/*
 Update the the values of a note attribtue with the name attributeName and the
 type attributeType with newValues. 
 
 After this call the newValues will replace the oldValues. 
 
 This method just checks the attributeType and calls the corresponding method 
 for it. 
 
 If attributeType, and oldAttributeName are invalid the method returns
 without doing anything. 
 */
@optional
-(void) updateNoteAttribute: (NSString *) attributeName
                     ofType: (NSString *) attributeType 
                    forNote: (NSString *)noteID
                 withValues: (NSArray *) values;

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
 
 This method does not gurauntee that all the keys are present in the dictionary. 
 
 */
@required
- (NSDictionary *) getAllNoteBasicInfo;

/*
 Returns all the attributes of attributeType for the note with noteID
 
 The returned type is a NSDictionary keyed on attributeNames. the value for 
 each key is an array of noteIDs that belong to that attribute.
 
 
 For example: 
 {linkageName1 = {noteID1,noteID2}, linkageName2= {noteID2,noteID3}}
 
 
 If the noteID does not exist the method returns nil without doing anything.
 */

@optional
- (NSDictionary *) getNoteAttributeInfo: (NSString *) attributeType
                                forNote: (NSString *)noteID;

/*
 Returns all the attributes of attributeType for the bulletiboard
 
 The returned type is a NSDictionary keyed on attributeNames. the value for 
 each key is an array of noteIDs that belong to that attribute.
 
 
 For example: 
 {StackingName1 = {noteID1,noteID2}, StackingName2= {noteID2,noteID3}}
 
 
 If the noteID does not exist the method returns nil without doing anything.
 */
@optional
- (NSDictionary *) getBulletinBoardAttributeInfo: (NSString *) attributeType;


@end

