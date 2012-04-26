//
//  MainScreenDropbox.m
//  IdeaStock
//
//  Created by Ali Fathalian on 4/24/12.
//  Copyright (c) 2012 University of Washington. All rights reserved.
//

#import "MainScreenDropboxViewController.h"

@interface MainScreenDropboxViewController ()

//this is the main model that will be initialized from dropbox. 
@property (nonatomic,strong) NSMutableArray * bulletinBoardNames;

@property (weak, nonatomic) IBOutlet UIView *prototypeView;
@property (weak, nonatomic) IBOutlet UIScrollView *mainView;
@property (strong, nonatomic) NSMutableArray * bulletinBoardViews; 

@end

@implementation MainScreenDropboxViewController

@synthesize bulletinBoardViews = _bulletinBoardViews;
@synthesize dropBox = _dropBox;
@synthesize bulletinBoardNames = _bulletinBoardNames;
@synthesize prototypeView = _prototypeView;
@synthesize mainView = _mainView;
@synthesize queue = _queue;

-(NSMutableArray *) bulletinBoardViews{
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
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(UIView *) createBulletinBoardPreviewWithName: (NSString *) name inFrame: (CGRect) frame{
    
    
    UIImage *image = [UIImage imageNamed:@"Pile note.png"];
    UIImageView * view = [[UIImageView alloc] initWithImage:image];
    [view setFrame:frame];
    CGFloat middleX = view.bounds.size.width/2 + view.bounds.origin.x;
    CGFloat middleY = view.bounds.size.height/2 + view.bounds.origin.y;
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(middleX * 0.4, middleY * 0.85, view.bounds.size.width/2, 0.1* view.bounds.size.height)];
    label.text = name;
    label.textAlignment = UITextAlignmentCenter;
    label.font = [UIFont fontWithName:@"Helvetica" size:12.0];
    [view addSubview:label];

    
    
    return view;
    
}

-(void) layoutBulletinBoards{
    
    CGFloat bulletinBoardWidth = self.mainView.bounds.size.width * 0.29;
    CGFloat bulletinBoardHeight = self.mainView.bounds.size.height * 0.22;
    CGFloat initPointX = self.mainView.bounds.origin.x + 0.04 * self.mainView.bounds.size.width;
    initPointX *= 0;
    CGFloat initPointY = self.mainView.bounds.origin.y + 0.11 * self.mainView.bounds.size.height;
    initPointY *= 0.1;
    
    int rowCount = 0;
    int colCount = 0;
    
    if ( [UIDevice currentDevice].orientation ==  UIDeviceOrientationPortrait || [UIDevice currentDevice].orientation == UIDeviceOrientationPortraitUpsideDown || [UIDevice currentDevice].orientation ==  UIDeviceOrientationUnknown){
        for (NSString * name in self.bulletinBoardNames){
            CGRect frame = CGRectMake(initPointX, initPointY, bulletinBoardWidth, bulletinBoardHeight);
            UIView * view = [self createBulletinBoardPreviewWithName:name inFrame:frame];
            [self.mainView addSubview:view];
            [self.bulletinBoardViews addObject:view];
            rowCount++;
            if (rowCount <= 3 ) {
                initPointX += bulletinBoardWidth * 0.75;
            }
            else{
                rowCount = 0 ;
                colCount ++;
                initPointX = self.mainView.bounds.origin.x + 0.02 * self.mainView.bounds.size.width;
                initPointY += bulletinBoardHeight * 0.8;
            }
            
        }
        
    }
    else {
        for (NSString * name in self.bulletinBoardNames){
            CGRect frame = CGRectMake(initPointX, initPointY, bulletinBoardWidth, bulletinBoardHeight);
            UIView * view = [self createBulletinBoardPreviewWithName:name inFrame:frame];
            [self.mainView addSubview:view];
            [self.bulletinBoardViews addObject:view];
            rowCount++;
            if (rowCount <= 2 ) {
                initPointX += bulletinBoardWidth * 0.75;
            }
            else{
                rowCount = 0 ;
                colCount ++;
                initPointX = self.mainView.bounds.origin.x + 0.02 * self.mainView.bounds.size.width;
                initPointY += bulletinBoardHeight * 0.8;
            }
            
        }
    }
    
    
}

