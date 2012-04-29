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
        textView.text = @"Created by Ali Fathalian on 4/28/12. Copyright (c) 2012 University of Washington. All rights reserved.Created by Ali Fathalian on 4/28/12. Copyright (c) 2012 University of Washington. Created by Ali Fathalian on 4/28/12. Copyright (c) 2012 University of Washington. Created by Ali Fathalian on 4/28/12. Copyright (c) 2012 University of Washington. Created by Ali Fathalian on 4/28/12. Copyright (c) 2012 University of Washington. ";
        [self addSubview:imageView];
        [self addSubview:textView];
    }
    return self;
}

-(void) scale:(CGFloat) scaleFactor{
    
    for (UIView * subView in self.subviews){
        if ([subView isKindOfClass:[UIImageView class]]){
            subView.frame = CGRectMake(subView.frame.origin.x, subView.frame.origin.y, subView.frame.size.width * scaleFactor, subView.frame.size.height * scaleFactor);
        }
        else if ([subView isKindOfClass:[UITextView class]]){
            //doing this to make the text clearer instead of resizing an existing UITextView
            NSString * oldText = ((UITextView *)subView).text;
            CGRect textFrame = CGRectMake(self.bounds.origin.x + self.bounds.size.width * 0.07 ,
                                          self.bounds.origin.y + self.bounds.size.height * 0.07,
                                          self.bounds.size.width * 0.87, self.bounds.size.height * 0.49);
            UITextView * textView = [[UITextView alloc] initWithFrame:textFrame];
            textView.text = oldText;
            
            //posisble memory leakage?
            [subView removeFromSuperview];
             
            [self addSubview:textView];
            
        }
    }
}

@end
