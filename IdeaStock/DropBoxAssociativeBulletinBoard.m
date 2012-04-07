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

@implementation DropBoxAssociativeBulletinBoard

//TODO here I am patrially initializing the class. I think this is bad

@synthesize dataModel = _dataModel;
- (DropboxDataModel *) dataModel{
    if (!_dataModel){
        _dataModel = [[DropboxDataModel alloc] init];
    }
    return (DropboxDataModel *)_dataModel;
}

-(id) initBulletinBoardFromXoomlWithName:(NSString *)bulletinBoardName{
    
    
    self = [super initBulletinBoardFromXoomlWithDatamodel:self.dataModel andName:bulletinBoardName];
        
    [(id <CallBackDataModel>) self.dataModel setDelegate:self];

    [(DropboxDataModel <CallBackDataModel> *) self.dataModel performAction];
    
    //the rest of initialization will be done in the callbacks
   // [(DropboxDataModel *) self.dataModel getBulletinBoardAsynch:bulletinBoardName];
    return self;
}

- (void) initiateBulletinBoadWithData:(NSData *) bulletinBoardData{
    
    id bulletinBoardController= [[XoomlBulletinBoardController alloc]  initWithData:bulletinBoardData];
    
    //Make the bulletinboard controller the datasource and delegate
    //for the bulletin board so the bulletin board can structural and
    //data centric questions from it.
    self.dataSource = bulletinBoardController;
    self.delegate = bulletinBoardController;
    
    //Now start to initialize the bulletin board attributes one by one
    //from the delegate.
    
    
    //First Note properties
    


    
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
    ;
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
