//
//  BulletinBoard.h
//  IdeaStock
//
//  Created by Ali Fathalian on 3/28/12.
//  Copyright (c) 2012 University of Washington. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Note.h"
#import "BulletinBoardAttributes.h"
@protocol BulletinBoard <NSObject>

//holds the actual individual note contents. This dictonary is keyed on the noteID
//stored in the bulletin board
@property (nonatomic,strong) NSDictionary <Note> * noteContents;

//holds all the attributes on the bulletin board level for example stack groups
@property (nonatomic,readonly) BulletinBoardAttributes * bulletinBoardAttributes;

//This is an NSDictionary of BulletinBoardAttributes. Its keyed on the noteIDs and
//for each note it contains all of the bulletin board attributes that is 
//associated with that particular note.
@property (nonatomic,readonly) NSDictionary * noteAttributes;



@end
