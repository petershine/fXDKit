//
//  FXDsuperProgressView.m
//
//
//  Created by petershine on 1/9/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import "FXDsuperProgressView.h"


#pragma mark - Public implementation
@implementation FXDsuperProgressView


#pragma mark - Memory management

#pragma mark - Initialization

#pragma mark - Property overriding

#pragma mark - Method overriding

#pragma mark - IBActions
- (IBAction)pressedCancelButton:(id)sender {	FXDLog_DEFAULT;
	self.didPressCancelButton = YES;

	[[NSOperationQueue mainQueue]
	 addOperationWithBlock:^{
		 
		 self.labelCanceling.text = NSLocalizedString(text_Canceling, nil);
	 }];
}

#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation

@end
