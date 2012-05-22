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
#import "BulletinBoardNote.h"


@interface BulletinBoardViewController ()


/*========================================================================*/


/*-----------------------------------------------------------
                        UI Properties
 -----------------------------------------------------------*/
@property (weak, nonatomic) IBOutlet UIBarButtonItem *label;
@property (weak, nonatomic) IBOutlet UIScrollView *bulletinboardView;
@property (strong, nonatomic) UIBarButtonItem * deleteButton;
@property (strong, nonatomic) UIBarButtonItem * expandButton;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

/*-----------------------------------------------------------
                            Model
 -----------------------------------------------------------*/
@property (strong, nonatomic) DropBoxAssociativeBulletinBoard * board;

/*-----------------------------------------------------------
                        Modal Properties
 -----------------------------------------------------------*/
@property (strong, nonatomic) NSArray * intersectingViews;
@property (weak, nonatomic) UIView<BulletinBoardObject> * highlightedView;
@property (nonatomic) BOOL editMode;
@property int panCounter ;

@end


/*========================================================================*/


@implementation BulletinBoardViewController

/*-----------------------------------------------------------
                    Synthesizers
 -----------------------------------------------------------*/
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

-(DropBoxAssociativeBulletinBoard *) board{
    
    if (!_board){
        _board = [[DropBoxAssociativeBulletinBoard alloc] initBulletinBoardFromXoomlWithName:self.bulletinBoardName];
    }
    return _board;
}

-(void) setBulletinBoardName:(NSString *) bulletinBoardName{
    _bulletinBoardName = bulletinBoardName;
    
    
}

/*========================================================================*/

/*-----------------------------------------------------------
                    Initializers
 -----------------------------------------------------------*/

- (id)initWithNibName:(NSString *) nibNameOrNil bundle:(NSBundle *) nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

/*-----------------------------------------------------------
                        UI Action Helper
 -----------------------------------------------------------*/

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
                                                                 mainView.bounds.size.width * STACKING_SCALING_WIDTH,
                                                                 mainView.bounds.size.height * STACKING_SCALING_HEIGHT );
                                     }
                                     else if ([mainView isKindOfClass:[StackView class]]){
                                         stackFrame = mainView.frame;
                                     }
                                     
                                     NSMutableArray * allNotes = [self getAllNormalNotesInViews:items];
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

