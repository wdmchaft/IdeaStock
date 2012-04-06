//
//  XoomlBulletinBoard.h
//  IdeaStock
//
//  Created by Ali Fathalian on 3/30/12.
//  Copyright (c) 2012 University of Washington. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BulletinBoard.h"

#import "DataModel.h"

#import "BulletinBoardDelegate.h"
#import "BulletinBoardDatasource.h"

#define STACKING @"stacking"
#define GROUPING @"grouping"


#define LINKAGE @"linkage"
#define POSITION @"position"


@interface AssociativeBulletinBoard : NSObject <BulletinBoard>

@property (nonatomic,strong) NSString * bulletinBoardName;
/*
 Holds the actual individual note contents. This dictonary is keyed on the noteID.
 
 The noteIDs in this dictionary determine whether a note belongs to this bulletin board or not. 
 */
@property (nonatomic,strong) NSMutableDictionary * noteContents;


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


/*
 Creates an internal model for the bulletin board which is empty 
 and updates the data model for to have an external representation of
 the bulletin board. 
 */
- (id)initEmptyBulletinBoardWithDataModel: (id <DataModel>) dataModel
                                  andName:(NSString *) bulletinBoardName;

/*
 Reads and fills up a bulletin board from the external structure of the datamodel
 */
- (id)initBulletinBoardFromXoomlWithDatamodel: (id <DataModel>) datamodel 
                                      andName: (NSString *) bulletinBoardName;

@end
