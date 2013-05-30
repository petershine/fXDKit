//
//  FXDsuperNewsView.m
//
//
//  Created by petershine on 5/30/13.
//  Copyright (c) 2013 Provus. All rights reserved.
//

#import "FXDsuperNewsView.h"


#pragma mark - Public implementation
@implementation FXDsuperNewsView


#pragma mark - Memory management

#pragma mark - Initialization

#pragma mark - Property overriding

#pragma mark - Method overriding

#pragma mark - IBActions
- (IBAction)pressedAcceptButton:(id)sender {	FXDLog_DEFAULT;
	self.didPressAcceptButton = YES;
	
	[[NSOperationQueue mainQueue] addOperationWithBlock:^{
		self.labelAccepting.text = NSLocalizedString(text_Accepting, nil);
	}];
}

#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation

@end
