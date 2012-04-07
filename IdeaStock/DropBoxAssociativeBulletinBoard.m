//
//  DropBoxAssociativeBulletinBoard.m
//  IdeaStock
//
//  Created by Ali Fathalian on 4/6/12.
//  Copyright (c) 2012 University of Washington. All rights reserved.
//

#import "DropBoxAssociativeBulletinBoard.h"
#import "DropboxDataModel.h"
#import "XoomlBulletinBoardController.h"
#import "DropboxDataModel.h"
#import "XoomlParser.h"

@interface DropBoxAssociativeBulletinBoard()

@property int fileCounter;

@end

@implementation DropBoxAssociativeBulletinBoard

//TODO here I am patrially initializing the class. I think this is bad

@synthesize dataModel = _dataModel;
@synthesize fileCounter = _fileCounter;

- (DropboxDataModel *) dataModel{
    if (!_dataModel){
        _dataModel = [[DropboxDataModel alloc] init];
    }
    return (DropboxDataModel *)_dataModel;
}

-(id) initBulletinBoardFromXoomlWithName:(NSString *)bulletinBoardName{
    
    
    self = [super initBulletinBoardFromXoomlWithDatamodel:self.dataModel andName:bulletinBoardName];
    
    [(id <CallBackDataModel>) self.dataModel setDelegate:self];
    
    //count the number of file to know when the download is finished
    self.fileCounter = 0;
    [(DropboxDataModel <CallBackDataModel> *) self.dataModel getBulletinBoardAsynch:bulletinBoardName];
    
    //the rest of initialization will be done in the callbacks
    // [(DropboxDataModel *) self.dataModel getBulletinBoardAsynch:bulletinBoardName];
    return self;
}

//files are saved in lowercase
#define BULLETINBOARD_XOOML_FILE_NAME @"xooml.xml"

- (NSData *) getBulletinBoardData{
    
    NSString * pathExtension = [[self.bulletinBoardName stringByAppendingString:@"/"] stringByAppendingString:BULLETINBOARD_XOOML_FILE_NAME];
    NSString *path = [NSTemporaryDirectory() stringByAppendingString:pathExtension];
    
    NSError * err;
    NSString *data = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&err];
    if (!data){
        NSLog(@"Failed to read file from disk: %@", err);
        return nil;
    }
    
    NSLog(@"BulletinBoard : %@ read successful", self.bulletinBoardName);
    
    return [data dataUsingEncoding:NSUTF8StringEncoding];
    
}

#define NOTE_XOOML_FILE_NAME @"xooml.xml"
- (NSData *) getNoteDataForNote: (NSString *) noteName{
    
    NSString * bulletinBoardPath = [self.bulletinBoardName stringByAppendingString:@"/"];
    NSString * noteExtension = [[[bulletinBoardPath stringByAppendingString:noteName] stringByAppendingString:@"/"] stringByAppendingString:NOTE_XOOML_FILE_NAME];
    NSString * path = [NSTemporaryDirectory() stringByAppendingString:noteExtension];
    
    NSError * err;
    NSString *data = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&err];
    if (!data){
        NSLog(@"Failed to read file from disk: %@", err);
        return nil;
    }
    
    NSLog(@"Note: %@ read Successful", noteName);
    
    return [data dataUsingEncoding:NSUTF8StringEncoding];
    
    
    
}
/*
 This methods completely initiates the bulletin board. 
 When this method is called it assumes that the bulletinboard data has been downloadded to disk so it uses disk to initiate itself. 
 */
