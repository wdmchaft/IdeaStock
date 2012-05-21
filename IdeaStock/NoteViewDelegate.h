//
//  NoteViewDelegate.h
//  IdeaStock
//
//  Created by Ali Fathalian on 5/20/12.
//  Copyright (c) 2012 University of Washington. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NoteViewDelegate <UITextViewDelegate>

- (void)textViewDidEndEditing:(UITextView *)textView;

@end
