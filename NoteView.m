//
//  NoteView.m
//  IdeaStock
//
//  Created by Ali Fathalian on 4/28/12.
//  Copyright (c) 2012 University of Washington. All rights reserved.
//

#import "NoteView.h"

@implementation NoteView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImage * image = [UIImage imageNamed:@"green2 note.png"];
        UIImageView * imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, self.bounds.size.height);

        CGRect textFrame = CGRectMake(self.bounds.origin.x + self.bounds.size.width * 0.07 ,
                                      self.bounds.origin.y + self.bounds.size.height * 0.07,
                                      self.bounds.size.width * 0.87, self.bounds.size.height * 0.49);
        UITextView * textView = [[UITextView alloc] initWithFrame:textFrame];
        textView.text = @"Ali";
        [self addSubview:imageView];
        [self addSubview:textView];
    }
    return self;
}


@end
