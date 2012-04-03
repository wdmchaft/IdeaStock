//
//  XoomlBulletinBoardController.m
//  IdeaStock
//
//  Created by Ali Fathalian on 4/1/12.
//  Copyright (c) 2012 University of Washington. All rights reserved.
//

#import "XoomlBulletinBoardController.h"
#import "DDXML.h"
#import "XoomlParser.h"

@interface XoomlBulletinBoardController()

//This is the actual xooml document that this object wraps around.
@property (nonatomic,strong) DDXMLDocument * document;
@end

@implementation XoomlBulletinBoardController 

@synthesize document = _document;
/*------------------------*
 Datasource Implementation
 *-----------------------*/

//TODO There may be some tidying up needed in the xooml file.
// to validate it and make sure its proper and also add some parts to it yourself
// as planz does
- (id) initWithData:(NSData *)data{
    
    self = [super init];
    //open the document from the data
    NSError * err = nil;
    self.document = [[DDXMLDocument alloc] initWithData:data options:0 error:&err];

    //TODO right now im ignoring err. I should use it 
    //to determine the error
    if (self.document == nil){
        NSLog(@"Error reading the note XML File");
        return nil;
    }
    
    return self;
}

-(id) initAsEmpty{
    
    //use this helper method to create xooml
    //for an empty bulletinboard
    NSData * emptyBulletinBoardDate =[XoomlParser getEmptyBulletinBoardXooml];
    
    //call designated initializer
    self = [self initWithData:emptyBulletinBoardDate];
    
    return self;
}

-(NSData *) getSerializableData{
    return [self.document XMLData];
}
@end
