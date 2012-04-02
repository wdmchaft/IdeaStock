//
//  XoomlBulletinBoard.m
//  IdeaStock
//
//  Created by Ali Fathalian on 3/30/12.
//  Copyright (c) 2012 University of Washington. All rights reserved.
//

#import "AssociativeBulletinBoard.h"
#import "XoomlParser.h"
#import "BulletinBoardDelegate.h"
#import "BulletinBoardDatasource.h"
#import "XoomlBulletinBoardController.h"

@interface AssociativeBulletinBoard()

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

/*
 This delegate object provides information for all of the data specific 
 questions that the bulletin baord may ask. 
 
 Properties of the bulletin board are among these data specific questions. 
 */
@property (nonatomic,strong) id <BulletinBoardDelegate> delegate;


@property (nonatomic,strong) id <BulletinBoardDatasource> dataSource;

@end
@implementation AssociativeBulletinBoard

@synthesize dataModel = _dataModel;
@synthesize delegate = _delegate;
@synthesize dataSource = _dataSource;


-(id)initEmptyBulletinBoardWithDataModel: (id <DataModel>) dataModel{
    self = [super init];
    self.dataModel = dataModel;
    self.noteContents = [NSMutableDictionary dictionary];
    
    //initialize the bulletin board attributes with stacking and grouping
    //to add new attributes first define them in the header file and the
    //initilize the bulletinBoardAttributes with an array of them
    self.bulletinBoardAttributes = [[BulletinBoardAttributes alloc] initWithAttributes:[NSArray arrayWithObjects:STACKING,GROUPING, nil]];
    
    //initialize the note attributes dictionary as an empty dictionary
    self.noteAttributes = [NSMutableDictionary dictionary];

    //TODO init the delegate and dataSource
    return self;
    
}

/*
 Initilizes the bulletin board with the content of a xooml file for a previously
 created bulletinboard. 
 */

//TODO this initializer is getting to heavy weight


/*
 These are the default attributes for note
 Add new ones here. 
 */
#define LINKAGE @"linkage"
#define POSITION_X @"positionX"
#define POSITION_Y @"positionY"
#define IS_VISIBLE @"isVisible"

#define DEFAULT_X_POSITION @"0"
#define DEFAULT_Y_POSITION @"0"
#define DEFAULT_VISIBILITY  @"true"
#define NOTE_NAME @"name"
-(id) initBullrtinBoardFromXoomlDatamodel:(id<DataModel>)datamodel andName:(NSString *)bulletinBoardName{
    self = [self initEmptyBulletinBoardWithDataModel:datamodel];
    NSData * bulletinBoardData = [datamodel getBulletinBoard:bulletinBoardName];  
    id bulletinBoardController= [[XoomlBulletinBoardController alloc]  initWithData:bulletinBoardData];
    
    self.dataSource = bulletinBoardController;
    self.delegate = bulletinBoardController;
    
    NSDictionary * noteInfo = [self.delegate getAllNoteBasicInfo];
    for (NSString * noteID in noteInfo){
        NSString * noteName = [[noteInfo objectForKey:noteID] objectForKey:NOTE_NAME];
        NSData * noteData = [self.dataModel getNoteForTheBulletinBoard:bulletinBoardName WithName:noteName];
        id <Note> noteObj = [XoomlParser xoomlNoteFromXML:noteData];
        [self.noteContents setObject:noteObj forKey:noteID];
        BulletinBoardAttributes * noteAttribute = [[BulletinBoardAttributes alloc] initWithAttributes:[NSArray arrayWithObjects:LINKAGE,POSITION_X,POSITION_Y,IS_VISIBLE, nil]];
        NSString * positionX = [noteInfo objectForKey: POSITION_X];
        if (!positionX ) positionX = DEFAULT_X_POSITION;
        NSString * positionY = [noteInfo objectForKey: POSITION_Y];
        if (!positionY) positionY = DEFAULT_Y_POSITION;
        NSString * isVisible = [noteInfo objectForKey:IS_VISIBLE];
        if (! isVisible) isVisible = DEFAULT_VISIBILITY;
        
    }
    
    
    
    
}

@end