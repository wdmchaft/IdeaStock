//
//  DropboxBulletinBoardControllerTests.m
//  IdeaStock
//
//  Created by Ali Fathalian on 4/10/12.
//  Copyright (c) 2012 University of Washington. All rights reserved.
//

#import "DropboxBulletinBoardControllerTests.h"

@implementation DropboxBulletinBoardControllerTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testExample
{
    //   STFail(@"Unit tests are not implemented yet in IdeaStockTests");
}

- (void) testInitEmptyBulletinBoard{
    
}

-(void) testInitBulletinBoardWithXooml{
    
}

-(void) testInitEmptyBulletinBoardWithNilDataModel{
    
}

-(void) testInitBulletinBoardWithXoomlWithNilDataModel{
    
}

-(void) testInitEmptyBulletinBoardWithNilName{
    
}

-(void) testInitBulletinBoardWithXoomlWithNilName{
    
}

-(void) testInitBulletinBoardWithInvalidXooml{
    
}

-(void) testInitBulletinBoardWithNilXooml{
    
}

-(void) testBulletinBoardTimer{
    
}

-(void) testBulletinBoardInvalidateTimer{
    
}

-(void) testAddNoteContent{
    
}

-(void) testAddNoteContentWithInvalidNote{
    
}

-(void) testAddNoteContentWithNilNote{
    
}

-(void) testNoteContentWithNilProperties{
    
}

-(void) testNoteContentWithMissingRequiredProperty{

}

-(void) testNoteContentWithMissingOptionalProperty{

}

-(void) testAddNoteAttribute{

}

-(void) testAddNoteAttributeWithNilName{

}

-(void) testAddNoteAttributeWithNilType{

}

-(void) testAddNoteAttributeWithInvalidType{

}

-(void) testAddNoteAttributeWithNilNoteId{

}

-(void) testAddNoteAttributeWithInvalidNoteID{

}

-(void) testAddNoteAttributeWithInvalidValues{

}

-(void) testAddNoteAttributeWithEmptyValues{

}

-(void) testAddNoteToAttribute{

}

-(void) testAddNoteToAttributeWithInvalidTargetID{

}
-(void) testAddNoteToAttributeWithInvalidSourceID{

}
-(void) testAddNoteToAttributeWithNilTargetID{

}
-(void) testAddNoteToAttributeWithNilSourceID{

}
-(void) testAddNoteToAttributeWithInvalidAttributeType{

}
-(void) testAddNoteToAttributeWithNilAttributeType{

}
-(void) testAddNoteToAttributeWithNilAttributeName{

}

-(void) testAddNoteToAttributeWithNewAttributeName{

}

-(void) testAddBulletinBoardAttribute{

}
-(void) testAddBulletinBoardAttributeWithInvalidType{

}

-(void) testAddBulletinBoardAttributeWithNilAttributeType{

}

-(void) testAddBulletinBoardAttributeWithNilAttributeName{

}

-(void) testAddNoteToBulletinBoardAttribute{

}

-(void) testAddNoteToBulletinBoardAttributeWithInvalidNoteID{

}

-(void) testAddNoteToBulletinBoardAttributeWithNilNoteID{

}

-(void) testAddNoteToBulletinBoardAttributeWithInvalidAttributeType{

}
-(void) testAddNoteToBulletinBoardAttributeWithNonExistingAttributeName{

}
-(void) testAddNoteToBulletinBoardAttributeWithNilAttributeName{

}

-(void) testRemoveNote{

}

-(void) testRemoveNoteWithInvalidNoteID{

}

-(void) testRemoveNoteWithNilNoteID{

}

-(void) testRemoveNoteFromAttribute{

}

-(void) testRemoveNoteFromAttributeWithInvalidTargetID{

}

-(void) testRemoveNoteFromAttributeWithInvalidSourceID{

}

-(void) testRemoveNoteFromAttributeWithNilTargetID{

}

-(void) testRemoveNoteFromAttributeWithNilSourceID{

}

-(void) testRemoveNoteFromAttributeWithInvalidAttributeName{

}

-(void) testRemoveNoteFromAttributeWithInvalidAttributeType{

}

-(void) testRemoveNoteFromAttributeWithNilAttributeName{

}

-(void) testRemoveNoteFromAttributeWithNilAttributeType{

}

-(void) testRemoveNoteFromAttributeWhenAttributeDoesNotContainTarget{

}

-(void) testRemoveNoteFromAttributeWhenAttributeDoesntBelongToSource{

}

-(void) testRemoveNoteFromAttributeTwice{

}

-(void) testRemoveNoteFromAttributeWithEmptyAttributeValues{

}

-(void) testRemoveNoteAttribute{

}

-(void) testRemoveNoteAttributeWithInvalidNoteID{

}
-(void) testRemoveNoteAttributeForNonExistingAttributeName{

}
-(void) testRemoveNoteAttributeForNonExistingAttributeType{

}
-(void) testRemoveNoteAttributeWithInvalidAttributeType{

}
-(void) testRemoveNoteAttributeWithNilAttributeName{

}
-(void) testRemoveNoteAttributeWithNilAttributeType{

}
-(void) testRemoveNoteAttributeWithNilNoteID{

}
-(void) testRemoveNoteAttributeTwice{

}
-(void) testRemoveNoteAttributeFromEmptyNoteAttributes{

}

-(void) testRemoveNoteAttributeFromBulletinBoardAttribute{

}

-(void) testRemoveNoteAttributeFromBulletinBoardAttributeInvalidNoteID{

}
-(void) testRemoveNoteAttributeFromBulletinBoardAttributeNilNoteID{

}

