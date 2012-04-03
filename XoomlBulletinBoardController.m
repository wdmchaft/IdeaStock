//
//  XoomlBulletinBoardController.m
//  IdeaStock
//
//  Created by Ali Fathalian on 4/1/12.
//  Copyright (c) 2012 University of Washington. All rights reserved.
//

#import "XoomlBulletinBoardController.h"
#import "DDXML.h"
#import "XoomlParser.h"

@interface XoomlBulletinBoardController()

//This is the actual xooml document that this object wraps around.
@property (nonatomic,strong) DDXMLDocument * document;
@end

@implementation XoomlBulletinBoardController 

@synthesize document = _document;
/*------------------------*
 Datasource Implementation
 *-----------------------*/

//TODO There may be some tidying up needed in the xooml file.
// to validate it and make sure its proper and also add some parts to it yourself
// as planz does
- (id) initWithData:(NSData *)data{
    
    self = [super init];
    //open the document from the data
    NSError * err = nil;
    self.document = [[DDXMLDocument alloc] initWithData:data options:0 error:&err];

    //TODO right now im ignoring err. I should use it 
    //to determine the error
    if (self.document == nil){
        NSLog(@"Error reading the note XML File");
        return nil;
    }
    
    return self;
}

-(id) initAsEmpty{
    
    //use this helper method to create xooml
    //for an empty bulletinboard
    NSData * emptyBulletinBoardDate =[XoomlParser getEmptyBulletinBoardXooml];
    
    //call designated initializer
    self = [self initWithData:emptyBulletinBoardDate];
    
    return self;
}

-(NSData *) getSerializableData{
    return [self.document XMLData];
}

/*------------------------
 Private helpers
 
 New bulletinboard structural functionality should be added here
 The bulletinboard object itself is oblivious of the 
 functionality that it can perform. 
 -------------------------*/

/*
 Adds a linkage to note with noteID to note with note refID
 
 If the noteID is not valid this method returns without doing anything. 
 
 This method assumes that refNoteID is a valid refID. 
 */
- (void) addLinkage: (NSString *) linkageName
             ToNote: (NSString *) noteID
WithReferenceToNote: (NSString *) refNoteID{
    
}

/*
 Adds a stacking property with stackingName and the notes that are specified
 in the array note. 
 
 The array notes contains a list of noteIDs. 
 
 The method assumes that the stackingName is unique and if there exists
 another stacking with the same name adds it anyways. 
 
 Th method assumes the noteIDs passed in the NSArray notes are valid existing
 refNoteIDs. 
 */

- (void) addStackingWithName: (NSString *) stackingName
                   withNotes: (NSArray *) notes{
    
}
/*
 Adds a grouping property with groupingName and the notes that are specified
 in the array note. 
 
 The array notes contains a list of noteIDs. 
 
 The method assumes that the groupingName is unique and if there exists
 another grouping with the same name adds it anyways. 
 
 Th method assumes the noteIDs passed in the NSArray notes are valid existing
 refNoteIDs. 
 */

- (void) addGroupingWithName: (NSString *) groupingName
                   withNotes: (NSArray *) notes{
    
}

/*
 Adds a note with noteID to the stacking with stackingName. 
 
 If a stacking with stackingName does not exist, this method returns without
 doing anything. 
 
 This method assumes that the noteID is a valid noteID. 
 
 This method assumes that stackingName is unique. If there are more than
 one stacking with the stackingName it adds the note to the first stacking.
 */

- (void) addNote: (NSString *) noteID
      toStacking: (NSString *) stackingName{
    
}


/*
 Adds a note with noteID to the grouping with groupingName. 
 
 If a grouping with groupingName does not exist, this method returns without
 doing anything. 
 
 This method assumes that the noteID is a valid noteID. 
 
 This method assumes that groupingName is unique. If there are more than
 one grouping with the groupingName it adds the note to the first stacking.
 */

- (void) addNote: (NSString *) noteID
      toGrouping: (NSString *) groupingName{
    
}


/*
 Deletes the linkage with linkageName for the note with NoteID. 
 
 Deleting the linkage removes all the notes whose refIDs appear in the linakge.
 
 If the noteID or the linkageName are invalid. This method returns without
 doing anything. 
 */

- (void) deleteLinkage: (NSString *) linkageName 
               forNote: (NSString *)noteID{
    
}
/*
 Delete the note with noteRefID from the linkage with linkageName belonging
 to the note with noteID.
 
 If the noteID, noteRefID, or linkageName are invalid this method returns
 without doing anything. 
 */

- (void) deleteNote: (NSString *) noteRefID
        fromLinkage: (NSString *)linkageName
            forNote: (NSString *) noteID{
    
}
/*
 Deletes the stacking with stackingName from the bulletin board. 
 
 This deletion removes any notes that the stacking with stackingName 
 refered to from the list of its attributes. 
 
 If the stackingName is invalid this method returns without doing anything.
 */

- (void) deleteStacking: (NSString *) stackingName{
    
}

/*
 Deletes the note with noteID from the stacking with stackingName. 
 
 If the stackingName or noteID are invalid this method returns without
 doing anything.
 */

- (void) deleteNote: (NSString *) noteID
       fromStacking: (NSString *) stackingName{
    
}
/*
 Deletes the grouping with groupingName from the bulletin board. 
 
 This deletion removes any notes that the grouping with grouping 
 refered to from the list of its attributes. 
 
 If the groupingName is invalid this method returns without doing anything.
 */


- (void) deleteGrouping: (NSString *) groupingName{
    
}

/*
 Deletes the note with noteID from the grouping with groupingName. 
 
 If the groupingName or noteID are invalid this method returns without
 doing anything.
 */

- (void) deleteNote: (NSString *) noteID
        fromGroupin: (NSString *) groupingName{
    
}

/*
 updates the name of linkage for note with noteID from linkageName
 to newLinkageName. 
 
 If the noteID or linkageName are invalid the method returns without 
 doing anything. 
 */

- (void) updateLinkageName: (NSString *) linkageName
                   forNote: (NSString *) noteID
               withNewName: (NSString *) newLinkageName{
    
}

/*
 Updates the name of a bulletin board stacking from stacking to 
 newStackingName. 
 
 If the stackingName is invalid the method returns without doing anything.
 */

- (void) updateStackingName: (NSString *) stackingName
                withNewName: (NSString *) newStackingName{
    
}
/*
 Updates the name of a bulletin board grouping from groupingName to 
 newGroupingName. 
 
 If the groupingName is invalid the method returns without doing anything.
 */

- (void) updateGroupingName: (NSString *) groupingName
                withNewName: (NSString *) newGroupingName{
    
}

- (NSDictionary *) getLinkageInfoForNote: (NSString *) noteID{
    
}

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

- (NSDictionary *) getStackingInfo{
    
}

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

- (NSDictionary *) getGroupingInfo{
    
}
@end
