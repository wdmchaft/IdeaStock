//
//  FileSystemHelper.m
//  IdeaStock
//
//  Created by Ali Fathalian on 4/7/12.
//  Copyright (c) 2012 University of Washington. All rights reserved.
//

#import "FileSystemHelper.h"

@implementation FileSystemHelper

//files are saved in lowercase
#define BULLETINBOARD_XOOML_FILE_NAME @"xooml.xml"
#define NOTE_XOOML_FILE_NAME @"xooml.xml"

+ (NSString *) getPathForBulletinBoardWithName:(NSString *) bulletinBoardName{
    
    
    NSString * pathExtension = [[bulletinBoardName stringByAppendingString:@"/"] stringByAppendingString:BULLETINBOARD_XOOML_FILE_NAME];
    pathExtension = [pathExtension lowercaseString];
    NSString * tempDir = NSTemporaryDirectory();
    NSLog(@"Temp Dir Is: %@", tempDir);
    NSString *path = [NSTemporaryDirectory() stringByAppendingString:pathExtension];
    return path;

    
}

+ (NSString *) getPathForNoteWithName: (NSString *) noteName inBulletinBoardWithName: (NSString *) bulletinBoardName{
    NSString * bulletinBoardPath = [bulletinBoardName stringByAppendingString:@"/"];
    NSString * noteExtension = [[[bulletinBoardPath stringByAppendingString:noteName] stringByAppendingString:@"/"] stringByAppendingString:NOTE_XOOML_FILE_NAME];
    NSString * path = [NSTemporaryDirectory() stringByAppendingString:noteExtension];
    return path;
}

@end
