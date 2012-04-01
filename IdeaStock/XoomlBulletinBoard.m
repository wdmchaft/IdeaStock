//
//  XoomlBulletinBoard.m
//  IdeaStock
//
//  Created by Ali Fathalian on 3/30/12.
//  Copyright (c) 2012 University of Washington. All rights reserved.
//

#import "XoomlBulletinBoard.h"

@interface XoomlBulletinBoard()

//holds the actual individual note contents. This dictonary is keyed on the noteID
//stored in the bulletin board
@property (nonatomic,strong) NSDictionary <Note> * noteContents;

//holds all the attributes on the bulletin board level for example stack groups
@property (nonatomic,strong) BulletinBoardAttributes * bulletinBoardAttributes;

//This is an NSDictionary of BulletinBoardAttributes. Its keyed on the noteIDs and
//for each note it contains all of the bulletin board attributes that is 
//associated with that particular note.
@property (nonatomic,strong) NSDictionary * noteAttributes;
@property (nonatomic,strong) id<DataModel> dataModel;

@end
@implementation XoomlBulletinBoard

@synthesize dataModel = _dataModel;


-(id)initWithDataModel: (id <DataModel>) dataModel{

}

@end
