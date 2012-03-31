//
//  BulletinBoard.h
//  IdeaStock
//
//  Created by Ali Fathalian on 3/28/12.
//  Copyright (c) 2012 University of Washington. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Note.h"
@protocol BulletinBoard <NSObject>

@property (nonatomic,strong) NSDictionary <Note> * notes;


@end
