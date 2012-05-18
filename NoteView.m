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
                [subView setTransform:CGAffineTransformMakeScale(1.3, 1.4)];
                                           
            }
           /* else if ([subView isKindOfClass:[UITextView class]]){
                subView.frame = CGRectMake(self.bounds.origin.x + self.bounds.size.width * STARTING_POS_OFFSET_X * 2 ,
                                           self.bounds.origin.y + self.bounds.size.height * STARTING_POS_OFFSET_Y * 1.3,
                                           self.bounds.size.width * TEXT_WIDHT_RATIO * 0.82, self.bounds.size.height * TEXT_HEIGHT_RATIO * 0.8);
            }*/
        }
        else{
            if ([subView isKindOfClass:[UIImageView class]]){
                [((UIImageView *) subView) setImage:self.normalImage];
                [subView setTransform:CGAffineTransformIdentity];
               // subView.frame = self.bounds;
            }

        }
        
    }
}
- (void) setText:(NSString *)text{
    _text = text;
    for (UIView * subView in self.subviews){
        if ([subView isKindOfClass:[UITextView class]]){
            ((UITextView *) subView).text = text;
            return;
        }
    }
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
        [self addSubview:imageView];
        [self addSubview:textView];
        self.text = @"Created by Ali Fathalian on 4/28/12. Copyright (c) 2012 University of Washington. All rights reserved.Created by Ali Fathalian on 4/28/12. Copyright (c) 2012 University of Washington. Created by Ali Fathalian on 4/28/12. Copyright (c) 2012 University of Washington. Created by Ali Fathalian on 4/28/12. Copyright (c) 2012 University of Washington. Created by Ali Fathalian on 4/28/12. Copyright (c) 2012 University of Washington. ";
        //self.backgroundColor = [UIColor blueColor];
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
            
            
            [subView removeFromSuperview];
            
            [self addSubview:textView];
            
        }
    }
}


-(void) resizeToRect:(CGRect)rect{
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

@end
