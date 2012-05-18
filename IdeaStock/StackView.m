//
//  StackView.m
//  IdeaStock
//
//  Created by Ali Fathalian on 5/16/12.
//  Copyright (c) 2012 University of Washington. All rights reserved.
//

#import "StackView.h"

@interface StackView()

@property (weak, nonatomic) NoteView * mainView;

@end

@implementation StackView

@synthesize views = _views;
@synthesize mainView = _mainView;
@synthesize text = _text;

#define STARTING_POS_OFFSET_X 0.10
#define STARTING_POS_OFFSET_Y 0.20
#define TEXT_WIDHT_RATIO 0.83
#define TEXT_HEIGHT_RATIO 0.60

- (void) setText:(NSString *)text{
    _text = text;
    for(UIView * view in self.subviews){
        if ([view isKindOfClass:[UITextView class]]){
            ((UITextView *) view).text = text;
        }
    }
}
-(id) initWithViews: (NSArray *) views 
        andMainView: (NoteView *) mainView 
          withFrame:(CGRect) frame{
    
    
    self = [super initWithFrame:frame];
    if (self){
        self.mainView = mainView;
        self.views = views;
        UIImage * image = [UIImage imageNamed:@"stackedGreenNote.png"];
        UIImageView * imageView = [[UIImageView alloc]initWithImage:image];
        imageView.frame = self.bounds;
        CGRect textFrame = CGRectMake(self.bounds.origin.x + self.bounds.size.width * STARTING_POS_OFFSET_X ,
                                      self.bounds.origin.y + self.bounds.size.height * STARTING_POS_OFFSET_Y,
                                      self.bounds.size.width * TEXT_WIDHT_RATIO, self.bounds.size.height * TEXT_HEIGHT_RATIO);
        UITextView * textView = [[UITextView alloc] initWithFrame:textFrame];
        textView.editable = NO;
        [self addSubview:imageView];
        [self addSubview:textView];
        self.text= mainView.text;
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
            
            //posisble memory leakage?
            [subView removeFromSuperview];
            
            [self addSubview:textView];
            
        }
    }

    
}
@end
