//
//  BulletinBoardViewController.m
//  IdeaStock
//
//  Created by Ali Fathalian on 4/28/12.
//  Copyright (c) 2012 University of Washington. All rights reserved.
//

#import "BulletinBoardViewController.h"
#import "DropBoxAssociativeBulletinBoard.h"
#import "NoteView.h"

@interface BulletinBoardViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *label;
@property (weak, nonatomic) IBOutlet UIScrollView *bulletinboardView;
@property (strong, nonatomic) DropBoxAssociativeBulletinBoard * board;

@end

@implementation BulletinBoardViewController
@synthesize label = _label;
@synthesize bulletinboardView = _bulletinboardView; 
@synthesize parent = _parent;
@synthesize board = _board;


@synthesize bulletinBoardName = _bulletinBoardName;

- (DropBoxAssociativeBulletinBoard *) board{

    if (!_board){
        _board = [[DropBoxAssociativeBulletinBoard alloc] initBulletinBoardFromXoomlWithName:self.bulletinBoardName];
    }
    return _board;
}
- (void) setBulletinBoardName:(NSString *)bulletinBoardName{
    _bulletinBoardName = bulletinBoardName;

    
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)backPressed:(id)sender {
    
    //save the bulletinboard
    
    [self.parent finishedWorkingWithBulletinBoard];
}

-(void) notePinched: (UIPinchGestureRecognizer *) sender{
    
    if (sender.state == UIGestureRecognizerStateChanged ||
        sender.state == UIGestureRecognizerStateEnded){
        CGFloat scale = sender.scale;
        if ([sender.view isKindOfClass: [NoteView class]]){
            NSLog(@"Note View Pinched");
            NoteView * noteView = (NoteView *) sender.view;
            noteView.frame = CGRectMake(noteView.frame.origin.x,
                                        noteView.frame.origin.y, 
                                        noteView.frame.size.width * scale,
                                        noteView.frame.size.height * scale);
            [noteView scale:scale];
        }
        
        sender.scale = 1 ;
    }
}
-(void) notePanned: (UIPanGestureRecognizer *) sender{
    if( sender.state == UIGestureRecognizerStateChanged ||
       sender.state == UIGestureRecognizerStateEnded){
        CGPoint translation = [sender translationInView:self.bulletinboardView];
        UIView * pannedView = [sender view];
        CGPoint newOrigin = CGPointMake(pannedView.frame.origin.x + translation.x,
                                               pannedView.frame.origin.y + translation.y);
        pannedView.frame = CGRectMake(newOrigin.x, newOrigin.y, pannedView.frame.size.width,pannedView.frame.size.height);
        [sender setTranslation:CGPointZero inView:self.bulletinboardView];
    }
}
-(void) mainScreenDoubleTapped:(UITapGestureRecognizer *)sender{
    
    CGPoint location = [sender locationOfTouch:0 inView:self.bulletinboardView];
    CGRect frame = CGRectMake(location.x, location.y, 200, 200);
    UIView * note = [[NoteView alloc] initWithFrame:frame];
    note.transform = CGAffineTransformScale(note.transform, 10, 10);
    note.alpha = 0;

    [UIView animateWithDuration:0.25 animations:^{
        note.transform = CGAffineTransformScale(note.transform, 0.1, 0.1);
        note.alpha = 1;
    }];
    
    [self.bulletinboardView addSubview:note];
    UIPanGestureRecognizer * gr = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(notePanned:)];
    UIPinchGestureRecognizer * pgr = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(notePinched:)];
    [note addGestureRecognizer:gr];
    [note addGestureRecognizer:pgr];
}

- (void)viewDidLoad
{
    
    //load and display notes and groupings
    //...
    
    [super viewDidLoad];
    self.label.title = self.bulletinBoardName;
    CGSize size =  CGSizeMake(self.bulletinboardView.bounds.size.width * 5, self.bulletinboardView.bounds.size.height * 5);
   [self.bulletinboardView setContentSize:size];

    UITapGestureRecognizer * gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mainScreenDoubleTapped:)];
    gr.numberOfTapsRequired = 2;
    [self.bulletinboardView addGestureRecognizer:gr];

	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setLabel:nil];
    [self setView:nil];
    [self setBulletinboardView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

@end
