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

#define STACKING @"stacking"
#define GROUPING @"grouping"


#define LINKAGE @"linkage"
#define POSITION @"position"


@interface AssociativeBulletinBoard : NSObject <BulletinBoard>

- (id)initEmptyBulletinBoardWithDataModel: (id <DataModel>) dataModel;

- (id)initBullrtinBoardFromXoomlWithDatamodel: (id <DataModel>) datamodel 
                                      andName:(NSString *) bulletinBoardName;

@end
