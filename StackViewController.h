//
//  StackViewController.h
//  IdeaStock
//
//  Created by Ali Fathalian on 5/17/12.
//  Copyright (c) 2012 University of Washington. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BulletinBoardObject.h"

@protocol StackViewDelegate;
@interface StackViewController : UIViewController

@property (weak,nonatomic) NSArray * notes;
@property (weak, nonatomic) UIViewController<StackViewDelegate> * delegate;

@end


@protocol StackViewDelegate

-(void) returnedstackViewController: (StackViewController *) sender;

@end