- (NSMutableArray *) getAllNormalNotesInViews: (NSArray *) views{
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

/*-----------------------------------------------------------
                        Layout Methods
 -----------------------------------------------------------*/

#define EXPAND_COL_SIZE 5
#define SEPERATOR_RATIO 0.1
-(CGSize) getRectSizeForStack: (StackView *) stack{
    
    int notesInStack = [stack.views count];
    
    //get the number of rows in expanded state
    int numberOfRows = notesInStack / EXPAND_COL_SIZE;
    if (notesInStack % EXPAND_COL_SIZE != 0 ) numberOfRows++;
    
    //get a single note size from the main note in stack
    NoteView * dummyNote = ((NoteView *)[stack.views lastObject]);
    [dummyNote resetSize];
    float noteWidth = dummyNote.bounds.size.width ;
    float noteHeight = dummyNote.bounds.size.height ;
    
    //calculate the rectangle size before adding seperators
    int rowItems = notesInStack >= EXPAND_COL_SIZE ? EXPAND_COL_SIZE : notesInStack;
    float seperatorSpace = MAX(noteWidth,noteHeight) * SEPERATOR_RATIO;
    float rectWidth = noteWidth + ( (noteWidth/3) * (rowItems - 1)) + ((numberOfRows) * seperatorSpace);
    float rectHeight= (2* seperatorSpace) + noteHeight + ( (noteHeight/3) * (numberOfRows - 1));
    
    //add seperator sizes
    // float biggerSize = MAX(rectWidth, rectHeight);
    // float seperatorSize = SEPERATOR_RATIO * biggerSize;
    //rectWidth += (EXPAND_COL_SIZE + 1) * seperatorSize;
    //rectHeight += (numberOfRows + 1) * seperatorSize;
    
    return CGSizeMake(rectWidth, rectHeight);
}

-(CGRect) findFittingRectangle: (StackView *) stack{
    
    //find the size
    CGSize rectSize = [self getRectSizeForStack:stack];
    
    //now find the starting position
    float stackMiddleX = stack.frame.origin.x + stack.frame.size.width/2;
    float stackMiddleY = stack.frame.origin.y + stack.frame.size.height/2;
    
    //first find the starting x
    float startX = 0;
    float startY = 0;
    if (stackMiddleX + rectSize.width/2 > self.bulletinboardView.bounds.origin.x + self.bulletinboardView.bounds.size.width){
        //rect goes out of the right side of screen so fit it in a way that the right side of rect is on the right side of 
        //the screen
        startX = (self.bulletinboardView.bounds.origin.x + self.bulletinboardView.bounds.size.width) - rectSize.width;
    }
    else if (stackMiddleX - rectSize.width/2 < self.bulletinboardView.bounds.origin.x){
        //rect goes out of the left side of screen so fit it in a way that the left side of rect is on the left side of 
        //the screen
        startX = self.bulletinboardView.bounds.origin.x;
    }
    else{
        //rect fits around the stack 
        startX = stackMiddleX - rectSize.width/2;
    }
    
    //do the same thing to find starting y
    if (stackMiddleY + rectSize.height/2 > self.bulletinboardView.bounds.origin.y + self.bulletinboardView.bounds.size.height){
        startY  = (self.bulletinboardView.bounds.origin.y + self.bulletinboardView.bounds.size.height) - rectSize.height;
    }
    else if (stackMiddleY - rectSize.height/2 < self.bulletinboardView.bounds.origin.y){
        startY = self.bulletinboardView.bounds.origin.y;
    }
    else {
        startY = stackMiddleY - rectSize.height/2;
    }

    return CGRectMake(startX, startY, rectSize.width, rectSize.height);
}

#define EXIT_OFFSET_RATIO 0.1
-(void) clearRectangle: (CGRect) rect{
    for (UIView * subView in self.bulletinboardView.subviews){
        if ([subView isKindOfClass:[NoteView class]]){
            if (CGRectIntersectsRect(subView.frame, rect)){
                
                float newStartX = subView.frame.origin.x;
                float newStartY = subView.frame.origin.y;
                
                float offsetX = EXIT_OFFSET_RATIO * subView.frame.size.width;
                float offsetY = EXIT_OFFSET_RATIO * subView.frame.size.height;
                
                //find the closest point for the view to exit
                float rectMid = rect.origin.x + rect.size.width/2;
                if (subView.frame.origin.x < rectMid){
                    //view is in the left side of the rect 
                    //find the distance to move the view come out of the rect
                    //it will first try to see if the view fits the screen if it exits from the right side rect
                    //if this is not possible it tries the lower side of the rect and if that doesnt work either
                    //it should definetly fit the top side ( given that the rect is not bigger than the screen)
                    //we try each case in order
                    
                    //first the left side. This distance is the distance between the left edge of the rect and the right edge of view
                    float distanceToExitX = (subView.frame.origin.x + subView.frame.size.width + offsetX) - rect.origin.x;
                    
                    //check to see if traveling this distance makes the subView fall out of screen on the left side
                    if ( subView.frame.origin.x - distanceToExitX > self.bulletinboardView.bounds.origin.x){
                        //the view doesn't fall out of the screen so move make its starting point there
                        newStartX = subView.frame.origin.x - distanceToExitX;
                    }
                    else{
                        //the view falls out of the screen if we move left, try moving down
                        //the distance is between the top edge of the subview and low buttom of the rect
                        float distanceToExitY = (rect.origin.y + rect.size.height + offsetY) - (subView.frame.origin.y);
                        if (subView.frame.origin.y + subView.frame.size.height +distanceToExitY < self.bulletinboardView.bounds.origin.y + self.bulletinboardView.bounds.size.height){
                            //the view can be fit outside the lower edge of the rect
                            newStartY = subView.frame.origin.y + distanceToExitY;
                        }
                        else {
                            //the view cannot be fit in the left side of rect or the down side of the rect, surely it can fit in the upper side of the rect
                            //find the distance to exit from the top side. the distance is between the low edge of the view and the top edge of the rect
                            distanceToExitY = (subView.frame.origin.y + subView.frame.size.height + offsetY) - rect.origin.y;
                            newStartY = subView.frame.origin.y - distanceToExitY;
                        }
                    }
                    
                }
                
                
                //we follow the same algorithm if the view is in the right side of the rect
                else {
                    
                    //try the rightside. The distance is between the right edge of rect and left edge of view
                    float distanceToExitX = (rect.origin.x + rect.size.width + offsetX) - (subView.frame.origin.x );
                    if (subView.frame.origin.x + subView.frame.size.width + distanceToExitX < self.bulletinboardView.bounds.origin.x + self.bulletinboardView.bounds.size.width){
                        //fits in the right side 
                        newStartX = subView.frame.origin.x + distanceToExitX;
                    }
                    else{
                        //try the lower side
                        float distanceToExitY = (rect.origin.y + rect.size.height + offsetY) - (subView.frame.origin.y);
                        if (subView.frame.origin.y +subView.frame.size.height + distanceToExitY < self.bulletinboardView.bounds.origin.y + self.bulletinboardView.bounds.size.height){
                            newStartY = subView.frame.origin.y + distanceToExitY;
                        }
                        else{
                            //use the top side
                            distanceToExitY = (subView.frame.origin.y + subView.frame.size.height + offsetY) - rect.origin.y;
                            newStartY = subView.frame.origin.y - distanceToExitY;
                        }
                    }
                }
                
                [UIView animateWithDuration:0.25 animations:^{subView.frame = CGRectMake(newStartX, newStartY, subView.frame.size.width, subView.frame.size.height);}];
            }
        }
    }
}

-(void) layoutStackView: (StackView *) stack inRect: (CGRect) rect{
    
    NSArray * items = stack.views;
    
    //now find the size of the seperator from any note
    [((NoteView *) [items lastObject]) resetSize];
    float noteWidth = ((NoteView *)[items lastObject]).frame.size.width  ;
    float noteHeight = ((NoteView *)[items lastObject]).frame.size.height;

    //remove all existing gesture recognizers and add the new ones. 
    //finally position all the notes in the center of the stackView
    for (NoteView * view in items){
        for (UIGestureRecognizer * gr in view.gestureRecognizers){
            [view removeGestureRecognizer:gr];
        }
        UIPanGestureRecognizer * gr = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(objectPanned:)];
        UIPinchGestureRecognizer * pgr = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(objectPinched:)];
        UILongPressGestureRecognizer * lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(objectPressed:)];
        
        [view addGestureRecognizer:lpgr];
        [view addGestureRecognizer:gr];
        [view addGestureRecognizer:pgr];
        
         view.delegate = self;
        [view resetSize];
        [view removeFromSuperview];
        [self.bulletinboardView addSubview:view];
        CGRect viewTempFrame = CGRectMake(stack.frame.origin.x, stack.frame.origin.y, view.frame.size.width, view.frame.size.height);
        view.frame = viewTempFrame;
        

    }
    
    //now remove the stack itself
    [UIView animateWithDuration:0.25 animations:^{ stack.alpha = 0 ;} completion:^(BOOL finished){[stack removeFromSuperview];}];
    
    
    float seperator = SEPERATOR_RATIO * MAX(noteWidth, noteHeight);
    
    float startX = rect.origin.x + seperator;
    float startY = rect.origin.y + seperator;
    
    int rowCount = 0;
    int colCount = 0;
    for (NoteView * view in items){
        [UIView animateWithDuration:0.5 animations:^{view.frame = CGRectMake(startX, startY, view.frame.size.width, view.frame.size.height);}];
        rowCount++;
        if (rowCount >= EXPAND_COL_SIZE){
            rowCount = 0;
            colCount++;
            startX = rect.origin.x + seperator * (colCount+1);
            startY += noteHeight/3;
        }
        else{
            startX += noteWidth/3;
        }
        
    }
}

