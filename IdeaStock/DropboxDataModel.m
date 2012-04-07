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


@end

@implementation DropboxDataModel

@synthesize restClient = _restClient;

- (DBRestClient *) restClient{
    if (!_restClient){
        _restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
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
-(void) performAction{
    [[self restClient] loadMetadata:[NSString stringWithFormat: @"/%@", @"BulletinBoard"]];
}


- (void)restClient:(DBRestClient *)client loadedMetadata:(DBMetadata *)metadata {
    if (metadata.isDirectory) {
        NSLog(@"Folder '%@' contains:", metadata.path);
        for (DBMetadata *file in metadata.contents) {
            NSLog(@"\t%@", file.filename);
        }
    }
}

- (void)restClient:(DBRestClient *)client
loadMetadataFailedWithError:(NSError *)error {
    
    NSLog(@"Error loading metadata: %@", error);
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
    
 /*   //TODO maybe load it with hash ? 
    //TODO maybe the root need to be specified?
    NSLog(@"%@",[self.restClient.delegate description]);

    [[self restClient] loadMetadata:@"/"];
    
    NSLog(@"%@",[self.delegate description]);
    //[self.restClient loadMetadata:[NSString stringWithFormat: @"%@", bulletinBoardName]];
   
    
   NSString * bulletinBoardXoomlPath = [NSString stringWithFormat:@"%@/xooml.xml",bulletinBoardName];
    NSString * tempPath = [NSString stringWithFormat:@"%@/BulletinBoardXooml.xml",NSTemporaryDirectory()];
    
    [self.restClient loadFile:bulletinBoardXoomlPath intoPath:tempPath];
    The rest is handled by the delegate*/
    
}
-(void) getNoteForTheBulletinBoardAsynch: (NSString *) bulletinBoardName
                                WithName: (NSString *)noteName{
    
}

-(NSString *) description{
    return @"Its me the dropbox datamodel itself";
}
@end