-(void) testRemoveNoteAttributeFromBulletinBoardAttributeInvalidAttributeName{

}
-(void) testRemoveNoteAttributeFromBulletinBoardAttributeInvalidAttributeType{

}
-(void) testRemoveNoteAttributeFromBulletinBoardAttributeNilAttributeName{

}
-(void) testRemoveNoteAttributeFromBulletinBoardAttributeNilAttributeType{

}
-(void) testRemoveNoteAttributeFromBulletinBoardAttributeFromNonExistingAttribute{

}

-(void) testRemoveNoteAttributeFromBulletinBoardAttributeTwice{

}

-(void) testRemoveNoteAttributeFromBulletinBoardAttributeWithNoteNotBelongingToAttribute{

}

-(void) removeBulletinBoardAttribute{

}

-(void) removeBulletinBoardAttributeInvalidName{

}
-(void) removeBulletinBoardAttributeInvalidType{

}
-(void) removeBulletinBoardAttributeTwice{

}

- (void) updateNoteContent{

}

- (void) updateNoteContentWithInvalidNoteID{

}

- (void) updateNoteContentWithNilNoteID{

}
- (void) updateNoteContentWithInvalidNewCotnent{

}
- (void) updateNoteContentWithNilNewContnent{

}

-(void) testRenameNoteAttribute{

}

-(void) testRenameNoteAttributeInvalidOldName{

}

-(void) testRenameNoteAttributeNilOldName{

}

-(void) testRenameNoteAttributeInvalidAttributeType{

}

-(void) testRenameNoteAttributeNilAttributeType{

}

-(void) testRenameNoteAttributeInvalidNoteID{

}
-(void) testRenameNoteAttributeNilNoteID{

}
-(void) testRenameNoteAttributeNilNewAttributeName{

}
-(void) testRenameNoteAttributeToSelf{

}

-(void) testUpdateNoteAttribute{

}

-(void) testUpdateNoteAttributeInvalidName{

}

-(void) testUpdateNoteAttributeNilName{

}
-(void) testUpdateNoteAttributeInvalidType{

}
-(void) testUpdateNoteAttributeNilType{

}

-(void) testUpdateNoteAttributeInvalidNoteID{

}

-(void) testUpdateNoteAttributeNilNoteID{

}

-(void) testUpdateNoteAttributeForNonExistingAttribute{

}

-(void) testUpdateNoteAttributeWithEmptyOldValues{

}

-(void) testUpdateNoteAttributeWithEmptyNewValues{

}

-(void) testUpdateNoteAttributeWithOneValue{

}

-(void) testUpdateNoteAttributeWithSameNewValues{

}

-(void) testRenameBulletinBoardAttribute{

}

-(void) testRenameBulletinBoardAttributeInvalidOldAttribute{

}
-(void) testRenameBulletinBoardAttributeNilOldAttribute{

}

-(void) testRenameBulletinBoardAttributeInvalidAttributeType{

}

-(void) testRenameBulletinBoardAttributeNilAttributeType{

}
-(void) testRenameBulletinBoardAttributeNilNewAttributeName{

}

-(void) testRenameBulletinBoardAttributeNonExistingAttribute{

}

-(void) testGetAllNotes{

}

-(void) testGetAllNotesWithNoNote{

}

-(void) testGetAllBulletinBoardAttributes{

}

-(void) testGetAllBulletinBoardAttributesInvalidType{

}

-(void) testGetAllBulletinBoardAttributesNilType{

}

-(void) testGetAllBulletinBoardAttributesWithNoAttribute{

}

-(void) testGetAllNoteAttributes{

}

-(void) testGetAllNoteAttributesInvalidNoteID{

}

-(void) testGetAllNoteAttributesNilNoteID{

}

-(void) testGetAllNoteAttributesInvalidAttributeType{

}

-(void) testGetAllNoteAttributesNilAttributeType{

}

-(void) testGetAllNoteAttributesWithNoAttribute{

}

-(void) testGetNoteContnet{

}

-(void) testGetNoteContentInvalidNoteID{

}

-(void) testGetNoteContentNilNoteID{

}

-(void) testGetllAllNotesInBulletinBoardAttribute{

}

-(void) testGetllAllNotesInBulletinBoardAttributeWithInvalidAttributeName{

}
-(void) testGetllAllNotesInBulletinBoardAttributeWithNilAttributeName{

}
-(void) testGetllAllNotesInBulletinBoardAttributeWhenAttributeDoesNotExist{

}
-(void) testGetllAllNotesInBulletinBoardAttributeWithInvalidAttributeType{

}
-(void) testGetllAllNotesInBulletinBoardAttributeWithNilAttributeType{

}

-(void) testGetllAllNotesInBulletinBoardAttributeWithNoBulletinBoardAttribute{

}

-(void) testGetAllNotesInNoteAttribute{

}

-(void) testGetAllNotesInNoteAttributeInvalidNoteID{

}
-(void) testGetAllNotesInNoteAttributeNilNoteID{

}

-(void) testGetAllNotesInNoteAttributeInvalidAttributeName{

}

-(void) testGetAllNotesInNoteAttributeNilAttributeName{

}

-(void) testGetAllNotesInNoteAttributeWhenNoAttributeExist{

}

-(void) testGetAllNotesInNoteAttributeInvalidAttributeType{

}

-(void) testGetAllNotesInNoteAttributeWithNilAttributeType{

}

-(void) testSaveBulletinBoard{

}

-(void) testSynchrnization{

}

-(void) testSynchrnoizationFlag{

}




@end
