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
#import "XoomlAttributeHelper.h"


#define SYNCHRONIZATION_PERIOD 5
@interface DropBoxAssociativeBulletinBoard()

/*--------------------------------------------------
 
                Private Methods
 
 -------------------------------------------------*/

- (void) synchronize:(NSTimer *) timer;

/*--------------------------------------------------
 
                Synchronization Properties
 
 -------------------------------------------------*/

@property int fileCounter;
//this indicates that we need to synchronize
//any action that changes the bulletinBoard data model calls
//this and then nothing else is needed
@property BOOL needSynchronization;
@property NSTimer * timer;

/*--------------------------------------------------
 
                Dummy Properties
 
 -------------------------------------------------*/

@property NSString * demoBulletinBoardName;
@property NSString * demoNoteName;

@end

@implementation DropBoxAssociativeBulletinBoard

/*=======================================================*/

/*--------------------------------------------------
 
                    Synthesis
 
 -------------------------------------------------*/

//TODO here I am patrially initializing the class. I think this is bad
@synthesize dataModel = _dataModel;
@synthesize fileCounter = _fileCounter;
@synthesize queue = _queue;
@synthesize  needSynchronization = _needSynchronization;
@synthesize  timer = _timer;
@synthesize demoNoteName = _demoNoteName;
@synthesize demoBulletinBoardName = _demoBulletinBoardName;

- (NSMutableArray *) queue{
    if (!_queue){
        _queue = [NSMutableArray array];
    }
    return _queue;
}

- (DropboxDataModel *) dataModel{
    if (!_dataModel){
        _dataModel = [[DropboxDataModel alloc] init];
    }
    return (DropboxDataModel *)_dataModel;
}

/*=======================================================*/

/*--------------------------------------------------
 
                    Synchronization
 
 -------------------------------------------------*/

/*
 Every SYNCHRONIZATION_PERIOD seconds we try to synchrnoize. 
 If the synchronize flag is set the bulletin board is updated from
 the internal datastructures.
 
 
 */


-(void) startTimer{
    [NSTimer scheduledTimerWithTimeInterval: SYNCHRONIZATION_PERIOD 
                                     target:self 
                                   selector:@selector(synchronize:) 
                                   userInfo:nil 
                                    repeats:YES];
}

//TODO who calls you ? 
-(void) stopTimer{
    [self.timer invalidate];
}

-(void) synchronize:(NSTimer *) timer{
    
    if (self.needSynchronization){
        self.needSynchronization = NO;
        [DropBoxAssociativeBulletinBoard saveBulletinBoard: self];
    }
}


+(void) saveBulletinBoard:(id) bulletinBoard{
    
    if ([bulletinBoard isKindOfClass:[DropBoxAssociativeBulletinBoard class]]){
        DropBoxAssociativeBulletinBoard * board = (DropBoxAssociativeBulletinBoard *) bulletinBoard;
        if ([board.dataModel isKindOfClass:[DropboxDataModel class]]){
            ((DropboxDataModel *) board.dataModel).delegate = board;
        }
        
    }
    
    [super saveBulletinBoard:bulletinBoard];
}

/*--------------------------------------------------
 
                    Initialization
 
 -------------------------------------------------*/

-(id) initEmptyBulletinBoardWithDataModel:(id<DataModel>)dataModel 
                                  andName:(NSString *)bulletinBoardName{
    self = [super initEmptyBulletinBoardWithDataModel:dataModel
                                              andName:bulletinBoardName];
    [self startTimer];
    return self;
    
}

-(id) initBulletinBoardFromXoomlWithDatamodel:(id<DataModel>)datamodel
                                      andName:(NSString *)bulletinBoardName{
    self.dataModel = datamodel;
    return [self initBulletinBoardFromXoomlWithName:bulletinBoardName];
}

-(id) initBulletinBoardFromXoomlWithName:(NSString *)bulletinBoardName{
    
    
    self = [super initBulletinBoardFromXoomlWithDatamodel:self.dataModel andName:bulletinBoardName];
    
    [(id <CallBackDataModel>) self.dataModel setDelegate:self];
    
    //count the number of file to know when the download is finished
    self.fileCounter = 0;
    [(DropboxDataModel <CallBackDataModel> *) self.dataModel getBulletinBoardAsynch:bulletinBoardName];
    
    //start synchronization timer
    [self startTimer];
    
    return self;
}

/*
 This methods completely initiates the bulletin board. 
 When this method is called it assumes that the bulletinboard data has been downloadded to disk so it uses disk to initiate itself. 
 */
