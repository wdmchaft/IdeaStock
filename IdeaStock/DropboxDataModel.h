//
//  DropboxDataModel.h
//  IdeaStock
//
//  Created by Ali Fathalian on 3/28/12.
//  Copyright (c) 2012 University of Washington. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataModel.h"
#import <DropboxSDK/DropboxSDK.h>
#import "CallBackDataModel.h"

@interface DropboxDataModel : NSObject <DataModel,CallBackDataModel,DBRestClientDelegate> 
@property  (nonatomic, strong) DBRestClient *restClient;


/*
 This class is an implementation of the data model. 
 The main feature of this class is that it provides asynch communication with 
 the storage in this case Dropbox. 
 The results are returned via callbacks to the delegate of this method. 
 
 The previous methods getAllBulletinBoardsFromRoot, getBulletinBoard: and getNoteFroTheBulletinBoardAsynch are overrided to return nil and use the 
 callback mechanism to return their answers. These methods always return nil 
 
 It is important not to have synchronous communication with this class and only use 
 callbacks.
 */

//TODO I am not sure whether this is really an implementation of the DataModel protocol
//because it is somehow changing its behavior . 



-(void) getAllBulletinBoardsAsynch;

/*
 This method asynchronously gets the bulletinBoard specified by bulletinBoardName. 
 It assumes that the bulletinBoardName is a valid existing bulletinBoard in the dropbox
 root.
 */
-(void) getBulletinBoardAsynch: (NSString *) bulletinBoardName;
-(void) getNoteForTheBulletinBoardAsynch: (NSString *) bulletinBoardName
                                      WithName: (NSString *)noteName;


@end