- (void) layoutItmesWithAnimation{
    [super viewWillLayoutSubviews];
    CGFloat bulletinBoardWidth = self.mainView.bounds.size.width * 0.29;
    CGFloat bulletinBoardHeight = self.mainView.bounds.size.height * 0.22;
    CGFloat initPointX = self.mainView.bounds.origin.x + 0.04 * self.mainView.bounds.size.width;
    initPointX *= 0;
    CGFloat initPointY = self.mainView.bounds.origin.y + 0.11 * self.mainView.bounds.size.height;
    initPointY *= 0.1;
    
    int rowCount = 0;
    int colCount = 0;
    
    BOOL isFirst = YES;
    if ( [UIDevice currentDevice].orientation ==  UIDeviceOrientationPortrait || [UIDevice currentDevice].orientation == UIDeviceOrientationPortraitUpsideDown){
        NSLog(@"Portrait");
        for (UIView * view in self.bulletinBoardViews){
            CGRect frame = CGRectMake(initPointX, initPointY, bulletinBoardWidth, bulletinBoardHeight);
            [UIView animateWithDuration:1.0
                                  delay:0 
                                options:UIViewAnimationOptionBeginFromCurrentState
                             animations:^{[view setFrame:frame];} 
                             completion:nil];
            
            CGFloat middleX = view.bounds.size.width/2 + view.bounds.origin.x;
            CGFloat middleY = view.bounds.size.height/2 + view.bounds.origin.y;
            [[view.subviews lastObject] setFrame:CGRectMake(middleX * 0.4, middleY * 0.85, view.bounds.size.width/2, 0.1* view.bounds.size.height)];
            rowCount++;
            if ( rowCount <= 3 ) {
                initPointX += bulletinBoardWidth * 0.75;
            }
            else{
                rowCount = 0 ;
                colCount ++;
                initPointX = self.mainView.bounds.origin.x + 0.02 * self.mainView.bounds.size.width;
                initPointY += bulletinBoardHeight * 0.8;
            }
            if (isFirst){
                isFirst = false;
                [UIView animateWithDuration:3.0
                                      delay:0 
                                    options:UIViewAnimationOptionBeginFromCurrentState
                                 animations:^{view.alpha = 1;} 
                                 completion:nil];
            }
        }
        
    }
    else {
        NSLog(@"Landscape");
        for (UIView * view in self.bulletinBoardViews){
            CGRect frame = CGRectMake(initPointX, initPointY, bulletinBoardWidth, bulletinBoardHeight);
            [UIView animateWithDuration:3.0
                                  delay:0 
                                options:UIViewAnimationOptionBeginFromCurrentState
                             animations:^{[view setFrame:frame];} 
                             completion:nil];
            CGFloat middleX = view.bounds.size.width/2 + view.bounds.origin.x;
            CGFloat middleY = view.bounds.size.height/2 + view.bounds.origin.y;
            [[view.subviews lastObject] setFrame:CGRectMake(middleX * 0.4, middleY * 0.85, view.bounds.size.width/2, 0.1* view.bounds.size.height)];
            rowCount++;
            if ( rowCount <= 2 ) {
                initPointX += bulletinBoardWidth * 0.75;
            }
            else{
                rowCount = 0 ;
                colCount ++;
                initPointX = self.mainView.bounds.origin.x + 0.02 * self.mainView.bounds.size.width;
                initPointY += bulletinBoardHeight * 0.8;
            }
            if (isFirst){
                isFirst = false;
                [UIView animateWithDuration:3.0
                                      delay:0 
                                    options:UIViewAnimationOptionBeginFromCurrentState
                                 animations:^{view.alpha = 1;} 
                                 completion:nil];
            }
        }
    }
    
}
/*---------------------------------
 Dropbox Datamodel delegate methods
 ----------------------------------*/

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
/*---------------------
 Queue Delegate Methods
 --------------------*/
/*
 The queue methods are here for the purpose of multi delete
 */
-(void) putIntoQueue: (id) item{
    [self.queue addObject:item];    
}

-(void) produceNext{
    //pick up the next delete request and send the request to dropbox
}



/*-----------------
 View Events
 ------------------*/

