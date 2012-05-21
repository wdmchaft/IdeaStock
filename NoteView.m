//
//  NoteView.m
//  IdeaStock
//
//  Created by Ali Fathalian on 4/28/12.
//  Copyright (c) 2012 University of Washington. All rights reserved.
//

#import "NoteView.h"

@interface NoteView()

@property (nonatomic) CGRect originalFrame;
@property (nonatomic) CGRect lastFrame;

@property (strong, nonatomic) UIImage * highLightedImage;
@property (strong, nonatomic) UIImage * normalImage;

@end

@implementation NoteView

#define STARTING_POS_OFFSET_X 0.07
#define STARTING_POS_OFFSET_Y 0.13
#define TEXT_WIDHT_RATIO 0.9
#define TEXT_HEIGHT_RATIO 0.75


@synthesize text = _text;
@synthesize highlighted = _highlighted;
@synthesize originalFrame = _originalFrame;
@synthesize highLightedImage = _highLightedImage;
@synthesize normalImage = _normalImage;
@synthesize lastFrame = _lastFrame;
@synthesize delegate = _delegate;


-(void) setDelegate:(id<NoteViewDelegate>)delegate{
    _delegate = delegate;
    for (UIView * subView in self.subviews){
        if ([subView isKindOfClass:[UITextView class]]){
            ((UITextView *)subView).delegate = delegate;
        }
    }
}
/*
-(id <NoteViewDelegate>) delegate{
    for (UIView * subView in self.subviews){
        if ([subView isKindOfClass:[UITextView class]]){
            return (id<NoteViewDelegate>) ((UITextView *)subView).delegate;
        }
    }
    return nil;
}
*/
-(UIImage *) normalImage{
    if (!_normalImage){
        _normalImage = [UIImage imageNamed:@"green note3.png"];
    }
    return _normalImage;
}

-(UIImage *) highLightedImage{
    
    if (! _highLightedImage){
        _highLightedImage = [UIImage imageNamed:@"green note highlight.png"];
        
    }
    return _highLightedImage;
}
-(void) setHighlighted:(BOOL)highlighted{
    _highlighted = highlighted;
    
    for (UIView * subView in self.subviews){
        
        if (highlighted){
            if ([subView isKindOfClass:[UIImageView class]]){
                
                [((UIImageView *) subView) setImage:self.highLightedImage];
                [UIView animateWithDuration:0.20 animations:^{                [subView setTransform:CGAffineTransformMakeScale(1.4, 1.5)];}];                             
            }
        }
        else{
            if ([subView isKindOfClass:[UIImageView class]]){
                [((UIImageView *) subView) setImage:self.normalImage];
                [UIView animateWithDuration:0.20 animations:^{[subView setTransform:CGAffineTransformIdentity];}];
             
            }

        }
        
    }
}
- (void) setText:(NSString *)text{
    for (UIView * subView in self.subviews){
        if ([subView isKindOfClass:[UITextView class]]){
            ((UITextView *) subView).text = text;
            return;
        }
    }
}

