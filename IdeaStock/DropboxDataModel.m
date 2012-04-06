//
//  DropboxDataModel.m
//  IdeaStock
//
//  Created by Ali Fathalian on 3/28/12.
//  Copyright (c) 2012 University of Washington. All rights reserved.
//

#import "DropboxDataModel.h"


@interface DropboxDataModel()

//connection to dropbox
@property (nonatomic,strong) DBRestClient *restClient;

@end

@implementation DropboxDataModel

@synthesize restClient = _restClient;
@synthesize delegate = _delegate;

//incomplete
- (DBRestClient *) restClient{
    if (!_restClient){
        _restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
 
    }
    return _restClient;
}
- (void) addBulletinBoardWithName: (NSString *) bulletinBoardName
             andBulletinBoardInfo: (NSData *) content{
    
}

- (void) addNote: (NSString *)noteName 
     withContent: (NSData *) note 
 ToBulletinBoard: (NSString *) bulletinBoardName{
    
}

- (void) removeBulletinBoard:(NSString *) boardName{
    
}

- (void) removeNote: (NSString *) noteName
  FromBulletinBoard: (NSString *) bulletinBoardName{
    
}

- (NSArray *) getAllBulletinBoardsFromRoot{
    [self getAllBulletinBoardsAsynch];
    return nil;
}

- (NSData *) getBulletinBoard: (NSString *) bulletinBoardName{
    [self getBulletinBoardAsynch:bulletinBoardName];
    return nil;
}

- (NSData *) getNoteForTheBulletinBoard: (NSString *) bulletinBoardName
                               WithName: (NSString *) noteName{
    [self getNoteForTheBulletinBoardAsynch:bulletinBoardName WithName:noteName];
    return nil;
}

-(void) getAllBulletinBoardsAsynch{
    
}
-(void) getBulletinBoardAsynch: (NSString *) bulletinBoardName{
    
}
-(void) getNoteForTheBulletinBoardAsynch: (NSString *) bulletinBoardName
                                WithName: (NSString *)noteName{
    
}
@end
