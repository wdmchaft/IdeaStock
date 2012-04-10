//
//  DropBoxAssociativeBulletinBoard.h
//  IdeaStock
//
//  Created by Ali Fathalian on 4/6/12.
//  Copyright (c) 2012 University of Washington. All rights reserved.
//

#import "AssociativeBulletinBoard.h"
#import <DropboxSDK/DropboxSDK.h>
#import "CallBackDataModel.h"
#import "QueueProducer.h"
/*
 This class provides all the functionality of an associative bulletin board 
 with the extra functionality that it can also be used as a delegate for 
 responsing to the dropbox asynch calls
 */
@interface DropBoxAssociativeBulletinBoard : AssociativeBulletinBoard <DBRestClientDelegate,QueueProducer>

-(id) initBulletinBoardFromXoomlWithName:(NSString *)bulletinBoardName;

//for stopping or starting the syncrhnozation timer
-(void) startTimer;
-(void) stopTimer;


-(void) demoAddNewBulletinBoard;
-(void) demoAddNewNote;
-(void) demoDeleteBB;
-(void) demoDeleteNote;

@end
