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
#import "StackView.h"

@interface BulletinBoardViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *label;
@property (weak, nonatomic) IBOutlet UIScrollView *bulletinboardView;
@property (strong, nonatomic) DropBoxAssociativeBulletinBoard * board;
@property (weak, nonatomic) UIView * layerView;
@property (strong, nonatomic) NSArray * intersectingViews;
@property int panCounter ;


@end

@implementation BulletinBoardViewController
@synthesize label = _label;
@synthesize bulletinboardView = _bulletinboardView; 
@synthesize parent = _parent;
@synthesize board = _board;
@synthesize layerView = _layerView;
@synthesize panCounter = _panCounter;
@synthesize intersectingViews = _intersectingViews;



@synthesize bulletinBoardName = _bulletinBoardName;


- (NSArray *) intersectingViews{
    if (!_intersectingViews){
        _intersectingViews = [[NSArray alloc] init];
    }
    return _intersectingViews;
}
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

- (NSArray *) checkForOverlapWithView: (UIView *) senderView{
    NSMutableArray * ans = [[NSMutableArray alloc] init];
    for (UIView * view in self.layerView.subviews){
        if ([view isKindOfClass: [NoteView class]] && view != senderView){
            if (CGRectIntersectsRect(view.frame,senderView.frame)){
                [ans addObject:view];
            }
        }
    }
    [ans addObject:senderView];
    return ans;
}


#define STACKING_SCALING_WIDTH 1.1
#define STACKING_SCALING_HEIGHT 1.2

-(void) stackNotes: (NSArray *) items into: (UIView *) mainNote{
     __block BOOL first = YES;
    for (UIView * view in items){
        if (view != mainNote){
            [UIView animateWithDuration:0.5
                                  delay:0 options:UIViewAnimationCurveEaseOut
                             animations:^{[view setFrame:mainNote.frame];}
                             completion:^(BOOL finished){
                                 [view removeFromSuperview];
                                 if (first){
                                     CGRect stackFrame = CGRectMake(mainNote.frame.origin.x - ((STACKING_SCALING_WIDTH -1)/4) * mainNote.frame.origin.x,
                                                                    mainNote.frame.origin.y - ((STACKING_SCALING_HEIGHT -1)/4) * mainNote.frame.origin.y,
                                                                    mainNote.frame.size.width * STACKING_SCALING_WIDTH,
                                                                    mainNote.frame.size.height * STACKING_SCALING_HEIGHT );
                                     StackView * stack = [[StackView alloc] initWithViews:items
                                                                          andMainView:(NoteView *)mainNote
                                                                            withFrame:
                                                      stackFrame];
                                     [UIView animateWithDuration:0.5 animations:^{mainNote.alpha = 0;}];
                                     [mainNote removeFromSuperview];
                                     mainNote.alpha = 1;
                                     stack.alpha =0;
                                     [self.layerView addSubview:stack];
                                     [UIView animateWithDuration:0.5 animations:^{stack.alpha = 1;}];
                                     first = NO;
                                 
                                 }
                         }];
        }
    }
    
    
    
    
    
}
#define CHECK_TIME 0
-(void) notePanned: (UIPanGestureRecognizer *) sender{
    if( sender.state == UIGestureRecognizerStateChanged ||
       sender.state == UIGestureRecognizerStateEnded){
        CGPoint translation = [sender translationInView:self.layerView];
        self.panCounter++;
        if (self.panCounter > CHECK_TIME ){
            self.panCounter = 0;
            NSArray * intersectingViews = [self checkForOverlapWithView:sender.view];
            
            if ( [intersectingViews count] != [self.intersectingViews count] || [intersectingViews count] == 1){
                for (UIView * view in self.intersectingViews){
                    view.alpha = 1;
                }
            }
            else{
                for (UIView * view in intersectingViews){
                    
                    view.alpha = 0.5;
                }
            }
            self.intersectingViews = intersectingViews;   
        }
        UIView * pannedView = [sender view];
        CGPoint newOrigin = CGPointMake(pannedView.frame.origin.x + translation.x,
                                        pannedView.frame.origin.y + translation.y);
        pannedView.frame = CGRectMake(newOrigin.x, newOrigin.y, pannedView.frame.size.width,pannedView.frame.size.height);
        [sender setTranslation:CGPointZero inView:self.layerView];
    }
    
    if (sender.state == UIGestureRecognizerStateEnded){
        
        for (UIView * view in self.intersectingViews){
            view.alpha = 1;
        }
        
        if ([self.intersectingViews count] > 1 ){
            [self stackNotes:self.intersectingViews into:sender.view];
        }
    }
    
}
-(void) mainScreenDoubleTapped:(UITapGestureRecognizer *)sender{
    
    CGPoint location = [sender locationOfTouch:0 inView:self.layerView];
    CGRect frame = CGRectMake(location.x, location.y, 200, 200);
    UIView * note = [[NoteView alloc] initWithFrame:frame];
    note.transform = CGAffineTransformScale(note.transform, 10, 10);
    note.alpha = 0;
    
    [UIView animateWithDuration:0.25 animations:^{
        note.transform = CGAffineTransformScale(note.transform, 0.1, 0.1);
        note.alpha = 1;
    }];
    
    [self.layerView addSubview:note];
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
    CGSize size =  CGSizeMake(self.bulletinboardView.bounds.size.width, self.bulletinboardView.bounds.size.height);
    [self.bulletinboardView setContentSize:size];
    UIScrollView * layerView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.bulletinboardView.bounds.origin.x,
                                                                              self.bulletinboardView.bounds.origin.y,
                                                                              size.width,
                                                                              size.height)];
    self.layerView = layerView;
    [self.bulletinboardView addSubview:layerView];
    UITapGestureRecognizer * gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mainScreenDoubleTapped:)];
    gr.numberOfTapsRequired = 2;
    
    [self.bulletinboardView addGestureRecognizer:gr];
    self.bulletinboardView.delegate = self;
    //    self.bulletinboardView.minimumZoomScale = 0.1;
    //  self.bulletinboardView.minimumZoomScale = 10;
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

/*
 Unlimited space is disable now
 - (UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView{
 return self.layerView;
 }
 */


@end
