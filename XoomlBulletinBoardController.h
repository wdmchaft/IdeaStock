//
//  XoomlBulletinBoardController.h
//  IdeaStock
//
//  Created by Ali Fathalian on 4/1/12.
//  Copyright (c) 2012 University of Washington. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BulletinBoardDelegate.h"
#import "BulletinBoardDatasource.h"


/*
 Provides functionality for working the xooml datamodel of the bulletin 
 board. 
 */
@interface XoomlBulletinBoardController : NSObject <BulletinBoardDelegate, BulletinBoardDatasource>

@end
