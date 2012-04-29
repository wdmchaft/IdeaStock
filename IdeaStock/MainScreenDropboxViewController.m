//
//  MainScreenDropbox.m
//  IdeaStock
//
//  Created by Ali Fathalian on 4/24/12.
//  Copyright (c) 2012 University of Washington. All rights reserved.
//

#import "MainScreenDropboxViewController.h"
#import "XoomlBulletinBoardController.h"

@interface MainScreenDropboxViewController ()

//this is the main model that will be initialized from dropbox. 
@property (nonatomic,strong) NSMutableArray * bulletinBoardNames;
@property (strong, nonatomic) NSMutableArray * bulletinBoardViews; 
@property (weak, nonatomic) IBOutlet UIView *prototypeView;
@property (weak, nonatomic) IBOutlet UIScrollView *mainView;
//Maybe change this to a more graceful way of cycling through colors
@property int colorOrder;

@end

/*--------------------------------------------------------------------------------------
 Synthesizers
 ----------------------------------------------------------------------------------------*/


@implementation MainScreenDropboxViewController

@synthesize bulletinBoardViews = _bulletinBoardViews;
@synthesize dropBox = _dropBox;
@synthesize bulletinBoardNames = _bulletinBoardNames;
@synthesize prototypeView = _prototypeView;
@synthesize mainView = _mainView;
@synthesize queue = _queue;
@synthesize colorOrder = _colorOrder;

- (NSMutableArray *) bulletinBoardViews{
    
    if (!_bulletinBoardViews){
        _bulletinBoardViews = [NSMutableArray array];
    }
    return _bulletinBoardViews;
}

- (NSMutableArray *) bulletinBoardNames{
    
    if (!_bulletinBoardNames){
        _bulletinBoardNames = [NSMutableArray array];
    }
    return _bulletinBoardNames;
}

- (DropboxDataModel *) dropBox{
    
    if (!_dropBox){
        _dropBox = [[DropboxDataModel alloc] init];
    }
    return _dropBox;
}

/*---------------------------------------------------------------------------------------------------
 Layout methods
 --------------------------------------------------------------------------------------------------*/


-(UIView *) createBulletinBoardPreviewWithName: (NSString *) name inFrame: (CGRect) frame{
    
    UIImage * image;
    
    if ( self.colorOrder == 0 ) {
        image  = [UIImage imageNamed:@"green board.png"];
        self.colorOrder++;
        
    }
    else if ( self.colorOrder == 1){
        image =[UIImage imageNamed:@"red board.png"];
        self.colorOrder++;
    }
    else {
        image =[UIImage imageNamed:@"blue board.png"];
        self.colorOrder = 0 ;
    }
    
    UIImageView * view = [[UIImageView alloc] initWithImage:image];
    [view setFrame:frame];
    CGFloat middleX = view.bounds.size.width/2 + view.bounds.origin.x;
    CGFloat middleY = view.bounds.size.height/2 + view.bounds.origin.y;
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(middleX * 0.4, middleY * 0.85, view.bounds.size.width/2, 0.1* view.bounds.size.height)];
    label.text = name;
    [label setBackgroundColor:[UIColor clearColor]];
    label.textAlignment = UITextAlignmentCenter;
    label.font = [UIFont fontWithName:@"Helvetica" size:14.0];
    [view addSubview:label];
    
    [view setUserInteractionEnabled:YES];
    [view setMultipleTouchEnabled:YES];
    SEL actionSelector = @selector(selectBulletinBoard:);
    UITapGestureRecognizer * gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:actionSelector];
    [view addGestureRecognizer:gr];
    
    return view;
}

