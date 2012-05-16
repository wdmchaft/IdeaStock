//
//  NoteView.m
//  IdeaStock
//
//  Created by Ali Fathalian on 4/28/12.
//  Copyright (c) 2012 University of Washington. All rights reserved.
//

#import "NoteView.h"

@implementation NoteView

#define STARTING_POS_OFFSET_X 0.07
#define STARTING_POS_OFFSET_Y 0.13
#define TEXT_WIDHT_RATIO 0.9
#define TEXT_HEIGHT_RATIO 0.75


@synthesize text = _text;

- (void) setText:(NSString *)text{
    _text = text;
    for (UIView * subView in self.subviews){
        if ([subView isKindOfClass:[UITextView class]]){
            ((UITextView *) subView).text = text;
            return;
        }
    }
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImage * image = [UIImage imageNamed:@"green note3.png"];
        UIImageView * imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, self.bounds.size.height);
        
        CGRect textFrame = CGRectMake(self.bounds.origin.x + self.bounds.size.width * STARTING_POS_OFFSET_X ,
                                      self.bounds.origin.y + self.bounds.size.height * STARTING_POS_OFFSET_Y,
                                      self.bounds.size.width * TEXT_WIDHT_RATIO, self.bounds.size.height * TEXT_HEIGHT_RATIO);
        UITextView * textView = [[UITextView alloc] initWithFrame:textFrame];
        [self addSubview:imageView];
        [self addSubview:textView];
        self.text = @"Created by Ali Fathalian on 4/28/12. Copyright (c) 2012 University of Washington. All rights reserved.Created by Ali Fathalian on 4/28/12. Copyright (c) 2012 University of Washington. Created by Ali Fathalian on 4/28/12. Copyright (c) 2012 University of Washington. Created by Ali Fathalian on 4/28/12. Copyright (c) 2012 University of Washington. Created by Ali Fathalian on 4/28/12. Copyright (c) 2012 University of Washington. ";
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
            CGRect textFrame = CGRectMake(self.bounds.origin.x + self.bounds.size.width * STARTING_POS_OFFSET_X ,
                                          self.bounds.origin.y + self.bounds.size.height * STARTING_POS_OFFSET_Y,
                                          self.bounds.size.width * TEXT_WIDHT_RATIO, self.bounds.size.height * TEXT_HEIGHT_RATIO);
            UITextView * textView = [[UITextView alloc] initWithFrame:textFrame];
            textView.text = oldText;
            
            //posisble memory leakage?
            [subView removeFromSuperview];
             
            [self addSubview:textView];
            
        }
    }
}

@end
