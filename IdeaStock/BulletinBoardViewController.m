//
//  BulletinBoardViewController.m
//  IdeaStock
//
//  Created by Ali Fathalian on 4/28/12.
//  Copyright (c) 2012 University of Washington. All rights reserved.
//

#import "BulletinBoardViewController.h"


@interface BulletinBoardViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *label;

@end

@implementation BulletinBoardViewController
@synthesize label = _label;
@synthesize parent = _parent;

@synthesize bulletinBoardName = _bulletinBoardName;

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

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    self.label.title = self.bulletinBoardName;
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

@end