#define X_STARTING_POS 40
#define Y_STARTING_POST 40
#define PORTRAIT_ROW_COUNT 3
#define PORTRAIT_COL_COUNT 4
#define LANDSCAPE_ROW_COUNT 4
#define LANDSCAPE_COL_COUNT 3
//ROW AND COL ARE USED IN REVERSE ! 
-(void) layoutBulletinBoards: (BOOL) animation withDuration: (float) duration{
    
    CGSize newSize = CGSizeMake(self.mainView.bounds.size.width, self.mainView.bounds.size.height);
    [self.mainView setContentSize: newSize];
    
    CGFloat initPointX = X_STARTING_POS;
    CGFloat initPointY = Y_STARTING_POST;
    
    int rowCount = 0;
    int colCount = 0;
    CGFloat rowOffset = initPointX ;
    
    BOOL isFirst = YES;
    
    if ( [UIDevice currentDevice].orientation ==  UIDeviceOrientationPortrait || [UIDevice currentDevice].orientation == UIDeviceOrientationPortraitUpsideDown){
        int numPages = self.bulletinBoardViews.count / (PORTRAIT_ROW_COUNT * PORTRAIT_COL_COUNT);
        int remainder = self.bulletinBoardViews.count % (PORTRAIT_COL_COUNT * PORTRAIT_ROW_COUNT);
        if ( remainder ==  0 ) numPages --;
        
        CGSize newSize = CGSizeMake(self.mainView.contentSize.width * (numPages + 1), self.mainView.contentSize.height);
        [self.mainView setContentSize:newSize];
        
        for (UIView * view in self.bulletinBoardViews){
            
            CGFloat bulletinBoardWidth = self.mainView.bounds.size.width * 0.26;
            CGFloat bulletinBoardHeight = self.mainView.bounds.size.height * 0.20;
            
            CGRect frame = CGRectMake(initPointX, initPointY, bulletinBoardWidth , bulletinBoardHeight );
            
            if (animation){
                if (isFirst){
                    [UIView animateWithDuration:duration *2
                                          delay:0.25
                                        options:UIViewAnimationOptionBeginFromCurrentState
                                     animations:^{[view setFrame:frame];} 
                                     completion:nil];
                    
                }else{
                    [UIView animateWithDuration:duration
                                          delay:0 
                                        options:UIViewAnimationOptionBeginFromCurrentState
                                     animations:^{[view setFrame:frame];} 
                                     completion:nil];
                }
            }
            else{
                [view setFrame:frame];
            }
            
            //set the text according to the orientation
            CGFloat middleX = view.bounds.size.width/2 + view.bounds.origin.x;
            CGFloat middleY = view.bounds.size.height/2 + view.bounds.origin.y;
            [[view.subviews lastObject] setFrame:CGRectMake(middleX * 0.4, middleY * 0.85, view.bounds.size.width/2, 0.1* view.bounds.size.height)];
            
            
            rowCount++;
            if ( rowCount <= PORTRAIT_ROW_COUNT - 1 ) {
                initPointX += bulletinBoardWidth * 1.2;
            }
            else{
                rowCount = 0 ;
                if (colCount >= PORTRAIT_COL_COUNT - 1){
                    colCount = 0;
                    CGFloat originalWidth = self.mainView.bounds.size.width ;
                    colCount = 0 ;
                    initPointY = Y_STARTING_POST;
                    initPointX = originalWidth + rowOffset ;
                    rowOffset = initPointX;
                }
                else{
                    colCount ++;
                    initPointX = rowOffset;
                    initPointY += bulletinBoardHeight + Y_STARTING_POST;
                }
            }
            if (isFirst){
                isFirst = false;
                [UIView animateWithDuration:duration
                                      delay:0.5 
                                    options:UIViewAnimationOptionBeginFromCurrentState
                                 animations:^{view.alpha = 1;} 
                                 completion:nil];
            }
        }
        
    }
    else {
        
        CGFloat bulletinBoardWidth = self.mainView.bounds.size.width * 0.26;
        CGFloat bulletinBoardHeight = self.mainView.bounds.size.height * 0.23;
        int numPages = self.bulletinBoardViews.count / (LANDSCAPE_ROW_COUNT * LANDSCAPE_COL_COUNT);
        int remainder = self.bulletinBoardViews.count % (LANDSCAPE_COL_COUNT * LANDSCAPE_ROW_COUNT);
        if ( remainder ==  0 ) numPages --;
        CGSize newSize = CGSizeMake(self.mainView.contentSize.width * (numPages + 1), self.mainView.contentSize.height);
        [self.mainView setContentSize:newSize];
        
        for (UIView * view in self.bulletinBoardViews){
            CGRect frame = CGRectMake(initPointX, initPointY, bulletinBoardWidth * 0.8, bulletinBoardHeight * 1.2);
            
            if(animation){
                if (isFirst){
                    [UIView animateWithDuration:duration
                                          delay:0.25
                                        options:UIViewAnimationOptionBeginFromCurrentState
                                     animations:^{[view setFrame:frame];} 
                                     completion:nil];
                }
                else{
                    [UIView animateWithDuration:duration
                                          delay:0 
                                        options:UIViewAnimationOptionBeginFromCurrentState
                                     animations:^{[view setFrame:frame];} 
                                     completion:nil];
                }
                
            }
            
            else{
                [view setFrame:frame]; 
            }
            
            CGFloat middleX = view.bounds.size.width/2 + view.bounds.origin.x;
            CGFloat middleY = view.bounds.size.height/2 + view.bounds.origin.y;
            [[view.subviews lastObject] setFrame:CGRectMake(middleX * 0.4, middleY * 0.85, view.bounds.size.width/2, 0.1* view.bounds.size.height)];
            
            rowCount++;
            if ( rowCount <= LANDSCAPE_ROW_COUNT-1 ) {
                initPointX += bulletinBoardWidth * 0.91;
            }
            else{
                rowCount = 0 ;
                if (colCount >= LANDSCAPE_COL_COUNT-1){
                    colCount = 0;
                    CGFloat originalWidth = self.mainView.bounds.size.width ;
                    colCount = 0 ;
                    initPointY = Y_STARTING_POST;
                    initPointX = originalWidth + rowOffset;
                    rowOffset = initPointX;
                    
                }
                else {
                    colCount ++;
                    initPointX =  rowOffset;
                    initPointY += bulletinBoardHeight * 1.1 + Y_STARTING_POST ;
                }
            }
            if (isFirst){
                isFirst = false;
                [UIView animateWithDuration:duration
                                      delay:0.5
                                    options:UIViewAnimationOptionBeginFromCurrentState
                                 animations:^{view.alpha = 1;} 
                                 completion:nil];
            }
        }
    }
}