#define NOTE_NAME @"name"
-(void) initiateBulletinBoad{
    
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
        NSData * noteData = [self getNoteDataForNote:noteName];
        
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
    
    
    //send notification to the notification objects 
    //so interested objects can see that the bulletinboard is loaded
    
    NSLog(@"Notification starts");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BulletinBoardLoaded"
                                                        object:self];
    
}

/*--------------------------------------------------
 
                    Query
 
 -------------------------------------------------*/

-(NSData *) getBulletinBoardData{
    
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

-(NSData *) getNoteDataForNote: (NSString *) noteName{
    
    
    NSString * path = [FileSystemHelper getPathForNoteWithName:noteName inBulletinBoardWithName:self.bulletinBoardName];
    NSError * err;
    NSString *data = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&err];
    if (!data){
        NSLog(@"Failed to read  file from disk: %@", err);
        return nil;
    }
    
    NSLog(@"Note: %@ read Successful", noteName);
    
    return [data dataUsingEncoding:NSUTF8StringEncoding];
}

/*--------------------------------------------------
 
                    Creation
 
 -------------------------------------------------*/

/*
 For the rest of the methods we use the parent methods. 
 However those methods that change only and only the bulletin board require later synchronization.
 In those cases we set the synchronization flag. 
 Note that notes that are changed directly without the bulletin board : for example changing the
 contnets of a note, do not require synchronization cause the changes gets saved in dropbox as
 soon as they happen. 
 */

-(void) addNoteContent: (id <Note>) note 
          andProperties: (NSDictionary *) properties{
    [super addNoteContent:note andProperties:properties];
    
    self.needSynchronization = YES;
}

-(void) addNoteAttribute: (NSString *) attributeName
         forAttributeType: (NSString *) attributeType
                  forNote: (NSString *) noteID 
                andValues: (NSArray *) values{
    [super addNoteAttribute:attributeName
           forAttributeType:attributeType 
                    forNote:noteID 
                  andValues:values];
    
    self.needSynchronization = YES;
}

-(void) addNote: (NSString *) targetNoteID
 toAttributeName: (NSString *) attributeName
forAttributeType: (NSString *) attributeType
          ofNote: (NSString *) sourceNoteId{
    [super addNote:targetNoteID 
   toAttributeName:attributeName 
  forAttributeType:attributeType 
            ofNote:sourceNoteId];
    
    self.needSynchronization = YES;
}

-(void) addNoteWithID:(NSString *)noteID 
toBulletinBoardAttribute:(NSString *)attributeName 
      forAttributeType:(NSString *)attributeType{
    [super addNoteWithID:noteID 
toBulletinBoardAttribute:attributeName
        forAttributeType:attributeType];
    
    self.needSynchronization = YES;
}

/*--------------------------------------------------
 
                    Deletion
 
 -------------------------------------------------*/

-(void) removeNoteWithID:(NSString *)delNoteID{
    [super removeNoteWithID:delNoteID];
    
    self.needSynchronization = true;
}

-(void) removeNote: (NSString *) targetNoteID
      fromAttribute: (NSString *) attributeName
             ofType: (NSString *) attributeType
   fromAttributesOf: (NSString *) sourceNoteID{
    [super removeNote:targetNoteID 
        fromAttribute:attributeName 
               ofType:attributeType 
     fromAttributesOf:sourceNoteID];
    
    self.needSynchronization = YES;
}

-(void) removeNoteAttribute: (NSString *) attributeName
                      ofType: (NSString *) attributeType
                    FromNote: (NSString *) noteID{
    [super removeNoteAttribute:attributeName 
                        ofType:attributeType 
                      FromNote:noteID];
    
    self.needSynchronization = YES;
}

-(void) removeNote: (NSString *) noteID
fromBulletinBoardAttribute: (NSString *) attributeName 
             ofType: (NSString *) attributeType{
    [super removeNote:noteID 
fromBulletinBoardAttribute:attributeName
               ofType:attributeType];
    
    self.needSynchronization = YES;
}

-(void) removeBulletinBoardAttribute:(NSString *)attributeName 
                               ofType:(NSString *)attributeType{
    [super removeBulletinBoardAttribute:attributeName 
                                 ofType:attributeType];
    self.needSynchronization = YES;
}


/*--------------------------------------------------
 
                    Update 
 
 -------------------------------------------------*/

-(void) renameNoteAttribute: (NSString *) oldAttributeName 
                      ofType: (NSString *) attributeType
                     forNote: (NSString *) noteID 
                    withName: (NSString *) newAttributeName{
    [super renameNoteAttribute:oldAttributeName
                        ofType:attributeType
                       forNote:noteID
                      withName:newAttributeName];
    
    self.needSynchronization = YES;
}