- (IBAction)AddPressed:(id)sender {
    CGFloat bulletinBoardWidth = self.mainView.bounds.size.width * 0.29;
    CGFloat bulletinBoardHeight = self.mainView.bounds.size.height * 0.22;
    CGFloat initPointX = self.mainView.bounds.origin.x + 0.04 * self.mainView.bounds.size.width;
    initPointX *= 0;
    CGFloat initPointY = self.mainView.bounds.origin.y + 0.11 * self.mainView.bounds.size.height;
    initPointY *= 0.1;
    CGFloat topRightX = self.mainView.bounds.origin.x + self.mainView.bounds.size.width - 250;
    CGFloat topRightY = self.mainView.bounds.origin.y - 50;
    CGRect frame = CGRectMake(topRightX,topRightY, bulletinBoardWidth, bulletinBoardHeight);
    UIView * view = [self createBulletinBoardPreviewWithName:@"Unknown" inFrame:frame];
    view.alpha = 0;
    [self.mainView addSubview:view];
    [self.bulletinBoardViews insertObject:view atIndex:0];
    [self layoutItmesWithAnimation];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //This call is asynch and the initialization of the bulletinBoardNames happen
    //in the callback here. 
    
    
    
    //TODO make delegate a property so you can access it by dropbox.delegate
    [self.dropBox setDelegate: self];
    [self.dropBox getAllBulletinBoardsAsynch];
    
    
}

- (void)viewDidUnload
{
    [self setMainView:nil];
    [self setPrototypeView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void) viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    CGFloat bulletinBoardWidth = self.mainView.bounds.size.width * 0.29;
    CGFloat bulletinBoardHeight = self.mainView.bounds.size.height * 0.22;
    CGFloat initPointX = self.mainView.bounds.origin.x + 0.04 * self.mainView.bounds.size.width;
    initPointX *= 0;
    CGFloat initPointY = self.mainView.bounds.origin.y + 0.11 * self.mainView.bounds.size.height;
    initPointY *= 0.1;
    
    int rowCount = 0;
    int colCount = 0;
    
    
    if ( [UIDevice currentDevice].orientation ==  UIDeviceOrientationPortrait || [UIDevice currentDevice].orientation == UIDeviceOrientationPortraitUpsideDown){
        NSLog(@"Portrait");
        for (UIView * view in self.bulletinBoardViews){
            CGRect frame = CGRectMake(initPointX, initPointY, bulletinBoardWidth, bulletinBoardHeight);
            [view setFrame:frame];
            CGFloat middleX = view.bounds.size.width/2 + view.bounds.origin.x;
            CGFloat middleY = view.bounds.size.height/2 + view.bounds.origin.y;
            [[view.subviews lastObject] setFrame:CGRectMake(middleX * 0.4, middleY * 0.85, view.bounds.size.width/2, 0.1* view.bounds.size.height)];
            rowCount++;
            if ( rowCount <= 3 ) {
                initPointX += bulletinBoardWidth * 0.75;
            }
            else{
                rowCount = 0 ;
                colCount ++;
                initPointX = self.mainView.bounds.origin.x + 0.02 * self.mainView.bounds.size.width;
                initPointY += bulletinBoardHeight * 0.8;
            }
        }
    }
    else {
        NSLog(@"Landscape");

        for (UIView * view in self.bulletinBoardViews){
            CGRect frame = CGRectMake(initPointX, initPointY, bulletinBoardWidth, bulletinBoardHeight);
            [view setFrame:frame];
            CGFloat middleX = view.bounds.size.width/2 + view.bounds.origin.x;
            CGFloat middleY = view.bounds.size.height/2 + view.bounds.origin.y;
            [[view.subviews lastObject] setFrame:CGRectMake(middleX * 0.4, middleY * 0.85, view.bounds.size.width/2, 0.1* view.bounds.size.height)];
            rowCount++;
            if ( rowCount <= 2 ) {
                initPointX += bulletinBoardWidth * 0.9;
            }
            else{
                rowCount = 0 ;
                colCount ++;
                initPointX = self.mainView.bounds.origin.x + 0.02 * self.mainView.bounds.size.width;
                initPointY += bulletinBoardHeight * 0.8;
            }
        }
    }
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

-(NSString *) description{
    return @"Its me the MainScreenViewController";
}
@end
