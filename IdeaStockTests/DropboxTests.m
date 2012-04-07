//
//  DropboxTests.m
//  IdeaStock
//
//  Created by Ali Fathalian on 4/6/12.
//  Copyright (c) 2012 University of Washington. All rights reserved.
//

#import "DropboxTests.h"
#import "DropboxDataModel.h"
#import "DropBoxAssociativeBulletinBoard.h"
#import <DropboxSDK/DropboxSDK.h>

@implementation DropboxTests

- (void)setUp
{
    [super setUp];
    
    id <DataModel> dataModel = [[DropboxDataModel alloc] init];
    id <DBRestClientDelegate> delegate = [[DropBoxAssociativeBulletinBoard alloc] initBulletinBoardFromXoomlWithDatamodel:dataModel andName:@"TestName"];

}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testCompleteFileDownload
{
    
}
@end
