//
//  BulletinBoardViewController.h
//  IdeaStock
//
//  Created by Ali Fathalian on 4/28/12.
//  Copyright (c) 2012 University of Washington. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainScreenDropboxViewController.h"
#import "StackViewController.h"

@interface BulletinBoardViewController : UIViewController <UIScrollViewDelegate,StackViewDelegate>
@property (strong,nonatomic) NSString * bulletinBoardName;
@property (weak,nonatomic) MainScreenDropboxViewController * parent;

@end