-(NSArray *) intersectingViews{
    if (!_intersectingViews){
        _intersectingViews = [[NSArray alloc] init];
    }
    return _intersectingViews;
}

-(NSArray *) checkForOverlapWithView: (UIView *) senderView{
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

/*-----------------------------------------------------------
                        Gesture Events
 -----------------------------------------------------------*/

-(void) screenTapped: (UIGestureRecognizer *) sender{
    if (self.editMode){
        self.editMode = NO;
        self.highlightedView.highlighted = NO;
        [self removeContextualToolbarItems:self.highlightedView];
        self.highlightedView = nil;
        
    }
}

-(void) mainScreenDoubleTapped:(UITapGestureRecognizer *) sender{
    
    if (self.editMode) return;
    
    CGPoint location = [sender locationOfTouch:0 inView:self.bulletinboardView];
    CGRect frame = CGRectMake(location.x, location.y, 200, 200);
    NoteView * note = [[NoteView alloc] initWithFrame:frame];
    note.transform = CGAffineTransformScale(note.transform, 10, 10);
    note.alpha = 0;
    note.delegate = self;
    
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
    
    //add note to dropbox
    
    
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

-(void) stackTapped: (UIPanGestureRecognizer *) sender{
    StackViewController * stackViewer = [self.storyboard instantiateViewControllerWithIdentifier:@"StackView"];
    stackViewer.delegate = self;
    stackViewer.notes = ((StackView *) sender.view).views;
    stackViewer.openStack = (StackView *) sender.view;
    [self presentModalViewController:stackViewer animated:YES];
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

/*-----------------------------------------------------------
                         UI Events
 -----------------------------------------------------------*/

-(void) viewDidLoad
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

-(IBAction) expandPressed:(id) sender {
    if (!self.editMode) return;
    
    if (![self.highlightedView isKindOfClass:[StackView class]]) return;
    
    
    CGRect fittingRect = [self findFittingRectangle: (StackView *) self.highlightedView];
    
    //move stuff that is in the rectangle out of it
    [self clearRectangle: fittingRect];
    
    //layout stack in the empty rect
    [self layoutStackView:(StackView *) self.highlightedView inRect:fittingRect ];
    
    //clean up
    [self removeContextualToolbarItems:self.highlightedView];
    self.highlightedView = nil;
    self.editMode = NO;

    
}

-(IBAction) deletePressed:(id) sender {
    if(!self.editMode) return;
    
    
    [self removeContextualToolbarItems:self.highlightedView];
    
    if ([self.highlightedView isKindOfClass:[StackView class]]){
        for (UIView * view in ((StackView *) self.highlightedView).views){
            [view removeFromSuperview];
        }
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        self.highlightedView.transform = CGAffineTransformScale(self.highlightedView.transform, 0.05, 0.05);
    }completion:^ (BOOL didFinish){
        [self.highlightedView removeFromSuperview];
        self.editMode = NO;
        self.highlightedView = nil;
    }];
    
    
}

-(IBAction)backPressed:(id) sender {
    
    //save the bulletinboard
    
    [self.parent finishedWorkingWithBulletinBoard];
}

-(void) viewDidUnload
{
    [self setLabel:nil];
    [self setView:nil];
    [self setBulletinboardView:nil];
    [self setToolbar:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

/*-----------------------------------------------------------
                        Stack Delegate Protocol
 -----------------------------------------------------------*/

-(void) returnedstackViewController:(StackViewController *)sender{
    [self dismissModalViewControllerAnimated:YES];
}

-(void) unstackItem:(UIView *) item
           fromView: (UIView *) stackView 
      withPastCount: (int) count{
    if (!item) NSLog(@"Fuck you nill item");
    if ( [item isKindOfClass:[NoteView class]]){
        NoteView * noteItem = (NoteView *) item;
        
        for (UIGestureRecognizer * gr in noteItem.gestureRecognizers){
            [noteItem removeGestureRecognizer:gr];
        }
    
        UIPanGestureRecognizer * gr = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(objectPanned:)];
        UIPinchGestureRecognizer * pgr = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(objectPinched:)];
        UILongPressGestureRecognizer * lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(objectPressed:)];
    
        [noteItem addGestureRecognizer:lpgr];
        [noteItem addGestureRecognizer:gr];
        [noteItem addGestureRecognizer:pgr];
    
        noteItem.delegate = self;
        [noteItem resetSize];

        [noteItem resetSize];
        float offset = SEPERATOR_RATIO * noteItem.frame.size.width;
        CGRect tempRect = CGRectMake (self.bulletinboardView.frame.origin.x + offset,
                                      self.bulletinboardView.frame.origin.y + self.bulletinboardView.frame.size.height - (noteItem.frame.size.height + offset),
                                      noteItem.frame.size.width,
                                      noteItem.frame.size.height);
        noteItem.frame = tempRect;
        [self.bulletinboardView addSubview:noteItem];
        [UIView animateWithDuration:0.5 animations:^{ noteItem.alpha = 1;} completion:^(BOOL isFinished){
            CGRect finalRect = CGRectMake(stackView.frame.origin.x + (count * offset * 2), 
                                          stackView.frame.origin.y + (count * offset * 2), 
                                          noteItem.frame.size.width,
                                          noteItem.frame.size.height);
            [UIView animateWithDuration:1 animations:^{noteItem.frame = finalRect;}];
        }];
        
    }
}

/*-----------------------------------------------------------
                        Note Delegate Protocol
 -----------------------------------------------------------*/

-(void) textViewDidEndEditing:(UITextView *)textView{
    NSLog(@"synchronize dropbox");
}


@end
