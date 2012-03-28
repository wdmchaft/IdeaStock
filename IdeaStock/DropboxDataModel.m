//
//  DropboxDataModel.m
//  IdeaStock
//
//  Created by Ali Fathalian on 3/28/12.
//  Copyright (c) 2012 University of Washington. All rights reserved.
//

#import "DropboxDataModel.h"

@implementation DropboxDataModel

- (NSArray <BulletinBoard> *) getBulletinBoardsFromRoot{
    return nil;
}

//add bulletinBoard to the root 
- (void) addBulletinBoard: (id <BulletinBoard>) board{
    
}

//get all the notes belonging to the bulletin board
- (NSArray <Note> *) getAllNotesForTheBulletinBoard: (id <BulletinBoard>) board{
    return nil;
}

//add Notes to a specific bulletin board
- (void) addNotes:(NSArray <Note> *) notes ToBulletinBoard: (id <BulletinBoard>)board{
    
}

//remove a bulletin board from the root
- (void) removeBulletinBoard:(id <BulletinBoard>) board{
    
}

//remove the notes specificied
- (void) removeNotes: (NSArray <Note> *)notes FromBulletinBoard: (id <BulletinBoard>)board{
    
}

//update a bulletin board meta information. Does not including updating the bulletin board notes. The board argument passed to the board 
//has the old bulletinBoards ID but with new information. This is the same as calling removeBulletinBoard and then addingNewOne with the 
//same ID
- (id <BulletinBoard>) updateBulletinBoard: (id <BulletinBoard>) board{
    return nil;
    
}

//update a bulletin board notes with the new notes. This is the same as calling removeNotes:FromBulletinBoard on the specified notes
//and then calling addNotes:ToBulletinBoard
- (id <BulletinBoard>) updateNotes:(NSArray <Note> *)notes  InBulletinBoard: (id <BulletinBoard>)board{
    return nil;
    
}




@end
