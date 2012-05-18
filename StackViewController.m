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

@end

@implementation StackViewController
@synthesize stackView = _stackView;


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

-(void) notePressed: (UIGestureRecognizer *) sender{
    
    ((NoteView *) sender.view).highlighted = !((NoteView *) sender.view).highlighted;
    
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
