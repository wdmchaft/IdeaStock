//
//  DataModel.h
//  IdeaStock
//
//  Created by Ali Fathalian on 3/28/12.
//  Copyright (c) 2012 University of Washington. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BulletinBoard.h"
#import "Note.h"

/**
 * The protocol for the datamodel. Includes essential behaviors for working 
 with bulletin boards and notes. 
 */
@protocol DataModel <NSObject>

@required


/*----------------------
 Creation Behavior
 ----------------------*/

/*
 Adds a bulletin board with all of its note content to the data model. 
 
 Since notes are stored as separate entities, the implementation should 
 provide for recursive writing of all the notes in the bulletin board. 
 
 This method assumes that the content passed to it as NSData is verified 
 and is valid.
 */
- (void) addBulletinBoardWithName: (NSString *) bulletinBoardName
             andBulletinBoardInfo: (NSData *) content;

/*
 Adds one note with name noteName and content note to the bulletinBoard
 with bulletinBoardName
 
 If the bulletinBoard specified by bulletinBoard does not exist, the method
 returns without doing anything. 
 
 This method assumes that the content passed to it as NSData is verified 
 and is valid.
 */
- (void) addNote: (NSString *)noteName 
     withContent: (NSData *) note 
 ToBulletinBoard: (NSString *) bulletinBoardName; 


/*----------------------
 Update Behavior
 -----------------------*/

//Right now  the data model provides no explicit update. 
//Update should be done by using deletion and creation behavior
 
 /*----------------------
 Deletion Behavior
 ----------------------*/

/*
 Remove a bulletin board with the boardName from the root. 
 
 This method also removes all the notes that are contained in the bulletin board. 
 
 If the boardName is invalid the method returns without doing anything.
 
 This method is not responsible for deletion of the bulletin board structure in the 
 application.
 */
- (void) removeBulletinBoard:(NSString *) boardName;

/*
 Removes a note with noteName from the bulletin board with bulletinBoardName.
 
If the boardName or noteName are invalid the method returns without doing anything.
 
 This method is not responsible for deletion of the individual note data structures
 in the application. 
 */
- (void) removeNote: (NSString *) noteName
  FromBulletinBoard: (NSString *) bulletinBoardName;


/*----------------------
 Query Behavior
 ----------------------*/

/*
 Returns an Array of string with the name of all the available bulletin
 boards in the root.
 
 If no bulletin board exists the array is empty. 
 
 In case of any error in storage or retrieval the method returns nil.
 */
- (NSArray *) getAllBulletinBoardsFromRoot;

/*
 Return a NSData object with the contents of the stored bulletinBoard for
 the bulletinBoardName. 
 
 In case of any error in storage or retrieval the method returns nil.
 
 The method does not gurantee the NSData returned is a valid bulletin board data. 
 */
- (NSData *) getBulletinBoard: (NSString *) bulletinBoardName;
/*
 Gets the note contents for the passed bulletin board name and noteName.
 Returns an NSData containing the data for the note. 
 
 If the bulletin board and the noteName are not valid the method returns
 nil without doing anything. 
 
 The method does not gurantee the NSData returned is a valid note data. 
 */
- (NSData *) getNoteForTheBulletinBoard: (NSString *) bulletinBoardName
                                   WithName: (NSString *) noteName;








@end