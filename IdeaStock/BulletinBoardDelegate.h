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
 
 The optional keys in this dictionary are linkage with the value of an NSArray
 of RefIds which are strings each refrencing another note ID. 
 
 For example: 
 {name="Note4", ID="NoteID4", positionX= "100", positionY = "150", isVisible="true", Linkage = {"NoteID1", "NoteID2"}}
 
 This method assumes that the noteIDs that may be passed in the linkage
 property are valid. 
 */
//TODO maybe the required properties should be passed as explicit attributes
//It is easy for the user of the API to make mistakes and not pass implicit
//properties

@required
- (void) addNoteWithID: (NSString *) id andProperties: (NSDictionary *)properties;

/*
 Adds a linkage to note with noteID to note with note refID
 
 If the noteID is not valid this method returns without doing anything. 
 
 This method assumes that refNoteID is a valid refID. 
 */

@optional
- (void) addLinkage: (NSString *) linkageName
             ToNote: (NSString *) noteID
WithReferenceToNote: (NSString *) refNoteID;

/*
 Adds a stacking property with stackingName and the notes that are specified
 in the array note. 
 
 The array notes contains a list of noteIDs. 
 
 The method assumes that the stackingName is unique and if there exists
 another stacking with the same name adds it anyways. 
 
 Th method assumes the noteIDs passed in the NSArray notes are valid existing
 refNoteIDs. 
 */
@optional
- (void) addStackingWithName: (NSString *) stackingName
                   withNotes: (NSArray *) notes;
/*
 Adds a grouping property with groupingName and the notes that are specified
 in the array note. 
 
 The array notes contains a list of noteIDs. 
 
 The method assumes that the groupingName is unique and if there exists
 another grouping with the same name adds it anyways. 
 
 Th method assumes the noteIDs passed in the NSArray notes are valid existing
 refNoteIDs. 
 */
@optional
- (void) addGroupingWithName: (NSString *) groupingName
                   withNotes: (NSArray *) notes;

/*
 Adds a note with noteID to the stacking with stackingName. 
 
 If a stacking with stackingName does not exist, this method returns without
 doing anything. 
 
 This method assumes that the noteID is a valid noteID. 
 
 This method assumes that stackingName is unique. If there are more than
 one stacking with the stackingName it adds the note to the first stacking.
 */
@optional
- (void) addNote: (NSString *) noteID
      toStacking: (NSString *) stackingName;


/*
 Adds a note with noteID to the grouping with groupingName. 
 
 If a grouping with groupingName does not exist, this method returns without
 doing anything. 
 
 This method assumes that the noteID is a valid noteID. 
 
 This method assumes that groupingName is unique. If there are more than
 one grouping with the groupingName it adds the note to the first stacking.
 */
@optional
- (void) addNote: (NSString *) noteID
      toGrouping: (NSString *) groupingName;

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
 Deletes the linkage with linkageName for the note with NoteID. 
 
 Deleting the linkage removes all the notes whose refIDs appear in the linakge.
 
 If the noteID or the linkageName are invalid. This method returns without
 doing anything. 
 */
@optional
- (void) deleteLinkage: (NSString *) linkageName 
               forNote: (NSString *)noteID;
/*
 Delete the note with noteRefID from the linkage with linkageName belonging
 to the note with noteID.
 
 If the noteID, noteRefID, or linkageName are invalid this method returns
 without doing anything. 
 */
@optional
- (void) deleteNote: (NSString *) noteRefID
        fromLinkage: (NSString *)linkageName
            forNote: (NSString *) noteID;
/*
 Deletes the stacking with stackingName from the bulletin board. 
 
 This deletion removes any notes that the stacking with stackingName 
 refered to from the list of its attributes. 
 
 If the stackingName is invalid this method returns without doing anything.
 */
@optional
- (void) deleteStacking: (NSString *) stackingName;

/*
 Deletes the note with noteID from the stacking with stackingName. 
 
 If the stackingName or noteID are invalid this method returns without
 doing anything.
 */
@optional
- (void) deleteNote: (NSString *) noteID
       fromStacking: (NSString *) stackingName;
/*
 Deletes the grouping with groupingName from the bulletin board. 
 
 This deletion removes any notes that the grouping with grouping 
 refered to from the list of its attributes. 
 
 If the groupingName is invalid this method returns without doing anything.
 */
@optional
- (void) deleteGrouping: (NSString *) groupingName;

/*
 Deletes the note with noteID from the grouping with groupingName. 
 
 If the groupingName or noteID are invalid this method returns without
 doing anything.
 */
@optional
- (void) deleteNote: (NSString *) noteID
        fromGroupin: (NSString *) groupingName;
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
 updates the name of linkage for note with noteID from linkageName
 to newLinkageName. 
 
 If the noteID or linkageName are invalid the method returns without 
 doing anything. 
 */
@optional
- (void) updateLinkageName: (NSString *) linkageName
                   forNote: (NSString *) noteID
               withNewName: (NSString *) newLinkageName;

/*
 Updates the name of a bulletin board stacking from stacking to 
 newStackingName. 
 
 If the stackingName is invalid the method returns without doing anything.
 */
@optional
- (void) updateStackingName: (NSString *) stackingName
                withNewName: (NSString *) newStackingName;
/*
 Updates the name of a bulletin board grouping from groupingName to 
 newGroupingName. 
 
 If the groupingName is invalid the method returns without doing anything.
 */
@optional
- (void) updateGroupingName: (NSString *) groupingName
                withNewName: (NSString *) newGroupingName;
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
 Returns all the linkage info for the note with noteID.
 
 A linkage info contains a name, an and an array of noteIDs that are linked
 to that note. These are expressed as two keys name and refIDs.
 
 For example: 
 {name="linkage1", refIDs = {"NoteID2","NoteID3"}}
 
 The burden for the linkage to be describe correctly (both in the linker and
 linkee note attributes) is on the xooml file. 
 
 If the noteID does not exist the method returns nil without doing anything.
 */
@optional
- (NSDictionary *) getLinkageInfoForNote: (NSString *) noteID;

/*
 Returns all the stacking info for the bulletin board.
 
 A stacking info contain name of the stacking and an array of noteIDs that
 belong to that stacking. These are expressed as two keys name and refIDs.
 
 For Example: 
 {name="Stacking1", refIDs = {"NoteID2", "NoteID3"}}
 
 If no stacking infos exist the dictionary will be empty. 
 
 The method assumes that each stacking is uniquely identified with its name.
 As a result it only returns the first stacking with a given name and ignores 
 the rest. 
 */
@optional
- (NSDictionary *) getStackingInfo;

/*
 Returns all the grouping info for the bulletin board.
 
 A grouping info contain name of the grouping and an array of noteIDs that
 belong to that grouping. These are expressed as two keys name and refIDs.
 
 For Example: 
 {name="Grouping1", refIDs = {"NoteID2", "NoteID3"}}
 
 If no grouping infos exist the dictionary will be empty. 
 
 The method assumes that each grouping is uniquely identified with its name.
 As a result it only returns the first grouping with a given name and ignores 
 the rest. 
 */
@optional
- (NSDictionary *) getGroupingInfo;

@end

