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
@synthesize noteAttributes = _noteAttributes;
@synthesize bulletinBoardAttributes = _bulletinBoardAttributes;


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

#define POSITION_X @"positionX"
#define POSITION_Y @"positionY"
#define IS_VISIBLE @"isVisible"

#define POSITION_TYPE @"position"
#define VISIBILITY_TYPE @"visibility"
#define LINKAGE_TYPE @"linkage"
#define STACKING_TYPE @"stacking"
#define GROUPING_TYPE @"grouping"


#define DEFAULT_X_POSITION @"0"
#define DEFAULT_Y_POSITION @"0"
#define DEFAULT_VISIBILITY  @"true"
#define NOTE_NAME @"name"

#define LINKAGE_NAME @"name"
#define STACKING_NAME @"name"
#define REF_IDS @"refIDs"


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
        BulletinBoardAttributes * noteAttribute = [[BulletinBoardAttributes alloc] initWithAttributes:[NSArray arrayWithObjects:LINKAGE_TYPE,POSITION_TYPE, VISIBILITY_TYPE, nil]];
        NSString * positionX = [noteInfo objectForKey: POSITION_X];
        if (!positionX ) positionX = DEFAULT_X_POSITION;
        NSString * positionY = [noteInfo objectForKey: POSITION_Y];
        if (!positionY) positionY = DEFAULT_Y_POSITION;
        NSString * isVisible = [noteInfo objectForKey:IS_VISIBLE];
        if (! isVisible) isVisible = DEFAULT_VISIBILITY;
        
        [noteAttribute createAttributeWithName:POSITION_X forAttributeType: POSITION_TYPE andValues:[NSArray arrayWithObject: positionX ]];
        [noteAttribute createAttributeWithName:POSITION_Y forAttributeType:POSITION_TYPE andValues:[NSArray arrayWithObject:positionY]];
        [noteAttribute createAttributeWithName:IS_VISIBLE forAttributeType:VISIBILITY_TYPE andValues:[NSArray arrayWithObject:isVisible]];
    }
    
    for (NSString * noteID in self.noteContents){
        NSDictionary *linkageInfo = [self.delegate getLinkageInfoForNote:noteID];
        NSArray * refIDs = [linkageInfo objectForKey:REF_IDS];
        NSString * linkageName = [linkageInfo objectForKey:LINKAGE_NAME];
        
        for (NSString * refID in refIDs){
            if (![self.noteContents objectForKey:refID]){
                [[self.noteAttributes objectForKey:noteID] addValues:[NSArray arrayWithObject:refID] ToAttribute:linkageName forAttributeType:LINKAGE_TYPE];
                
            }
        }
        
    }
    
    self.bulletinBoardAttributes = [[BulletinBoardAttributes alloc] initWithAttributes:[NSArray arrayWithObjects:STACKING_TYPE, GROUPING_TYPE,nil]];
    NSDictionary *stackingInfo = [self.delegate getStackingInfo];
    for (NSString * stackingName in stackingInfo){
        NSArray * refIDs = [stackingInfo objectForKey:REF_IDS];
        for (NSString * refID in refIDs){
            if(![self.noteContents objectForKey:refIDs]){
                [self.bulletinBoardAttributes addValues:[NSArray arrayWithObject:refID] ToAttribute:stackingName forAttributeType:STACKING_TYPE];
            }
        }
    }
    
    
    NSDictionary *groupingInfo = [self.delegate getGroupingInfo];
    for (NSString * groupingName in groupingInfo){
        NSArray * refIDs = [groupingInfo objectForKey:REF_IDS];
        for (NSString * refID in refIDs){
            if(![self.noteContents objectForKey:refIDs]){
                [self.bulletinBoardAttributes addValues:[NSArray arrayWithObject:refID] ToAttribute:groupingName forAttributeType:GROUPING_TYPE];
            }
        }
    }
    
    
    
    
    
}

@end