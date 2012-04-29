//
//  DropboxDataModel.m
//  IdeaStock
//
//  Created by Ali Fathalian on 3/28/12.
//  Copyright (c) 2012 University of Washington. All rights reserved.
//

#import "DropboxDataModel.h"
#import "FileSystemHelper.h"
#import "QueueProducer.h"


@interface DropboxDataModel()

//connection to dropbox
@property (nonatomic,strong) id tempDel;


#define ADD_BULLETIN_BOARD_ACTION @"addBulletinBoard"
#define UPDATE_BULLETIN_BOARD_ACTION @"addBulletinBoard"
#define ADD_NOTE_ACTION @"addNote"
#define UPDATE_NOTE_ACTION @"updateNote"






@property NSString * action;

@property NSString * actionPath;
@property NSString * actionBulletinBoardName;
@property NSString * actionNoteName;
@end

@implementation DropboxDataModel

@synthesize restClient = _restClient;
@synthesize tempDel = _tempDel;
@synthesize action = _action;
@synthesize actionPath = _actionPath;
@synthesize actionBulletinBoardName = _actionBulletinBoardName;
@synthesize actionNoteName = _actionNoteName;

- (DBRestClient *) restClient{
    if (!_restClient){
        _restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        
        //the default is that the data model sets itself as delegate
        _restClient.delegate = self;
    }
    return _restClient;
}

- (void) setDelegate:(id <QueueProducer,DBRestClientDelegate>)delegate{
    self.restClient.delegate = delegate;
}

-(id) delegate{
    return  _restClient.delegate;
}

- (void) createMissingDirectoryForPath: (NSString *) path{
    
    NSString * directory = [path stringByDeletingLastPathComponent];
    NSString * directoryName = [directory lastPathComponent];
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSError * err;
    //check to see if directory exists
    NSString * root = [directory stringByDeletingLastPathComponent];
    NSArray * rootDirectories = [fileManager contentsOfDirectoryAtPath:root  error:&err];
    BOOL shouldCreateDirectory = YES;
    if (rootDirectories){
        for (NSString * dir in rootDirectories){
            if ([dir isEqualToString:directoryName]){
                shouldCreateDirectory =NO;
                break;
            }
        }
    }
    if (shouldCreateDirectory){
        

        BOOL didCreate = [fileManager createDirectoryAtPath:directory withIntermediateDirectories:NO attributes:nil error: &err];
        if(!didCreate){
            NSLog(@"Failed To create Direcjjjtory: %@",err);
        }
        
    }
    
}
#define BULLETINBOARD_XOOML_FILE_NAME @"XooML.xml"
- (void) addBulletinBoardWithName: (NSString *) bulletinBoardName
             andBulletinBoardInfo: (NSData *) content{
    
    
    //first write the new content to the disk

    NSError * err;
    NSString * path = [FileSystemHelper getPathForBulletinBoardWithName:bulletinBoardName];
    [self createMissingDirectoryForPath:path];
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
    self.actionBulletinBoardName = bulletinBoardName;
    

    //now create a folder in dropbox the rest is done by the foldercreated delegate method
    [self.restClient createFolder:bulletinBoardName];
}


-(void) updateBulletinBoardWithName: (NSString *) bulletinBoardName 
               andBulletinBoardInfo: (NSData *) content{
    
    NSError * err;
    NSString * path = [FileSystemHelper getPathForBulletinBoardWithName:bulletinBoardName];
    [self createMissingDirectoryForPath:path];
    
    BOOL didWrite = [content writeToFile:path options:NSDataWritingAtomic error:&err];
    if (!didWrite){
        NSLog(@"Error in writing to file system: %@", err);
        return;
    }
    
    //temporality save the delegate
    self.tempDel = self.delegate;
    
    //make yourself delegate
    self.restClient.delegate = self;
    
    //set the action
    self.action = UPDATE_BULLETIN_BOARD_ACTION;
    self.actionPath = path;
    self.actionBulletinBoardName = bulletinBoardName;
    
    //now update the bulletin board. No need to create any folders 
    //because we are assuming its always there.
    //To update we need to know the latest revision number by calling metadata
    NSString * destination = [NSString stringWithFormat:@"/%@/%@",bulletinBoardName,BULLETINBOARD_XOOML_FILE_NAME];
    [self.restClient loadMetadata:destination];
    
    
}
#define NOTE_XOOML_FILE_NAME @"XooML.xml"