-(void) updateNoteAttribute: (NSString *) attributeName
                     ofType:(NSString *) attributeType 
                    forNote: (NSString *) noteID 
              withNewValues: (NSArray *) newValues{
    [super updateNoteAttribute:attributeName
                        ofType:attributeType
                       forNote:noteID 
                 withNewValues:newValues];
    
    self.needSynchronization = YES;
}

-(void) renameBulletinBoardAttribute: (NSString *) oldAttributeNAme 
                               ofType: (NSString *) attributeType 
                             withName: (NSString *) newAttributeName{
    [super renameBulletinBoardAttribute:oldAttributeNAme
                                 ofType:attributeType 
                               withName:newAttributeName];
    
    self.needSynchronization = YES;
}


-(void) updateNoteProperties:(NSString *)noteID withProperties:(NSDictionary *)newProperties{
    [super updateNoteProperties:noteID withProperties:newProperties];
    
    self.needSynchronization = YES;
}
/*--------------------------------------------------
 
                    Dropbox delegate methods
 
 -------------------------------------------------*/

- (void)restClient:(DBRestClient*)client loadedMetadata:(DBMetadata*)metadata{
    
    NSString * tempDir = [NSTemporaryDirectory() stringByDeletingPathExtension];
    
     NSString * rootFolder = [tempDir stringByAppendingString:[metadata path]];
    [FileSystemHelper createMissingDirectoryForPath:rootFolder];
    NSLog(@"Creating root directory: %@",rootFolder);
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
    //now synchronize everything to the dropbox
    //this is like saving to make sure everything is reflected
    
}

- (void)restClient:(DBRestClient*)client uploadFileFailedWithError:(NSError*)error{
    NSLog(@"Upload file failed with error: %@", error);
}


- (void)restClient:(DBRestClient*)client deletedPath:(NSString *)path{
    NSLog(@"Successfully deleted path : %@", path);
    
}
- (void)restClient:(DBRestClient*)client deletePathFailedWithError:(NSError*)error{
    NSLog(@"Failed to delete path: %@", error);
}

/*--------------------------------------------------
 
                Queue Delegate methods
 
 -------------------------------------------------*/

-(void) putIntoQueue: (id) item{
    [self.queue addObject:item];    
}

/*
 This method is called whenever the asynch data model finishes processing 
 and adding a new note. The datamodel will call this method and picks up another
 remianing note to be added.
 */
#define NOTE_NAME_TYPE @"name"
-(void) produceNext{
    //we are done
    if ([self.queue count] == 0) return;
    
    NSString * noteID = [self.queue lastObject];
    [self.queue removeLastObject];
    NSData * noteData = [XoomlParser convertNoteToXooml:[self.noteContents objectForKey:noteID]];
    BulletinBoardAttributes * noteAttributes = [self.noteAttributes objectForKey:noteID];
    NSString * noteName = [[noteAttributes getAttributeWithName:NOTE_NAME forAttributeType:NOTE_NAME_TYPE] lastObject];
    
    [self.dataModel updateNote:noteName withContent:noteData inBulletinBoard:self.bulletinBoardName];
    
    
    
}

/*--------------------------------------------------
 
                    Dummy Methods
 
 -------------------------------------------------*/

-(void) demoAddNewBulletinBoard{
    
    int r = arc4random();
    NSString * BBName = [NSString stringWithFormat:@"BulletinBoard%d",r];
    self.demoBulletinBoardName = BBName;
    [self.dataModel addBulletinBoardWithName:BBName andBulletinBoardInfo:[self.dataSource data]];
}

-(void) demoAddNewNote{
    
    NSData * content;
    for (NSString * noteID in self.noteContents){
        content = [XoomlParser convertNoteToXooml:[self.noteContents objectForKey:noteID]];
        break;
    }
    NSString * bulletinBoardName = self.demoBulletinBoardName ? self.demoBulletinBoardName : self.bulletinBoardName;
    
    int r = arc4random();
    NSString * noteName = [NSString stringWithFormat:@"note%d",r];
    self.demoNoteName = noteName;
    [self.dataModel addNote: noteName withContent:content ToBulletinBoard:bulletinBoardName];
}

-(void) demoDeleteBB{
    [self.dataModel removeBulletinBoard:self.demoBulletinBoardName];
}

-(void) demoDeleteNote{
    [self.dataModel removeNote:self.demoNoteName FromBulletinBoard:self.demoBulletinBoardName];
}


@end
