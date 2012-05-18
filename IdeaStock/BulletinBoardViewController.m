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
#import "StackViewController.h"

@interface BulletinBoardViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *label;
@property (weak, nonatomic) IBOutlet UIScrollView *bulletinboardView;
@property (strong, nonatomic) DropBoxAssociativeBulletinBoard * board;
@property (strong, nonatomic) NSArray * intersectingViews;
@property int panCounter ;


@end

@implementation BulletinBoardViewController
@synthesize label = _label;
@synthesize bulletinboardView = _bulletinboardView; 
@synthesize parent = _parent;
@synthesize board = _board;
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

-(void) objectPinched: (UIPinchGestureRecognizer *) sender{
    
    if (sender.state == UIGestureRecognizerStateChanged ||
        sender.state == UIGestureRecognizerStateEnded){
        CGFloat scale = sender.scale;
        if ([sender.view conformsToProtocol: @protocol(BulletinBoardObject)]){
            UIView <BulletinBoardObject> * view = (NoteView *) sender.view;
            view.frame = CGRectMake(view.frame.origin.x,
                                    view.frame.origin.y, 
                                    view.frame.size.width * scale,
                                    view.frame.size.height * scale);
            [view scale:scale];
        }
        
        sender.scale = 1 ;
    }
}

- (NSArray *) checkForOverlapWithView: (UIView *) senderView{
    NSMutableArray * ans = [[NSMutableArray alloc] init];
    for (UIView * view in self.bulletinboardView.subviews){
        if (view != senderView && [view conformsToProtocol:@protocol(BulletinBoardObject)]){
            if (CGRectIntersectsRect(view.frame,senderView.frame)){
                [ans addObject:view];
                
            }
        }
    }
    [ans addObject:senderView];
    return ans;
}

-(void) stackTapped: (UIPanGestureRecognizer *) sender{
    StackViewController * stackViewer = [self.storyboard instantiateViewControllerWithIdentifier:@"StackView"];
    stackViewer.delegate = self;
    stackViewer.notes = ((StackView *) sender.view).views;
    [self presentModalViewController:stackViewer animated:YES];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    ((StackViewController *) segue.destinationViewController).delegate = self;
    NSArray * notes = ((StackView *) sender).views;
    ((StackViewController *) segue.destinationViewController).notes = notes;
}

#define STACKING_SCALING_WIDTH 1.1
#define STACKING_SCALING_HEIGHT 1.2

-(void) stackNotes: (NSArray *) items into: (UIView *) mainView{
    __block BOOL first = YES;
    
    for (UIView * view in items){
        if (view != mainView){
            [UIView animateWithDuration:0.5
                                  delay:0 options:UIViewAnimationCurveEaseOut
                             animations:^{[view setFrame:mainView.frame];}
                             completion:^(BOOL finished){
                                 [view removeFromSuperview];
                                 if (first){
                                     CGRect stackFrame;
                                     if ([mainView isKindOfClass:[NoteView class]]){
                                      stackFrame = CGRectMake(mainView.frame.origin.x - ((STACKING_SCALING_WIDTH -1)/4) * mainView.frame.origin.x,
                                                                    mainView.frame.origin.y - ((STACKING_SCALING_HEIGHT -1)/4) * mainView.frame.origin.y,
                                                                    mainView.frame.size.width * STACKING_SCALING_WIDTH,
                                                                    mainView.frame.size.height * STACKING_SCALING_HEIGHT );
                                     }
                                     else if ([mainView isKindOfClass:[StackView class]]){
                                         stackFrame = mainView.frame;
                                     }
                                     
                                     NSArray * allNotes = [self getAllNormalNotesInViews:items];
                                     StackView * stack = [[StackView alloc] initWithViews:allNotes
                                                                              andMainView:(NoteView *)mainView
                                                                                withFrame:
                                                          stackFrame];
                                     [UIView animateWithDuration:0.5 animations:^{mainView.alpha = 0;}];
                                     [mainView removeFromSuperview];
                                     mainView.alpha = 1;
                                     stack.alpha =0;
                                     UIPanGestureRecognizer * gr = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(objectPanned:)];
                                     UIPinchGestureRecognizer * pgr = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(objectPinched:)];
                                     UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stackTapped:)];
                                     [stack addGestureRecognizer:gr];
                                     [stack addGestureRecognizer:pgr];
                                     [stack addGestureRecognizer:tgr];
                                     [self.bulletinboardView addSubview:stack];
                                     [UIView animateWithDuration:0.5 animations:^{stack.alpha = 1;}];
                                     first = NO;
                                     
                                 }
                             }];
        }
    }
    
    
    
    
    
}


- (NSArray *) getAllNormalNotesInViews: (NSArray *) views{
    NSMutableArray * ans = [[NSMutableArray alloc] init];
    for (UIView * view in views){
        if ([view isKindOfClass: [NoteView class]]){
            [ans addObject:view];
        }
        else if ([view isKindOfClass:[StackView class]]){
            [view removeFromSuperview];
            [ans addObjectsFromArray:((StackView *) view).views];
        }
    }
    return ans;
}

#define CHECK_TIME 0
-(void) objectPanned: (UIPanGestureRecognizer *) sender{
    if( sender.state == UIGestureRecognizerStateChanged ||
       sender.state == UIGestureRecognizerStateEnded){
        CGPoint translation = [sender translationInView:self.bulletinboardView];
        UIView * pannedView = [sender view];
        CGPoint newOrigin = CGPointMake(pannedView.frame.origin.x + translation.x,
                                        pannedView.frame.origin.y + translation.y);
        pannedView.frame = CGRectMake(newOrigin.x, newOrigin.y, pannedView.frame.size.width,pannedView.frame.size.height);
        [sender setTranslation:CGPointZero inView:self.bulletinboardView];
        
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
    UIPanGestureRecognizer * gr = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(objectPanned:)];
    UIPinchGestureRecognizer * pgr = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(objectPinched:)];
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
    
    UITapGestureRecognizer * gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mainScreenDoubleTapped:)];
    gr.numberOfTapsRequired = 2;
    
    [self.bulletinboardView addGestureRecognizer:gr];
    self.bulletinboardView.delegate = self;
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




/*----------------
 Stack View Delegate Methods
 -------------------*/

-(void) returnedstackViewController:(StackViewController *)sender{
    [self dismissModalViewControllerAnimated:YES];
}


@end
