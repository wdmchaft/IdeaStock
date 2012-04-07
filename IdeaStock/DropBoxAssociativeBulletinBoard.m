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
#import "FileSystemHelper.h"

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



- (NSData *) getBulletinBoardData{
    
    NSString * path = [FileSystemHelper getPathForBulletinBoardWithName:self.bulletinBoardName];
    NSError * err;
    NSString *data = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&err];
    if (!data){
        NSLog(@"Failed to read file from disk: %@", err);
        return nil;
    }
    
    NSLog(@"BulletinBoard : %@ read successful", self.bulletinBoardName);
    
    return [data dataUsingEncoding:NSUTF8StringEncoding];
    
}


- (NSData *) getNoteDataForNote: (NSString *) noteName{
    

    NSString * path = [FileSystemHelper getPathForNoteWithName:noteName inBulletinBoardWithName:self.bulletinBoardName];
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
    NSFileManager * fileManager =  [NSFileManager defaultManager];
    
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

- (void)restClient:(DBRestClient*)client loadFileFailedWithError:(NSError*)error {
    NSLog(@"There was an error loading the file - %@", error);
}

- (void)restClient:(DBRestClient*)client uploadedFile:(NSString*)destPath from:(NSString*)srcPath 
          metadata:(DBMetadata*)metadata{
    NSLog(@"Successfully Uploaded File from %@ to %@", srcPath,destPath);
}

- (void)restClient:(DBRestClient*)client uploadFileFailedWithError:(NSError*)error{
    NSLog(@"Upload file failed with error: %@", error);
}



@end