- (void) addNote: (NSString *)noteName 
     withContent: (NSData *) note 
 ToBulletinBoard: (NSString *) bulletinBoardName{
    
  //  noteName = @"Joojoo";
    NSError * err;
    //first write the note to the disk
    NSString * path = [FileSystemHelper getPathForNoteWithName:noteName inBulletinBoardWithName:bulletinBoardName];
    [self createMissingDirectoryForPath:path];
    BOOL didWrite = [note writeToFile:path options:NSDataWritingAtomic error:&err];
    if (!didWrite){
        NSLog(@"Error in writing to file system: %@", err);
        return;
    }
    
    //temporarily save the delegate
    self.tempDel = self.delegate;
    
    //make yourself delegate
    self.restClient.delegate = self;
    
    
    //set the action
    self.action = ADD_NOTE_ACTION;
    self.actionPath = path;
    self.actionBulletinBoardName = bulletinBoardName;
    self.actionNoteName = noteName;
    

    //now upload the file to the dropbox
    //First check whether the note folder exists
    //NSString * destination = [NSString stringWithFormat: @"/%@/%@/%@", bulletinBoardName, noteName, NOTE_XOOML_FILE_NAME];
     NSString * destination = [NSString stringWithFormat: @"/%@/%@", bulletinBoardName, noteName];
    
    //the rest is done for loadedMetadata method
    [self.restClient createFolder: destination];
    
}

-(void) updateNote: (NSString *) noteName 
       withContent: (NSData *) content
   inBulletinBoard:(NSString *) bulletinBoardName{
    
    NSError *err;
    NSString *path = [FileSystemHelper getPathForNoteWithName:noteName inBulletinBoardWithName:bulletinBoardName];
    [self createMissingDirectoryForPath:path];
    
    BOOL didWrite = [content writeToFile:path options:NSDataWritingAtomic error:&err];
    if (!didWrite){
        NSLog(@"Error in writing to file system: %@", err);
        return;
    }
    
    //temporality save the delegate
    self.tempDel = self.delegate;
    
    //make yourself delegate
    self.restClient.delegate = self;
    
    //set the action
    self.action = UPDATE_NOTE_ACTION;
    self.actionPath = path;
    self.actionBulletinBoardName = bulletinBoardName;
    
    //now update the bulletin board. No need to create any folders 
    //because we are assuming its always there.
    //To update we need to know the latest revision number by calling metadata
    NSString * destination = [NSString stringWithFormat:@"/%@/%@/%@",bulletinBoardName,noteName, NOTE_XOOML_FILE_NAME];
    [self.restClient loadMetadata:destination];

    
    
}

- (void) removeBulletinBoard:(NSString *) boardName{
    NSError * err;
    NSString * path = [FileSystemHelper getPathForBulletinBoardWithName:boardName];
    path = [path stringByDeletingLastPathComponent];
    NSFileManager * manager = [NSFileManager defaultManager];
    BOOL didDelete = [manager removeItemAtPath:path error:&err];
    
    //its okey if this is not on the disk and we have an error
    //try dropbox and see if you can delete it from there
    if (!didDelete){
        NSLog(@"Error in deleting the file from the disk: %@",err);
        NSLog(@"Trying to delete from dropbox...");
    }
    
    [self.restClient deletePath:boardName];
    
}

- (void) removeNote: (NSString *) noteName
  FromBulletinBoard: (NSString *) bulletinBoardName{
    
    NSError *err;
    NSString * path = [[FileSystemHelper getPathForNoteWithName:noteName inBulletinBoardWithName:bulletinBoardName] stringByDeletingLastPathComponent];
    NSFileManager * manager = [NSFileManager defaultManager];
    BOOL didDelete = [manager removeItemAtPath:path error:&err];
    
    //its okey if this is not on the disk and we have an error
    //try dropbox and see if you can delete it from there
    if (!didDelete){
        NSLog(@"Error in deleting the file from the disk: %@",err);
        NSLog(@"Trying to delete from dropbox...");
    }
    
    NSString * delPath = [bulletinBoardName stringByAppendingFormat:@"/%@",noteName];
    [self.restClient deletePath:delPath];

    
}

- (NSArray *) getAllBulletinBoardsFromRoot{
    [self getAllBulletinBoardsAsynch];
    return nil;
}

