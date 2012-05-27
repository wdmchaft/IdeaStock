//
//  StackView.m
//  IdeaStock
//
//  Created by Ali Fathalian on 5/16/12.
//  Copyright (c) 2012 University of Washington. All rights reserved.
//

#import "StackView.h"


@interface StackView()

/*========================================================================*/


/*------------------------------------------------
                    UI properties
 -------------------------------------------------*/


@property (strong,nonatomic) UIImage * normalImage;
@property (strong, nonatomic) UIImage * highlightedImage;
@property CGRect originalFrame;

@end

/*========================================================================*/


@implementation StackView


/*------------------------------------------------
                    Synthesizers
 -------------------------------------------------*/

@synthesize views = _views;
@synthesize mainView = _mainView;
@synthesize text = _text;
@synthesize highlighted = _highlighted;
@synthesize normalImage = _normalImage;
@synthesize highlightedImage = _highlightedImage;
@synthesize ID = _ID;
@synthesize originalFrame = _originalFrame;


#define STARTING_POS_OFFSET_X 0.10
#define STARTING_POS_OFFSET_Y 0.2
#define TEXT_WIDHT_RATIO 0.7
#define TEXT_HEIGHT_RATIO 0.70

-(UIImage *) normalImage{
    if (!_normalImage){
        _normalImage = [UIImage imageNamed:@"stacknoshadow.png"];
    }
    return _normalImage;
}

-(UIImage *) highlightedImage{
    if (!_highlightedImage){
        _highlightedImage = [UIImage imageNamed:@"stackSelected.png"];
    }
return _highlightedImage;
}

-(void) setHighlighted:(BOOL) highlighted{
    
    _highlighted = highlighted;

    for (UIView * subView in self.subviews){
        if (highlighted){

            if ([subView isKindOfClass:[UIImageView class]]){
                [((UIImageView *) subView) setImage:self.highlightedImage];
                [UIView animateWithDuration:0.20 animations:^{[subView setTransform:CGAffineTransformMakeScale(1.3, 1.4)];}];                              
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

-(void) setText:(NSString *) text{
    _text = text;
    for(UIView * view in self.subviews){
        if ([view isKindOfClass:[UITextView class]]){
            ((UITextView *) view).text = text;
        }
    }
}


/*========================================================================*/


/*------------------------------------------------
                    Initializers
 -------------------------------------------------*/

-(id) initWithViews: (NSMutableArray *) views 
        andMainView: (NoteView *) mainView 
          withFrame:(CGRect) frame{
    
    
    self = [super initWithFrame:frame];
    if (self){
        self.mainView = mainView;
        self.views = views;
        UIImage * image = self.normalImage;
        UIImageView * imageView = [[UIImageView alloc]initWithImage:image];
        imageView.frame = self.bounds;
        CGRect textFrame = CGRectMake(self.bounds.origin.x + self.bounds.size.width * STARTING_POS_OFFSET_X ,
                                      self.bounds.origin.y + self.bounds.size.height * STARTING_POS_OFFSET_Y,
                                      self.bounds.size.width * TEXT_WIDHT_RATIO, self.bounds.size.height * TEXT_HEIGHT_RATIO);
        UITextView * textView = [[UITextView alloc] initWithFrame:textFrame];
        textView.font = [UIFont fontWithName:@"Cochin" size:17.0];
        textView.editable = NO;
        [self addSubview:imageView];
        [self addSubview:textView];
        self.text= mainView.text;
        self.originalFrame = self.frame;
    }
    return self;    
    
}

/*------------------------------------------------
                    Layout Methods
 -------------------------------------------------*/

-(void) scale:(CGFloat) scaleFactor{
    
    if ( self.frame.size.width * scaleFactor > self.originalFrame.size.width * 2||
        self.frame.size.height * scaleFactor > self.originalFrame.size.height * 2){
        return;
    }
    if ( self.frame.size.width * scaleFactor < self.originalFrame.size.width * 0.9||
        self.frame.size.height * scaleFactor < self.originalFrame.size.height * 0.9){
        return;
    }
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
            textView.font = [UIFont fontWithName:@"Cochin" size:17.0];
            textView.text = oldText;
            
            //posisble memory leakage?
            [subView removeFromSuperview];
            
            [self addSubview:textView];
            
        }
    }

    
}


-(void) setNextMainView{
    [self.views removeObject:self.mainView];
    self.mainView = [self.views lastObject];
    [self setText:((NoteView *)[self.views lastObject]).text];
}


/*-----------------------------------------------------------
 Keyboard methods
 -----------------------------------------------------------*/

-(void) resignFirstResponder{
    for (UIView * subView in self.subviews){
        if ([subView isKindOfClass:[UITextView class]]){
            if (subView.isFirstResponder){
                [subView resignFirstResponder];
            }
        }
    }
}
@end