/*---------------------------------------------------------------------------------------------------
 Animations
 --------------------------------------------------------------------------------------------------*/


-(void) animateAdd: (UIView *) view{
    
    CGAffineTransform transform = view.transform;
    CGFloat midX = self.mainView.bounds.origin.x + self.mainView.bounds.size.width/2;
    CGFloat midY = self.mainView.bounds.origin.y + self.mainView.bounds.size.height/2;
    [UIView animateWithDuration:0.25 
                          delay:0 
                        options:UIViewAnimationOptionCurveLinear
                     animations: ^{
                         view.transform = CGAffineTransformRotate(CGAffineTransformScale(CGAffineTransformTranslate(transform, midX/3, midY/3), 1 , 1), 2 * 3.14 /3 );
                     }
                     completion:^(BOOL finished){
                         if (finished){
                             [UIView animateWithDuration:0.25 
                                                   delay:0 
                                                 options:UIViewAnimationOptionCurveLinear animations:^{
                                                     view.transform = CGAffineTransformRotate(CGAffineTransformScale(CGAffineTransformTranslate(transform, midX/3, midY/3), 1 , 1), -2 * 3.14 /3 );  
                                                 }
                                              completion:^(BOOL finished){
                                                  [UIView animateWithDuration:0.25
                                                                        delay:0
                                                                      options:UIViewAnimationOptionCurveLinear
                                                                   animations:^{
                                                                       view.transform = CGAffineTransformScale(transform, 1, 1);
                                                                   }
                                                                   completion:nil];
                                              }];
                             
                         }
                         
                     }];
}

-(void) animateSelect: (UIView *) view{
    CGFloat middleScreenX = self.mainView.bounds.origin.x + self.mainView.bounds.size.width/2 - ((UIView *)self.bulletinBoardViews.lastObject).bounds.size.width/2;
    CGFloat middleScreenY = self.mainView.bounds.origin.y + self.mainView.bounds.size.height/2 - ((UIView *)self.bulletinBoardViews.lastObject).bounds.size.height/2;
    [UIView animateWithDuration:0.25
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         ((UIView *)[view.subviews lastObject]).alpha = 0;
                     }completion:nil];
    
    [UIView animateWithDuration:0.25 
                          delay:0 
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         [view setFrame:CGRectMake(middleScreenX, middleScreenY, view.frame.size.width, view.frame.size.height)];
                     }completion:^(BOOL finished){
                         if(finished){
                             CGAffineTransform transform = view.transform;
                             [UIView animateWithDuration:0.25
                                                   delay:0
                                                 options:UIViewAnimationCurveEaseOut
                                              animations:^{
                                                  view.transform = CGAffineTransformScale(transform, 20, 20);
                                                  view.alpha = 0;
                                              }completion:^ (BOOL finished){
                                                  [self performSegueWithIdentifier:@"Segue" sender:self];
                                              }];
                             
                         }
                     }];
}

/*---------------------------------------------------------------------------------------------------------
 Event responsers
 --------------------------------------------------------------------------------------------------------*/


-(void) selectBulletinBoard: (UITapGestureRecognizer *) sender{
    
    UIView * touchedView = [sender view];
    NSString * bulletinBoardName = ((UILabel *)[[touchedView subviews] objectAtIndex:0]).text;
    [self animateSelect: touchedView];
    
    
}

