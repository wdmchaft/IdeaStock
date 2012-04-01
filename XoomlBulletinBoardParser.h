//
//  XoomlBulletinBoardParser.h
//  IdeaStock
//
//  Created by Ali Fathalian on 4/1/12.
//  Copyright (c) 2012 University of Washington. All rights reserved.
//

#import "XoomlParser.h"
#import "XoomlBulletinBoardDelegate.h"

/*
 This class acts as an agent that holds the Xooml info for the bulletin board.
 When the bulletinboard is initiated this class is initiated with the Xooml
 contents and is synchronized with both the bulletin board and the data model
 in the storage. 
 */
@interface XoomlBulletinBoardParser : XoomlParser <XoomlBulletinBoardDelegate>

@end
