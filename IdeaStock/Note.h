//
//  Note.h
//  IdeaStock
//
//  Created by Ali Fathalian on 3/28/12.
//  Copyright (c) 2012 University of Washington. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *Object for holding a single notes basic information.
 */
@protocol Note <NSObject>

@required
@property (nonatomic,strong) NSString * noteText;
@property (nonatomic,strong) NSString * noteTextID;
@property (nonatomic,strong) NSString * creationDate;
@property (nonatomic,strong) NSString * modificationDate;

- (NSString *) description;

@end
