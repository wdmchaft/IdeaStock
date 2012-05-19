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
@property (strong, nonatomic) UIBarButtonItem * deleteButton;
@property (strong, nonatomic) UIBarButtonItem * expandButton;
@property (weak, nonatomic) UIView<BulletinBoardObject> * highlightedView;

@property int panCounter ;
@property (nonatomic) BOOL editMode;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;


@end

@implementation BulletinBoardViewController
@synthesize label = _label;
@synthesize bulletinboardView = _bulletinboardView; 
@synthesize parent = _parent;
@synthesize board = _board;
@synthesize panCounter = _panCounter;
@synthesize toolbar = _toolbar;
@synthesize intersectingViews = _intersectingViews;
@synthesize deleteButton = _deleteButton;
@synthesize expandButton = _expandButton;
@synthesize editMode = _editMode;
@synthesize highlightedView = _highlightedView;



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
    
    if (self.editMode) return;
    if (sender.state == UIGestureRecognizerStateChanged ||
        sender.state == UIGestureRecognizerStateEnded){
        CGFloat scale = sender.scale;
        if ([sender.view conformsToProtocol: @protocol(BulletinBoardObject)]){
            UIView <BulletinBoardObject> * view = (NoteView *) sender.view;
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
                                     UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(objectPressed:)];
                                     [stack addGestureRecognizer:gr];
                                     [stack addGestureRecognizer:pgr];
                                     [stack addGestureRecognizer:tgr];
                                     [stack addGestureRecognizer:lpgr];
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

-(void) removeContextualToolbarItems:(UIView *) contextView{
    
    NSMutableArray * newToolbarItems = [self.toolbar.items mutableCopy];
    [newToolbarItems removeLastObject];
    if( [contextView isKindOfClass:[StackView class]]){
        [newToolbarItems removeLastObject];
    }
    self.toolbar.items = newToolbarItems;
}

-(void) addContextualToolbarItems: (UIView *) contextView{
    NSMutableArray * newToolbarItems = [self.toolbar.items mutableCopy];
    if ( [contextView isKindOfClass:[StackView class]]){
        [newToolbarItems addObject:self.expandButton];
    }
    [newToolbarItems addObject:self.deleteButton];
    self.toolbar.items = newToolbarItems;
    
    
}
-(void) objectPressed: (UILongPressGestureRecognizer *) sender{
    
    
    if ( sender.state == UIGestureRecognizerStateBegan){
        
        if (self.highlightedView && self.highlightedView != sender.view){
            self.highlightedView.highlighted = NO;
            [self removeContextualToolbarItems:self.highlightedView];
            self.highlightedView = (UIView <BulletinBoardObject> *) sender.view;
            [self addContextualToolbarItems:self.highlightedView];
            self.highlightedView.highlighted = YES;
            
        }
        else if (self.editMode){
            self.editMode = NO;
            self.highlightedView = nil;
            [self removeContextualToolbarItems:sender.view];
            
            if ([sender.view conformsToProtocol:@protocol(BulletinBoardObject)]){
                ((UIView <BulletinBoardObject> * ) sender.view).highlighted = NO;
            }
        }
        else{
            self.editMode = YES;
            self.highlightedView = (UIView <BulletinBoardObject> *) sender.view;
            
            [self addContextualToolbarItems:sender.view];
            
            if ([sender.view conformsToProtocol:@protocol(BulletinBoardObject)]){
                ((UIView <BulletinBoardObject> * ) sender.view).highlighted = YES;
            }
        }
    }
    
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
        
        if (self.editMode) return;
        
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
    
    if (self.editMode) return;
    
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
    UILongPressGestureRecognizer * lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(objectPressed:)];
    
    [note addGestureRecognizer:lpgr];
    [note addGestureRecognizer:gr];
    [note addGestureRecognizer:pgr];
    
}

-(void) screenTapped: (UIGestureRecognizer *)sender{
    if (self.editMode){
        self.editMode = NO;
        self.highlightedView.highlighted = NO;
        [self removeContextualToolbarItems:self.highlightedView];
        self.highlightedView = nil;
        
    }
}

- (void)viewDidLoad
{
    
    int len = [[self.toolbar items] count];
    self.deleteButton = [[self.toolbar items] objectAtIndex:len - 1];
    self.expandButton = [[self.toolbar items] objectAtIndex:len - 2];
    NSMutableArray * toolBarItems = [[NSMutableArray alloc] init];
    for ( int i = 0 ; i < 4 ; i++){
        [toolBarItems addObject:[[self.toolbar items] objectAtIndex:i]];
    }
    self.toolbar.items = [toolBarItems copy];
    
    [super viewDidLoad];
    self.label.title = self.bulletinBoardName;
    CGSize size =  CGSizeMake(self.bulletinboardView.bounds.size.width, self.bulletinboardView.bounds.size.height);
    [self.bulletinboardView setContentSize:size];
    
    UITapGestureRecognizer * gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mainScreenDoubleTapped:)];
    gr.numberOfTapsRequired = 2;
    UITapGestureRecognizer * tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(screenTapped:)];
    [self.bulletinboardView addGestureRecognizer:gr];
    [self.bulletinboardView addGestureRecognizer:tgr];
    self.bulletinboardView.delegate = self;
}
- (IBAction)deletePressed:(id)sender {
    if(!self.editMode) return;
    
    
    [self removeContextualToolbarItems:self.highlightedView];
    if ([self.highlightedView isKindOfClass:[NoteView class]]){
        [self.highlightedView removeFromSuperview];        
    }
    else if ([self.highlightedView isKindOfClass:[StackView class]]){
        for (UIView * view in ((StackView *) self.highlightedView).views){
            [view removeFromSuperview];
        }
    [self.highlightedView removeFromSuperview ];
}

self.editMode = NO;
self.highlightedView = nil;
}

- (void)viewDidUnload
{
    [self setLabel:nil];
    [self setView:nil];
    [self setBulletinboardView:nil];
    [self setToolbar:nil];
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
