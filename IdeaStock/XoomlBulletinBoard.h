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
@interface XoomlBulletinBoard : NSObject <BulletinBoard>

-(id)initWithDataModel: (id <DataModel>) dataModel;

@end
