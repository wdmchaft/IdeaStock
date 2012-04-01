//
//  XoomlBulletinBoard.m
//  IdeaStock
//
//  Created by Ali Fathalian on 3/30/12.
//  Copyright (c) 2012 University of Washington. All rights reserved.
//

#import "XoomlBulletinBoard.h"

@interface XoomlBulletinBoard()

/*
 Holds the actual individual note contents. This dictonary is keyed on the noteID.
 
 The noteIDs in this dictionary determine whether a note belongs to this bulletin board or not. 
 */
@property (nonatomic,strong) NSMutableDictionary <Note> * noteContents;


/*
 holds all the attributes that belong to the bulletin board level: for example stack groups. 
 */
@property (nonatomic,strong) BulletinBoardAttributes * bulletinBoardAttributes;


/*
 This is an NSDictionary of BulletinBoardAttributes. Its keyed on the noteIDs.
 
 For each noteID,  this contains all of the note level attributes that are
 associated with that particular note.
 */
@property (nonatomic,strong) NSMutableDictionary * noteAttributes;

/*
 This is the datamodel that the bulletin board uses for retrieval and storage of itself. 
 */
@property (nonatomic,strong) id<DataModel> dataModel;

@end
@implementation XoomlBulletinBoard

@synthesize dataModel = _dataModel;


-(id)initEmptyBulletinBoardWithDataModel: (id <DataModel>) dataModel{
    self.dataModel = dataModel;
    self.noteContents = [NSMutableDictionary dictionary];
    
    //initialize the bulletin board attributes with stacking and grouping
    //to add new attributes first define them in the header file and the
    //initilize the bulletinBoardAttributes with an array of them
    self.bulletinBoardAttributes = [[BulletinBoardAttributes alloc] initWithAttributes:[NSArray arrayWithObjects:STACKING,GROUPING nil]];
    
    //initialize the note attributes dictionary as an empty dictionary
    self.noteAttributes = [NSMutableDictionary dictionary];
    
}

@end