-(void) layoutBulletinBoards{
    
    CGFloat bulletinBoardWidth = self.mainView.bounds.size.width * 0.29;
    CGFloat bulletinBoardHeight = self.mainView.bounds.size.height * 0.22;
    
    for (NSString * name in self.bulletinBoardNames){
        CGRect frame = CGRectMake(0, 0, bulletinBoardWidth, bulletinBoardHeight);
        UIView * view = [self createBulletinBoardPreviewWithName:name inFrame:frame];
        [self.mainView addSubview:view];
        [self.bulletinBoardViews addObject:view];
    }
    [self layoutBulletinBoards:YES withDuration:0.2];
}

-(void) createNewBulletinBoard: (NSString *) name{
    
    CGFloat bulletinBoardWidth = self.mainView.bounds.size.width * 0.29;
    CGFloat bulletinBoardHeight = self.mainView.bounds.size.height * 0.22;
    CGFloat initPointX = self.mainView.bounds.origin.x + 0.04 * self.mainView.bounds.size.width;
    initPointX *= 0;
    CGFloat initPointY = self.mainView.bounds.origin.y + 0.11 * self.mainView.bounds.size.height;
    initPointY *= 0.1;
    CGFloat topRightX = self.mainView.bounds.origin.x + self.mainView.bounds.size.width - 250;
    CGFloat topRightY = self.mainView.bounds.origin.y - 50;
    CGRect frame = CGRectMake(topRightX,topRightY, bulletinBoardWidth, bulletinBoardHeight);
    UIView * view = [self createBulletinBoardPreviewWithName:name inFrame:frame];
    
    view.alpha = 0;
    [self.mainView addSubview:view];
    [self.bulletinBoardViews insertObject:view atIndex:0];
    [self layoutBulletinBoards:YES withDuration:0.30];
    NSData * emptyBulletinBoard = [XoomlBulletinBoardController getEmptyBulletinBoardData];
    [self.dropBox addBulletinBoardWithName:name andBulletinBoardInfo:emptyBulletinBoard];
    
    [self animateAdd:view];
}

/*---------------------------------------------------------------------------------------------------------
 View Events
 --------------------------------------------------------------------------------------------------------*/


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)AddPressed:(id)sender {
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Create New Bulletinboard" message: @"Enter the name of the the BulletinBoard" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1){
        NSString * name = [[alertView textFieldAtIndex:0] text];  
        [self createNewBulletinBoard:name];
    }    
    
}

-(void) viewWillAppear:(BOOL)animated{
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    NSLog(@"Generating orientation notification");
}

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    if (![[DBSession sharedSession] isLinked]) {
        [[DBSession sharedSession] link];
    }
    
    
    [self.mainView setContentSize:self.mainView.bounds.size];
    
    //This call is asynch and the initialization of the bulletinBoardNames happen
    //in the callback here. 
    //TODO make delegate a property so you can access it by dropbox.delegate
    
    [self.dropBox setDelegate: self];
    [self.dropBox getAllBulletinBoardsAsynch];
    
    
}

- (void)viewDidUnload{
    
    [self setMainView:nil];
    [self setPrototypeView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void) viewWillLayoutSubviews{
    
    [super viewWillLayoutSubviews];
    [self layoutBulletinBoards:NO withDuration:0];    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return YES;
}

-(NSString *) description{
    return @"Its me the MainScreenViewController";
}

/*----------------------------------------------------------------------------------------------------
 Dropbox Datamodel delegate methods
 -----------------------------------------------------------------------------------------------------*/


- (void)restClient:(DBRestClient *)client loadedMetadata:(DBMetadata *)metadata{
    
    for (DBMetadata * child in metadata.contents){
        if (child.isDirectory){
            NSString * name = [child.path substringFromIndex:1];
            [self.bulletinBoardNames addObject:name];
        }
    }
    
    NSLog(@"These bulletin boards got loaded \n: %@", self.bulletinBoardNames);
    
    [self layoutBulletinBoards];
    
}

- (void)restClient:(DBRestClient*)client loadMetadataFailedWithError:(NSError*)error{
    
    NSLog(@"Failutre: %@",error);
}

/*---------------------------------------------------------------------------------------------------------
 Queue Delegate Methods
 --------------------------------------------------------------------------------------------------------*/


/*
 The queue methods are here for the purpose of multi delete
 */
-(void) putIntoQueue: (id) item{
    
    [self.queue addObject:item];    
}

-(void) produceNext{
    //pick up the next delete request and send the request to dropbox
}


@end
