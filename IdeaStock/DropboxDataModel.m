//
//  DropboxDataModel.m
//  IdeaStock
//
//  Created by Ali Fathalian on 3/28/12.
//  Copyright (c) 2012 University of Washington. All rights reserved.
//

#import "DropboxDataModel.h"
#import "FileSystemHelper.h"


@interface DropboxDataModel()

//connection to dropbox
@property (nonatomic,strong) id tempDel;


#define ADD_BULLETIN_BOARD_ACTION @"addBulletinBoard"


@property NSString * action;

@property NSString * actionPath;
@end

@implementation DropboxDataModel

@synthesize restClient = _restClient;
@synthesize tempDel = _tempDel;
@synthesize action = _action;
@synthesize actionPath = _actionPath;

- (DBRestClient *) restClient{
    if (!_restClient){
        _restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        
        //the default is that the data model sets itself as delegate
        _restClient.delegate = self;
    }
    return _restClient;
}

- (void) setDelegate:(id)delegate{
    self.restClient.delegate = delegate;
}

-(id) delegate{
    return _restClient.delegate;
}


#define BULLETINBOARD_XOOML_FILE_NAME @"XooML.xml"
- (void) addBulletinBoardWithName: (NSString *) bulletinBoardName
             andBulletinBoardInfo: (NSData *) content{
    
    //first write the new content to the disk
    NSString * path = [FileSystemHelper getPathForBulletinBoardWithName:bulletinBoardName];
    NSError * err;
    BOOL didWrite = [content writeToFile:path options:NSDataWritingAtomic error:&err];
    if (!didWrite){
        NSLog(@"Error in writing to file system: %@", err);
        return;
    }

    
    //temporarily save the delegate
    self.tempDel = self.delegate;
    
    //make yourself delegate
    self.restClient.delegate = self;

    
    //set the action
    self.action = ADD_BULLETIN_BOARD_ACTION;
    self.actionPath = path;
    
    //the rest is done for loadedMetadata method
    //now upload the file to the dropbox
    NSString * destination = [NSString stringWithFormat: @"/%@/%@", bulletinBoardName,BULLETINBOARD_XOOML_FILE_NAME];
    
    [self.restClient loadMetadata:destination];
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
    
    
    [[self restClient] loadMetadata:[NSString stringWithFormat: @"/%@", bulletinBoardName]];
    
}
-(void) getNoteForTheBulletinBoardAsynch: (NSString *) bulletinBoardName
                                WithName: (NSString *)noteName{
    
}


-(void) saveBulletinBoard:(NSString *) bulletinBoardName
                 withData:(NSData *) data{
    [self addBulletinBoardWithName:bulletinBoardName andBulletinBoardInfo:data];

    
}

/*----------------------------------------------------
 Delegate Methods
 *---------------------------------------------------*/


- (void)restClient:(DBRestClient *)client loadedMetadata:(DBMetadata *)metadata {
    
    NSString * parentRev = [metadata rev];
    NSString * path = [metadata path];
    NSLog(@"Got Rev: %@", parentRev);
    NSLog(@"For File: %@" ,path);
                                     
    
    //we are done now change the delegate to the original one
    
    self.delegate = self.tempDel;
    
    if( [self.action isEqualToString:ADD_BULLETIN_BOARD_ACTION]){
        
        //now upload the file to the dropbox

        
        //TODO need to do error checking 
        NSString * sourcePAth = self.actionPath;
        //pop the self action and its path
        self.action = nil; 
        self.actionPath = nil;
        
        //remove the filename from the path
        path = [path stringByDeletingLastPathComponent];
        [self.restClient uploadFile:BULLETINBOARD_XOOML_FILE_NAME toPath:path withParentRev:parentRev fromPath:sourcePAth];
    }

    
}

- (void)restClient:(DBRestClient *)client
loadMetadataFailedWithError:(NSError *)error {
    
    NSLog(@"Error loading metadata: %@", error);
}

-(NSString *) description{
    return @"Its me the dropbox datamodel itself";
}
@end
