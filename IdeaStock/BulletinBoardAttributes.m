//
//  BulletinBoardAttributes.m
//  IdeaStock
//
//  Created by Ali Fathalian on 3/30/12.
//  Copyright (c) 2012 University of Washington. All rights reserved.
//

#import "BulletinBoardAttributes.h"

@interface BulletinBoardAttributes()

/*
 the main datastructure for holding the attributes. This is an NSDictionary of NSDictionary of NSArrays. 
 attributes is keyed on attribute type.
 attribute[attributeType] is keyed on attribute Name.
 attribute[attributeType][attibuteName] is an array of noteIDs belonging to
 that attribute. 
 
 for example. attribute["Stack"]["StackName1] returns and array of all the noteIDs that bleong to the attribute stackName1 of type Stack. 
 */
@property (nonatomic,strong) NSMutableDictionary * attributes;

@end

@implementation BulletinBoardAttributes

@synthesize attributes = _attributes;


- (id) initWithAttributes: (NSArray *)attributeTypes{
    self = [super init];
    self.attributes = [NSMutableDictionary dictionary];
    for (NSString * attributeType in attributeTypes){
        NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
        [self.attributes setObject:attributes forKey:attributeType];
    }
    return self;
}

- (NSDictionary *) getAllAttributesForAttributeType: (NSString *) attributeType{
    return [[self.attributes objectForKey:attributeType] copy];
}

- (NSArray *) getAttributeWithName: (NSString *) attributeName
                  forAttributeType: (NSString *) attributeType{
    return [[[self.attributes objectForKey:attributeType] objectForKey:attributeName] copy];
    
}

- (void) createEmptyAttributeWithName: (NSString *) attributeName
                     forAttributeType:(NSString *) attributeType{
    NSMutableArray * noteIDs = [NSMutableArray array];
    [[self.attributes objectForKey:attributeType] setObject:noteIDs forKey:attributeName];
}

- (void) addNoteID: (NSString *) noteID 
       ToAttribute: (NSString *)attributeName
  forAttributeType: (NSString *) attributeType{
    [[[self.attributes objectForKey:attributeType] objectForKey:attributeName] addObject:noteID];
}

- (void) removeNoteID: (NSString *) noteID
        fromAttribute: (NSString *) attributeName
     forAttributeType: (NSString *) attributeType{
        [[[self.attributes objectForKey:attributeType] objectForKey:attributeName] removeObject:noteID];
}

- (void) removeAttribute: (NSString *) attributeName
        forAttributeType: (NSString *)AttributeType{
    
    [[self.attributes objectForKey:AttributeType] removeObjectForKey:attributeName];
}

@end
