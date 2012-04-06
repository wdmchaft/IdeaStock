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


- (void) setDelegate:(id)delegate{
    _delegate = delegate;
    if (self.restClient) self.restClient.delegate = delegate;
}

- (DBRestClient *) restClient{
    if (!_restClient){
        _restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
    }
    if (!_restClient.delegate){
        _restClient.delegate = self.delegate;
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
    
    //TODO implement later when you need to get All bulletinboards.
    
}


-(void) getBulletinBoardAsynch: (NSString *) bulletinBoardName{
    NSString * bulletinBoardXoomlPath = [NSString stringWithFormat:@"%@/xooml.xml",bulletinBoardName];
    NSString * tempPath = [NSString stringWithFormat:@"%@/BulletinBoardXooml.xml",NSTemporaryDirectory()];
    
    [self.restClient loadFile:bulletinBoardXoomlPath intoPath:tempPath];
    //The rest is handled by the delegate
    
}
-(void) getNoteForTheBulletinBoardAsynch: (NSString *) bulletinBoardName
                                WithName: (NSString *)noteName{
    
}
@end