- (NSData *) getBulletinBoard: (NSString *) bulletinBoardName{
    [self getBulletinBoardAsynch:bulletinBoardName];
    return nil;
}


-(void) getAllBulletinBoardsAsynch{
    
    [self.restClient loadMetadata:@"/"];
}


-(void) getBulletinBoardAsynch: (NSString *) bulletinBoardName{
    
    
    [[self restClient] loadMetadata:[NSString stringWithFormat: @"/%@", bulletinBoardName]];
    
}





/*----------------------------------------------------
 Delegate Methods
 *---------------------------------------------------*/


- (void)restClient:(DBRestClient *)client loadedMetadata:(DBMetadata *)metadata {
    
    NSString * parentRev = [metadata rev];
    NSString * path = [metadata path];
    NSLog(@"Got Rev: %@", parentRev);
    NSLog(@"For path: %@" , path);
                                     
    
    if( [self.action isEqualToString:UPDATE_BULLETIN_BOARD_ACTION] ){
        NSString * sourcePath = self.actionPath;
        
        self.action = nil;
        self.actionPath = nil;
        self.actionBulletinBoardName = nil;
        self.actionNoteName = nil;
        self.restClient.delegate = self.tempDel;
        
        path = [path stringByDeletingLastPathComponent];
        [self.restClient uploadFile:BULLETINBOARD_XOOML_FILE_NAME toPath:path withParentRev:parentRev fromPath:sourcePath];
        return;
    }
    
    if ( [self.action isEqualToString:UPDATE_NOTE_ACTION]){
        
        NSString * sourcePath = self.actionPath;        
     
        self.action = nil;
        self.actionPath = nil;
        self.actionNoteName = nil;
        self.actionBulletinBoardName = nil;

        
        path = [path stringByDeletingLastPathComponent];
        [self.restClient uploadFile:NOTE_XOOML_FILE_NAME toPath:path withParentRev:parentRev fromPath:sourcePath];
        return;
    }
    
}

- (void)restClient:(DBRestClient *)client
loadMetadataFailedWithError:(NSError *)error {
    
    NSLog(@"Error loading metadata: %@", error);
}

-(void) restClient:(DBRestClient *)client uploadedFile:(NSString *)destPath from:(NSString *)srcPath{
    NSLog(@"File sucessfully uploaded from %@ to %@",srcPath, destPath);
    self.restClient.delegate = self.tempDel;
    [self.delegate produceNext];
}
    

-(NSString *) description{
    return @"Its me the dropbox datamodel itself";
}

- (void)restClient:(DBRestClient*)client createdFolder:(DBMetadata*)folder{
    
    if ([self.action isEqualToString:ADD_BULLETIN_BOARD_ACTION]){
        NSLog(@"Folder Created for bulletinboard: %@ ", self.actionBulletinBoardName);
        NSString *path = [folder path];
        NSString * sourcePath = self.actionPath;
        //pop the self action and its path
        self.action = nil; 
        self.actionPath = nil;
        self.actionBulletinBoardName = nil;
        self.actionNoteName = nil;
        
        //reset the delegate
        self.restClient.delegate = self.tempDel;
        //since its a new file the revision is set to nil
        [self.restClient uploadFile:BULLETINBOARD_XOOML_FILE_NAME toPath:path withParentRev:nil fromPath:sourcePath];
        return;
        
    }
    
    
    //TODO Right now Im assuming that there would not be consequetive add notes so there is no need for queue if this turns out wrong
    //I will need to implement something like the queue mechanism for update note. 
    if([self.action isEqualToString:ADD_NOTE_ACTION]){
        NSLog(@"Folder Created for note: %@", self.actionNoteName);
        NSString * path = [folder path];
        NSString * sourcePath = self.actionPath;
        //pop the self action and its path
        self.action = nil; 
        self.actionPath = nil;
        self.actionBulletinBoardName = nil;
        self.actionNoteName = nil;
        self.restClient.delegate = self.tempDel;
        

        [self.restClient uploadFile:NOTE_XOOML_FILE_NAME toPath:path withParentRev:nil fromPath:sourcePath];
    }
}

- (void)restClient:(DBRestClient*)client createFolderFailedWithError:(NSError*)error{
    NSLog(@"Failed to create Folder:: %@", error);
    self.restClient.delegate = self.tempDel;
}


@end
