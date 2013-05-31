//
//  FXDsuperMessageView.m
//
//
//  Created by petershine on 5/30/13.
//  Copyright (c) 2013 Provus. All rights reserved.
//

#import "FXDsuperMessageView.h"


#pragma mark - Public implementation
@implementation FXDsuperMessageView


#pragma mark - Memory management
- (void)dealloc {
#if ForDEVELOPER
	FXDLog_DEFAULT;
	FXDLog(@"_callbackBlock: %@", _callbackBlock);
#endif
	
	_callbackBlock = nil;
}


#pragma mark - Initialization

#pragma mark - Property overriding

#pragma mark - Method overriding

#pragma mark - IBActions
- (IBAction)pressedCancelButton:(id)sender {	FXDLog_DEFAULT;
	if (self.callbackBlock) {
		self.callbackBlock(self, buttonIndexCancel);
	}
	
	[super pressedCancelButton:sender];
}

- (IBAction)pressedAcceptButton:(id)sender {	FXDLog_DEFAULT;
	if (self.callbackBlock) {
		self.callbackBlock(self, buttonIndexAccept);
	}
	
	self.didPressAcceptButton = YES;
	
	[[NSOperationQueue mainQueue] addOperationWithBlock:^{
		self.labelAccepting.text = NSLocalizedString(text_Accepting, nil);
	}];
}

#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation

@end
