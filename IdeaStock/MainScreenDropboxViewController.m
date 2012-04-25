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

@property (weak, nonatomic) IBOutlet UIScrollView *mainView;
@end

@implementation MainScreenDropboxViewController

@synthesize dropBox = _dropBox;
@synthesize bulletinBoardNames = _bulletinBoardNames;
@synthesize mainView = _mainView;
@synthesize queue = _queue;

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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

-(NSString *) description{
    return @"Its me the MainScreenViewController";
}
@end