#define NOTE_NAME @"name"
- (void) initiateBulletinBoad{
    
    NSData * bulletinBoardData = [self getBulletinBoardData];
    id bulletinBoardController= [[XoomlBulletinBoardController alloc]  initWithData:bulletinBoardData];
    
    //Make the bulletinboard controller the datasource and delegate
    //for the bulletin board so the bulletin board can structural and
    //data centric questions from it.
    self.dataSource = bulletinBoardController;
    self.delegate = bulletinBoardController;
    
    //Now start to initialize the bulletin board attributes one by one
    //from the delegate.
    
    NSDictionary * noteInfo = [self.delegate getAllNoteBasicInfo];
    
    
    //set up note contents
    for(NSString * noteID in noteInfo){
        
        //for each note create a note Object by reading its separate xooml files
        //from the data model
        NSString * noteName = [[noteInfo objectForKey:noteID] objectForKey:NOTE_NAME];
        NSData * noteData = [self getNoteDataForNote: noteName];
        
        if (!noteData) return;
        
        [self initiateNoteContent:noteData
                        forNoteID:noteID
                          andName:noteName
                    andProperties:noteInfo];
    }
    NSLog(@"Note Content Initiated");

    //initiate Linkages
    [self initiateLinkages];
    NSLog(@"Linkages initiated");

    //initiate stacking
    [self initiateStacking];
    NSLog(@"Stacking initiated");

    //initiate grouping
    [self initiateGrouping];
    NSLog(@"Grouping initiated");


}

- (void)restClient:(DBRestClient*)client loadedMetadata:(DBMetadata*)metadata{
    
    NSString * tempDir = [NSTemporaryDirectory() stringByDeletingPathExtension];
    // NSString * rootFolder = [tempDir stringByAppendingString:[metadata path]];
    //NSLog(@"Creating root directory: %@",rootFolder);
    //handle this error later
    NSError * err;
    NSFileManager * fileManager =  [[NSFileManager alloc] init];
    
    for(DBMetadata * child in metadata.contents){
        NSString *path = [child.path lowercaseString];
        if(child.isDirectory){
            [client loadMetadata:child.path];
            NSString * dir = [tempDir stringByAppendingString:path];
            NSLog(@"Creating the dir: %@", dir);
            BOOL didCreate = [fileManager createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:&err];
            if (!didCreate){
                NSLog(@"Error in creating Dir: %@",err);
            }
            
        }
        
        
        else{
            NSLog(@"found file: %@", child.path);
            
            self.fileCounter++;
            
            NSLog(@"path:  %@", child.path);
            NSString * destination = [tempDir stringByAppendingString:path];
            
            NSLog(@"putting file in destination: %@",destination);
            [client loadFile:child.path intoPath:destination];
        }
    }
}

- (void)restClient:(DBRestClient*)client loadMetadataFailedWithError:(NSError*)error{
    NSLog(@"Failutre: %@",error);
}
-(void) restClient: (DBRestClient *) client loadedFile:(NSString *)destPath{
    //one file is loaded so reduce the counter
    self.fileCounter --;
    
    if (self.fileCounter == 0){
        //all the bulletinboard files are downloaded
        //now initialize the bulletinBoard. 
        NSLog(@"All Files Download");
        [self initiateBulletinBoad];
    }
    
}
#define XOOML_BULLETIN_BOARD_FILE_NAME @"BulletinBoardXooml.xml"
#define XOOML_NOTE_FILE_NAME @"NoteXooml.xml"

//delegate function for when a fileIsLoaded
/*- (void)restClient:(DBRestClient*)client loadedFile:(NSString*)localPath {
 NSError * err;
 
 NSString * stringData = [NSString stringWithContentsOfFile:localPath encoding:NSUTF8StringEncoding error:&err];
 if (!stringData){
 //do something with the err
 NSLog(@"There was an error loading the file from fileSystem - %@", err);
 return;
 }
 
 BOOL isBulletinBoard = YES;
 if ([localPath rangeOfString:XOOML_BULLETIN_BOARD_FILE_NAME].location == NSNotFound){
 isBulletinBoard = NO;
 }
 if(isBulletinBoard){
 NSData * data = [stringData dataUsingEncoding:NSUTF8StringEncoding];
 [self initiateBulletinBoadWithData:data];
 
 }
 else{
 //do the note initiation stuff
 }
 
 return;
 }*/

- (void)restClient:(DBRestClient*)client loadFileFailedWithError:(NSError*)error {
    NSLog(@"There was an error loading the file - %@", error);
}
@end
