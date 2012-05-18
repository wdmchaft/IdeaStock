//
//  NoteView.h
//  IdeaStock
//
//  Created by Ali Fathalian on 4/28/12.
//  Copyright (c) 2012 University of Washington. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BulletinBoardObject.h"
@interface NoteView : UIView <BulletinBoardObject>

-(void) resetSize;
-(void) resizeToRect:(CGRect) rect;
@property (nonatomic) BOOL highlighted;

@end