-(NSString *) text{
    for (UIView * subView in self.subviews){
        if ([subView isKindOfClass:[UITextView class]]){
            return ((UITextView *) subView).text;
        }
    }
    return nil;

    
}
-(void) resetSize{
    [self setFrame: self.originalFrame];
    for (UIView * subView in self.subviews){
        if ([subView isKindOfClass:[UIImageView class]]){
            subView.frame = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, self.bounds.size.height);
            
        }
        else if ([subView isKindOfClass:[UITextView class]]){
            subView.frame = CGRectMake(self.bounds.origin.x + self.bounds.size.width * STARTING_POS_OFFSET_X ,
                                       self.bounds.origin.y + self.bounds.size.height * STARTING_POS_OFFSET_Y,
                                       self.bounds.size.width * TEXT_WIDHT_RATIO, self.bounds.size.height * TEXT_HEIGHT_RATIO);
        }
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.originalFrame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
        UIImageView * imageView = [[UIImageView alloc] initWithImage:self.normalImage];
        imageView.frame = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, self.bounds.size.height);
        
        CGRect textFrame = CGRectMake(self.bounds.origin.x + self.bounds.size.width * STARTING_POS_OFFSET_X ,
                                      self.bounds.origin.y + self.bounds.size.height * STARTING_POS_OFFSET_Y,
                                      self.bounds.size.width * TEXT_WIDHT_RATIO, self.bounds.size.height * TEXT_HEIGHT_RATIO);
        UITextView * textView = [[UITextView alloc] initWithFrame:textFrame];
        textView.delegate = self.delegate;
        [self addSubview:imageView];
        [self addSubview:textView];
        self.text = @"Created by Ali Fathalian on 4/28/12. Copyright (c) 2012 University of Washington. All rights reserved.Created by Ali Fathalian on 4/28/12. Copyright (c) 2012 University of Washington. Created by Ali Fathalian on 4/28/12. Copyright (c) 2012 University of Washington. Created by Ali Fathalian on 4/28/12. Copyright (c) 2012 University of Washington. Created by Ali Fathalian on 4/28/12. Copyright (c) 2012 University of Washington. ";
       // self.backgroundColor = [UIColor blueColor];
    }
    return self;
}

-(void) scale:(CGFloat) scaleFactor{
    
    self.frame = CGRectMake(self.frame.origin.x,
                            self.frame.origin.y, 
                            self.frame.size.width * scaleFactor,
                            self.frame.size.height * scaleFactor);
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
            textView.delegate = self.delegate;
            
            
            [subView removeFromSuperview];
            
            [self addSubview:textView];
            
        }
    }
}


-(void) resizeToRect:(CGRect)rect Animate: (BOOL) animate{
    if (animate){
        [UIView animateWithDuration:0.5 animations:^{
            self.frame = rect;
            for (UIView * subView in self.subviews){
                if ([subView isKindOfClass:[UIImageView class]]){
                    subView.frame = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, self.bounds.size.height);
                }
                else if ([subView isKindOfClass:[UITextView class]]){
                    //doing this to make the text clearer instead of resizing an existing UITextView
                    NSString * oldText = ((UITextView *)subView).text;
                    CGRect textFrame = CGRectMake(self.bounds.origin.x + self.bounds.size.width * STARTING_POS_OFFSET_X ,
                                                  self.bounds.origin.y + self.bounds.size.height * STARTING_POS_OFFSET_Y,
                                                  self.bounds.size.width * TEXT_WIDHT_RATIO, self.bounds.size.height * TEXT_HEIGHT_RATIO);
                    UITextView * textView = [[UITextView alloc] initWithFrame:textFrame];
                    textView.text = oldText;
                    textView.delegate = self.delegate;
                    
                    
                    [subView removeFromSuperview];
                    
                    [self addSubview:textView];
                }
            }
            
        }
         ];
    }
    else {
        self.frame = rect;
        for (UIView * subView in self.subviews){
            if ([subView isKindOfClass:[UIImageView class]]){
                subView.frame = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, self.bounds.size.height);
            }
            else if ([subView isKindOfClass:[UITextView class]]){
                //doing this to make the text clearer instead of resizing an existing UITextView
                NSString * oldText = ((UITextView *)subView).text;
                CGRect textFrame = CGRectMake(self.bounds.origin.x + self.bounds.size.width * STARTING_POS_OFFSET_X ,
                                              self.bounds.origin.y + self.bounds.size.height * STARTING_POS_OFFSET_Y,
                                              self.bounds.size.width * TEXT_WIDHT_RATIO, self.bounds.size.height * TEXT_HEIGHT_RATIO);
                UITextView * textView = [[UITextView alloc] initWithFrame:textFrame];
                textView.text = oldText;
                
                
                [subView removeFromSuperview];
                
                [self addSubview:textView];
            }
        }
    }

}

@end
