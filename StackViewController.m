//
//  StackViewController.m
//  IdeaStock
//
//  Created by Ali Fathalian on 5/17/12.
//  Copyright (c) 2012 University of Washington. All rights reserved.
//

#import "StackViewController.h"
#import "NoteView.h"

@interface StackViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *stackView;
@property (nonatomic) BOOL isInEditMode; 
@property (weak, nonatomic) NoteView * highLightedNote;

@end

@implementation StackViewController
@synthesize stackView = _stackView;
@synthesize highLightedNote = _highLightedNote;
@synthesize isInEditMode = _isInEditMode;

@synthesize notes = _notes;
@synthesize delegate = _delegate;


-(void) setNotes:(NSArray *)notes{
    _notes = notes;
    
    //remove the gesture recognizor from all the notes
    for(UIView * view in _notes){
        for (UIGestureRecognizer * gr in [view gestureRecognizers]){
            [view removeGestureRecognizer:gr];
            [((NoteView *) view) resetSize];
        }
        UILongPressGestureRecognizer * pgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(notePressed:)];
        [view addGestureRecognizer:pgr];
        
    }
}

-(void) notePanned: (UIPanGestureRecognizer *) sender{
    
    
        NSLog( @"Hallo");
    if (sender.state == UIGestureRecognizerStateEnded || sender.state ==UIGestureRecognizerStateChanged){
        CGPoint translation = [sender translationInView:self.stackView];
        UIView * pannedView = [sender view];
        CGPoint newOrigin = CGPointMake(pannedView.frame.origin.x + translation.x,
                                        pannedView.frame.origin.y + translation.y);
        pannedView.frame = CGRectMake(newOrigin.x, newOrigin.y, pannedView.frame.size.width,pannedView.frame.size.height);
        [sender setTranslation:CGPointZero inView:self.stackView];
        
        
    }
}
-(void) notePressed: (UILongPressGestureRecognizer *) sender{
    if (sender.state == UIGestureRecognizerStateBegan){
        ((NoteView *) sender.view).highlighted = !((NoteView *) sender.view).highlighted;
        if ( ((NoteView *) sender.view).highlighted){
            if (self.highLightedNote) {
                self.highLightedNote.highlighted = NO;
            }
            UIPanGestureRecognizer * pgr = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(notePanned:)];
            [sender.view addGestureRecognizer:pgr];
            UITapGestureRecognizer * tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(screenTapped:)];
            [self.stackView addGestureRecognizer:tgr];
            self.highLightedNote = (NoteView *) sender.view;
            self.isInEditMode = YES;
        }
        else{
            self.highLightedNote = nil;
            self.isInEditMode = NO;
            for (UIGestureRecognizer * gr in [sender.view gestureRecognizers]){
                if ([gr isKindOfClass:[UIPanGestureRecognizer class]]){
                    [sender.view removeGestureRecognizer:gr];
                }
            }
        }
    }
    else if (sender.state == UIGestureRecognizerStateChanged){
        CGPoint newStart = [sender locationInView:self.stackView];
        CGRect newRect = CGRectMake(newStart.x, newStart.y, sender.view.bounds.size.width, sender.view.bounds.size.height);
        [sender.view setFrame:newRect];
    }
    else if (sender.state == UIGestureRecognizerStateEnded){
    }
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)backPressed:(id)sender{
    if ( self.highLightedNote) self.highLightedNote.highlighted = NO;
    [self.delegate returnedstackViewController:self];
}

#define ROW_COUNT 2
#define COL_COUNT 2



-(void) layoutNotes{
    
    int pageNotes = ROW_COUNT * COL_COUNT;
    int totalNotes = [self.notes count];
    int totalPages = totalNotes/pageNotes;
    if ( totalNotes % pageNotes > 0 ) totalPages++;
    
    
    int page = 0;
    int col = 0;
    int row = 0;
    
    
    float pageWidth = self.stackView.frame.size.width;
    float pageHeight = self.stackView.frame.size.height;
    float noteWidth = (pageWidth / COL_COUNT ) * 0.82;
    float noteHeight = (pageHeight / ROW_COUNT ) * 0.75;
    float colSeperator = noteWidth / 7;
    float rowSeperator = noteHeight / 5;
    
    BOOL needResizing = NO;
    for (UIView * view in self.notes){
        if (needResizing){
            needResizing = NO;
            CGSize size = CGSizeMake(self.stackView.frame.size.width * (page+1), self.stackView.frame.size.height);
            [self.stackView setContentSize:size];
        }
        CGFloat startX = (page * pageWidth) + (col * noteWidth) + ((col+1) * colSeperator);
        CGFloat startY = (row * noteHeight) + ((row + 1) * rowSeperator);
        CGRect viewFrame = CGRectMake(startX, startY, noteWidth, noteHeight);
        
        [((NoteView *) view) resizeToRect:viewFrame];
        [self.stackView addSubview:view];
        
        col++;
        if ( col >= COL_COUNT) {
            col = 0;
            row++;
            if ( row >= ROW_COUNT){
                row = 0 ;
                page++;
                needResizing = YES;
            }
        }
    }
    
}

-(void) screenTapped: (UITapGestureRecognizer *) sender{
    if (self.isInEditMode){
        self.isInEditMode = NO;
        self.highLightedNote.highlighted = NO;
        for (UIGestureRecognizer * gr in [self.highLightedNote gestureRecognizers]){
            if ([gr isKindOfClass:[UIPanGestureRecognizer class]]){
                [self.highLightedNote removeGestureRecognizer:gr];
            }
            
        }
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.stackView setContentSize:self.stackView.bounds.size];
    NSLog(@"Notes here: %d", [self.notes count]);
    [self layoutNotes];
}

- (void)viewDidUnload
{
    [self setStackView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

@end
