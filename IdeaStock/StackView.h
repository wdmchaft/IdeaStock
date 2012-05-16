//
//  StackView.h
//  IdeaStock
//
//  Created by Ali Fathalian on 5/16/12.
//  Copyright (c) 2012 University of Washington. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NoteView.h"

@interface StackView : UIView

@property (weak,nonatomic) NSArray * views;
-(id) initWithViews: (NSArray *) views 
        andMainView: (NoteView *) mainView
          withFrame: (CGRect) frame;

@end
