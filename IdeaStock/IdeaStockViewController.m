//
//  IdeaStockViewController.m
//  IdeaStock
//
//  Created by Ali Fathalian on 3/28/12.
//  Copyright (c) 2012 University of Washington. All rights reserved.
//

#import "IdeaStockViewController.h"
#import <DropboxSDK/DropboxSDK.h>

@interface IdeaStockViewController ()

@end

@implementation IdeaStockViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //setup dropbox
    if (![[DBSession sharedSession] isLinked]) {
        [[DBSession sharedSession] link];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
