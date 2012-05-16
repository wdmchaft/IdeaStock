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

#define STARTING_POS_OFFSET_X 0.10
#define STARTING_POS_OFFSET_Y 0.20
#define TEXT_WIDHT_RATIO 0.83
#define TEXT_HEIGHT_RATIO 0.60


-(id) initWithViews: (NSArray *) views 
        andMainView: (NoteView *) mainView 
          withFrame:(CGRect) frame{
    
    
    self = [super initWithFrame:frame];
    if (self){
        self.mainView = mainView;
        self.views = views;
        UIImage * image = [UIImage imageNamed:@"StackedGreenNote.png"];
        UIImageView * imageView = [[UIImageView alloc]initWithImage:image];
        imageView.frame = self.bounds;
        CGRect textFrame = CGRectMake(self.bounds.origin.x + self.bounds.size.width * STARTING_POS_OFFSET_X ,
                                      self.bounds.origin.y + self.bounds.size.height * STARTING_POS_OFFSET_Y,
                                      self.bounds.size.width * TEXT_WIDHT_RATIO, self.bounds.size.height * TEXT_HEIGHT_RATIO);
        UITextView * textView = [[UITextView alloc] initWithFrame:textFrame];
        textView.text = mainView.text;
        [self addSubview:imageView];
        [self addSubview:textView];
    }
    return self;    
    
}
@end
